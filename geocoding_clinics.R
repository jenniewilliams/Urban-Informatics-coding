# Analysis of distance from a patients’ home, to a mental health institution (MHI) in South London
#
# Jennie Williams k1758331


library(spatstat)
library(ggmap)
#install.packages("reshape")
library(reshape)

register_google(key=google_key)

# read in the mental health data
MHdf <- "~/Documents/urban informatics/MentalHealth/cw/MentalHealthData.csv"
connM <- file(MHdf,open="r")
mhdf <- read.table(connM, sep = ',',header = TRUE, fileEncoding = "UTF-16LE")
close(connM)

# read in the locations of the services
LOCdf <- "~/Documents/urban informatics/MentalHealth/cw/All_locations.csv"
connL <- file(LOCdf,open="r")
locdf <- read.table(connL, sep = ',',header = TRUE, fileEncoding = "UTF-16LE")
close(connL)

#remove punctuation from the location before putting it through the api
locdf$LocStr <- gsub('[[:punct:] ]+',' ',locdf$X)

#https://developers.google.com/maps/documentation/geocoding/intro
#When the geocoder returns results, it places them within a (JSON) results array. 
#"results" contains an array of geocoded address information and geometry information.
locdf$result <- geocode(locdf$LocStr, output = "latlona", source = "google",ext="uk")
#transform the result to flat dataframe in order to get rid of the address and json format

# flatten the results of the api call so that they are like a dataframe format
library(jsonlite)
data2 <- flatten(locdf$result)
data3 <- data2[c(1:2)]
locdf0 <- locdf[c(1:3)]
locdf1 <- cbind(locdf0, data3)
# for some reason a duplicate record has appeared.
locdf2 <- unique(locdf1)

# read in the patients postcode gps coords from 
# https://www.freemaptools.com/download-uk-postcode-lat-lng.htm
POdf <- "~/Documents/urban informatics/MentalHealth/cw/postcode-outcodes.csv"
connP <- file(POdf,open="r")
podf <- read.table(connP, sep = ',',header = TRUE, fileEncoding = "UTF-16LE")
close(connP)

# join the mental health data with a gps postcode for the location of the patient
df0 <- merge(mhdf, podf, by.x = "truncatedpostcode", by.y = "postcode",all.x = TRUE)

# merge on the concatenated_service_location for the location of the service attended
df1 <- merge(x=df0, y=locdf2, by = "concatenated_service_location",all.x = TRUE)

# calculate some distances from home postcode to clinic
library(data.table)
library(geosphere)

setDT(df1)
df1[, distance_hav := distHaversine(matrix(c(postlong, postlat), ncol = 2),
                                    matrix(c(lon, lat), ncol = 2))]

df1$distance_hav_km = round(df1$distance_hav/1000,2)

# create distances categories
df1$distcat<-cut(df1$distance_hav_km, c(0,10,20,30,65))

# create in-patient-days categories
df1$hospdays<-cut(df1$inpatientdays, c(-0.1,25,50,75,100,125,170))
df1$postlat <- as.numeric(df1$postlat)
df1$postlong <- as.numeric(df1$postlong)

# correlation plot & test of Distance travelled vs No. of days in hospital - gave no significant result

#install.packages("ggpubr")
library("ggpubr")
ggscatter(df1, x = "distance_hav_km", y = "inpatientdays", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "Distance travelled", ylab = "No. of days in hospital")

#write.csv(df1, file = "~/Documents/urban informatics/MentalHealth/cw/geocoded.csv")

# use QGIS to create a graph

#get rid of clinic 39 because it is an outlier....
dfx <- df1[df1$X != "Kent and Medway Adolescent Unit   Woodland House   Cranbrook Road   Staplehurst TN12 0ER", ]

# calculate the distance for each diagnosis/clinic
attach(dfx)
dfx <- dfx[order(distance_hav_km,firstsmi_primary_diagnosisrecode),] 
#re-enumerate the clinics
dfx$clinic <- as.numeric(as.factor(dfx$X))
#aggregate 
aggdata <-aggregate(x = dfx$distance_hav_km, by=list(dfx$clinic,dfx$firstsmi_primary_diagnosisrecode), 
                    FUN=max, na.rm=TRUE)
