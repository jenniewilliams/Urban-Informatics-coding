fileName <- "~/Documents/urban informatics/Stats/Assignment1/protein.csv"

connP <- file(fileName,open="r")
df <- read.table(connP, sep = ',',header = TRUE, fileEncoding = "UTF-16LE")
close(connP)

titles <-c("Red Meat","White Meat","Eggs","Milk","Fish","Cereals","Starch","Nuts","Fr.Veg")
for (i in 2:10){
  cat("Median of ", titles[i-1]," is: ",median(df[,i])," and the Interquartile Range is:",IQR(df[,i]),"\n")
}

IQR(df[,2:9])

#mean(df$RedMeat)
#min(df$Eggs)
#max(df$Milk)
#sd(df$Fish)
#var(df$Cereals)
#range(df$Starch)
#quantile(df$Nuts)

pal0 <- brewer.pal(9, "Set1")
par(mar = c(2,6,2,2))
boxplot(df[,2:10], main ="Boxplots for protein data",las=1,col = pal0, horizontal = TRUE)

cor(df$Fr.Veg,df[2:9])


library(corrplot)
corr <- round(cor(df$Fr.Veg,df[2:9]),2)
row.names(corr) <-"Fr.Veg"
par(mar = c(4,4,4,4))
corrplot(corr, method="color",tl.srt=45, addCoef.col = "black")
title("Heatmap of Fruit & Veg Correlations in the Protein Data.", line = -1)

#----------------------------------------------------------------------------

fileName <- "~/Documents/urban informatics/Stats/Assignment1/DartPoints.csv"

connD <- file(fileName,open="r")
tabD <- read.table(connD, sep = ',',header = TRUE, fileEncoding = "UTF-16LE")
close(connD)
df <- as.data.frame(tabD)

code<-rep(NA,length(df$Name))
code[which(df$Name=="Darl")]<-1
code[which(df$Name=="Ensor")]<-2
code[which(df$Name=="Pedernales")]<-3
code[which(df$Name=="Travis")]<-4
code[which(df$Name=="Wells")]<-5

titlesX <-c("Maximum Width (mm)","Maxmimum Thickness (mm)","Basal width (mm)",
            "Juncture width (mm)","Haft element length (mm)","Weight (gm)")
par(mfrow=c(2,4)) # set more than one plot per figure
hist(df$Length,main ="",xlab="Maximum Length (mm)",probability = TRUE)
for (i in 4:9){
    plot(df[,i],df$Length,col=code,pch=code,ylab="",xlab=titlesX[i-3])
}


cols <- c(3:4, 9)
cor(df[,cols])
"""
Name
Dart point type: Darl, Ensor, Pedernales, Travis, Wells

Length   Maximum Length (mm)

Width    Maximum Width (mm)

Thickness   Maxmimum Thickness (mm)

B.Width   Basal width (mm)

J.Width   Juncture width (mm)

H.Length   Haft element length (mm)

Weight   Weight (gm)

Blade.Sh
Blade shape: E - Excurvate, I - Incurvate, R - Recurvate, S - Straight

Base.Sh
Base shape: E - Excurvate, I - Incurvate, R - Recurvate, S - Straight

Should.Sh
Shoulder shape: E - Excurvate, I - Incurvate, S - Straight, X - None

Should.Or
Shoulder orientation: B - Barbed, H - Horizontal, T - Tapered, X - None

Haft.Sh
Shape lateral haft element A - Angular, E - Excurvate, I - Incurvate, R - Recurvate, S - Straight

Haft.Or
Orientation lateral haft element: C - Concave, E - Expanding, P - Parallel, T - Contracting, V - Convex
"""
df <- as.data.frame(tabD)

ggplot(df, aes(x=Blade.Sh, y=Length)) +
  geom_boxplot(aes(x=factor(Blade.Sh), group=Blade.Sh, col=Blade.Sh), width=.25)

barplot(df[,2:10], main ="Boxplots for protein data",las=1,col = pal0, horizontal = TRUE)

par(mfrow=c(2,3))
par(mar = c(4,6,4,4))
hist(df$Length,main ="",xlab="Dart Point Length",probability = TRUE)
for (j in 10:15){
    plot(df$Length,df[,j],col=species_code,
           + pch=species_code,xlab=names(iris)[i],ylab=names(iris)[j])
    }
