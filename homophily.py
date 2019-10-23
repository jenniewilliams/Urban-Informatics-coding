#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Mar 27 19:02:30 2019

@author: # K1758331/1769227 Network coursework

"""
import pandas as pd
import networkx as nx
import matplotlib.pyplot as plt
import os
os.chdir('/Users/jennie/Documents/urban informatics/Network/cw2/weeplaces/')

# read in the checkins data
wcdf = pd.read_csv('weeplace_checkins.csv',encoding = "ISO-8859-1")
wcdf.info()
wcdf.head()
wcdf.sample(5)
wcdf.category.unique()

# read in the friends data
wfdf = pd.read_csv('weeplace_friends.csv',encoding = "ISO-8859-1")
wfdf.info()
wfdf.head()
wfdf.sample(5)




#https://chrisalbon.com/python/data_wrangling/pandas_regex_to_create_columns/
# selecting pandas columns containing the word food
import re

#find all of the checkins in the 'Food' category 
fooddf = wcdf[wcdf['category'].str.contains('^Food:*',regex=True,na=False)]

# only keep the Restaurants since they represent places where people might eat together
restdf = fooddf[fooddf['category'].str.contains('Restaurants$',regex=True,na=False)]
#restdf.info()


# it might be interesting to look at strip club checkins.... maybe :)
#nightdf = wcdf[wcdf['category'].str.contains('Strip Club$',regex=True,na=False)]
#nightdf.category.unique()

# create a dataset with all the unique names of users in the friends file.....
names1 = wfdf.userid1.unique()
names2 = wfdf.userid2.unique()
namearr = pd.concat([wfdf['userid1'], wfdf['userid2']],axis=0)
dataset = pd.DataFrame({'NameID':namearr})
# remove duplicates
unamedf = dataset.drop_duplicates()
# create a new id to anonymise the data
unamedf0=unamedf.reset_index()
unamedf0.columns = ['New_ID','NameID']
unamedf0['New_ID']=unamedf0.index + 0
iddf = unamedf0

# create a fake name for the users
from sklearn.utils import shuffle
# read in the fake names data
fndf = pd.read_csv('fakenames.csv',encoding = "ISO-8859-1")
fndf.info()
fndf = shuffle(fndf)
fakename = fndf.sample(n=len(iddf))
fakename.info()
# join the fake names with the id
users = pd.concat([iddf.reset_index(drop=True), fakename.reset_index(drop=True)], axis=1)

# add the new ids and fake names to the friends data
# source user first
friendsdf0 = pd.merge(wfdf, users, left_on='userid1', right_on='NameID',how='left')
friendsdf0.rename(columns={'New_ID': 'source'}, inplace=True)
friendsdf0.drop(['NameID'], axis=1, inplace=True)
friendsdf0.info()
# add the new ids and fake names to the friends data
# target user second
friends = pd.merge(friendsdf0, users, left_on='userid2', right_on='NameID',how='left')
friends.rename(columns={'New_ID': 'target'}, inplace=True)
friends.drop(['userid1','userid2','NameID'], axis=1, inplace=True)
friends.sample(5)
friends.info()

# add the new ids and fake names to the check in data
diners = pd.merge(restdf, users, left_on='userid', right_on='NameID',how='left')
diners.rename(columns={'New_ID': 'source'}, inplace=True)
diners.drop(['userid','NameID'], axis=1, inplace=True)
diners['catsub'] = diners.category.str.replace(r'^Food:*', r'')
diners['newcat'] = diners.catsub.str.replace(r'Restaurants$', r'')
diners['newcat'] = diners.newcat.str.replace(r'Restaurants:Paella$', r'')
#replace blank restaurant type with 'Generic'
diners.loc[diners['newcat'] == '', 'newcat'] = 'Generic'
diners.drop(['catsub','city','category'], axis=1, inplace=True)

new = diners["datetime"].str.split("T", n = 1, expand = True) 
diners["date"]= new[0] 
diners["time"]= new[1]
diners.info() 
new0 = diners["time"].str.split(":", n = 2, expand = True) 
diners["hour"]= new0[0] 
diners["min"]= new0[1] 
diners["sec"]= new0[2] 

#time_in_datetime = datetime.strptime(diners["datetime"], "%d-%m-%Y %H:%M:%S")
diners['date'] = pd.to_datetime(diners['date'])

#0=Monday, 1=Tuesday, 3=Wednesday, 4=Thursday, 5=Friday, 6=Saturday, 7=Sunday
diners['dayofweek'] = diners['date'].dt.dayofweek

diners.drop(['datetime'], axis=1, inplace=True)
diners.info()

diners.to_csv('diners.csv',index=False)
friends.to_csv('friends.csv',index=False)



w_names = diners.label.unique()
w_rest = diners.newcat.unique()
wfriends = friends.loc[friends['label_x'].isin(w_names) & friends['label_y'].isin(w_names)]
wlinks = wfriends.drop(['source','target'], axis=1)

wlinks.to_csv('wlinks.csv',index=False)

#berlin bounding box
bbox = [13.088400,52.338120,13.761340,52.675499]
 
lon0 = diners['lon']>13.089
lon1 = diners['lon']<13.762
lat0 = diners['lat']>52.339
lat1 = diners['lat']<52.676

berlin = diners[lon0 & lon1 & lat0 & lat1]
berlin.info()
berlin.to_csv('berlin.csv',index=False)
be_names = berlin.label.unique()
be_rest = berlin.newcat.unique()
befriends = friends.loc[friends['label_x'].isin(be_names) & friends['label_y'].isin(be_names)]
belinks = befriends.drop(['source','target'], axis=1)
belinks.to_csv('belinks.csv',index=False)


#amsterdam bounding box
bbox = [4.7685, 52.3216, 5.0173, 52.4251]

lon0 = diners['lon']>4.768
lon1 = diners['lon']<5.018
lat0 = diners['lat']>52.321
lat1 = diners['lat']<52.426

amster = diners[lon0 & lon1 & lat0 & lat1]
amster.info()
amster.to_csv('amster.csv',index=False)

# london -0.5103, 51.2868, 0.3340, 51.6923
lon0 = diners['lon']>-0.510
lon1 = diners['lon']<0.335
lat0 = diners['lat']>51.286
lat1 = diners['lat']<51.693

london = diners[lon0 & lon1 & lat0 & lat1]
london.info()
london.to_csv('london.csv',index=False)
lo_names = london.label.unique()
lo_rest = london.newcat.unique()
lofriends = friends.loc[friends['label_x'].isin(lo_names) & friends['label_y'].isin(lo_names)]
lolinks = lofriends.drop(['source','target'], axis=1)
lolinks.to_csv('lolinks.csv',index=False)

# new zealand 165.8838, -52.6186, -175.9872, -29.2100
lon0 = diners['lon']>165.883
lon1 = diners['lon']<175.987
lat0 = diners['lat']>-52.618
lat1 = diners['lat']<-29.209

#test
lon0 = diners['lon']>170.492
lon1 = diners['lon']<171.746
lat0 = diners['lat']>-45.896
lat1 = diners['lat']<-43.905

diners = pd.read_csv('diners.csv',encoding = "ISO-8859-1")
friends = pd.read_csv('friends.csv',encoding = "ISO-8859-1")
nz = diners[lon0 & lon1 & lat0 & lat1]
nz.info()
nz.to_csv('nz.csv',index=False)
nz_names = nz.label.unique()
nz_rest = nz.newcat.unique()
nzfriends = friends.loc[friends['label_x'].isin(nz_names) & friends['label_y'].isin(nz_names)]
nzlinks = nzfriends.drop(['source','target'], axis=1)
nzlinks.to_csv('nzlinks.csv',index=False)

#paris 2.0868, 48.6583, 2.6379, 49.0469
lon0 = diners['lon']>2.086
lon1 = diners['lon']<2.638
lat0 = diners['lat']>48.658
lat1 = diners['lat']<49.047

paris = diners[lon0 & lon1 & lat0 & lat1]
paris.info()
paris.to_csv('paris.csv',index=False)
pa_names = paris.label.unique()
pa_rest = paris.newcat.unique()
pafriends = friends.loc[friends['label_x'].isin(pa_names) & friends['label_y'].isin(pa_names)]
palinks = pafriends.drop(['source','target'], axis=1)
palinks.to_csv('palinks.csv',index=False)


#friends.drop(['label_x','label_y'], axis=1, inplace=True)

#amster['label'] = amster['label'].str.lower()
#friends['label_x'] = friends['label_x'].str.lower()
#friends['label_y'] = friends['label_y'].str.lower()
am_names = amster.label.unique()
am_rest = amster.newcat.unique()

amfriends = friends.loc[friends['label_x'].isin(am_names) & friends['label_y'].isin(am_names)]
#amfriends['label_x'] = amfriends['label_x'].str.lower()
#amfriends['label_y'] = amfriends['label_y'].str.lower()
amlinks = amfriends.drop(['source','target'], axis=1)
amlinks.to_csv('amlinks.csv',index=False)


friends = pd.read_csv('wlinks.csv',encoding = "ISO-8859-1")
diners = pd.read_csv('diners.csv',encoding = "ISO-8859-1")
diners.info()

nznodes = pd.read_csv('nznodes.csv',encoding = "ISO-8859-1")
xnodes = pd.read_csv('xnodes.csv',encoding = "ISO-8859-1")
nzlinks = pd.read_csv('nzlinks.csv',encoding = "ISO-8859-1")
nzlayer2 = pd.read_csv('nzlayer2.csv',encoding = "ISO-8859-1")
tuplayer1 = list(zip(nzlinks.x,nzlinks.y,nzlinks.relation))
#tuplayer2 = list(zip(nzlayer2.source,nzlayer2.target,nzlayer2.restaurant,nzlayer2.weight))
tuplayer2 = list(zip(nzlayer2.source,nzlayer2.target))
tupnode = list(zip(nznodes.source))

fig, ax = plt.subplots(figsize=(10, 10))
G = nx.MultiGraph()
#pos=nx.spring_layout(G)
G.add_nodes_from(tupnode,node_color='yellow',node_size=300,alpha=0.5)
G.add_edges_from(tuplayer1,alpha=0.5, edge_color='k',ax=ax)
G.add_edges_from(tuplayer2,alpha=0.5, edge_color='k',ax=ax)
#nx.draw_networkx_labels(G,pos=nx.spring_layout(G),font_size=11,ax=ax)
nx.draw(G,with_labels=True)

G = nx.MultiGraph()
G.add_node("SIMONE",restaurant="Fast Food",date="28/01/2011",hour="5",placeid="mcdonalds")
G.add_node("SHULEM",restaurant="Fast Food",date="28/01/2011",hour="5",placeid="mcdonalds")
G.add_node("SHULEM",restaurant="Fast Food",date="10/03/2011",hour="6",placeid="botanical-takeaways-dunedin")
G.add_node("SIMONE",restaurant="Fast Food",date="10/03/2011",hour="6",placeid="botanical-takeaways-dunedin")
G.add_node("SHULEM",restaurant="Fast Food",date="15/03/2011",hour="11",placeid="botanical-takeaways-dunedin")
G.add_node("SHULEM",restaurant="Fast Food",date="28/01/2011",hour="10",placeid="willowbank-convenience-store-dunedin")
G.add_node("SHULEM",restaurant="Fast Food",date="28/01/2011",hour="10",placeid="willowbank-convenience-store-dunedin")
G.add_node("SHULEM",restaurant="Fast Food",date="28/01/2011",hour="7",placeid="willowbank-convenience-store-dunedin")
G.add_node("SHULEM",restaurant="Fast Food",date="28/01/2011",hour="10",placeid="willowbank-convenience-store-dunedin")
G.add_node("SHULEM",restaurant="Fast Food",date="28/01/2011",hour="3",placeid="willowbank-convenience-store-dunedin")
G.add_node("SHULEM",restaurant="Fast Food",date="28/01/2011",hour="1",placeid="willowbank-convenience-store-dunedin")
G.add_node("SHULEM",restaurant="Fast Food",date="28/01/2011",hour="11",placeid="willowbank-convenience-store-dunedin")
G.add_node("EME",gender='F')
G.add_node("SHULEM",gender='M')
G.add_node("SIMONE",gender='F')
G.add_edge("SHULEM","SIMONE",relation="Friend")
G.add_edge("SIMONE","SHULEM",relation="Friend")


G.add_edge("SHULEM","SIMONE",restaurant="Chinese",weight=1)
G.add_edge("SHULEM","SIMONE",restaurant="Fast Food",weight=5)
G.add_edge("SHULEM","SIMONE",restaurant="Asian",weight=4)
G.add_edge("SHULEM","SIMONE",restaurant="Japanese",weight=1)


print(G.edges(data=True))
nx.draw(G,with_labels=True)
nx.average_degree_connectivity(G)
my_degree, their_degree = zip(*nx.average_degree_connectivity(G).items())
nx.attribute_assortativity_coefficient(G,'gender')

G.from_pandas_dataframe(nznodes, 'id', 'nam')

G.add_edges_from([tuple(x,y,relation) for x,y,relation in zip(nzlinks)])

G=nx.MultiGraph()
G.add_edges_from([tuple(x) for x in nzlinks.values])
G.add_edge(tuplayer1)
G.add_edge(tuplayer2)

# add node attributes



tuplayer1 = list(zip(nzlinks.label_x,nzlinks.label_y))
tuplayer2 = list(zip(nzlayer2.source,nzlayer2.target,nzlayer2.restaurant))
#tuplink0 = list(zip(amster.label, amster.newcat))
tupnode = list(zip(nznodes.source,nznodes.label))
#tupnode0 = list(zip(amster.newcat))
#tupnode = amster.label
#amster.info()

fig, ax = plt.subplots(figsize=(10, 10))
G = nx.MultiGraph()
pos=nx.spring_layout(G)
G.add_nodes_from(tupnode,node_color='yellow',node_size=300,alpha=0.5)
G.add_edges_from(tuplayer1,alpha=0.5, edge_color='k',ax=ax)
G.add_edges(tuplayer2,alpha=0.5, edge_color='k',ax=ax)
#nx.draw_networkx_labels(G,pos=nx.spring_layout(G),font_size=11,ax=ax)
nx.draw(G,with_labels=True)


plt.savefig("/Users/jennie/Documents/urban informatics/Network/cw2/net.png") # save as png
plt.show()

B = nx.Graph()

B.add_nodes_from(noden, agent_type='Network type',bipartite=0)
B.add_nodes_from(nodeu, agent_type='University',bipartite=1)



assortivity_val=nx.attribute_assortativity_coefficient(G,'relation')
r = nx.degree_assortativity_coefficient(G)

G=nx.Graph() 
    
    
G=nx.Graph()
G.add_nodes_from([0,1],color='red')
G.add_nodes_from([2,3],color='blue')
G.add_edges_from([(0,1),(2,3)])
nx.draw(G,with_labels=True)
plt.show()
nx.attribute_assortativity_coefficient(G,'color')  
    
amfriends = pd.read_csv('amfriends.csv',encoding = "ISO-8859-1")
amster = pd.read_csv('amster.csv',encoding = "ISO-8859-1")
amlinks = pd.read_csv('amlinks.csv',encoding = "ISO-8859-1")
amster.info()  
venues = amster
venues.info()
#venues.info()
tuplayer1 = list(zip(amlinks.label_x,amlinks.label_y))
tuplayer2 = list(zip(amfriends.label_x,amfriends.label_y))

labels = amster["placeid"].to_dict()
import networkx as nx
G = nx.MultiGraph()
G.add_nodes_from(venues.index)
G.add_edges_from(tuplayer1)
nx.info(G)
#'Name: \nType: Graph\nNumber of nodes: 66\nNumber of edges: 3\nAverage degree:   0.0909'
pagerank = nx.pagerank(G,alpha=0.9)
betweenness = nx.betweenness_centrality(G)

byplace = venues.groupby(["placeid"])
vens = byplace["label"].describe()
vens.info()
vens['index1'] = vens.index
vens['count1'] = vens['count'].apply(pd.to_numeric, errors='coerce')
#venues['pagerank'] = [pagerank[n] for n in venues.index]
#venues['betweenness'] = [betweenness[n] for n in venues.index]
import matplotlib.pyplot as plt
fig = plt.figure(figsize=(8, 6), dpi=150)
ax = fig.add_subplot(111)
vens.sort_values('count1', inplace=True)
vens.plot(kind='barh',x='count1',y='index1')
ax.set_ylabel('Location')
ax.set_xlabel('Users')
ax.set_title('Top 20 Locations in Amsterdam by Users')
plt.show()
 
pagerank = nx.pagerank(G,alpha=0.9)
betweenness = nx.betweenness_centrality(G)

venues['pagerank'] = [pagerank[n] for n in venues.index]
venues['betweenness'] = [betweenness[n] for n in venues.index]  
fig = plt.figure(figsize=(8, 6), dpi=150)
ax = fig.add_subplot(111)
venues.sort('pagerank', inplace=True)
venues.set_index('name')[-20:].pagerank.plot(kind='barh')
ax.set_ylabel('Location')
ax.set_xlabel('Pagerank')
ax.set_title('Top 20 Locations by Pagerank')
plt.show() 

fig = plt.figure(figsize=(16, 9), dpi=150)
graph_pos=nx.spring_layout(G)
nodesize = [10000*n for n in pagerank.values()]
nx.draw_networkx_nodes(G,graph_pos,node_size=nodesize, alpha=0.5, node_color='blue')
nx.draw_networkx_edges(G,graph_pos,width=1, alpha=0.3,edge_color='blue')
nx.draw_networkx_labels(G, graph_pos, labels=labels, font_size=10, font_family='Arial')
plt.axis('off')
plt.savefig("/Users/jennie/Documents/urban informatics/Network/cw2/net.png") # save as png
plt.show()

nx.write_graphml(G, "./location_graph.graphml")  
    











# Friends contains 