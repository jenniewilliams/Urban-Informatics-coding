

#install.packages("vegan")
install.packages("spatstat")

library(spatstat)
fileName <- "~/Documents/urban informatics/Urban/coursework/boston_points1.csv"

connP <- file(fileName,open="r")
dfP <- read.table(connP, sep = ',',header = TRUE, fileEncoding = "UTF-16LE")
close(connP)

fileName1 <- "~/Documents/urban informatics/Urban/coursework/boston_points_crime_weather.shp"
connP1 <- file(fileName1,open="r")
dfC <- read.table(connP1, sep = ',',header = TRUE, fileEncoding = "UTF-16LE")
close(connP1)
class(dfC)

x <- as.vector(df1$Lat)
xmin <- min(x)
xmax <- max(x)
y <- as.vector(df1$Long)
ymin <- min(y)
ymax <- max(y)

df_0 <- df1[ which(df1$WindGrp==0),]
df_1 <- df1[ which(df1$WindGrp==1),]
df_2 <- df1[ which(df1$WindGrp==2),]

df_3 <- df1[ which(df1$WindGrp==3),]
df_4 <- df1[ which(df1$WindGrp==4),]
df_5 <- df1[ which(df1$WindGrp==5),]
df_6 <- df1[ which(df1$WindGrp==6),]
df_7 <- df1[ which(df1$WindGrp==7),]
df_8 <- df1[ which(df1$WindGrp==8),]


x <- as.vector(df_0$Lat)
y <- as.vector(df_0$Long)
X <- ppp(x, y, c(xmin,xmax), c(ymin,ymax))
nnda <- nndist(X)
hist(nnda, 
     border="grey", 
     col="purple", 
     xlim=c(0,0.06), 
     ylim=c(0,300), 
     main="Calm (N=22)",
     xlab="Distance (km)", 
     ylab="Frequency",
     breaks=10,
     las=1, 
     prob = TRUE)
lines(density(nnda))
mean(nnda)
sum(nnda)
sum(nnda*nnda)

x <- as.vector(df_1$Lat)
y <- as.vector(df_1$Long)
X <- ppp(x, y, c(xmin,xmax), c(ymin,ymax))
nnda <- nndist(X)
hist(nnda, 
     border="grey", 
     col="purple", 
     xlim=c(0,0.06), 
     ylim=c(0,300), 
     main="Light air (N=27)", 
     xlab="Distance (km)", 
     ylab="Frequency",
     breaks=10,
     las=1, 
     prob = TRUE)
lines(density(nnda))
mean(nnda)
sum(nnda)
sum(nnda*nnda)

x <- as.vector(df_2$Lat)
y <- as.vector(df_2$Long)
X <- ppp(x, y, c(xmin,xmax), c(ymin,ymax))
nnda <- nndist(X)
hist(nnda, 
     border="grey", 
     col="purple", 
     xlim=c(0,0.06), 
     ylim=c(0,300), 
     main="Light breeze (N=207)", 
     xlab="Distance (km)", 
     ylab="Frequency",
     breaks=10,
     las=1, 
     prob = TRUE)
lines(density(nnda))
mean(nnda)
sum(nnda)
sum(nnda*nnda)

x <- as.vector(df_3$Lat)
y <- as.vector(df_3$Long)
X <- ppp(x, y, c(xmin,xmax), c(ymin,ymax))
nnda <- nndist(X)
hist(nnda, 
     border="grey", 
     col="purple", 
     xlim=c(0,0.06), 
     ylim=c(0,300), 
     main="Gentle breeze (N=316)", 
     xlab="Distance (km)", 
     ylab="Frequency",
     breaks=10,
     las=1, 
     prob = TRUE)
lines(density(nnda))
mean(nnda)
sum(nnda)
sum(nnda*nnda)

x <- as.vector(df_4$Lat)
y <- as.vector(df_4$Long)
X <- ppp(x, y, c(xmin,xmax), c(ymin,ymax))
nnda <- nndist(X)
hist(nnda, 
     border="grey", 
     col="purple", 
     xlim=c(0,0.06), 
     ylim=c(0,300), 
     main="Moderate breeze (N=336)", 
     xlab="Distance (km)", 
     ylab="Frequency",
     breaks=10,
     las=1, 
     prob = TRUE)