par(mfrow=c(2,3))
par(mar = c(4,4,6,4))
cols <-c("red","blue","yellow","green","pink","orange")
titles <-c("Blade Shape","Base Shape","Shoulder Shape","Shoulder orientation","Shape lateral haft","Orientation lateral haft element")
for (i in 1:6){
#  boxplot(Length~df[,i+9],data=df,col=cols[i],ylab="Length",main=titles[i])
  p <- ggplot(df, aes(factor(df[,10]), Length))
  p + geom_violin()
  }
title("\nPlots of Shape & Orientation Variable by Length", outer=TRUE) 

par(mfrow=c(2,3))
par(mar = c(4,4,6,4))
inside <- position_dodge(width = 0.5)
for (i in 1:6){
  ggplot(data = df, aes(x = factor(df[i+9]), y = Length, fill = factor(df[i+9]))) +
  geom_violin(position = inside) +
  geom_boxplot(width=.1, outlier.colour=NA, position = inside, show.legend=FALSE) + 
  labs(x = titles[i]) +
  labs(y = "Length") 
}



titles <-c("Blade Shape","Base Shape","Shoulder Shape","Shoulder orientation",
           "Shape lateral haft","Orientation lateral haft element")
ggplot(data = df, aes(x = factor(df$Blade.Sh), y = Length, fill = factor(df$Blade.Sh))) +
  geom_violin(position = inside) +
  geom_boxplot(width=.1, outlier.colour=NA, position = inside, show.legend=FALSE) + 
  labs(x = "Blade Shape") +
  labs(y = "Length") 
ggplot(data = df, aes(x = factor(df$Base.Sh), y = Length, fill = factor(df$Base.Sh))) +
  geom_violin(position = inside) +
  geom_boxplot(width=.1, outlier.colour=NA, position = inside, show.legend=FALSE) + 
  labs(x = "Base Shape") +
  labs(y = "Length") 
ggplot(data = df, aes(x = factor(df$Should.Sh), y = Length, fill = factor(df$Should.Sh))) +
  geom_violin(position = inside) +
  geom_boxplot(width=.1, outlier.colour=NA, position = inside, show.legend=FALSE) + 
  labs(x = "Shoulder Shape") +
  labs(y = "Length") 
ggplot(data = df, aes(x = factor(df$Should.Or), y = Length, fill = factor(df$Should.Or))) +
  geom_violin(position = inside) +
  geom_boxplot(width=.1, outlier.colour=NA, position = inside, show.legend=FALSE) + 
  labs(x = "Shoulder Orientation") +
  labs(y = "Length") 
ggplot(data = df, aes(x = factor(df$Haft.Sh), y = Length, fill = factor(df$Haft.Sh))) +
  geom_violin(position = inside) +
  geom_boxplot(width=.1, outlier.colour=NA, position = inside, show.legend=FALSE) + 
  labs(x = "Haft Shape") +
  labs(y = "Length") 
ggplot(data = df, aes(x = factor(df$Haft.Or), y = Length, fill = factor(df$Haft.Or))) +
  geom_violin(position = inside) +
  geom_boxplot(width=.1, outlier.colour=NA, position = inside, show.legend=FALSE) + 
  labs(x = "Haft Orientation") +
  labs(y = "Length") 

facet_grid(. ~ clarity) +
  

#install.packages("gplots")
library(gplots)
par(mfrow=c(2,3))
par(mar = c(4,4,6,4))
for (i in 1:6){
  fit <- aov(Length ~ df[,i+9], data=df)
  print(titles[i])
  print(summary(fit))
  plotmeans(Length~df[,i+9],xlab=titles[i],
            ylab="Maximum Length (mm)", main="Mean Plot\nwith 95% CI")
}


#-------------------------------------------------------------------------------
df$Weightcat <- cut(df$Weight, breaks=c(2, 4, 6, 8, 10, 12, 14, Inf), 
                    labels=c("2-4", "4-6","6-8","8-10","10-12","12-14",">14"))
classtab = table(df$Weightcat,df$Blade.Sh)
classrf <-prop.table(classtab,2)

classdrf <- data.frame(classrf)
classdfr <- setNames(classdrf, c("Weight","Blade_Shape","Freq"))

