

library(ggplot2)
#fileName <- "~/Documents/urban informatics/stories/Group/moviecomb.txt"
fileName <- "~/Documents/urban informatics/stories/Group/movies_country_v_genre.txt"
conn <- file(fileName,open="r")
#install.packages("countrycode")
library(countrycode)
df <- read.table(conn, sep = '\t',header = TRUE, fileEncoding = "UTF-16LE")
close(conn)
df$Country[which(df$Country == "East Germany")] <- "Germany"
df$Country[which(df$Country == "West Germany")] <- "Germany"
df <- aggregate(. ~ Country,df,sum)
df$tot24 <- with(
  df,
  History+Short+Mystery+Family+Horror+Romance+War+Music+Drama+Biography+Crime+Action+Western+Sport+Adult+Comedy+Thriller+Documentary+Fantasy+Musical+Sci.Fi+Animation+Adventure
)
#countrycode(df$Country, "iso3c", "iso3c", warn = TRUE, nomatch = NA,
#            custom_dict = NULL, custom_match = NULL, origin_regex = FALSE)
df$Ccode <-countrycode(df$Country, 'country.name', 'iso2c')
df$continent <-countrycode(df$Country, 'country.name', 'continent')
df$gencname <-countrycode(df$Country, 'country.name', 'genc.name')
df$cowname <-countrycode(df$Country, 'country.name', 'cowc')

#cow name:
df$cowname[which(df$Country=="Vietnam")]<-"VNM"  
df$cowname[which(df$Country=="Serbia")]<-"SRB" 
df$cowname[which(df$Country=="Faroe Islands")]<-"FRO" 
df$cowname[which(df$Country=="Guadeloupe")]<-"GLP" 
df$cowname[which(df$Country=="Macau")]<-"MAC" 
df$cowname[which(df$Country=="Martinique")]<-"MTQ" 
df$cowname[which(df$Country=="Palestine")]<-"PSE" 
df$cowname[which(df$Country=="Puerto Rico")]<-"PRI" 
df$cowname[which(df$Country=="Hong Kong")]<-"HKG" 

fileNameU <- "~/Documents/urban informatics/stories/Group/UN_UrbanPop_percent_2010.txt"
connu <- file(fileNameU,open="r")
dfurb <- read.table(connu, sep = '\t',header = TRUE, fileEncoding = "UTF-16LE",comment.char = "", fill=T)
close(connu)
dfjoin <- merge(df,dfurb,by = "Country",all.x = TRUE)

fileNameR <- "~/Documents/urban informatics/stories/Group/UN_pop_christ_islam_2010.txt"
connR <- file(fileNameR,open="r")
dfrel <- read.table(connR, sep = '\t',header = TRUE, fileEncoding = "UTF-16LE",comment.char = "", fill=T)
dfall <- merge(dfjoin,dfrel,by = "cowname",all.x = TRUE)
close(connR)

dfall$Religion[dfall$Christian > 80] <- "Christian"
dfall$Religion[dfall$Islam > 80] <- "Islam"
dfall$Religion[dfall$Christian <= 80 & dfall$Islam <= 80] <- "Diverse"
dfall$Religion[dfall$Christian <= 80 & dfall$Islam <= 20] <- "Christian"
dfall$Religion[dfall$Christian <= 20 & dfall$Islam <= 80] <- "Islam"
dfall$Religion[dfall$Christian <= 30 & dfall$Islam <= 30] <- "Other"


dfall$Urbanisation[dfall$Urban > 66] <- "High"
dfall$Urbanisation[dfall$Urban < 33] <- "Low"
dfall$Urbanisation[dfall$Urban <= 66 & dfall$Urban >= 33] <- "Mixed"

write.table(dfall, file = "~/Documents/urban informatics/stories/Group/film_with_urban_pop_rel.csv",sep=",", col.names = TRUE, row.names = FALSE)
library(reshape2)
mdf <- melt(df,id=c("Country","Ccode","continent","gencname","cowname"))
names(mdf)[names(mdf) == 'variable'] <- 'Genre'
names(mdf)[names(mdf) == 'value'] <- 'FilmNo'
#sort by Genre (ascending) and FilmNo (descending)
attach(mdf)
dfnew <- mdf[order(Genre, -FilmNo, Country),] 
detach(mdf)
dfnew$Index = unlist(by(dfnew, dfnew$Genre, 
                    function(x) rank(-x$FilmNo, ties.method = "first")))