lines(density(nnda))
mean(nnda)
sum(nnda)
sum(nnda*nnda)

x <- as.vector(df_5$Lat)
y <- as.vector(df_5$Long)
X <- ppp(x, y, c(xmin,xmax), c(ymin,ymax))
nnda <- nndist(X)
hist(nnda, 
     border="grey", 
     col="purple", 
     xlim=c(0,0.06), 
     ylim=c(0,300), 
     main="Fresh breeze (N=56)", 
     xlab="Distance (km)", 
     ylab="Frequency",
     breaks=10,
     las=1, 
     prob = TRUE)
lines(density(nnda))
mean(nnda)
sum(nnda)
sum(nnda*nnda)

x <- as.vector(df_6$Lat)
y <- as.vector(df_6$Long)
X <- ppp(x, y, c(xmin,xmax), c(ymin,ymax))
nnda <- nndist(X)
hist(nnda, 
     border="grey", 
     col="purple", 
     xlim=c(0,0.06), 
     ylim=c(0,300), 
     main="Strong breeze (N=17)", 
     xlab="Distance (km)", 
     ylab="Frequency",
     breaks=10,
     las=1, 
     prob = TRUE)
lines(density(nnda))
mean(nnda)
sum(nnda)
sum(nnda*nnda)






round(cor(df1), 2)

"""
The Clark and Evans (1954) aggregation index R is a crude measure of 
clustering or ordering of a point pattern. It is the ratio of the 
observed mean nearest neighbour distance in the pattern to that expected 
for a Poisson point process of the same intensity. A value R>1 suggests 
ordering, while R<1 suggests clustering.
"""
#install.packages("maptools")
library(maptools)
burg = readShapeSpatial("~/Documents/urban informatics/Urban/coursework/boston_points_crime_weather.shp")
class(burg)
burglary <- as(burg, "ppp")
windows <- as.owin(burglary)
windows

df1(from = "SpatialPixelsDataFrame", to = "owin")
df1(from = "SpatialPoints", to = "ppp")
dfu <- unique(df)
dfu(from = "SpatialPixelsDataFrame", to = "owin")
#m <- factor(dfu$WindGrp, levels=0:8)

poly = readShapeSpatial("~/Documents/urban informatics/Urban/coursework/City_of_Boston_Boundary/City_of_Boston_Boundary.shp")

x <- as.vector(df1$Lat)
xmin <- min(x)
xmax <- max(x)
y <- as.vector(df1$Long)
ymin <- min(y)
ymax <- max(y)
m <- as.vector(df$WindGrp)
m <- factor(df$WindGrp, levels=0:8)
X <- ppp(x, y, c(xmin,xmax), c(ymin,ymax))
nnda <- nndist(X)
hist(nnd)

hist(nnda, 
     main="Histogram of nearest-neighbor distances", 
     xlab="Minimum distance between residential burglaries (Km)", 
     ylab="Number of residential burglaries",
     by=marks(m),
     border="grey", 
     col="purple", 
     ylim=c(0,700), 
     las=1, 
#     breaks=5, 
     prob = TRUE)
lines(density(nnd))
mean(nnda)

exp_nnd <- 0.5 / sqrt(gun$n / area.owin(W))

clarkevans(X, correction=c("none"))

plot(X, use.marks=FALSE)

clarkevans(redwood)

X <- rpoispp(100)
clarkevans(X)

#----------- descriptive statistics ---------------------------


mX <- mean(df$Lat)
# Mean of Latitude
mX
mY <- mean(df$Long)
# Mean of Longitude
mY
sdX <- sd(df$Lat)
# Standard Deviation of Latitude
sdX
sdY <- sd(df$Long)
# Standard Deviation of Longitude
sdY
sdist <- sqrt(sum(((df$Lat-mX)^2+(df$Long-mY)^2))/(nrow(df)))
#Standard Distance
sdist


