# Read in csv files manipulated in Python......

# K1758331/1769227 Network coursework - Jennie Williams

#install.packages("igraph") 
#install.packages("network") 
#install.packages("visNetwork")
#install.packages("sna")
#install.packages("threejs")
#install.packages("networkD3")
#install.packages("ndtv")
#install.packages("RColorBrewer")
library(igraph)
library(network)
library(visNetwork)
library(sna)
library(threejs)
library(networkD3)
library(ndtv)
library(RColorBrewer)

lonodes = read.csv("~/Documents/urban informatics/Network/cw2/weeplaces/london.csv")
panodes = read.csv("~/Documents/urban informatics/Network/cw2/weeplaces/paris.csv")
edges = read.csv("~/Documents/urban informatics/Network/cw2/weeplaces/friends.csv")

# Amsterdam--------------------------------------------
amnodes = read.csv("~/Documents/urban informatics/Network/cw2/weeplaces/amster.csv")
amlinks = read.csv("~/Documents/urban informatics/Network/cw2/weeplaces/amlinks.csv")
amnodes$label <- tolower(amnodes$label)
amlinks$label_x <- tolower(amlinks$label_x)
amlinks$label_y <- tolower(amlinks$label_y)
attach(amnodes)
adjmata <- table(newcat,label)
detach(amnodes)
par(mfrow=c(1,1))

net <- graph_from_data_frame(d=links, vertices=nodes, directed=T) 

neta <- graph_from_incidence_matrix(adjmata,directed=F)
add_edges(neta,c(amlinks$label_x,amlinks$label_y))
#E(neta)[[]]
lay<-layout.fruchterman.reingold(grap=neta,niter=10000)
plot(neta,lay,     
     vertex.color=c(rep("lightsteelblue",13),rep("yellow",22)), 
     vertex.frame.color="white", vertex.size=10, 
     vertex.label.cex=0.5, vertex.label.color="black")

assortativity(neta, V(neta), directed=F)

# BERLIN--------------------------------------------
benodes = read.csv("~/Documents/urban informatics/Network/cw2/weeplaces/berlin.csv")
benodes$label <- tolower(benodes$label)
attach(benodes)
adjmatb <- table(newcat,label)
detach(benodes)
belinks = read.csv("~/Documents/urban informatics/Network/cw2/weeplaces/belinks.csv")
belinks$label_x <- tolower(belinks$label_x)
belinks$label_y <- tolower(belinks$label_y)
par(mfrow=c(1,1))
netb <- graph_from_incidence_matrix(adjmatb,directed=F,multiple=T)
netb <- add_edges(netb,c(belinks$label_x,belinks$label_y),role=1)
lay<-layout.fruchterman.reingold(grap=netb,niter=10000)
plot(netb,lay,     
     vertex.color=c(rep("lightsteelblue",25),rep("yellow",41)), 
     vertex.frame.color="white", vertex.size=10, 
     vertex.label.cex=0.5, vertex.label.color="black")

assortativity(netb, V(netb), directed=F)

# LONDON--------------------------------------------
lonodes = read.csv("~/Documents/urban informatics/Network/cw2/weeplaces/london.csv")
lonodes$label <- tolower(lonodes$label)
attach(lonodes)
adjmatl <- table(newcat,label)
detach(lonodes)
lolinks = read.csv("~/Documents/urban informatics/Network/cw2/weeplaces/lolinks.csv")
lolinks$label_x <- tolower(lolinks$label_x)
lolinks$label_y <- tolower(lolinks$label_y)
par(mfrow=c(1,1))
netl <- graph_from_incidence_matrix(adjmatl,directed=F,multiple=T)
netl <- add_edges(netl,c(lolinks$label_x,lolinks$label_y),role=1)
lay<-layout.fruchterman.reingold(grap=netl,niter=10000)
plot(netl,
     vertex.color=c(rep("lightsteelblue",31),rep("yellow",87)), 
     vertex.frame.color="white", vertex.size=10, 
     vertex.label.cex=0.5, vertex.label.color="black")

assortativity(netl, V(netl), directed=F)

# PARIS--------------------------------------------
panodes = read.csv("~/Documents/urban informatics/Network/cw2/weeplaces/paris.csv")
panodes$label <- tolower(panodes$label)
attach(panodes)
adjmatp <- table(newcat,label)
detach(panodes)
palinks = read.csv("~/Documents/urban informatics/Network/cw2/weeplaces/palinks.csv")
palinks$label_x <- tolower(palinks$label_x)
palinks$label_y <- tolower(palinks$label_y)
par(mfrow=c(1,1))
netp <- graph_from_incidence_matrix(adjmatp,directed=F,multiple=T)
netp <- add_edges(netp,c(palinks$label_x,palinks$label_y),role=1)
lay<-layout.fruchterman.reingold(grap=netp,niter=10000)
plot(netp,
     vertex.color=c(rep("lightsteelblue",30),rep("yellow",79)), 
     vertex.frame.color="white", vertex.size=10, 
     vertex.label.cex=0.5, vertex.label.color="black")

