#read in the DartPoints file 
fileName <- "~/Documents/urban informatics/Stats/Assignment2/DartPoints.csv"
connD <- file(fileName,open="r")
tabD <- read.table(connD, sep = ',',header = TRUE, fileEncoding = "UTF-16LE")
close(connD)
df <- as.data.frame(tabD)
df$llen = log10(df$Length)
df$lwei = log10(df$Weight)
df$lwid = log10(df$Width)
df$lthi = log10(df$Thickness)
dpd <- subset(df, subset=(Name=="Pedernales" | Name=="Darl" ))

summary(df[2:15])

layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page 

par(mar = c(4,6,4,4))
hist(dpd[3:9],
     col="blue",
     freq=FALSE
)
library("DescTools")
options(scipen=10)
library(RColorBrewer)
pal0 <- brewer.pal(9, "Set1")
par(mar = c(3,6,3,3))
par(mfrow=c(2,2))
boxplot(Weight~Name, df,
        main ="Weight",las=1,col = pal0, horizontal = TRUE)
boxplot(Length~Name, df,
        main ="Length",las=1,col = pal0, horizontal = TRUE)
boxplot(Width~Name, df,
        main ="Width",las=1,col = pal0, horizontal = TRUE)
boxplot(Thickness~Name, df,
        main ="Thickness",las=1,col = pal0, horizontal = TRUE)

numSummary(df[3:9],statistics=c("mean","sd","skewness","kurtosis"))

panel.cor <- function(x, y, digits = 2, prefix = "", cex.cor)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  r <- abs(cor(x, y,use="na.or.complete"))
  txt <- format(c(r, 0.123456789), digits = digits)[1]
  txt <- paste0(prefix, txt)
  if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
  text(0.5, 0.5, txt, cex = cex.cor * r *2)
}
pairs(dpd[3:9], main = "DartPoints scatterplots and correlation",
      cex = 1.5, 
      cex.labels = 2, font.labels = 2,
      lower.panel = panel.smooth, upper.panel = panel.cor,
      gap=0, row1attop=FALSE)


fitlm1 <- lm(Weight~Width+Thickness+Blade.Sh+Should.Or+Haft.Sh,data=dpd)
summary(fitlm1)
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page 
plot(fitlm1)

coefficients(fitlm1) # model coefficients
confint(fitlm1, level=0.95) 

newdata = data.frame(Width=60,Thickness=50,Blade.Sh="R",Should.Or="B",Haft.Sh="E")
predict(fitlm1,newdata,interval="confidence")
"""
Predict the expected dart weight for a dart point of type Travis, with 
maximum length 70 mm, H.Length 60mm, Thickness 50 mm, B.Width 50 mm, 
J.Width 50 mm, Width 60 mm and with both blade shape and base shape recurvate, 
straight shoulder shape, barbed shoulder orientation, 
excurvate shape for the lateral haft element and 
parallel orientation of the lateral haft element. 
"""

#fitlm2 <- lm(Weight~Width+Blade.Sh.new+Should.Or.new+Haft.Sh.new,data=dpd)

# unfortunately there are no factor variables H or S in our previous model 
# so I will select other new variables where the value is 1 
fitlm2 <- lm(Weight~Width+Thickness+Blade.Sh.new+Should.Or.new+Haft.Sh.new,data=dpd)
summary(fitlm2)
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page 
plot(fitlm2)
newdata2 = data.frame(Width=60,Thickness=50,Should.Sh.new=1)
predict(fitlm2,newdata2,interval="confidence")
anova(fitlm1,fitlm2,test="Chisq")

fitlm3 <- lm(lwei~Width+Thickness+Blade.Sh+Should.Or+Haft.Sh,data=dpd)
summary(fitlm3)
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page 
plot(fitlm3)






layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page 
plot(fitlw)
summary(dpd)
coefficients(fitlw) # model coefficients
confint(fitlw, level=0.95) # CIs for model parameters 

library(MASS)
boxcox(fitlw)
fitlw <- lm(lwei~lwid+lthi+Blade.Sh+Should.Or+Haft.Sh,data=dpd)
summary(fitlw)
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page 
plot(fitlw)

boxplot(Weight~Name, dpd,
        main ="Weight",las=1,col = pal0, horizontal = TRUE)


