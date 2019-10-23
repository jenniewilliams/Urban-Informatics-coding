#library(lexicon) #sw_fry_1000 data to remove 1000 most common words
library(readr) #read csv files
library(tm) #topic modelling
library(NLP) #natural language processing
library(textstem) # lemmatize
library(text2vec) # word embeddings
library(stringr) # string setting
library(Hmisc) # useful string manipulation
library(viridis) # colormap
library(pheatmap) #heatmap with level cutting feature
library(ggplot2) #plotting
library(ggdendro) # dendrogram plotting
library(plyr) # useful rounding function
library(ape) #dendrogram from phylo application
library(gmodels) # cross tabulations
library(wordcloud) # word clouds
library(RColorBrewer) # color palattes
library(Rtsne) #word embedding/clustering visualisation
library(dendextend) #dendrogram
library(caret) #confusion matrix analysis
library(cluster) #sihlouette plot
set.seed(77)

pal1 <- brewer.pal(6,"Purples")
cb_palatte <- c("#999999","#E69F00","#56B4E9","#009E73","#F0E442","#0072B2","#D55E00","#CC79A7")
pal2 <- c("steelblue","black","#56B4E9","#009E73","#F0E442","#0072B2","#D55E00","#CC79A7")

#Sys.setlocale('LC_ALL','C') 

# Various files for messing around ....
#trunks <- read_csv("~/Documents/urban informatics/dissertation/BLdata/trunk.csv")
trunks <- read_csv("~/Documents/urban informatics/dissertation/BLdata/BL_Labs_EThOS_20150301.csv")
#trunks <- read_csv("~/Documents/urban informatics/dissertation/BLdata/title.csv")
#trunks <- read_csv("~/Documents/urban informatics/dissertation/BLdata/thatcher.csv")
#trunks <- read_csv("~/Documents/urban informatics/dissertation/BLdata/onethatch.csv")

# read in new file with updated DDCs and only keep the last 6 digits of EThOS Link 
# and DDC to merge with the data file containing abstracts: filling the DDC gaps 
DDCs <- read_csv("~/Documents/urban informatics/dissertation/BLdata/EThOS_DDC.csv")
DDCs$id <- str_sub(DDCs$`EThOS Link`, -6, -1)
keepvars <- c("id", "DDC")
DDCdf <- DDCs[keepvars]

# sort thesis records according Date 
#attach(trunks)
#trunk <- trunks[order(Date),] 
#detach(trunks)

#trunk <- trunks[ which(trunk$Abstract !=""),]
trunk <- trunks
#create text columns combining original data
# any abstract less than 80 characters in length should not be concatenated, 
# as they appear to be either general comments or information not pertaining to an abstract
if (length(trunk$Abstract)>80) {
  trunk$combined <- paste(trunk$Abstract, trunk$Title, sep=' ') 
} else{
  trunk$combined <- trunk$Title
}
#library(coop)
#install.packages("coop")
#sparsity(tcm, proportion = TRUE)
#4607584/2466512896
#describe(tcm)
trunk$content <- paste(trunk$combined, trunk$Keywords, sep=' ')
trunk$id <- str_sub(trunk$`EThOS Link`, -6, -1)

#trunk0 <- trunk[!is.na(trunk$DDC),]

# get rid of any records where there is no id value, ie. no link to the BL repository
trunk0 <- trunk[!is.na(trunk$id),]
DDCdf0 <- DDCdf[!is.na(DDCdf$id),]

#drop original DDC
trunk1 <- subset(trunk0, select = -c(DDC))

#merge on DDC updates
merged <- merge(x = trunk1, y = DDCdf0, by = "id", all.x = TRUE)

#http://bpeck.com/references/DDC/ddc.htm#table300
#only keep History (ddc>=930) & Earth Sciences(>=550 to <560)
histearth <- merged[ which( (merged$DDC>=930) | (merged$DDC >=550 & merged$DDC <560) ),]
#remove record with 'large'out of range' DDC value
histearth <- histearth[ which( histearth$DDC!='9405354' & histearth$DDC!='552..0941156' ),]
#histearth[1,]
contab <- histearth
contab$abs <- ifelse(is.na(contab$Abstract), 0, 1)
contab$key <- ifelse(is.na(contab$Keywords), 0, 1)
contab$tit <- ifelse(is.na(contab$Title), 0, 1)
CrossTable(contab$tit,contab[,"key"],plot=True)
CrossTable(contab$tit,contab[,"abs"],plot=True)
CrossTable(contab$key,contab[,"abs"],plot=True)

