library(ggmap)
library(gstat)
library(jsonlite)
library(raster)
library(reshape)
library(rgdal)
library(rgeos) 
library(sp)
library(spacetime)
library(spatstat)
library(viridis)

#run keys.R first.......
#register_google(key=google_key)

# read in the locations of the services
#LOCdf <- "~/Documents/urban informatics/Spatial/cw/data/gp_clinic_location.csv"
#connL <- file(LOCdf,open="r")
#locdf <- read.table(connL, sep = ',',header = TRUE, fileEncoding = "UTF-16LE")
#close(connL)

#remove punctuation in the location of the surgery
#locdf$LocStr <- gsub('[[:punct:] ]+',' ',locdf$surgery)

#https://developers.google.com/maps/documentation/geocoding/intro
#When the geocoder returns results, it places them within a (JSON) results array. 
#"results" contains an array of geocoded address information and geometry information.
#locdf$result <- geocode(locdf$LocStr, output = "latlona", source = "google",ext="uk")
#data2 <- flatten(locdf$result)
#data2$address <- gsub('[[:punct:] ]+',' ',data2$address)
#locdf0 <- locdf[c(1:1)]
#locdf1 <- cbind(locdf0, data2)
# wirte out geolocated file
#write.csv(locdf1, "~/Documents/urban informatics/Spatial/cw/data/gplocation_lonlat.csv")

# read in gp locations with asthma prevelance
ASTdf <- "~/Documents/urban informatics/Spatial/cw/data/gplocations_asthma.csv"
connL <- file(ASTdf,open="r")
df <- read.table(connL, sep = ',',header = TRUE, fileEncoding = "UTF-16LE")
close(connL)

# generate a voronoi plot, coloured by asthma prevelence level
voronoipolygons2 = function(layer) {
  require(deldir)
  crds = layer@coords
  z = deldir(crds[,1], crds[,2])
  w = tile.list(z)
  my.variable = layer@data[,1]   ## HERE
  polys = vector(mode='list', length=length(w))
  require(sp)
  for (i in seq(along=polys)) {
    pcrds = cbind(w[[i]]$x, w[[i]]$y)
    pcrds = rbind(pcrds, pcrds[1,])
    polys[[i]] = Polygons(list(Polygon(pcrds)), ID=as.character(i))
  }
  SP = SpatialPolygons(polys)
  voronoi = SpatialPolygonsDataFrame(SP, data=data.frame(dummy = seq(length(SP)), 
                                                         my.data = my.variable, # HERE add new column to my voronoi data 
                                                         row.names=sapply(slot(SP, 'polygons'), 
                                                                          function(x) slot(x, 'ID'))))
}
coordinates(df)<- ~ lon + lat
df.voro <- voronoipolygons2(df)   # calculated VORONOI

#install.packages("dismo")
#require('dismo')
#spplot(df.voro, "dummy",col.regions = viridis_pal()(9))   # colorize Polygons

# add z variable to newly created data
df.voro@data$asthma<-as.numeric(df$asthma)    ##
spplot(df.voro, "asthma",col.regions = viridis_pal()(16))

data1 <- read.table("~/Documents/urban informatics/Spatial/cw/data/2018-Parkerx.csv", sep=",", header=T,colClasses=c("character", "character"))
data1$lat <- 52.204608
data1$lon <- 0.125891
data2 <- read.table("~/Documents/urban informatics/Spatial/cw/data/2018-Gonvillex.csv", sep=",", header=T,colClasses=c("character", "character"))
data2$lat <- 52.199575
data2$lon <- 0.12774
data3 <- read.table("~/Documents/urban informatics/Spatial/cw/data/2018-Newmarketx.csv", sep=",", header=T,colClasses=c("character", "character"))
data3$lat <- 52.20843
data3$lon <- 0.141521
data4 <- read.table("~/Documents/urban informatics/Spatial/cw/data/2018-Montaguex.csv", sep=",", header=T,colClasses=c("character", "character"))
data4$lat <- 52.214201
data4$lon <- 0.136545
data5 <- read.table("~/Documents/urban informatics/Spatial/cw/data/2018-Girtonx.csv", sep=",", header=T,colClasses=c("character", "character"))
data5$lat <- 52.225556
data5$lon <- 0.087222
data6 <- read.table("~/Documents/urban informatics/Spatial/cw/data/2018-OrchardParkSchoolx.csv", sep=",", header=T,colClasses=c("character", "character"))
data6$lat <- 52.2335
data6$lon <- 0.115229

#dataall = rbind(data1, data2, data3, data4, data5, data6)

# For PM10 remove data3, there is no PM10 data
data = rbind(data1, data2, data4, data5, data6)


data$DateTime <- as.POSIXct(paste(data$EndDate, data$EndTime), format="%d/%m/%y %H:%M:%S")
data <- data[with(data, order(DateTime)), ]
sub <- data[data$DateTime>=as.POSIXct('2018-04-20 00:00:00') & data$DateTime<=as.POSIXct('2018-04-20 23:00:00'),]
sub <- na.omit(sub)
subpm10 <- sub[rowSums(is.na(sub[ , 3:4])) == 0, ]
subpm10<-subset(sub, (!is.na(sub$PM10)))
#sub$pm10 <- as.numeric(sub$PM10)