ggplot(subset(classdfr,Blade_Shape=="E"),aes(x=Weight,y=Freq))+
  geom_bar(stat="identity",position="dodge",color="lightblue", fill="lightblue")+
  labs(title ="Relative Frequency of binned Weight for Blade Shape: Excurvate")+
  xlab("Binned Weight")+ylab("Relative Frequency")
ggplot(subset(classdfr,Blade_Shape=="I"),aes(x=Weight,y=Freq))+
  geom_bar(stat="identity",position="dodge",color="lightblue", fill="lightblue")+
  labs(title ="Relative Frequency of binned Weight for Blade Shape: Incurvate")+
  xlab("Binned Weight")+ylab("Relative Frequency")
ggplot(subset(classdfr,Blade_Shape=="R"),aes(x=Weight,y=Freq))+
  geom_bar(stat="identity",position="dodge",color="lightblue", fill="lightblue")+
  labs(title ="Relative Frequency of binned Weight for Blade Shape: Recurvate")+
  xlab("Binned Weight")+ylab("Relative Frequency")
ggplot(subset(classdfr,Blade_Shape=="S"),aes(x=Weight,y=Freq))+
  geom_bar(stat="identity",position="dodge",color="lightblue", fill="lightblue")+
  labs(title ="Relative Frequency of binned Weight for Blade Shape: Straight")+
  xlab("Binned Weight")+ylab("Relative Frequency")




library(ggplot2)
ggplot(classdfr,aes(x=Weight,y=Freq,fill=factor(Blade_Shape)))+
  geom_bar(stat="identity",position="dodge")+
  scale_fill_discrete(name="Blade Shape",
                      breaks=c("E", "I","R","S"),
                      labels=c("Excurvate", "Incurvate","Recurvate","Straight"))+
  xlab("Binned Weight")+ylab("Relative Frequency")

--------------last histogram-------------------
  
  
blade <- subset(classdfr,Blade_Shape=="E")
barplot(blade$Freq, blade$Weight, col = "lightblue", border = "pink")
blade <- subset(classdfr,Blade_Shape=="I")
hist(blade$Freq, breaks = 7, col = "lightblue", border = "pink")
blade <- subset(classdfr,Blade_Shape=="R")
hist(blade$Freq, breaks = 7, col = "lightblue", border = "pink")
blade <- subset(classdfr,Blade_Shape=="S")
hist(blade$Freq, breaks = 7, col = "lightblue", border = "pink")

data<-read.table("~/Documents/urban informatics/Stats/plant_class_data.txt",header=TRUE)
attach(data)
# reorder size levels
size<-factor(size,levels=c("very low","low","medium","high","very high"))
# absolute frequency table
table(X.type.,size)
table(X.type.,size)/dim(data)[1]
barplot(table(X.type.,size)[3,]/length(which(X.type.=="trt3")),main = "Type= trt3")
table(X.type.,size)



library(ggplot2)
ggplot(classdfr, aes(x=Weight, y=Freq, group=Blade_Shape, colour=Blade_Shape)) + 
  labs(title ="Relative Frequency of binned Weight by Blade Shape") + 
  geom_line(linetype=1) + 
  geom_point(size=2, shape=19)

library(ggplot2)
ggplot(classdfr, aes(x=Weight, y=Freq, group=Blade_Shape, colour=Blade_Shape)) + 
  labs(title ="Relative Frequency of binned Weight by Blade Shape") + 
  geom_line(linetype=1) + 
  geom_point(size=2, shape=19)

ggplot(classdfr, aes(Weight, fill=Blade_Shape,colour = Blade_Shape)) +
  geom_histogram(stat=Freq)





"""
ggplot(tabD, aes(x=Blade.Sh, y=Length, fill=Name, col = Name)) + 
  labs(title ="Bar plot: stacked bar graph") + 
  geom_bar(stat="identity", width=0.5) + coord_flip()
  ggplot(df, aes(x=df[,i+9], y=Length)) +
    geom_boxplot(aes(x=factor(df[,i+9]), group=df[,i+9], col=df[,i+9]), width=.25)


pairs(Length~Width+Thickness+Weight+B.Width+J.Width+H.Length,data=tabD, 
      main="Scatterplot Matrix of ",col=Name, upper.panel = NULL)
"""

