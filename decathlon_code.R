library(readr)
newdata <- read_csv("~/Documents/analytics/decathlon_uk_row.csv")
total_order <- order(newdata$Total)
decat <- newdata[total_order,]

# We have 2 groups of data, the top 10 UK and ROW decathletes.
# In order to give meanings to the 10 events carry out a Principal Component Analysis
# for UK and then ROW seperately
# talk about the analysis found online which says that throwing events have 
# more weight in the overall score - this should not be the case - but since
# that analysis didnt take into account that fast times for a running race are
# better than slower times whereas in throwing & jumping events the bigger the 
# the measurement the better the athlete, this wasn't accounted for in their analysis.
# --------------------------------------------------------
# Give the background to these equations, IAAF has adjusted then 12 times in 
# order to ensure that no one event is given an advantage. 
#    Track event points=A×(B−T)C
#    Field event points=A×(D−B)C
#---------------------------------------------------------
#   Event	          A	      B	    C

decat$P100   = as.integer(25.4347*((18-decat$D100m)**1.81))
decat$P110 = as.integer(5.74352*((28.5-decat$D110mH)**1.92))
decat$P400   = as.integer(1.53775*((82-decat$D400m)**1.81))
decat$PHJ    = as.integer(0.8465*(((decat$HJ*100)-75)**1.42))
decat$PPV    = as.integer(0.2797*(((decat$PV*100)-100)**1.35))
decat$PLJ    = as.integer(0.14354*(((decat$LJ*100)-220)**1.4))
decat$PDT    = as.integer(12.91*((decat$Discus-4)**1.1))
decat$PSP    = as.integer(51.39*((decat$SP-1.5)**1.05))
decat$PJT    = as.integer(10.14*((decat$Jav-7)**1.08))
decat$P1500  = as.integer(0.03768*((480-decat$D1500m)**1.85))

#----------------------------------------------------------
# Run a PCA on the combined dataset. Interpret your results and plot the first PC 
# against the 2nd Is there any evidence that there are 2 different groups of athletes
# based on the events? No.....
decat$totptsX <- with(
  decat,
  P100+PLJ+PSP+PHJ+P400+P110+PDT+PPV+PJT+P1500
)
#print out the correlation matrix

# discuss which is better to base the principal components on.

var(decat$P100)
var(decat$P110)
var(decat$P400)
var(decat$P1500)
var(decat$PLJ)
var(decat$PHJ)
var(decat$PPV)
var(decat$PDT)
var(decat$PSP)
var(decat$PJT)

fit <-lm(totptsX~P110+PDT, data=decat[15:25])
summary(fit)
#check into whether its a good idea to normalise the data or not.
#normalize <- function(x) {
#  return ((x - min(x)) / (max(x) - min(x)))
#}
#decNorm <- as.data.frame(lapply(decat[,15:24], normalize))

#standardize <- function(x) {
#  return ((x - mean(x)) / sd(x))
#}
#decStand <- as.data.frame(lapply(decat[,15:24], standardize))


#print out the correlation matrix
round(cor(decat[15:24]), 2)

boxplot(decat[15:24],main ="Boxplot of points scored for each event")
mean(decat[,15:24])
means <- tapply(decat[15:24],mean)
points(means,col="red",pch=18)






# Make the boxplot and save the boxplot object
rb <- boxplot(decat[15:24],main ="Boxplot of points scored for each event")
# Compute the means
summary(decat[15:24])
# Add them as triangles.
points(seq(rb$n), mean.value, pch = 17)

boxplot(decat[1:10,15:24],
        main ="Boxplot of points scored for each event for UK Athletes")
boxplot(decat[11:20,15:24],
        main ="Boxplot of points scored for each event for ROW Athletes")


#run prinicpal component anaylsis with the correlation matrix scale=TRUE
#decathlon.princomp.pca=prcomp(decathlon[,2:11],scale=TRUE)
#summary stats

