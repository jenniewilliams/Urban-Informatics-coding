#install.packages("DescTools")
library(DescTools)
library(xtable)
options(xtable.floating = FALSE)
options(xtable.timestamp = "")
evecs <- dc
evecs$dccat <- ifelse(dc$V102>700, "History", "Earth Sciences")
#look at the means
#HotellingsT2Test(as.matrix(evecs[,1:100])~evecs$dccat)
#test for differences between the means
EThOS.manova <- lm(as.matrix(evecs[,2:101])~evecs$dccat)
xtab <- data.frame(CrossTable(dc$topic,dc$disc,plot=True))
xtable(manova(EThOS.manova),test="Pillai")
xtable(manova(EThOS.manova),test="Wilks")
xtable(manova(EThOS.manova),test="Hotelling-Lawley")
xtable(manova(EThOS.manova),test="Roy")
mandf <-xtable(lm(as.matrix(evecs[,2:101])~evecs$dccat))
write.csv(mandf,'~/Documents/urban informatics/dissertation/BLdata/mandf.csv')

summary(manova(EThOS.manova),test="Pillai")
summary(manova(EThOS.manova),test="Wilks")
summary(manova(EThOS.manova),test="Hotelling-Lawley")
summary(manova(EThOS.manova),test="Roy")

# Canonical Discriminant Analysis - how are the means different?
#install.packages("candisc")
library(candisc)
EThOS.can <- candisc(EThOS.manova, prior=c(59,41)/100)
EThOS.can
summary(EThOS.can)
coef(EThOS.can, type="structure")
plot(EThOS.can, var.lwd=1, col=c("darkblue","darkgray"), var.col="black", 
     var.cex=0.7, ann=FALSE)

EThOS.can1 <- candisc(EThOS.manova, ndim=1, col=pal2)
plot(EThOS.can1, ann=FALSE)