for (row in 1:nrow(subpm10)) {
  valu <- subpm10[row,"PM10"]
  if (valu <= 1) {
    subpm10[row,"PM10"] <- 38.8
  }
}
library(Hmisc)
summary(as.numeric(subpm10$PM10))
#write.csv(subpm10, file = "~/Documents/urban informatics/Spatial/cw/data/subpm10data.csv")

#install.packages("doBy")
#library(doBy)
#sumsummaryBy(pm10 ~ EndDate + EndTime + lon + lat, data = sub, 
#          FUN = function(x) { c(m = mean(x)) } )
# produces mpg.m wt.m mpg.s wt.s for each 
# combination of the levels of cyl and vs

coordinates(subpm10)=~lon+lat
projection(subpm10)=CRS("+init=epsg:4326")

ozone.UTM <- spTransform(subpm10,CRS("+init=epsg:3395"))
ozoneSP <- SpatialPoints(unique(ozone.UTM@coords),CRS("+init=epsg:3395"))
ozoneTM <- unique(ozone.UTM$DateTime)
ozoneDF <- data.frame(PM10=as.numeric(ozone.UTM$PM10))
timeDF <- STFDF(ozoneSP,ozoneTM,data=ozoneDF)

stplot(timeDF,cutoff = 1,par.strip.text=list(cex=0.45),col.regions = viridis_pal()(15))

var <- variogramST(PM10~1,data=timeDF,assumeRegular=T,na.omit=T)

plot(var,map=T,col = viridis_pal()(16))
plot(var,map=F,col = viridis_pal()(16)) 
plot(var,wireframe=T,col = viridis_pal()(160))

pars.l <- c(sill.s = 0, range.s = 10, nugget.s = 0,sill.t = 0, range.t = 1, nugget.t = 0,sill.st = 0, range.st = 10, nugget.st = 0, anis = 0)
pars.u <- c(sill.s = 200, range.s = 1000, nugget.s = 100,sill.t = 200, range.t = 60, nugget.t = 100,sill.st = 200, range.st = 1000, nugget.st = 100,anis = 700) 
#pars.l <- c(sill.s = 0, range.s = 0, nugget.s = 0,sill.t = 0, range.t = 1, nugget.t = 0,sill.st = 0, range.st = 1, nugget.st = 0, anis = 0)
#pars.u <- c(sill.s = 200, range.s = 10, nugget.s = 60,sill.t = 200, range.t = 10, nugget.t = 60,sill.st = 200, range.st = 10, nugget.st = 60,anis = 500) 

separable <- vgmST("separable", space = vgm(-60,"Sph", 500, 1),time = vgm(35,"Sph", 500, 1), sill=0.56)
separable_Vgm <- fit.StVariogram(var, separable, fit.method=6)
attr(separable_Vgm,"MSE")
plot(var, separable_Vgm)
#plot(var,separable,map=F,col = viridis_pal()(16))
#plot(var,separable,map=T,col = viridis_pal()(16))
#plot(var,separable_Vgm,map=T,col = viridis_pal()(16))

#extractPar(separable_Vgm)
prodSumModel <- vgmST("productSum",space = vgm(1, "Sph", 150, 0.5),time = vgm(1, "Exp", 5, 0.5),k = 5)
prodSumModel_Vgm <- fit.StVariogram(var, prodSumModel,method = "L-BFGS-B",lower=pars.l,upper=pars.u,tunit="hours")
attr(prodSumModel_Vgm, "MSE")
#plot(var,prodSumModel_Vgm,map=F)

sumMetric <- vgmST("sumMetric", space = vgm(psill=100,"Sph", range=5000, nugget=0),time = vgm(psill=500,"Sph", range=5000, nugget=0), joint = vgm(psill=1,"Sph", range=5000, nugget=10), stAni=500)
sumMetric_Vgm <- fit.StVariogram(var, sumMetric, method="L-BFGS-B",lower=pars.l,upper=pars.u,tunit="hours")
attr(sumMetric_Vgm, "MSE")


plot(var,list(separable_Vgm, prodSumModel_Vgm, sumMetric_Vgm),all=T,wireframe=T,col = viridis_pal()(120))
plot(var,list(separable_Vgm, prodSumModel_Vgm, sumMetric_Vgm),all=T,map=T,col = viridis_pal()(120))
plot(var,list(separable_Vgm, prodSumModel_Vgm, sumMetric_Vgm),all=T,map=F,col = viridis_pal()(120))



camb <- shapefile("~/Documents/urban informatics/Spatial/cw/data/CambridgeUKBoundaryData/england_lad_2011.shp")
camb.UTM <- spTransform(camb,CRS("+init=epsg:3395"))
camb.cropped <- crop(camb.UTM,ozone.UTM)
plot(camb.cropped)
plot(ozone.UTM,add=T,col="red")

sp.grid.UTM <- spsample(camb.cropped,n=100,type="random") 
plot(camb.cropped)
plot(ozone.UTM,add=T,col="red")
plot(sp.grid.UTM,add=T,col="blue")
tm.grid <- seq(as.POSIXct('2018-04-20 00:00:00 BST'),as.POSIXct('2018-04-20 23:00:00 BST'),length.out=24)
grid.ST <- STF(sp.grid.UTM,tm.grid)
#az <- seq(9.2, 65.0, 15)
pred <- krigeST(PM10~1, data=timeDF, modelList=sumMetric_Vgm, newdata=grid.ST)

stplot(pred,par.strip.text=list(cex=0.6),col.regions = viridis_pal()(50))