dfjoin2 <- merge(dfnew,dfurb,by = "Country",all.x = TRUE)

dfall2 <- merge(dfjoin2,dfrel,by = "cowname",all.x = TRUE)

dfall2$Religion[dfall2$Christian > 80] <- "Christian"
dfall2$Religion[dfall2$Islam > 80] <- "Islam"
dfall2$Religion[dfall2$Christian <= 80 & dfall2$Islam <= 80] <- "Diverse"
dfall2$Religion[dfall2$Christian <= 80 & dfall2$Islam <= 20] <- "Christian"
dfall2$Religion[dfall2$Christian <= 20 & dfall2$Islam <= 80] <- "Islam"
dfall2$Religion[dfall2$Christian <= 30 & dfall2$Islam <= 30] <- "Other"

dfall2$Urbanisation[dfall2$Urban > 66] <- "High"
dfall2$Urbanisation[dfall2$Urban < 33] <- "Low"
dfall2$Urbanisation[dfall2$Urban <= 66 & dfall2$Urban >= 33] <- "Mixed"

write.table(dfall2, file = "~/Documents/urban informatics/stories/Group/film_reshape.csv",sep=",", col.names = TRUE, row.names = FALSE)



#------------------------------------------------------------------------------------------------------
fileNameP <- "~/Documents/urban informatics/stories/Group/PRECIPUN.txt"
connP <- file(fileNameP,open="r")
pre <- read.table(connP, sep = '\t',header = TRUE, fileEncoding = "UTF-16LE",comment.char = "", fill=T)
close(connP)

library(data.table)
#DT <- data.table(dfpre)
#DT[, mean(Annual), by=Country]
dfpre <- aggregate(Annual~Country,pre,mean)
dfpre$cowname <-countrycode(dfpre$Country, 'country.name', 'cowc')
dfpre$cowname[which(dfpre$Country=="VIETNAM")]<-"VNM"  
dfpre$cowname[which(dfpre$Country=="SERBIA")]<-"SRB" 
dfpre$cowname[which(dfpre$Country=="FAROE ISLANDS")]<-"FRO" 
dfpre$cowname[which(dfpre$Country=="GUADELOUPE")]<-"GLP" 
dfpre$cowname[which(dfpre$Country=="MACAU")]<-"MAC" 
dfpre$cowname[which(dfpre$Country=="MARTINIQUE")]<-"MTQ" 
dfpre$cowname[which(dfpre$Country=="PALESTINE")]<-"PSE" 
dfpre$cowname[which(dfpre$Country=="PUERTO RICO")]<-"PRI" 
dfpre$cowname[which(dfpre$Country=="HONG KONG")]<-"HKG" 
keeps <- c("cowname","Annual")
dfpre <- dfpre[keeps]
dfcomb <- merge(dfall,dfpre,by = "cowname",all.x = TRUE)

write.table(dfcomb, file = "~/Documents/urban informatics/stories/Group/film_with_urban_pop_rel_precip.csv",sep=",", col.names = TRUE, row.names = FALSE)


library(ggplot2)
install.packages("ggridges")
library("ggridges")
#theme_set(theme_ridges())
ggplot(dfjoin, aes(x = Urban, y = continent)) +
  geom_density_ridges(aes(fill = continent)) +
  scale_fill_manual(values = c("#00AFBB", "#E7B800", "#FC4E07"))


boxplot(dfjoin[,2])
summary(dfjoin[,2])

code<-rep(NA,length(dfjoin$Urban))
code[which(dfjoin$Urban>=95)]<-1
code[which(dfjoin$Urban>=90 & dfjoin$Urban<95)]<-2
code[which(dfjoin$Urban>=85 & dfjoin$Urban<90)]<-3
code[which(dfjoin$Urban>=80 & dfjoin$Urban<85)]<-4
code[which(dfjoin$Urban>=75 & dfjoin$Urban<80)]<-5
code[which(dfjoin$Urban>=70 & dfjoin$Urban<75)]<-6
code[which(dfjoin$Urban>=65 & dfjoin$Urban<70)]<-7
code[which(dfjoin$Urban>=60 & dfjoin$Urban<65)]<-8
code[which(dfjoin$Urban>=55 & dfjoin$Urban<60)]<-9
code[which(dfjoin$Urban>=50 & dfjoin$Urban<55)]<-10
code[which(dfjoin$Urban>=45 & dfjoin$Urban<50)]<-11
code[which(dfjoin$Urban>=40 & dfjoin$Urban<45)]<-12
code[which(dfjoin$Urban>=35 & dfjoin$Urban<40)]<-13
code[which(dfjoin$Urban>=30 & dfjoin$Urban<35)]<-14
code[which(dfjoin$Urban>=25 & dfjoin$Urban<30)]<-15
code[which(dfjoin$Urban>=20 & dfjoin$Urban<25)]<-16
code[which(dfjoin$Urban<20)]<-17