# How much of the overall variation is explained by each of the principal 
# components for UK and ROW decathletes - taken from the summary results
#      UK   ROW
#PC1   41%  42%
#PC2   24%  21%
#PC3   14%  14%
#pcauk=prcomp(decNorm[1:10,],scale=TRUE)
#summary(pcauk)


#pcarow=prcomp(decNorm[11:20,],center=TRUE,scale=TRUE)
#summary(pcarow)
#pca=prcomp(decNorm[],scale=TRUE)
#summary(pca)
pca=prcomp(decat[15:24],scale=TRUE)
summary(pca)
pcam <- as.matrix(pca$rotation[,1:3])
heatmap(pcam, Rowv=NA, Colv=NA, col = cm.colors(256), scale="column", margins=c(5,10))

screeplot(pca,col = heat.colors(10, alpha = 1),ylim = c(0, 6), xlim = c(0, 10),
        main ="Variance explained by the Principal Components"
)
#screeplot(pca, npcs = 10, type = "lines",ylim = c(0, 6),
#          main ="Proportion of Variance for each Principal Component")
lmean <- (0.5185+0.1434+0.1162+0.0664+0.056784+0.04223+0.02457+0.01933+0.00862+0.00392)/10
#lmeanDecathlon <- (0.3036+0.1806+0.1134+0.09766+0.07881+0.06695+0.05797+0.04749+0.02761+0.02591)/10
#lmeanROW <- (0.4283+0.2140+0.1438+0.08034+0.05849+0.04176+0.02401+0.00925+0.00008 +0)/10

#print out the principal components
print(pca)
#plot the first 2 principal components
biplot(pca)

install.packages('XQuartz') 
library(rgl)
plot3d(pca$scores[,1:3])
plot(pca)
#------------------------------------------------
pcam <- as.matrix(pca$rotation[,1:3])
install.packages('scatterplot3d') 
library(scatterplot3d) 
s3d = scatterplot3d(x=pcam[1],y=pcam[2],z=pcam[3], xlab='Comp.1', ylab='Comp.2', zlab='Comp.3')














round(cor(decat[,15:11]), 2)

biplot(pcauk)
biplot(pcarow)
biplot(pca)
install.packages("rgl")
install.packages("XQuartz")
library(XQuartz)
library(rgl)
library(plotly)
packageVersion('plotly')
pcadf <- as.data.frame(pca$rotation)
p <- plot_ly(pcadf,x=pcadf[1],y=pcadf[2],z=pcadf[3])%>%
  add_markers() %>%
  layout(scene = list(xaxis = list(title = 'PC1'),
                      yaxis = list(title = 'Gross horsepower'),
                      zaxis = list(title = '1/4 mile time')))

install.packages("plotly")
install.packages("tibble")
install.packages("tidyr")
install.packages("jsonlite")
library(plotly)
require(devtools)
install_version("plotly", version = "4.5.6", repos = "http://cran.us.r-project.org")
p <- plot_ly(pcadf,x=~pcadf[1],y=~pcadf[2],z=~pcadf[3],type = "scatter3d",mode = "markers")
p
# Create a shareable link to your chart
# Set up API credentials: https://plot.ly/r/getting-started
chart_link = plotly_POST(p, filename="scatter3d/colorscale")
chart_link

#print out the eigen vectors
#decathlon.princomp.pca$rotation
# write down each principal component in terms of the original measurements
# For UK Y1 = -0.45xD100m -0.31xD400m etc.....
# For UK, PC1 appears to represent events which involve sprinting
# For ROW.......
print(pcauk)
print(pcarow)
print(pca)
round(cor(decat[,15:24]), 2)
install.packages("GDAdata")
library("GDAdata")
data(Decathlon)
Decathlon

#Correlation vs Covariance ????
#Examine the plots and the eigenvectors
#What do the results tell us?
#Which analysis is more appropriate