#----------------------------------------------------------------
install.packages("geosphere")
library(geosphere)

f <- "~/Documents/urban informatics/Urban/coursework/areapoints.csv"
c <- file(f,open="r")
t <- read.table(c, sep = ',',header = TRUE, fileEncoding = "UTF-16LE")
close(c)
area <= areaPolygon(t)
a <- area/1000

p <- rbind(c(-71.2,42.2), c(-71.2,42.4), c(-70.9, 42.4), c(-70.9,42.2), c(-71.2,42.2))
areaPolygon(p)




#--------------------------------------------------------------------

#install.packages("plotrix")
install.packages("sp")
install.packages("raster")
install.packages("proj-bin")
install.packages("rgdal")
library(plotrix)
library(sp)
library(raster)
library(spatstat)
library(maptools)
library("rgdal")


jpeg("PP_Circle.jpeg",2500,2000,res=300)
plot(df,pch="+",cex=0.5,main="")
Bborder <- readShapeSpatial("~/Documents/urban informatics/Urban/coursework/City_of_Boston_Boundary/City_of_Boston_Boundary.shp")
Bborder@data
View(Bborder@data)


plot(Bborder)
points(mX,mY,col="red",pch=16)
draw.circle(mX,mY,radius=sdist,border="red",lwd=2)

dev.off()
















###################################################################
library(vegan)
fileName <- "~/Documents/urban informatics/Urban/coursework/boston_points1.csv"

connP <- file(fileName,open="r")
df <- read.table(connP, sep = ',',header = TRUE, fileEncoding = "UTF-16LE")
close(connP)

head(df)
data()

## Bray-Curtis distances between samples
dis <- vegdist(df)
head(dis)

## First 16 sites grazed, remaining 8 sites ungrazed
#groups <- factor(df$group, labels = c("grazed","ungrazed"))
groups <- df$WindGrp

## Calculate multivariate dispersions
mod <- betadisper(dis, groups)
mod

## Perform test
anova(mod)

## Permutation test for F
permutest(mod, pairwise = TRUE, permutations = 99)

## Tukey's Honest Significant Differences
(mod.HSD <- TukeyHSD(mod))
plot(mod.HSD)

## Plot the groups and distances to centroids on the
## first two PCoA axes
plot(mod)

## with data ellipses instead of hulls
plot(mod, ellipse = TRUE, hull = FALSE) # 1 sd data ellipse
plot(mod, ellipse = TRUE, hull = FALSE, conf = 0.90) # 90% data ellipse

## can also specify which axes to plot, ordering respected
plot(mod, axes = c(3,1), seg.col = "forestgreen", seg.lty = "dashed")

## Draw a boxplot of the distances to centroid for each group
boxplot(mod)

## `scores` and `eigenvals` also work
scrs <- scores(mod)
str(scrs)
head(scores(mod, 1:4, display = "sites"))
# group centroids/medians 
scores(mod, 1:4, display = "centroids")
# eigenvalues from the underlying principal coordinates analysis
eigenvals(mod) 

## try out bias correction; compare with mod3
(mod3B <- betadisper(dis, groups, type = "median", bias.adjust=TRUE))
anova(mod3B)
permutest(mod3B, permutations = 99)

## should always work for a single group
group <- factor(rep("grazed", NROW(varespec)))
(tmp <- betadisper(dis, group, type = "median"))
(tmp <- betadisper(dis, group, type = "centroid"))

## simulate missing values in 'd' and 'group'
## using spatial medians
groups[c(2,20)] <- NA
dis[c(2, 20)] <- NA
mod2 <- betadisper(dis, groups) ## messages
mod2
permutest(mod2, permutations = 99)
anova(mod2)
plot(mod2)
boxplot(mod2)
plot(TukeyHSD(mod2))

## Using group centroids
mod3 <- betadisper(dis, groups, type = "centroid")
mod3
permutest(mod3, permutations = 99)
anova(mod3)
plot(mod3)
boxplot(mod3)
plot(TukeyHSD(mod3))