fitlw <- lm(Weight~Width+Blade.Sh.new+Should.Or.new+Haft.Sh,data=dpd)
summary(fitlw)
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page 
plot(fitlw)
summary(dpd)
coefficients(fitlw) # model coefficients
confint(fitlw, level=0.95) # CIs for model parameters 

fitlw <- lm(Weight~Width+Blade.Sh.new+Should.Or.new,data=dpd)
summary(fitlw)


df$Blade.Sh.new<-0
df$Blade.Sh.new[which(df$Blade.Sh=="S" | df$Blade.Sh=="H")]<-1
df$Base.Sh.new<-0
df$Base.Sh.new[which(df$Base.Sh=="S" | df$Base.Sh=="H")]<-1
df$Should.Sh.new<-0
df$Should.Sh.new[which(df$Should.Sh=="S" | df$Should.Sh=="H")]<-1
df$Should.Or.new<-0
df$Should.Or.new[which(df$Should.Or=="S" | df$Should.Or=="H")]<-1
df$Haft.Sh.new<-0
df$Haft.Sh.new[which(df$Haft.Sh=="S" | df$Haft.Sh=="H")]<-1
df$Haft.Or.new<-0
df$Haft.Or.new[which(df$Haft.Or=="S" | df$Haft.Or=="H")]<-1








dpd$Blade.Sh.new<-0
dpd$Blade.Sh.new[which(dpd$Blade.Sh=="S" | dpd$Blade.Sh=="H")]<-1
dpd$Base.Sh.new<-0
dpd$Base.Sh.new[which(dpd$Base.Sh=="S" | dpd$Base.Sh=="H")]<-1
dpd$Should.Sh.new<-0
dpd$Should.Sh.new[which(dpd$Should.Sh=="S" | dpd$Should.Sh=="H")]<-1
dpd$Should.Or.new<-0
dpd$Should.Or.new[which(dpd$Should.Or=="S" | dpd$Should.Or=="H")]<-1
dpd$Haft.Sh.new<-0
dpd$Haft.Sh.new[which(dpd$Haft.Sh=="S" | dpd$Haft.Sh=="H")]<-1
dpd$Haft.Or.new<-0
dpd$Haft.Or.new[which(dpd$Haft.Or=="S" | dpd$Haft.Or=="H")]<-1


#create a dataframe
library(RcmdrMisc)

#dd <- subset(df, subset=(Name=="Darl" ))
round(cor(df[3:9]),2)
scatterplotMatrix(~Weight+Length+Width+Thickness+B.Width+J.Width+H.Length,df)

#de <- subset(df, subset=(Name!="Ensor" ))
#round(cor(de[3:9]),2)
dpd <- subset(df, subset=(Name=="Pedernales" | Name=="Darl" ))
dp <- subset(df, subset=(Name=="Pedernales"))
#round(cor(dpd[3:9]),2)

fitlw <- lm(Weight~Width+Thickness+Blade.Sh+Should.Sh+
              Should.Or+Haft.Sh,data=dpd)
summary(fitlw)













fitlw <- lm(Weight~I(log10(Width))+I(log10(Thickness))+Should.Or+Haft.Sh+Haft.Or,data=dpd)
summary(fitlw)
fitlw <- lm(lwei~lthi,data=dpd)
summary(fitlw)
#remove base.sh
fitlw <- lm(Weight~Name+Length+Width+Thickness+B.Width+J.Width+H.Length+
              Blade.Sh.new+Base.Sh.new+Should.Sh.new+Should.Or.new+
              Haft.Sh.new,data=dpd)
summary(fitlw)


fitlw <- lm(Weight~Name+Length+J.Width+H.Length+Blade.Sh.new+
              Should.Or.new+Haft.Sh.new+Haft.Or.new,data=df)
summary(fitlw)

fitlw <- lm(Weight~Width+Thickness+J.Width+H.Length+
              Should.Or.new+Haft.Sh.new,data=dpd)
summary(fitlw)

fitlw <- lm(Weight~Width+Thickness+J.Width+H.Length+Blade.Sh+
              Base.Sh+Should.Or+Haft.Sh+Haft.Or,data=dp)
