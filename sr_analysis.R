# 3.	
# Choose either a Twitter identifier (@) or hashtag (#) or a public Facebook page to analyse. 
# Run a query against Twitter to extract 250 Tweets. Produce two analyses. 
# The first analysis should showcase the most influential users and the second should 
# visualise the textual content with a wordcloud. 
# In particular: 
# In Twitter the most influential users are those with the largest number of followers. 
# So, you need to either find those from a group of user using a # or find the most influential 
# one for a @. 
# Please, include in your answer at least one API key to demonstrate that you have created 
# your own and describe in 2-3 sentences your result.

#install.packages('ggplot2')
# run the key file


library(tm)
library(NLP)
library(ggplot2)
library(twitteR)


#twitter_consumer_key
# prepare local environment
options(httr_oauth_cache=TRUE)
setup_twitter_oauth(twitter_consumer_key, twitter_consumer_secret,twitter_access_token, twitter_access_secret)
#spRead <- getUser('SpeedReads')
spRead <- getUser('lilpump')


sp_follower_IDs<-spRead$getFollowers(retryOnRateLimit=180)
sp_followers_df <- twListToDF(sp_follower_IDs)
sp_followers_df$friendsCount<-sp_followers_df$friendsCount/1000000
sp_followers_df$followersCount<-sp_followers_df$followersCount/1000000

# remove the twitter verified and only display followers with more than half a million followers
sp_followers <- subset(sp_followers_df, screenName != 'verified' & followersCount>0.5)
plot(sp_followers$friendsCount, sp_followers$followersCount, 
     main='Friend and follower counts of @SpeedReads followers who have >0.5 million followers.', 
     xlab='Friends (millions)', ylab='Followers (millions)')
text(sp_followers$friendsCount, sp_followers$followersCount, 
     labels=sp_followers$screenName, cex= 0.6, pos=3)

# Get 250 tweets from the SpeedReads
sp<-userTimeline('SpeedReads', n=250)
sp_tweets <-twListToDF(sp)
# removes @ words
sp0<-gsub("@([a-zA-Z0-9]|[_])*", "", sp_tweets$text)
# removes URLs
sp1<-gsub(" ?(f|ht)tp(s?)://(.*)[.][a-z]+", "", sp0)
sp2<-gsub("/([a-zA-Z0-9]|[_])*", "", sp1)
sp3<-gsub('[[:punct:] ]+',' ',sp2)
sptweet<-as.data.frame(sp3)
# convert the emoticons.....
tweets2 <- data.frame(text = iconv(sptweet$sp3, "latin1", "ASCII", "byte"), stringsAsFactors = FALSE)
#get rid of all punctuation except for <>
corp<-Corpus(DataframeSource(tweets2))

orbit<-content_transformer(function(x,pattern){return(gsub(pattern,"",x))})
# seperate out the <> emoticon symbols and group them back together again
corp<-tm_map(corp,content_transformer(gsub),pattern="> <",replacement="> _ <")
corp<-tm_map(corp,content_transformer(gsub),pattern=">  <",replacement="> _ <")
corp<-tm_map(corp,content_transformer(gsub),pattern="<",replacement="x<")
corp<-tm_map(corp,content_transformer(gsub),pattern=">",replacement=">x")
corp<-tm_map(corp,content_transformer(gsub),pattern=">xx<",replacement="><")
corp<-tm_map(corp,content_transformer(gsub),pattern='"',replacement='')
corp<-tm_map(corp,content_transformer(gsub),pattern="<>",replacement=" ")
corp<-tm_map(corp,content_transformer(gsub),pattern=">x _ x<",replacement="> <")
# writeLines(as.character(corp[[3]]))

# remove hyphens & convert to lower case
corp<-tm_map(corp,orbit,"-")
corp<-tm_map(corp,content_transformer(tolower))

#remove the word 'page' from the text because it appears on every page and
#is not interesting to the analysis
corp<-tm_map(corp,removeWords,"page")

# don't remove numbers as the hex codes for the emoticons will disappear.......
#corp<-tm_map(corp,removeNumbers)
# remove blank spaces except when they seperate the words
corp<-tm_map(corp, stripWhitespace)