#only keep History (ddc>=930)
#hist <- merged[ which(merged$DDC>=930),]
#hist$cat <- 2

#only keep Earth Sciences(>=550 to <560)
#earth <- merged[ which( (merged$DDC >=550 & merged$DDC <560) ),]
#earth$cat <- 3

#all <- rbind(histearth,hist,earth)
all <- histearth
# *--------------------------- end of data input & merging processing -----------------------------*


# *--------------------------- start of NLP processing -----------------------------*

#remove punctuation..........check these next 3 lines, might not need them all
all$content1 <- gsub("?[][!#$%()*,.:;&+<=>@^_|~.{}]", "", all$content)
usableText <- iconv(all$content1, "ASCII", "UTF-8", sub="")
#usableText[1:14]
usableText2 <- gsub("[^[:alnum:][:blank:]]", " ", usableText)
#usableText2[1:14]
# make a lemma dictionary from the data 
# irritating how it reduces words.......
lemma_dictionary <- make_lemma_dictionary(usableText2, engine = 'lexicon')
#describe(lemma_dictionary$lemma)
usableText3 <- lemmatize_strings(usableText2, dictionary = lemma_dictionary)
#usableText3[1:14]
#have decided not do do stemming........
#library(SnowballC) #stemming
#text_tokens(usableText, stemmer = "en") # english stemmer
#wordStem(usableText2, language = "porter")

#Create a corpus from the content column
corp = Corpus(VectorSource(usableText3)) 

#inspect(corp[1:14])
#orbit<-content_transformer(function(x,pattern){return(gsub(pattern,"",x))})
#corp<-tm_map(corp,content_transformer(gsub),pattern="-",replacement="")
corp <-tm_map(corp,orbit,"NA")
#inspect(corp[1])


corp <- tm_map(corp, content_transformer(tolower))
corp <- tm_map(corp, stripWhitespace)
#inspect(corp[18315])
#inspect(corp[7379])
#inspect(corp[10555])
#inspect(corp[17905])


# Titles such as “#NAME?”, “Thesis”, will naturally remove during NLP
# “Thesis submitted for the degree of Doctor of Science” will be removed explicitly.
#remove 's
corp<-tm_map(corp,content_transformer(gsub),pattern="'",replacement="")

#there are words with hyphens with only a word on one side......
#corp<-tm_map(corp,content_transformer(gsub),pattern=" - ",replacement="-")
#corp<-tm_map(corp,content_transformer(gsub),pattern="-",replacement=" ")
#corp<-tm_map(corp,content_transformer(gsub),pattern="/",replacement=" ")
#corp<-tm_map(corp,content_transformer(gsub),pattern="?",replacement=" ")

corp<-tm_map(corp,content_transformer(gsub),pattern="Thesis submitted for the degree of Doctor of Science",replacement="")

# Get rid of the following from within the abstract
# “Full abstract available online”
# “[For full abstract, with illustrations, see pdf file]”
# “[See pdf file for full abstract]”
# “(Please view 'front matter' file for full abstract)”

corp<-tm_map(corp,content_transformer(gsub),pattern="full abstract available online",replacement="")
corp<-tm_map(corp,content_transformer(gsub),pattern="for full abstract with illustration see pdf file",replacement="")

corp<-tm_map(corp,content_transformer(gsub),pattern="see pdf file for full abstract",replacement="")
corp<-tm_map(corp,content_transformer(gsub),pattern="please view front matter file for full abstract",replacement="")


# get stopwords, add a few extras and also sw_fry_1000 
words <- readLines(system.file("stopwords", "english.dat",package = "tm"))
words <- append (words, c('a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'))
#words <- append (words, c('w','b','m','c','s','v','na','ha','investigates','chapter','may','one','two','new','study', 'research', 'data','thesis','analysis','also','within','case','use','using','used','three','upon'))
#Fry, E. B. (1997). Fry 1000 instant words. Lincolnwood, IL: Contemporary Books.
#data(sw_fry_1000)