summary(fitlw)
fitlw <- lm(Weight~Length+Thickness, data=df)
summary(fitlw)
fitlw <- lm(Weight~Width+Thickness+Should.Sh+Haft.Sh+Haft.Or+Should.Or, data=dpd)
summary(fitlw)
df$llen = log10(df$Length)
df$lwei = log10(df$Weight)
df$lwid = log10(df$Width)
df$lthi = log10(df$Thickness)
attach(dpd)
res <- fitlw$residuals # residuals
fitval <- fitlw$fitted.values # fitted values
dff <-cbind(fitval, res)
boxplot(res,
        main ="Boxplots for errors",las=1,col = pal0, horizontal = TRUE)
summary(res)
scatterplot(fitval~res)
library("DescTools")
options(scipen=10)
Desc(res)
detach(dpd)
scatterplot(Weight~Width, data=dpd)

fitlw <- lm(lwei~lwid+lthi+Should.Sh+Haft.Sh+Haft.Or+Should.Or, data=dpd)
summary(fitlw)
scatterplot(lwei~lwid, data=dpd)
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page 
plot(fitlw,main = "log weight & width normality checks")

attach(dpd)
res <- fitlw$residuals # residuals
fitval <- fitlw$fitted.values # fitted values
dff <-cbind(fitval, res)
boxplot(res,
        main ="Boxplots for errors for logged values",las=1,col = pal0, horizontal = TRUE)
summary(res)
library("DescTools")
options(scipen=10)
Desc(res)
detach(dpd)


dpd <- subset(df, subset=(Name=="Pedernales" | Name=="Darl" ))


fitlw <- lm(lwei~llen+Blade.Sh.new+Base.Sh.new+Should.Sh.new+
              Should.Or.new+Haft.Sh.new+Haft.Or.new, data=dpd)
summary(fitlw)
fitlw <- lm(lwei~llen+Name+Should.Or.new, data=df)
summary(fitlw)












round(cor(df[3:9]),2)
rcorr.adjust(df[3:9], use="pairwise.complete.obs")


dt <- subset(df, subset=(Name=="Travis" ))
round(cor(dt[3:9]),2)
dp <- subset(df, subset=(Name=="Pedernales" ))
round(cor(dp[3:9]),2)
dd <- subset(df, subset=(Name=="Darl" ))
round(cor(dd[3:9]),2)
fitlw <- lm(Weight~Width+Thickness+Blade.Sh+Base.Sh+Should.Sh+Haft.Sh+Haft.Or+Should.Or, data=doth)
summary(fitlw)
de <- subset(df, subset=(Name=="Ensor" ))
round(cor(de[3:9]),2)
dw <- subset(df, subset=(Name=="Wells" ))
round(cor(dw[3:9]),2)


doth <- subset(df, subset=(Name!="Pedernales" & Name!="Darl" ))

"""
•	We assume that the relationship between the response variable and the explanatory 
  variables is a linear one, lets explore this idea with summary statistics
"""
summary(dd[2:15])
summary(dd[3:9] | Name)
scatterplotMatrix(dd[3:9])

library(RcmdrMisc)
library(RColorBrewer)
my_colors <- brewer.pal(nlevels(as.factor(df$Name)), "Set2")
scatterplotMatrix(dp[3:9])
scatterplotMatrix(~Weight+Length+Width+Thickness+B.Width+J.Width+H.Length|Name, data=df, 
                  col=my_colors ,cex=0.5 , pch=c(14,15,16,17,18) , main="Scatter plot with dart Point names")
scatterplotMatrix(~Weight+Length+Width+Thickness, data=dpd, 
                  col=my_colors ,cex=0.5 , pch=c(14,15,16,17,18) , main="Scatter plot with dart Point names")

#install.packages("DescTools")
par(mar = c(3,4,3,3))
par(mfrow=c(3,3))
library("DescTools")
options(scipen=10)
Desc(df[3:9])
attach(dpd)
Desc(dpd$Weight)
prop.table(dpd[10:15])
xtabs(~Blade.Sh+Base.Sh+Should.Sh+Haft.Sh+Haft.Or+Should.Or,dpd)
detach(dpd)
#install.packages("RcmdrMisc")
library(RcmdrMisc)
par(mfrow=c(1,7))
#numSummary(df[3:9],statistics=c("mean","sd","cv","skewness","kurtosis"),groups=df$Name)
numSummary(df[3:9],statistics=c("mean","sd","skewness","kurtosis"))

