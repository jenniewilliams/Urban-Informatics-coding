library(xtable)
options(xtable.floating = FALSE)
options(xtable.timestamp = "")
library(ngram)
wordcount(histearth[,"content"])


#files from the Python output
topics2 <- read_csv("~/Documents/urban informatics/dissertation/dftopic.csv")
topics3 <- read_csv("~/Documents/urban informatics/dissertation/dftopic_3xlev.csv")
topics4 <- read_csv("~/Documents/urban informatics/dissertation/dftopic_4lev.csv")
topiccorp <- read_csv("~/Documents/urban informatics/dissertation/corpdf.csv")
docvecs <- read_csv("~/Documents/urban informatics/dissertation/docvecs100.csv")

#h comes from latestcorpuscode.R
#clustersx <- cutree(h, k = 2)
dc<-data.frame(cbind(topiccorp,topics2,docvecs[,102:104],clustersx,topics4,topics3,topicy))
#tbl <- with(dc, table(clustersx,topic))
#barplot(tbl, legend.text=c("Cluster 1","Cluster 2"), las=2, width = c( 1 ),space = 0.2,
#        col=c("steelblue","gray"), ylab = "Count of theses",xlab="Topic Number",
#        #        main="Run 1, Level 1: 31 topics (leaves), 10 iterations",
#        cex.names=0.8, cex.axis=0.8, cex.lab = 0.8,args.legend=list(cex=0.8))

#describe(dc3)
round.choose <- function(x, roundTo, dir = 1) {
  if(dir == 1) {  ##ROUND UP
    x + (roundTo - x %% roundTo)
  } else {
    if(dir == 0) {  ##ROUND DOWN
      x - (x %% roundTo)
    }
  }
}
dc$disc <- round.choose(dc$V102,100,0)

xtable(data.frame(CrossTable(dc$topic,dc$clustersx,plot=True)))
CrossTable(dc$topic,dc$disc,plot=True)

#Get No. of unique levels of topics
df_uniq <- unique(dc$topic)
length(df_uniq)

#Run 1
xtab <- data.frame(CrossTable(dc$topic,dc$disc,plot=True))
xtable(xtab,digits = 3)
tbl <- with(dc, table(disc,topic))
barplot(tbl, legend.text=c("Earth Sciences","History"), las=2, width = c( 1 ),space = 0.2,
        col=c("steelblue","gray"), ylab = "Count of theses",xlab="Topic Number",
#        main="Run 1, Level 1: 31 topics (leaves), 10 iterations",
        cex.names=0.8, cex.axis=0.8, cex.lab = 0.8,args.legend=list(cex=0.8))

#Get No. of unique levels of topics
df_uniq <- unique(dc$lev1)
length(df_uniq)
df_uniq <- unique(dc$lev2)
length(df_uniq)

#Run 2
xtab <- data.frame(CrossTable(dc$lev1,dc$disc,plot=True))
xtable(xtab,digits = 3)
tbl <- with(dc, table(disc,lev1))
barplot(tbl, legend.text=c("Earth Sciences","History"), las=2,
        col=c("steelblue","gray"), ylab = "Count of theses",xlab="Topic Number",
#        main="Run 2, Level 1: 16 topics (internal nodes), 100 iterations",
        cex.names=0.8, cex.axis=0.9, cex.lab = 0.9,args.legend=list(cex=0.8))

#write out table to csv file
xtab <- data.frame(CrossTable(dc$lev2,dc$disc,plot=True))
xtabdf <- xtable(xtab,digits = 3)
write.csv(xtabdf,'~/Documents/urban informatics/dissertation/BLdata/run2table2.csv')
#Lets cut the plot at 70 topics
dc407 <- dc[which(dc$lev2<407),]
#CrossTable(dc200$lev2,dc200$disc,plot=True)
tbl <- with(dc407, table(disc,lev2))
barplot(tbl, legend.text=c("Earth Sciences","History"), las=2,
        col=c("steelblue","gray"), ylab = "Count of theses",xlab="Topic Number",
#        main="Run 2, Level 2: 70 of 356 topics (leaves), 100 iterations",
        cex.names=0.7, cex.axis=0.8, cex.lab = 0.8,args.legend=list(cex=0.8))

#Get No. of unique levels of topics
df_uniq <- unique(dc$level1)
length(df_uniq)
df_uniq <- unique(dc$level2)
length(df_uniq)
df_uniq <- unique(dc$level3)
length(df_uniq)

#Run 3
xtab <- data.frame(CrossTable(dc$level1,dc$disc,plot=True))
xtable(xtab,digits = 3)


tbl <- with(dc, table(disc,level1))
barplot(tbl, legend.text=c("Earth Sciences","History"), las=2,
        col=c("steelblue","gray"), ylab = "Count of theses",xlab="Topic Number",
#        main="Run 3, Level 1: 14 topics (internal nodes), 10 iterations",
        cex.names=0.8, cex.axis=0.9, cex.lab = 0.9,args.legend=list(cex=0.8))

xtab <- data.frame(CrossTable(dc$level2,dc$disc,plot=True))
xtable(xtab,digits = 3)

#Lets cut the plot at 30 topics
dc341 <- dc[which(dc$level2<341),]
#
tbl <- with(dc341, table(disc,level2))
barplot(tbl, legend.text=c("Earth Sciences","History"), las=2,
        col=c("steelblue","gray"), ylab = "Count of theses",xlab="Topic Number",
#        main="Run 3, Level 2: 70 of 128 topics (internal nodes), 10 iterations",
        cex.names=0.7, cex.axis=0.8, cex.lab = 0.8,args.legend=list(cex=0.8))

#write out table to csv file
xtab <- data.frame(CrossTable(dc$level3,dc$disc,plot=True))
xtabdf <- xtable(xtab,digits = 3)
write.csv(xtabdf,'~/Documents/urban informatics/dissertation/BLdata/run3table3.csv')

dc137 <- dc[which(dc$level3<137),]

tbl <- with(dc137, table(disc,level3))
barplot(tbl, legend.text=c("Earth Sciences","History"), las=2, width = c( 1 ),
        col=c("steelblue","gray"), ylab = "Count of theses",xlab="Topic Number",
#        main="Run 3, Level 3: 70 of 2372 topics (leaves), 10 iterations",
        cex.names=0.7, cex.axis=0.8, cex.lab = 0.8,args.legend=list(cex=0.8))
title("")
#counting words.....
histearth[which(histearth$`EThOS Link`=="http://ethos.bl.uk/OrderDetails.do?uin=uk.bl.ethos.585120"),"Abstract"]
histearth[which(nchar(dc$text)==5),"content"]