check <- aggregate(x = dfx$ID,by=list(dfx$truncatedpostcode,dfx$firstsmi_primary_diagnosisrecode),FUN="count")
library(plyr)
aggdata_postcode <- table(dfx$truncatedpostcode,dfx$firstsmi_primary_diagnosisrecode)
aggdata_postcode <- 

flatten(aggdata_postcode)
flatten(aggdata)
detach(dfx)
# polar plot
# use a color-blind friendly palette
#cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
p <- ggplot(aggdata) + 
  geom_line(aes(x=Group.1,y=x,group=Group.2,color=Group.2)) + 
  scale_x_continuous(breaks=1:57) +
  scale_color_manual(values=c("#F0E442","#56B4E9", "#CC79A7"),name=" ") +
  xlab("Institution") +
  ylab("Maximum distance (km)") +
  theme_light()
p + coord_polar()

# Now we have the home and clinic locations, the euclidean distance between them
# lets create a bounding box or window study area using the max & min coordinates
a <- min(dfx$postlong, na.rm = TRUE)
b <- max(dfx$postlong, na.rm = TRUE)
c <- min(dfx$postlat, na.rm = TRUE)
d <- max(dfx$postlat, na.rm = TRUE)
w <- owin(c(a,b),c(c,d))
library(plyr)
Z0 <- count(dfx, c("firstsmi_primary_diagnosisrecode","postlong","postlat","truncatedpostcode","lon","lat","clinic"))
#remove NAs 
Z <- na.omit(Z0)

# unique values per patient location by diagnosis
A0 <- unique(data.frame(Z$postlong,Z$postlat,Z$truncatedpostcode,Z$firstsmi_primary_diagnosisrecode))
A <- as.ppp(A0,w)

A1 <- A0[A0$Z.firstsmi_primary_diagnosisrecode=="Bipolar", ]
AA <- as.ppp(A1,w)
clarkevans.test(AA,clipregion=w, correction=c("Donnelly"))
A11 <- A0[A0$Z.firstsmi_primary_diagnosisrecode=="F2xSchizophrenia", ]
AAA <- as.ppp(A11,w)
clarkevans.test(AAA,clipregion=w, correction=c("Donnelly"))
A111 <- A0[A0$Z.firstsmi_primary_diagnosisrecode=="Schizoaffective", ]
AAAA <- as.ppp(A111,w)
clarkevans.test(AAAA,clipregion=w, correction=c("Donnelly"))

# unique values of MHIs
B0 <- unique(data.frame(Z$lon,Z$lat,Z$clinic))
B <- as.ppp(B0,w)
clarkevans.test(B,clipregion=w, correction=c("Donnelly"))

#------------------------------------------------
# Relocation of patients to nearest MHI
wU <- owin(c(-0.247, 0.235),c(51.311, 51.542))
UA0 <- unique(data.frame(Z$postlong,Z$postlat))
UA <- as.ppp(UA0,wU)
UB0 <- unique(data.frame(Z$lon,Z$lat))
UB <- as.ppp(UB0,wU)
UN <- nncross(UA,UB)$which
upattern <- superimpose("Patients"=UA,"MHI"=UB)
plot(upattern, main="Relocation of patients to nearest MHI", pch=19, cols=c("#CC79A7","red"), cex=1.0, border=c("darkblue"))
arrows(UA$x, UA$y, UB[UN]$x, UB[UN]$y, length=0.05, col="darkblue")
#----------------------------------------------------------------------

aggdata_new <-aggregate(x = dfx$distance_hav_km, by=list(dfx$truncatedpostcode,dfx$firstsmi_primary_diagnosisrecode), 
                        FUN=max, na.rm=TRUE)
aggp <-aggregate(x = dfx$ID, by=list(dfx$truncatedpostcode,dfx$firstsmi_primary_diagnosisrecode), 
                        FUN=count)
aggdata_new <- aggdata_new[aggdata_new$x != -Inf, ]