#title("Heatmap of explanatory variable correlations in the DartPoints data.", line = -1)
"""
Fit a multiple regression model, which can be used to predict the weight
of the dart, using some or all (after appropriate selection) of the variables
listed above as explanatory variables (with the exclusion of the
weight itself, of course).  
"""

#------------------------------------------------------------------------ 
# we will compute the correlation between the variables and compare their 
# distributions to a normal distribution before the least squares regression

corr <- round(cor(df[3:9]),2)
corr

# Multiple Linear Regression 

fitlw <- lm(Weight~Width+Thickness+Blade.Sh+Base.Sh+Should.Sh+Haft.Sh+Haft.Or+Should.Or, data=df)
fitlw <- lm(Weight~Width+Thickness+Blade.Sh+Base.Sh+Should.Sh+Haft.Sh+Haft.Or+Should.Or, data=dpd)
fitlw <- lm(Weight~Width+Thickness+Blade.Sh+Base.Sh+Should.Sh+Haft.Sh+Haft.Or+Should.Or, data=df)
fitlw <- lm(Weight~Width+Thickness+Blade.Sh+Base.Sh+Should.Sh+Haft.Sh+Haft.Or+Should.Or, data=doth)
summary(fitlw)

dpd$llen = log10(dpd$Length)
dpd$lwei = log10(dpd$Weight)
dpd$lwid = log10(dpd$Width)
dpd$lthi = log10(dpd$Thickness)

fitlw <- lm(lwei~lwid+lthi+Should.Sh+Haft.Sh+Haft.Or+Should.Or, data=dpd)
summary(fitlw)

attach(dpd)

res <- fitlw$residuals # residuals
fitval <- fitlw$fitted.values # fitted values
dff <-cbind(fitval, res)

boxplot(res,
        main ="Boxplots for errors",las=1,col = pal0, horizontal = TRUE)
summary(res)
library("DescTools")
options(scipen=10)
Desc(res)
detach(dpd)





# first try *****************************
fitlw <- lm(Weight~Length+Name+Should.Or, data=df)
fitlw <- lm(Weight~Length+Blade.Sh, data=df)
fitlw <- lm(Weight~Length+Name+Blade.Sh, data=df)
fitlw <- lm(Weight~Length+Name+Base.Sh, data=df)
fitlw <- lm(Weight~Length+Name+Should.Sh, data=df)
fitlw <- lm(Weight~Length+Name+Should.Or, data=df)
fitlw <- lm(Weight~Length+Name+Haft.Sh, data=df)
fitlw <- lm(Weight~Length+Name+Haft.Or, data=df)
df$Thick2 = df$Thickness*df$Thickness
fitlw <- lm(Weight~Thickness+Thick2+Name+Blade.Sh, data=df)

par(mar = c(4,6,4,4))
summary(fitlw)
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page 
plot(fitlw)
attach(df)
scatterplot(Weight~Length| Blade.Sh.new)
scatterplot(Weight~Length| Base.Sh.new)
scatterplot(Weight~Length| Should.Sh.new)
scatterplot(Weight~Length| Should.Or.new)
scatterplot(Weight~Length| Haft.Sh.new)
scatterplot(Weight~Length| Haft.Or.new)
detach(df)
# remove Ensor and log the values to get try to normalise the variable
# second try *****************************
df$llen = log10(df$Length)
df$lwei = log10(df$Weight)
df$lthi = log10(df$Thickness)
ne <- subset(df, subset=(Name!="Ensor"))
fitlw <- lm(lwei~llen+Name+Blade.Sh, data=ne)
summary(fitlw) # show results
fitlw <- lm(lwei~llen+Name+Blade.Sh+Base.Sh+Should.Sh+Haft.Sh+Haft.Or+Should.Or, data=ne)
summary(fitlw) # show results

summary(fitlw) # show results
par(mar = c(4,6,4,4))
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page 
plot(fitlw)
attach(ne)
scatterplot(lwei~llen | Name, log="xy")
detach(ne)
attach(df)
scatterplot(Weight ~ Blade.Sh)
detach(df)