#punctuation removal needs to go after words because english.dat contains punctuation
words <- readLines(system.file("stopwords", "english.dat",package = "tm"))
corp<-tm_map(corp,removeWords,words)

#get rid of all punctuation except for <>
#corp <- tm_map(corp, orbit, "[!\"#$%&'*+,./)(:;=?@\][\\^`{|}~]")
#corp<-tm_map(corp,removePunctuation)

# words to remove not contained in "english.dat"
corp<-tm_map(corp,removeWords,"said")
corp<-tm_map(corp,removeWords,"ill")
corp<-tm_map(corp,removeWords,"ive")
corp<-tm_map(corp,removeWords,"youre")
corp<-tm_map(corp,removeWords,"hed")
corp<-tm_map(corp,removeWords,"hes")
corp<-tm_map(corp,removeWords,"thats")
corp<-tm_map(corp,removeWords,"wasnt")
corp<-tm_map(corp,removeWords,"didnt")
corp<-tm_map(corp,removeWords,"couldnt")
corp<-tm_map(corp,removeWords,"cant")
corp<-tm_map(corp,removeWords,"dont")
corp<-tm_map(corp,removeWords,"doesnt")
corp<-tm_map(corp,removeWords,"arent")
corp<-tm_map(corp,removeWords,"dyou")
corp<-tm_map(corp,removeWords,"therees")
corp<-tm_map(corp,removeWords,"eaa")
corp<-tm_map(corp,removeWords,"eamade")
corp<-tm_map(corp,removeWords,"itea")
corp<-tm_map(corp,removeWords,"twitterorguk")
corp<-tm_map(corp,removeWords,"weell")
corp<-tm_map(corp,removeWords,"weere")
corp<-tm_map(corp,removeWords,"weeve")
corp<-tm_map(corp,removeWords,"weeveea")
corp<-tm_map(corp,removeWords,"wonet")
corp<-tm_map(corp,removeWords,"amp")
corp<-tm_map(corp,removeWords,"amp")
corp<-tm_map(corp,removeWords,"amp")
corp<-tm_map(corp,content_transformer(gsub),pattern="hunting",replacement="hunt")
corp<-tm_map(corp,content_transformer(gsub),pattern="hunts",replacement="hunt")
corp<-tm_map(corp,content_transformer(gsub),pattern="clarification",replacement="clarify")
corp<-tm_map(corp,content_transformer(gsub),pattern="clarifyea",replacement="clarify")
corp<-tm_map(corp,content_transformer(gsub),pattern="dates",replacement="date")
corp<-tm_map(corp,content_transformer(gsub),pattern="licences",replacement="licence")
corp<-tm_map(corp,content_transformer(gsub),pattern="licenced",replacement="licence")
corp<-tm_map(corp,content_transformer(gsub),pattern="licensed",replacement="licence")
corp<-tm_map(corp,content_transformer(gsub),pattern="licenses",replacement="licence")
corp<-tm_map(corp,content_transformer(gsub),pattern="licensing",replacement="licence")
corp<-tm_map(corp,content_transformer(gsub),pattern="photos",replacement="photo")
corp<-tm_map(corp,content_transformer(gsub),pattern="reports",replacement="report")
corp<-tm_map(corp,content_transformer(gsub),pattern="reported",replacement="report")
corp<-tm_map(corp,content_transformer(gsub),pattern="specify",replacement="specific")
corp<-tm_map(corp,content_transformer(gsub),pattern="websiteea",replacement="website")
corp<-tm_map(corp,content_transformer(gsub),pattern="works",replacement="work")
corp<-tm_map(corp,content_transformer(gsub),pattern="working",replacement="work")
corp<-tm_map(corp,content_transformer(gsub),pattern="indictments",replacement="indictment")
corp<-tm_map(corp,content_transformer(gsub),pattern="republicans",replacement="republican")
corp<-tm_map(corp,content_transformer(gsub),pattern="autumnal",replacement="autumn")
corp<-tm_map(corp,content_transformer(gsub),pattern="colours",replacement="colour")
corp<-tm_map(corp,content_transformer(gsub),pattern="enjoyed",replacement="enjoy")
corp<-tm_map(corp,content_transformer(gsub),pattern="exploring",replacement="explore")
corp<-tm_map(corp,content_transformer(gsub),pattern="helping",replacement="help")
corp<-tm_map(corp,content_transformer(gsub),pattern="helps",replacement="help")
corp<-tm_map(corp,content_transformer(gsub),pattern="images",replacement="image")
corp<-tm_map(corp,content_transformer(gsub),pattern="looking",replacement="look")
corp<-tm_map(corp,content_transformer(gsub),pattern="looks",replacement="look")
corp<-tm_map(corp,content_transformer(gsub),pattern="membership",replacement="member")
corp<-tm_map(corp,content_transformer(gsub),pattern="members",replacement="member")
corp<-tm_map(corp,content_transformer(gsub),pattern="publishing",replacement="publish")
corp<-tm_map(corp,content_transformer(gsub),pattern="visits",replacement="visit")
corp<-tm_map(corp,content_transformer(gsub),pattern="visiting",replacement="visit")
corp<-tm_map(corp,content_transformer(gsub),pattern="emojis",replacement="emoji")
corp<-tm_map(corp,content_transformer(gsub),pattern="<>",replacement="  ")
corp<-tm_map(corp,content_transformer(gsub),pattern="sexual",replacement="sex")
corp<-tm_map(corp,content_transformer(gsub),pattern="reportly",replacement="report")
corp<-tm_map(corp,content_transformer(gsub),pattern="sen",replacement="senator")
corp<-tm_map(corp,content_transformer(gsub),pattern="senatoratorate",replacement="senate")
corp<-tm_map(corp,content_transformer(gsub),pattern="senatorator",replacement="senator")