#exceptions <- grep(pattern = "-", x = corp$content, value = TRUE)
# get stopwords, add a few extras and also sw_fry_1000 
#corp<-tm_map(corp,removeWords,words)
#inspect(corp[1:14])
#corp<-tm_map(corp,removeWords,sw_fry_1000)
corp<-tm_map(corp,removeWords,words)
corp <- tm_map(corp, removeNumbers)
#inspect(corp[1:14])

#put the hyphens in after 'word' removal
#corp<-tm_map(corp,content_transformer(gsub),pattern=" ZZZZ ",replacement="")
#get rid of hyphens
corp<-tm_map(corp,content_transformer(gsub),pattern="-",replacement=" ")


corp <- tm_map(corp, stripWhitespace)

# Need this to get rid of the whitespace left by the stripWitespace function at the  
# beginning of the text which then gets converted to a blank word in the corpus
corp$content <- trimws(corp$content)

#dtm <- DocumentTermMatrix(corp)

# *--------------------------- end of NLP processing -----------------------------*

# *--------------------------- start of Word Embedding processing -----------------------------*

#create a vocabulary
#corpdf contains one record per doc with 1 column.....

corpdf <- data.frame(text = sapply(corp, paste, collapse = " "), stringsAsFactors = FALSE)
corpdf$id <- rownames(corpdf)


# http://text2vec.org/glove.html
it = itoken(corpdf$text, preprocessor = tolower, tokenizer = word_tokenizer)
vocab <- create_vocabulary(it)
#vocab0 <- vocab[order(vocab$term_count,decreasing=TRUE),]

# wordcloud of document count for each word
d1 <- vocab[order(vocab$doc_count, decreasing=TRUE), ]
dcheck <- d1[which(d1$term=="postpone"),]
#wordcloud(words=d1$term,freq=d1$doc_count,scale=c(2,.3),rot.per=.25,colors=cb_palatte,vfont=c("serif","plain"))

#A Cleveland Dot Plot of document count for each word
ggplot(d1, aes(x=doc_count, y=reorder(term,doc_count))) +
  geom_segment(aes(yend=reorder(term,doc_count)),xend=0, colour="steelblue") +
  geom_point(size=1,colour="darkgrey") +
  theme_bw() +
  scale_x_continuous(name="") +
  theme(axis.text.x=element_text(face="italic",size=6)) +
  scale_y_discrete(name="") +
  theme(axis.text.y=element_text(face="italic",size=6)) +
  theme(panel.grid.major.y = element_blank())

#scale_x_continuous(name="Number of theses.") +
#  scale_y_discrete(name="Top 100 words.") +
  
#A word cloud of word count across all documents
d2 <- vocab[order(vocab$term_count, decreasing=TRUE), ]
d2 <- d2[1:100,]
#wordcloud(words=d1$term,freq=d1$term_count,scale=c(2,.3),rot.per=.25,colors=cb_pallate,vfont=c("serif","plain"))

#A Cleveland Dot Plot of word count across all documents
ggplot(d2, aes(x=term_count, y=reorder(term,term_count))) +
  geom_segment(aes(yend=reorder(term,term_count)),xend=0, colour="steelblue") +
  geom_point(size=1,colour="darkgrey") +
  theme_bw() +
  scale_x_continuous(name="") +
  theme(axis.text.x=element_text(face="italic",size=6)) +
  scale_y_discrete(name="") +
  theme(axis.text.y=element_text(face="italic",size=6)) +
  theme(panel.grid.major.y = element_blank())

#for hLDA
#prune the vocab so that only words occurring >5 times are included in the vocab
#vocab1 <- prune_vocabulary(vocab,term_count_min=2L)
vocab1 <- prune_vocabulary(vocab,doc_count_min=2L)
#vocab1 <- prune_vocabulary(vocab1,term_count_max=4500L)
vocab1 <- prune_vocabulary(vocab1,doc_count_max=2100L)
# ######################need to get rid of words with length 1
#
vectorizer <- vocab_vectorizer(vocab)