names(fitlw) # to see what is in this lm object
res <- fitlw$residuals # residuals
fitval <- fitlw$fitted.values # fitted values
dff <-cbind(fitval, res) # cbind is column bind
plot(dff$fitval, dff$res)
abline(lm1)
attach(df)
boxplot(Length~Name,
        main ="Boxplots for Length (gm)",las=1,col = pal0, horizontal = TRUE)
detach(df)
attach(ne)
boxplot(lwei~Name,
        main ="Boxplots for Weight (gm)",las=1,col = pal0, horizontal = TRUE)
boxplot(llen~Name,
        main ="Boxplots for Maximum Length (mm)",las=1,col = pal0, horizontal = TRUE)
detach(ne)

#noEor100 <- subset(df, subset=(Name!="Ensor" & Length<100))
#fitlw <- lm(lwei~llen+Name, data=noEor100)
#summary(fitlw)
"""
Now create a new set of nominal variables (Blade.Sh.new, Base.Sh.new,
Should.Sh.new, Should.Or.new, Haft.Sh.new and Haft.Or.new) with value
1 if the original nominal variable has ”Straight” or ”Horizontal” level and 0
else. For example, the variable Blade.Sh.new would be equal to 1 for all the
observations for which Blade.Sh was straight and 0 for the others.
"""

df$Blade.Sh.new<-0
df$Blade.Sh.new[which(df$Blade.Sh=="S" | df$Blade.Sh=="H")]<-1
df$Base.Sh.new<-0
df$Base.Sh.new[which(df$Base.Sh=="S" | df$Base.Sh=="H")]<-1
df$Should.Sh.new<-0
df$Should.Sh.new[which(df$Should.Sh=="S" | df$Should.Sh=="H")]<-1
df$Should.Or.new<-0
df$Should.Or.new[which(df$Should.Or=="S" | df$Should.Or=="H")]<-1
df$Haft.Sh.new<-0
df$Haft.Sh.new[which(df$Haft.Sh=="S" | df$Haft.Sh=="H")]<-1
df$Haft.Or.new<-0
df$Haft.Or.new[which(df$Haft.Or=="S" | df$Haft.Or=="H")]<-1


fitlw <- lm(lwei~llen+Name+Blade.Sh.new+Base.Sh.new+Should.Sh.new+
              Should.Or.new+Haft.Sh.new+Haft.Or.new, data=df)
summary(fitlw)
fitlw <- lm(lwei~llen+Name+Should.Or.new, data=df)
summary(fitlw)

par(mfrow=c(3,3))
attach(df)
scatterplot(lwei~llen| Blade.Sh.new)
scatterplot(Weight~Length| Blade.Sh.new)
scatterplot(lwei~llen| Name)
scatterplot(Weight~Length| Name)
#scatterplot(Weight~Length| Base.Sh.new)
#scatterplot(Weight~Length| Should.Sh.new)
#scatterplot(Weight~Length| Should.Or.new)
#scatterplot(Weight~Length| Haft.Sh.new)
#scatterplot(Weight~Length| Haft.Or.new)
detach(df)
scatterplot(ne$lwei~ne$llen| ne$Name)


qqplot(df$Length)








# Other useful functions 

fitted(fitlw) # predicted values
residuals(fitlw) # residuals
summary(residuals(fitlw))
Desc(residuals(fitlw))
boxplot(residuals(fitlw),
        main ="Boxplots for residuals",las=1,col = pal0, horizontal = TRUE)

anova(fitlw) # anova table 
vcov(fitlw) # covariance matrix for model parameters 
cor(residuals(fitlw)) # covariance matrix for residuals 
influence(fitlw) # regression diagnostics


#Diagnostic plots provide checks for heteroscedasticity, normality, and influential observerations.
# diagnostic plots 
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page 
plot(fitlw)
attach(ne)
scatterplot(lwei~llen | Name, log="xy")
detach(ne)

"""
Predict the expected dart weight for a dart point of type Travis, with
maximum length 70 mm, H.Length 60mm, Thickness 50 mm, B.Width
50 mm, J.Width 50 mm, Width 60 mm and with both blade shape
and base shape recurvate, straight shoulder shape, barbed shoulder
orientation, excurvate shape for the lateral haft element and parallel
orientation of the lateral haft element. Give a 95% confidence interval
for this expected weight.
"""