assortativity(netp, V(netp), directed=F)

# WORLD--------------------------------------------
wnodes = read.csv("~/Documents/urban informatics/Network/cw2/weeplaces/diners.csv")
wnodes$label <- tolower(wnodes$label)
attach(wnodes)
adjmatw <- table(newcat,label)
detach(wnodes)
wlinks = read.csv("~/Documents/urban informatics/Network/cw2/weeplaces/wlinks.csv")
wlinks$label_x <- tolower(wlinks$label_x)
wlinks$label_y <- tolower(wlinks$label_y)
attach(wlinks)
checkd <- wlinks[ which(label_x!=label_y),]
detach(wlinks)
par(mfrow=c(1,1))
netw <- graph_from_incidence_matrix(adjmatw,directed=F,multiple=T)
netw <- add_edges(netw,c(checkd$label_x,checkd$label_y),role=1)
#lay<-layout.fruchterman.reingold(grap=netw,niter=10000)
#lay <- layout_with_kk(netw)
#coords <- layout.auto(netw)

plot(simplify(netw),
     vertex.color=c(rep("lightsteelblue",46),rep("yellow",1696)), 
     vertex.frame.color="white", vertex.size=1, 
     vertex.label.cex=0.1, vertex.label.color="black")

assortativity(netw, V(netw), directed=F)

# NZ--------------------------------------------
nznodes = read.csv("~/Documents/urban informatics/Network/cw2/weeplaces/nz.csv")
#nzlayer2 = read.csv("~/Documents/urban informatics/Network/cw2/weeplaces/nz.csv")
nznodes$label <- tolower(nznodes$label)
attach(nznodes)
adjmatn <- table(newcat,label)
detach(nznodes)
nzlinks = read.csv("~/Documents/urban informatics/Network/cw2/weeplaces/nzlinks.csv")
nzlinks$x <- tolower(nzlinks$x)
nzlinks$y <- tolower(nzlinks$y)
par(mfrow=c(1,1))
netn <- graph_from_incidence_matrix(adjmatn,directed=F,multiple=T)
netn <- add_edges(netn,c(nzlinks$label_x,nzlinks$label_y))
lay<-layout.fruchterman.reingold(grap=netn,niter=10000)
plot(netn,lay,
     vertex.color=c(rep("lightsteelblue",8),rep("yellow",4)), 
     vertex.frame.color="white", vertex.size=10, 
     vertex.label.cex=0.5, vertex.label.color="black")

assortativity(netn, V(netn), directed=F)
E(netn)

install.packages("multigraph")
library("multigraph")


install.packages("DiagrammeR")
library(DiagrammeR)
nznodes = read.csv("~/Documents/urban informatics/Network/cw2/weeplaces/nznodes.csv")
nzlinks = read.csv("~/Documents/urban informatics/Network/cw2/weeplaces/nzlinks.csv")
nzlayer2 = read.csv("~/Documents/urban informatics/Network/cw2/weeplaces/nzlayer2.csv")
par(mfrow=c(1,1))
#netn <- graph.data.frame(relations, directed=TRUE)

netn <- graph_from_data_frame(d=nzlayer2,vertices=nznodes,directed=F)


netn <- graph.data.frame(nznodes,directed=F)
netn <- add_edges(netn,c(nzlinks$x,nzlinks$y), attr = c(nzlayer2$relation))
netn <- add_edges(netn,c(nzlayer2$source,nzlayer2$target), attr = c(restaurant=nzlayer2$restaurant,weight=nzlayer2$weight))
lay<-layout.fruchterman.reingold(grap=netn,niter=10000)
plot(netn,
     vertex.color=c(rep("lightsteelblue",25),rep("yellow",17)), 
     vertex.frame.color="white", vertex.size=10, 
     vertex.label.cex=0.5, vertex.label.color="black")

assortativity(netn, V(netn), directed=F)
g <
g <- set.vertex.attribute(g, 'status', "N2", list(c("ON", "OFF", "UNKNOWN")))








agg <- min(as.numeric(wnodes[,7]), na.rm=T)

pt_max = as.data.frame(aggregate(date~label, wnodes, min))