corp<-tm_map(corp,removeWords,"says")
corp<-tm_map(corp,removeWords,"000")
corp<-tm_map(corp,removeWords,"2016")
corp<-tm_map(corp,removeWords,"2020")
corp<-tm_map(corp,removeWords,"wants")

library("qdapDictionaries")
data(Fry_1000)

corp<-tm_map(corp,removeWords,Fry_1000)

# writeLines(as.character(corp[[1]]))

# create a matrix of unique words from the Corpus
docterms<-TermDocumentMatrix(corp)
freq.terms <- findFreqTerms(docterms, lowfreq=1)
term.freq <- rowSums(as.matrix(docterms))
term.freq <- subset(term.freq, term.freq >=1)
df <- data.frame(term = names(term.freq), freq = term.freq)

eotw$term <- eotw$`R-encoding`
df0<-merge(df,eotw,by="term",all.x=TRUE)
df0$newterm<- ifelse(is.na(df0$Decode), as.character(df0$term), as.character(df0$Decode))
df1<-subset(df0,df0$freq>5)
ggplot(df1, aes(x=newterm, y=freq)) + geom_bar(stat = "identity") + xlab("Terms") + ylab("Count") +coord_flip()
library(wordcloud)

#corp <- twitter_fast_text(search_term, ntwee$text)
pal <- brewer.pal(6,"Dark2")
# words,freq,scale,min.freq,max.words,random.order,random.color,rot.per,colors,
# ordered.colours,use.r.layout,fixed.asp
# For SpeedReads
wordcloud(df0$newterm,df0$freq,c(5,.2),2,250,FALSE,,.4,pal,vfont=c("serif","plain"))
# Topics
dtm <- DocumentTermMatrix(corp_small)          
terms(topic_model, 10)


p <- plot_ly(data, x = ~wt, y = ~mpg, type = 'scatter', mode = 'markers',
             marker = list(size = 10)) %>%
  add_annotations(x = data$wt,
                  y = data$mpg,
                  text = rownames(data),
                  xref = "x",
                  yref = "y",
                  showarrow = TRUE,
                  arrowhead = 4,
                  arrowsize = .5,
                  ax = 20,
                  ay = -40)