# compare models
fit1 <- lm(Weight~Length+Width+Thickness+B.Width+J.Width+H.Length, data=df)
fit2 <- lm(Weight~Length+Width,data=df)
anova(fit1, fit2)

"""
Selecting a subset of predictor variables from a larger set (e.g., stepwise selection) 
is a controversial topic. You can perform stepwise selection (forward, backward, both) 
using the stepAIC( ) function from the MASS package. stepAIC( ) performs stepwise model 
selection by exact AIC.
"""
# Stepwise Regression
#install.packages("MASS")
library(MASS)
df1<-na.omit(df)
fit <- lm(Weight~Name+Length+Width+Thickness +H.Length+B.Width+J.Width+Blade.Sh+Base.Sh
          +Should.Sh+Haft.Sh+Haft.Or+Should.Or,data=df1)
step <- stepAIC(fit, direction="both")
step$anova # display results

"""
We can use (almost) the same diagnostic plots seen for simple linear
regression:
  • Scatterplot of fitted values vs residuals ⇒ to spot non-constant
    variance and trends
  • Scatterplot of fitted values vs (standardized) residuals ⇒ to spot
    non-constant variance and outliers
  • Q-Q plot ⇒ to check for normality of the error
"""

"""
Analogously to the case of simple linear regression, we can define a
(multiple) Rsq coeffcient with 0 ≤ Rsq ≤ 1. However, it is necessary 
to adjust this coeffcient to take into account the number of predictors

What to do when things go wrong:
• non-constant variance or non-normality of the data ⇒ non-linear
transformation of the response variable (e.g.,log(Y ), exp(Y ), √Y ,. . . ).
• trends ⇒ including additional predictors in the model (including
functions of the current predictors, such as Xsq, log(X), etc.)
Understanding which transformation to apply to the response variable
requires some experience, but there are automatic procedure to choose the
best transformation to make the residuals of the model as
normally-distributed as possible ⇒ see the boxcox function the R package
MASS.

References

Box, G. E. P. and Cox, D. R. (1964) An analysis of transformations (with discussion). Journal of the Royal Statistical Society B, 26, 211–252.

Venables, W. N. and Ripley, B. D. (2002) Modern Applied Statistics with S. Fourth edition. Springer.

Examples

boxcox(Volume ~ log(Height) + log(Girth), data = trees,
lambda = seq(-0.25, 0.25, length = 10))

boxcox(Days+1 ~ Eth*Sex*Age*Lrn, data = quine,
lambda = seq(-0.05, 0.45, len = 20))
"""


attach(df)
df$namecode<-rep(NA,length(df$Name))
df$namecode[which(df$Name=="Darl")]<-1
df$namecode[which(df$Name=="Ensor")]<-2
df$namecode[which(df$Name=="Pedernales")]<-3
df$namecode[which(df$Name=="Travis")]<-4
df$namecode[which(df$Name=="Wells")]<-5
detach(df)
library(RColorBrewer)
pal0 <- brewer.pal(9, "Set1")
par(mar = c(3,4,3,3))
par(mfrow=c(3,3))

attach(df)
boxplot(Weight~Name,
        main ="Boxplots for Weight (gm)",las=1,col = pal0, horizontal = TRUE)
boxplot(Length~Name, 
        main ="Boxplots for Length (mm)",las=1,col = pal0, horizontal = TRUE)
boxplot(Width~Name,
        main ="Boxplots for Width (mm)",las=1,col = pal0, horizontal = TRUE)
boxplot(Thickness~Name, 
        main ="Boxplots for Thickness (mm)",las=1,col = pal0, horizontal = TRUE)
boxplot(H.Length~Name, 
        main ="Boxplots for Haft length (mm)",las=1,col = pal0, horizontal = TRUE)
boxplot(B.Width~Name, 
        main ="Boxplots for Basal width (mm)",las=1,col = pal0, horizontal = TRUE)
boxplot(J.Width~Name, 
        main ="Boxplots for Juncture width (mm)",las=1,col = pal0, horizontal = TRUE)
detach(df)
"""
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