#titlesX <-c()   ,xlab=titlesX[i-3]
par(mfrow=c(2,2)) # set more than one plot per figure
hist(dfjoin$Urban,main ="",xlab="%Urban Population",probability = TRUE)
for (i in 2:25){
  barplot(dfjoin[,2],dfjoin$code,col=code,pch=code,ylab="Urban")
}

pairs(Urban~Drama+Biography+Western+Adult,data=dfjoin, 
      main="Scatterplot Matrix of ", upper.panel = NULL)
pairs(Urban~History+Short+Mystery+Family+Horror+Romance+War+Music+Drama+Biography+Crime+Action+Western+Sport+Adult+Comedy+Thriller+Documentary+Fantasy+Musical+Sci.Fi+Animation+Adventure+Film.Noir
      ,data=dfjoin, 
      main="Scatterplot Matrix of ", upper.panel = NULL)


summary(dfjoin[,2])
for (i in 2:25){
#  bins <- seq(from=min(dfjoin[,i]),to=max(dfjoin[,2]),length.out = 11)
#  hist(dfjoin[,i],breaks=bins,main ="",probability = TRUE)
  d <- density(dfjoin[,i])
  plot(d)
}
plot(dfjoin[,2],dfjoin$Urban,col=code,pch=code,ylab="")

round(cor(dfjoin[2:24]), 2)

pcam <- as.matrix(pca$rotation[,1:3])
fit <-lm(Urban~History+Short+Mystery+Family+Horror+Romance+War+Music+Drama+Biography+Crime+Action+Western+Sport+Adult+Comedy+Thriller+Documentary+Fantasy+Musical+Sci.Fi+Animation+Adventure+Film.Noir, data=dfjoin)

summary(fit)

pca=prcomp(dfjoin[2:24],scale=TRUE)
summary(pca)
heatmap(pcam, Rowv=NA, Colv=NA, col = cm.colors(256), scale="column", margins=c(5,10))
screeplot(pca,col = heat.colors(10, alpha = 1),ylim = c(0, 6), xlim = c(0, 10),
          main ="Variance explained by the Principal Components"
)

#What are the top 5 most popular genres worldwide?
barplot(df[,2:10], main ="Boxplots for protein data",las=1,col = pal0, horizontal = TRUE)