library(data.table)
DT <- data.table(wnodes)
DT[ , max(as.numeric(date)), by = label]

install.packages('sqldf')
library(sqldf)
sqldf("select max(date),label from wnodes by label")

library(Hmisc)
statsmax <- summarize(as.Date(wnodes$date),wnodes$label,max)
colnames(statsmax)[1] <- "label"
colnames(statsmax)[2] <- "date"
statsmax['betterDates'] <- as.Date(statsmax['date'],
                       format = "%m/%d/%y")

setDT(group)[, .SD[which.max(date)], by=label]


agg <-aggregate(x = wnodes$date, by=byg, 
                  FUN=min, na.rm=TRUE)













par(mfrow=c(1,1))
net <- graph_from_incidence_matrix(adjmata,directed=F,multiple=T)
net <- add_edges(net,c(amlinks$label_x,amlinks$label_y),role=1)
lay<-layout.fruchterman.reingold(grap=net,niter=10000)
plot(net,     
     vertex.color=c(rep("lightsteelblue",13),rep("yellow",22)), 
     vertex.frame.color="white", vertex.size=10, 
     vertex.label.cex=0.5, vertex.label.color="black")

assortativity(net, V(net), directed=F)

attach(lonodes)
adjmatl <- table(newcat,label)
detach(lonodes)
 
attach(panodes)
adjmatp <- table(newcat,label)
detach(panodes)
 
dist=cor(adjmata)
dist[dist<0.5]=0
diag(dist)=0

g1<-graph.adjacency(adjmata,weighted="TRUE",mode="undirected")
lay<-layout.fruchterman.reingold(grap=g1,niter=10000)

# Then I make the plot. I ask to show the know structure of the population
par(mar=c(0.5,0.5,0.5,0.5))
plot.igraph(g1, 
            layout=lay,vertex.label=rownames(dist) ,
            vertex.color="green" , 
            vertex.size=0.5 , 
            edge.arrow.size=13 , 
            main="")

assortativity_nominal(net, directed = FALSE)


#Finally I add a legend
legend("bottomleft", legend = c("Letter lovers" , "art lovers" , "math lovers"), 
       col = rainbow(3, alpha = 0.3) , 
       pch = 15, bty = "n",  pt.cex = 1.5, cex = 0.8 , 
       text.col = "black", horiz = FALSE, inset = c(0.1, 0.1))


net <- graph_from_data_frame(d=edge0, vertices=node0, directed=F)


g <- graph.data.frame(edge0, directed=F)

# Plot graph
#plot(g, edge.width=E(g)$weight)
plot(g)

ba <- sample_pa(n=100, power=1, m=1, directed=F)
plot(ba, vertex.size=6, vertex.label=NA)
degree_distribution(ba)





homophily<-function(graph,vertex.attr,attr.val=NULL,prop=T){
  #Assign names as vertex attributes for edgelist output#
  V(graph)$name<-vertex_attr(graph,vertex.attr)
  #Get the basic edgelist#
  ee<-get.data.frame(graph)
  #If not specifying on particular attribute value, get percentage (prop=T)#
  #or count (prop=F) of all nodes tied with matching attribute#
  if(is.null(attr.val)){
    ifelse(prop==T,sum(ee[,1]==ee[,2])/nrow(ee),sum(ee[,1]==ee[,2]))
    #If not null, get proportion (prop=T) or count (prop=F) of#
    #edges among nodes with that particular node attribute value#
  } else {
    ifelse(prop==T,sum(ee[,1]==attr.val & ee[,2]==attr.val)/nrow(ee[ee[,1]==attr.val|ee[,2]==attr.val,]),
           sum(ee[,1]==attr.val & ee[,2]==attr.val))
  }
}
#Set the seed for replication#
set.seed(5165)
nodes = read.csv("~/Documents/urban informatics/Network/cw2/weeplaces/amster.csv")
links = read.csv("~/Documents/urban informatics/Network/cw2/weeplaces/friends.csv")
nrow(nodes); length(unique(nodes$date))
nrow(links); nrow(unique(links[,c("source","target")]))
#Random directed graph with 100 nodes and 30% chance of a tie#
#gg<-random.graph.game(100,0.3,"gnp",directed=T)
net <- graph_from_data_frame(d=links, vertices=nodes,directed=F)

library(intergraph)
library(network)
as.matrix(asNetwork(network),matrix.type="incidence")

#Randomly assign the node attribute (group numbers 0:3)#
V(net)$group<-sample(1:5,100,replace=T)
vertex.attributes(net)
edges(net)
homophily(graph = net, vertex.attr = "group")

assortativity(net, V(net), directed=F)