#marks(A) <- A0[, c(4)]
#marks(B) <- B0[, c(3)]

#mypattern <- superimpose(A,B)
#N_dist <- nncross(A,B,what = c("dist", "which"))
#N <- nncross(A,B)$which

#get the 3 nearest neighbour institutions
N3 <- nncross(A,B,what = c("dist", "which"),k=1:3)

#convert the distances from degrees to euclidean 
N3$d1 <- 6371*N3$dist.1*pi/180
N3$d2 <- 6371*N3$dist.2*pi/180
N3$d3 <- 6371*N3$dist.3*pi/180

drops <- c("dist.1","dist.2","dist.3")
DN <- N3[ , !(names(N3) %in% drops)]
DN$origPatient <- as.numeric(rownames(DN))

#rownames(DN) <- 1:nrow(DN)
A0$origPatient <-as.numeric(rownames(A0))

#A0 <- A0[order(A0$Z.truncatedpostcode,A0$Z.firstsmi_primary_diagnosisrecode),]

#merge A0 and aggdata_new
flatten(A0)
flatten(aggdata_new)
origD <- merge(aggdata_new, A0, by.x = c("Group.1","Group.2"),by.y = c("Z.truncatedpostcode","Z.firstsmi_primary_diagnosisrecode"), all = TRUE)
origD$origPatient <- as.numeric(rownames(origD))

MergedDist <- merge(DN, origD, by = "origPatient", all = TRUE)
#MergedDist <- MergedDist[order(MergedDist$d1),]
MergedDist <- MergedDist[order(MergedDist$origPatient),]

MergedDist$distcat3<-cut(MergedDist$d3, c(0,10,20,30,65))
table(MergedDist$distcat3,useNA = "ifany")
aggpost <- dfx[aggdata_new$x != -Inf, ]

ggplot(MergedDist, aes(as.numeric(row.names(MergedDist)), background="white" )) + 
  geom_line(aes(y = d1), colour="DarkBlue") + 
  geom_line(aes(y = d2), colour = "Blue") +
  geom_line(aes(y = d3), colour = "LightBlue") +
  geom_line(aes(y = x), colour = "darkgrey") +
  geom_line(aes(y = 10), colour = "grey") +
  geom_line(aes(y = 20), colour = "grey") +
  xlab("Patient locations") +
  ylab("Distance of 3 NN clinics (blue) and max. distance (grey) in km") +
  theme_classic()

# try to get a map with the bounding box
library(ggmap)
library(ggplot2)

### Set a range
lat <- c(51.313, 51.542)                
lon <- c(-0.247, 0.235)   

### Get a map
map <- get_map(location = c(lon = mean(lon), lat = mean(lat)),
               maptype = "roadmap", source = "google")

#dt <- dfx[dfx$X %like% "Maudsley" & dfx$firstsmi_primary_diagnosisrecode=="Bipolar", ]
dt <- dfx[dfx$X %like% "Maudsley" | dfx$X %like% "Monks", ]

### When you draw a figure, you limit lon and lat.      
foo <- ggmap(map)+
  scale_x_continuous(limits = lon, expand = c(0, 0)) +
  scale_y_continuous(limits = lat, expand = c(0, 0)) +
  geom_point(aes(x=postlong,y=postlat,colour="red"), data = dt, alpha = .8) +
  geom_point(aes(x=lon,y=lat,colour="blue"), data = dt, alpha = .8) +
  geom_segment(aes(x = lon, y = lat, xend = postlong, yend = postlat, colour="black"), data = dt[ which(dt$X %like% "Monks"),]) +
  geom_point(aes(x=postlong,y=postlat,colour="red"), data = dt, alpha = .8) +
  geom_point(aes(x=lon,y=lat,colour="blue"), data = dt, alpha = .8) +
  geom_segment(aes(x = lon, y = lat, xend = postlong, yend = postlat, colour="blue"), data = dt[ which(dt$X %like% "Maudsley"),]) +
  scale_color_manual(values=c("grey","lightblue","darkblue"))
foo