"""
• What are the top 20 countries in movie making?
Doctor A would also like to find out some less obvious facts, such as
• Does the number of movies made by each continent differ significantly?
• Does each continent have a very different distribution of genres?

barplot(dfjoin[,2:25], main ="Boxplots for protein data",las=1,col = pal0, horizontal = TRUE)

#Is there any preference of genres that may be influenced by geographical, culture, political, 
#and religious reasons?
library(RColorBrewer)
pal0 <- brewer.pal(9, "Set1")
par(mar = c(2,6,2,2))
boxplot(df[,2:25], main ="Boxplots for movie data",las=1,col = pal0, horizontal = TRUE)

cor(dfjoin$Urban,dfjoin[,2:25])

ggplot(dfjoin, aes(x=Urban, y=Adult)) +
  geom_boxplot(aes(x=factor(Urban), group=Blade.Sh, col=Blade.Sh), width=.25)

barplot(df[,2:10], main ="Boxplots for protein data",las=1,col = pal0, horizontal = TRUE)





#This file was amended to change United Kingdom to UK & United States to USA
datac<-read_csv("~/Documents/urban informatics/stories/Group/cultindex.csv")
Alldf <- merge(df,datac,by="Country",all.x = TRUE)
#install.packages("tidyr")
library(tidyr)
long_DF <- Alldf %>% gather(Genre, Films, 2:29 )
d<-long_DF[!(long_DF$Films == 0),] 
#fill in 
attach(d)
#Set continent to Europe for the following: cowname: CZE, YUG, KOS & GDR + Country=Serbia and Montenegro
d$continent[cowname =="CZE"] <- "Europe"
d$continent[cowname =="YUG"] <- "Europe"
d$continent[cowname =="GDR"] <- "Europe"
d$continent[cowname =="KOS"] <- "Europe"
d$continent[Country =="Serbia and Montenegro"] <- "Europe"
detach(d)
library(RColorBrewer)
# What are the top 5 most popular genres worldwide?
ggplot(d, aes(x=Genre, y=Films, fill=continent, col = continent)) + 
  labs(title ="Bar plot: stacked bar graph") + 
  geom_bar(stat="identity", width=0.5) + coord_flip()


# What are the top 20 countries in movie making?

# Does the number of movies made by each continent differ significantly?
library(plotly)
p <- d %>%
  group_by(Genre) %>%
  summarize(count = sum(Films)) %>%
  plot_ly(labels = ~Genre, values = ~count) %>%
  add_pie(hole = 0.6) %>%
  layout(title = "A Genre Donut",  showlegend = T,
         xaxis = list(showgrid = F, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list(showgrid = F, zeroline = FALSE, showticklabels = FALSE))
p

# Pie Chart with Percentages
slices <- c(10, 12, 4, 16, 8) 
lbls <- c("US", "UK", "Australia", "Germany", "France")
pct <- round(df$Films/sum(Films)*100)
lbls <- paste(lbls, pct) # add percents to labels 
lbls <- paste(lbls,"%",sep="") # ad % to labels 
pie(slices,labels = lbls, col=rainbow(length(lbls)),
    main="Pie Chart of Countries")

# Does each continent have a very different distribution of genres?

# Is there any preference of genres that may be influenced by geographical, 
# culture, political, and religious reasons?

# If we connect or cluster together all those countries with a similar distribution 
# of genres, can we see any common features among those countries?
round(cor(df[2:29]), 2)

#colnames(df)
# Our question????

for (i in 2:29){
  print(var(df[i]))
}
#fit <-lm(total~History+Short+Mystery+Family+Horror+Romance+War+Music+Drama+Biography+Crime+Action+Western+Sport+Adult+Comedy+Thriller+Documentary+Fantasy+Musical+Sci.Fi+Animation+Adventure+Reality.TV+News+Film.Noir+Talk.Show+Game.Show
fit <-lm(total~History+Short+Mystery+Family+Horror+Romance+War+Music+Drama+Biography+Crime+Action+Western+Sport+Adult+Comedy+Thriller+Documentary+Fantasy+Musical+Sci.Fi+Animation+Adventure+Reality.TV+News+Film.Noir+Talk.Show+Game.Show
, data=df[2:30])
summary(fit)

for (i in 2:25){
  d <- density(df[i])
  plot(d)
}

d <- density(df$Romance)
plot(d)
d <- density(df$Adult)
plot(d)
d <- density(df$Western)
plot(d)
pca=prcomp(df[2:25],scale=TRUE)
summary(pca)

pcam <- as.matrix(pca$rotation[,1:3])
heatmap(pcam, Rowv=NA, Colv=NA, col = cm.colors(256), scale="column", margins=c(5,10))

screeplot(pca,col = heat.colors(10, alpha = 1),ylim = c(0, 6), xlim = c(0, 10),
          main ="Variance explained by the Principal Components"
)
print(pca)
#plot the first 2 principal components
biplot(pca)

total_order <- order(newdata$Total)
decat <- newdata[total_order,]
attach(df)
#total_order <- order(df$total)
dfo <- df[order(total,Country),]
detach(df)
#scale_x_discrete(limits=total)
df$
ggplot(dfo, aes(x=Country, y=total, fill=continent, col = continent)) + 
  labs(title ="Bar plot: stacked bar graph") + 
  geom_bar(stat="identity", width=0.5) + coord_flip()
par(las=2)
library(dplyr)
tabd <- table(d$continent,d$Films)
attach(d)
prop.table(xtabs(Films ~ continent))
detach(d)
boxplot(dfo[,2:29],
        main ="Boxplot of total films made", horizontal=TRUE)
#round(cor(dfo[,2:29]), 2)
# Reference:
# WRP dataset The Correlates of War project

# Zeev Maoz and Errol A. Henderson. 2013. “The World Religion Dataset, 1945-2010: Logic, Estimates, and Trends.” International Interactions, 39: 265-291. [version 1.1 accessed 4th Oct 2018]