# Now we create a term co-occurrence matrix
# Each element Xij of such matrix represents how often word i appears 
# in context of word j.
tcm <- create_tcm(it, vectorizer, skip_grams_window = 10L) 

# Set up a new glove model
glove_model = GloVe$new(word_vectors_size=100, vocabulary=vocab, x_max=100, learning_rate = .05, alpha=0.75)

# fit the model and get word vectors
ethos_main <- glove_model$fit_transform(tcm, n_iter = 50L)

#get the context vectors
ethos_context <- glove_model$components
#g <-data.frame(ethos_vectors["magmatic",])
# According to the Glove paper, summing the two word 
# vectors results in more accurate representation.
#.....................................................
ethos_vectors <- ethos_main + t(ethos_context)

#dev.off()

texts <- strsplit(corpdf[,1], " ")
# Here we average the vectors of the words each document, creating one vector per thesis.
x <-1
for (w in texts) {
#  print(w)
  for (i in 1:100){
    if (i == 1){
#      print(i)
      vec <- c(sum(ethos_vectors[w,i])/length(w))
    }
    else{
      vec <- c(vec,sum(ethos_vectors[w,i])/length(w))
    }
  }
#    print(vec)
  if (x == 1){
    alldocs <- as.numeric(vec)
  }
  else{
    alldocs <- rbind(alldocs,as.numeric(vec))
  }
  
  
#  print(x)
  x <- x +1
}
#print(alldocs)
corpdf$ethosid <- histearth$id
#write.csv(corpdf,'~/Documents/urban informatics/dissertation/BLdata/corpdf.csv')
docvecs <- cbind(alldocs,as.numeric(corpdf$id),as.numeric(histearth$DDC),as.numeric(corpdf$ethosid))
rownames(docvecs) <- docvecs[,103]
docvecs["635341",]
#function to round DDC values
round.choose <- function(x, roundTo, dir = 1) {
  if(dir == 1) {  ##ROUND UP
    x + (roundTo - x %% roundTo)
  } else {
    if(dir == 0) {  ##ROUND DOWN
      x - (x %% roundTo)
    }
  }
}

# all history & earth science theses
#dist is part of the 'stats' package 

docs <- dist( as.matrix(docvecs[,1:100]), method = "euclidean")
hclust_dist<- as.dist(docs)
hclust_dist[is.na(hclust_dist)] <- 0
hclust_dist[is.nan(hclust_dist)] <- 0
#sum(is.infinite(hclust_dist))  # THIS SHOULD BE 0
h <- hclust(hclust_dist, "ward.D2")
#hy <- hclust(hclust_dist, "ward.D")
#plot(h)
#ag <- agnes(hclust_dist,method="ward.D")
clustersx <- cutree(h, k = 2)
#clustersy <- cutree(hy, k = 2)
#clusters10 <- cutree(h, k = 10)
dc<-data.frame(cbind(docvecs,clustersx))
#describe(dc)
dc[,105] <- round.choose(dc[,102],100,0)
CrossTable(dc$clustersx,dc[,105],plot=True)

#plot document clusters
#tsne <- Rtsne(hclust_dist, perplexity = 9000, pca = FALSE)
tsne <- Rtsne(hclust_dist)
tsne_plot <- tsne$Y %>%
  as.data.frame() %>%
  mutate(cluster = factor(dc$clustersx)) %>%
  ggplot(aes(x = V1, y = V2, color=cluster)) + 
  theme_bw() +
  geom_point(shape=16)+
  scale_color_manual(values=c("steelblue","darkgray")) +
  xlab("Dimension 1") + 
  ylab("Dimension 2") +
  geom_text(size = 2)
tsne_plot
#  theme(legend.position = "none") +

ClusterPurity <- function(clusters, classes) {
  sum(apply(table(classes, clusters), 2, max)) / length(clusters)
}
ClusterPurity(dc$clustersx, dc[,105])

colors = c("steelblue","black")
dc$dccat <- ifelse(dc$V105>700, 2, 1)
clus2 = rbind(cutree(h, 2),dc$dccat)

#Silhouette plot
si3 <- silhouette(cutree(h, k = 2),hclust_dist)
plot(si3, col=c("steelblue","gray"), border=NA,main="", cex.names = 0.4)
si3df <- data.frame(si3)
