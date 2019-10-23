#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Feb  2 11:15:39 2019

@author: jennie
"""

 # displayimport pandas as pd
import numpy as np
import pandas as pd
import nltk
from nltk import FreqDist
import matplotlib.pyplot as plt
from nltk.stem import WordNetLemmatizer
import collections

"""
Read in data extracted from http://www.bl.uk/bibliographic/download.html which has then been reduce to 
include just 2018, records with titles containing the word 'network'
"""
df0 = pd.read_csv('/Users/jennie/Documents/urban informatics/Network/cw1/ethos_contains_network_2018.csv',encoding = "ISO-8859-1")
df0.info()

#----------------------------------------------------------------------------
# It may be necessary to use shortened University names so codes were 
# created but may not be used
#----------------------------------------------------------------------------
labdf = pd.read_csv('/Users/jennie/Documents/urban informatics/Network/cw1/uni_labels.csv',encoding = "ISO-8859-1")
labdf.info()
df = pd.merge(df0, labdf, how='left', on=['Institution'])
df.sample(5)

#----------------------------------------------------------------------------
# Stopwords are shor words like 'the', 'and' and 'of' which are not useful 
# when extracting text from thesis titles
#----------------------------------------------------------------------------
from nltk.corpus import stopwords
nltk.download('stopwords')
stop = stopwords.words('english')

df["lTitle"] = df["Title"].str.lower()

df['Title_without_stopwords'] = df['lTitle'].apply(lambda x: ' '.join([word for word in x.split() if word not in (stop)]))

#----------------------------------------------------------------------------
# Create a punctuation list to remove from the title 
# punc = '''!()[]{};:'"\,<>./?@#$%^&*_~'''
#----------------------------------------------------------------------------
punc = '[.?!,":;()|0-9]'
df['Title_without_punc'] = df['Title_without_stopwords'].apply(lambda x: ' '.join([word for word in x.split() if word not in (punc)]))
df['Title_without_punc1'] = df['Title_without_punc'].apply(lambda x: ''.join([i for i in x if not i.isdigit()]))
df['Title_without_punc1'] = df['Title_without_punc1'].str.replace(",", "")

# When 2 words are joined by a / seperate them
df['Title_without_punc1'] = df['Title_without_punc1'].str.replace("/", " ")
df['Title_without_punc1'] = df['Title_without_punc1'].str.replace("-", "")
df['Title_without_punc1'] = df['Title_without_punc1'].str.replace("(", "")
df['Title_without_punc1'] = df['Title_without_punc1'].str.replace(")", "")
df['Title_without_punc1'] = df['Title_without_punc1'].str.replace(".", "")

# Manual stemming of variations of the word network
df['Title_without_punc1'] = df['Title_without_punc1'].str.replace("networks", "network")
df['Title_without_punc1'] = df['Title_without_punc1'].str.replace("networking", "network")

# Remove ad hoc it means that the actual network type will be retrieved
df['Title_without_punc1'] = df['Title_without_punc1'].str.replace("adhoc", "")
df['Title_without_punc1'] = df['Title_without_punc1'].str.replace("ad hoc", "")
df['Title_without_punc1'] = df['Title_without_punc1'].str.replace("ad-hoc", "")
df['Title_without_punc1'] = df['Title_without_punc1'].str.replace("neuronal", "neural")

# 'use network' occurs in only one title, which also has 'queueing network' in the title
df['Title_without_punc1'] = df['Title_without_punc1'].str.replace("use network", "")

#----------------------------------------------------------------------------
# Perform stemming if I want to look at title word co-occurrence 
#----------------------------------------------------------------------------
"""
from nltk.stem import PorterStemmer, WordNetLemmatizer
porter_stemmer = PorterStemmer()
def stem_sentences(sentence):
    tokens = sentence.split()
    stemmed_tokens = [porter_stemmer.stem(token) for token in tokens]
    return ' '.join(stemmed_tokens)

df['Title_stemmed'] = df['Title_without_punc1'].apply(stem_sentences)
df['Title_stemmed'] = df['Title_without_punc1'].apply(stem_sentences)
"""
#----------------------------------------------------------------------------
# Some university names need to be shortened 
# but unlikely and shouldn't make any difference to the network type
#----------------------------------------------------------------------------
df['University'] = df['Institution'].str.replace("University of", "")
df['University'] = df['University'].str.replace("University College London", "UCL")
df['University'] = df['University'].str.replace("University", "")
df['University'] = df['University'].str.replace('( London)', '')
df['University'] = df['University'].str.replace("King's College","King's College London")
df['University'] = df['University'].str.replace("UCL", "University College London")
df['University'] = df['University'].str.replace("the West", "West")
df['University'] = df['University'].apply(lambda x: ' '.join([word for word in x.split() if word not in (punc)]))

import nltk
from nltk.collocations import *
df.info()
node = []
node1 = []
edges = []
edgehash = []
idx = 0
#----------------------------------------------------------------------------
# if the first word in Title_stemmed is network then create an 'other' network 
# type - here I make bigrams from all adjacent words in the title but only 
# keep the words in front of the word 'network' to create a network type
#----------------------------------------------------------------------------
for title,uni in zip(df["Title_without_punc1"],df["University"]):
    tokens = nltk.wordpunct_tokenize(title)
    if tokens[0] == 'network':
        print(tokens[0],tokens[1])
        title = 'other '+title
        tokens = nltk.wordpunct_tokenize(title)
        print(tokens[0],tokens[1])
    word_fd = nltk.FreqDist(tokens)
    bigram_fd = nltk.FreqDist(nltk.bigrams(tokens))
    finder = BigramCollocationFinder(word_fd, bigram_fd)
    bigram_measures = nltk.collocations.BigramAssocMeasures()
    scored = finder.score_ngrams(bigram_measures.raw_freq)
    for i in bigram_fd:
        for j in i[1:]:
            if j == 'network':
                node.append([i[0]])
                node1.append([uni])
                edges.append([i[0],uni]) 
                edgehash.append((i[0],uni)) 
    idx += 1
n = np.array(node)
unin=np.unique(n)
noden = np.array(unin).tolist()
u = np.array(node1)
uniu=np.unique(u)
nodeu = np.array(uniu).tolist()
edgedf = pd.DataFrame(edges)
edgedf.to_csv('/Users/jennie/Documents/urban informatics/Network/cw1/network_2018_output.csv', sep=',', encoding='utf-8',index=False)

#----------------------------------------------------------------------------
# Bipartite Graph
#----------------------------------------------------------------------------
import networkx as nx
from networkx.algorithms import bipartite  
#from string import ascii_lowercase 
#import matplotlib.image as mpimg
from collections import Counter
B = nx.Graph()

B.add_nodes_from(noden, agent_type='Network type',bipartite=0)
B.add_nodes_from(nodeu, agent_type='University',bipartite=1)
# Add edges only between nodes of opposite node sets
edges2 = list(Counter(edgehash).items())
n, z = map(list, zip(*edges2))
x, y = map(list, zip(*n))
weighted_edges = pd.DataFrame(
    {'network': x,
     'university': y,
     'weight': z
    })
weighted_list = weighted_edges.values.tolist()

B.add_weighted_edges_from(weighted_list)
#B.add_edges_from(edges)
#len(edges)
#https://stackoverflow.com/questions/41646735/how-to-created-a-weighted-directed-graph-from-edge-list-in-networkx
top_nodes = {n for n, d in B.nodes(data=True) if d['bipartite']==0}
bottom_nodes = set(B) - top_nodes

#len(top_nodes)
#len(bottom_nodes)
#--------------------------------------------------------------------------
# Check for connectedness
#--------------------------------------------------------------------------
nx.is_connected(B) 

#--------------------------------------------------------------------------
# Check that input graph is bipartite
#--------------------------------------------------------------------------
bipartite.is_bipartite(B)

#--------------------------------------------------------------------------
# Produce the bipartite graph
#--------------------------------------------------------------------------
pos = dict()
pos.update( (n, (1, i)) for i, n in enumerate(top_nodes) ) # put nodes from X at x=1
pos.update( (n, (1.006, i)) for i, n in enumerate(bottom_nodes) ) # put nodes from Y at x=2
fig, ax = plt.subplots(figsize=(20, 40))
plt.axis('off')

edgewidth = [ d['weight'] for (u,v,d) in B.edges(data=True)]

nx.draw_networkx_nodes(B,pos,
                       nodelist=top_nodes,
                       node_color='r',
                       node_size=300,
                       alpha=0.5)
nx.draw_networkx_nodes(B,pos,
                       nodelist=bottom_nodes,
                       node_color='b',
                       node_size=300,
                       alpha=0.5)
nx.draw_networkx_edges(B,pos,
                       width=edgewidth,
                       alpha=0.5, 
                       with_labels = True, 
                       edge_color=edgewidth,
                       edge_cmap=plt.cm.Blues,
                       ax=ax)

labels = {}
for idx, node in enumerate(B.nodes()):
    labels[node] = node

nx.draw_networkx_labels(B,pos,labels=labels,font_size=11,ax=ax)
fig.set_facecolor('grey')
plt.savefig("/Users/jennie/Documents/urban informatics/Network/cw1/labels_and_colors.png", facecolor=fig.get_facecolor()) # save as png
plt.show()

#--------------------------------------------------------------------------
# Calculate the density of the bipartite graph
#--------------------------------------------------------------------------
print(round(bipartite.density(B, bottom_nodes), 3))

#--------------------------------------------------------------------------
# Calculate the degree distribution of universities from the bipartite projected graph.
# We need to have a multigraph because it works for counting the mappings 
#--------------------------------------------------------------------------
U = bipartite.weighted_projected_graph(B,bottom_nodes)
#--------------------------------------------------------------------------
# Calculate the degree for the top and bottom nodes of the bipartite graph
#--------------------------------------------------------------------------
import operator

degX,degY=bipartite.degrees(U,top_nodes,weight='weight')
#universites
a, b = zip(*degX)
degreeCount = collections.Counter(b)
deg, cnt = zip(*degreeCount.items())

#The degree seq below does not take into account the weights of the edges
#degree_sequence = sorted([d for n, d in U.degree()], reverse=True)  # degree sequence
#degreeCount = collections.Counter(degree_sequence)
plt.rcParams['axes.facecolor']='grey'
plt.rcParams['savefig.facecolor']='grey'
fig, ax = plt.subplots(figsize=(10, 8))

#plt.title("Degree Histogram and Graph of Universities",fontsize=11)
plt.ylabel("Count of links",fontsize=14)
plt.xlabel("Degree",fontsize=14)
ax.set_xticks([d + 0.1 for d in deg])
ax.set_xticklabels(deg)
edgewidthU = [ d['weight'] for (u,v,d) in U.edges(data=True)]
plt.bar(deg, cnt, width=0.80, color='blue', alpha=0.5)
# draw graph in inset
plt.axes([0.45, 0.45, 0.45, 0.45])
pos = nx.spring_layout(U, seed=5)
plt.axis('off')
nx.draw_networkx_nodes(U,pos,
                       node_color='b',
                       node_size=20,
                       alpha=0.5)
nx.draw_networkx_edges(U,pos,
                       width=1.0,
                       edge_color=edgewidthU,
                       edge_cmap=plt.cm.Blues,
                       alpha=0.5)

plt.savefig("/Users/jennie/Documents/urban informatics/Network/cw1/degree_histogram_university.png") # save as png
plt.show()

#--------------------------------------------------------------------------
# power law plots for university nodes
#--------------------------------------------------------------------------
#! pip install powerlaw

import powerlaw
d = sorted([d for n, d in degX], reverse=True)  # degree sequence
# try this power law fit
fit = powerlaw.Fit(d, discrete=True)
####
LR, p = fit.distribution_compare('power_law', 'lognormal')
print('Likelihood ratio= ',LR,'  p-value= ',p)
fig = fit.plot_ccdf(linewidth=3, color='b',alpha=0.5, label='University node data')
fit.power_law.plot_ccdf(ax=fig, color='k',alpha=0.5, linestyle='--', label='Power law fit')
fit.lognormal.plot_ccdf(ax=fig, color='w',alpha=0.5, linestyle='--', label='Log-normal fit')
####
fig.set_ylabel(u"p(X≥x)")
fig.set_xlabel("Degree")
handles, labels = fig.get_legend_handles_labels()
fig.legend(handles, labels, loc=3)
plt.savefig("/Users/jennie/Documents/urban informatics/Network/cw1/powerlaw.png")
plt.show()


#--------------------------------------------------------------------------
# Plot the connected components of the universities
#--------------------------------------------------------------------------
fig, ax = plt.subplots(figsize=(10, 15))
plt.rcParams['axes.facecolor']='grey'
plt.rcParams['savefig.facecolor']='grey'
fig.patch.set_facecolor('grey')

plt.axis('off')
Ucc = sorted(nx.connected_component_subgraphs(U), key=len, reverse=True)[0]
labels = {}
for idx, node in enumerate(Ucc.nodes()):
    labels[node] = node
pos = nx.spring_layout(Ucc, seed=2)
plt.title("Connected Component subgraph of Universities",fontsize=11)
edgewidthUcc = [ d['weight'] for (u,v,d) in Ucc.edges(data=True)]
nx.draw_networkx_nodes(Ucc,pos,
                       node_color='b',
                       node_size=500,
                       alpha=0.5)
nx.draw_networkx_edges(Ucc,pos,
                       width=1.0,
                       edge_color=edgewidthUcc,
                       edge_cmap=plt.cm.Blues,
                       alpha=0.5)
nx.draw_networkx_labels(Ucc,pos,labels=labels,font_size=11)

plt.savefig("/Users/jennie/Documents/urban informatics/Network/cw1/cc_university.png") # save as png
plt.show()

Ucc.degree(weight='weight')
degXccu,degYccu=bipartite.degrees(Ucc,top_nodes,weight='weight')
set(degXccu)

degree_sequence = sorted([d for n, d in degXccu], reverse=True)  # degree sequence

#sorted(Ucc.degree(), key=operator.itemgetter(1), reverse=True)
# not quite sure why Exeter is missing from the plot........
#--------------------------------------------------------------------------
# Since Ucc is connected we can calculate its diameter:
#--------------------------------------------------------------------------
nx.diameter(Ucc)
nx.average_shortest_path_length(Ucc)
nx.degree_centrality(Ucc)
nx.closeness_centrality(Ucc)
nx.betweenness_centrality(Ucc)

deg_cent = nx.degree_centrality(Ucc)
plt.figure()
plt.hist(list(deg_cent.values()))
plt.show()
 
plt.figure()
plt.hist([len(Ucc.neighbors([n])) for n in Ucc.nodes()])
plt.show()
print(Ucc.neighbors('University College London'))
    
labels = {}
for idx, node in enumerate(Ucc.nodes()):
    labels[node] = node

nx.draw_networkx_labels(Ucc,pos,labels=labels,font_size=11,ax=ax)
fig.set_facecolor('grey')
#plt.savefig("/Users/jennie/Documents/urban informatics/Network/cw1/cc_university.png", facecolor=fig.get_facecolor()) # save as png
plt.show()


plt.rcParams['axes.facecolor']='white'
plt.rcParams['savefig.facecolor']='white'
#degree_centrality
pos = nx.spring_layout(Ucc, seed=2)
degCent = nx.degree_centrality(Ucc)
node_color = [20000.0 * Ucc.degree(v) for v in Ucc]
node_size =  [v * 10000 for v in degCent.values()]
plt.figure(figsize=(15,15))
nx.draw_networkx(Ucc, pos=pos, with_labels=True,
                 node_color=node_color,
                 node_size=node_size, alpha=0.5 )
nx.draw_networkx_labels(Ucc,pos,labels=labels,font_size=11,ax=ax)

plt.axis('off')
plt.savefig("/Users/jennie/Documents/urban informatics/Network/cw1/dc_university.png") # save as png
plt.show()

#betweenness_centrality
pos = nx.spring_layout(Ucc, seed=2)
betCent = nx.betweenness_centrality(Ucc, normalized=True, endpoints=True)
node_color = [20000.0 * Ucc.degree(v) for v in Ucc]
node_size =  [v * 10000 for v in betCent.values()]
plt.figure(figsize=(15,15))
nx.draw_networkx(Ucc, pos=pos, with_labels=True,
                 node_color=node_color,
                 node_size=node_size, alpha=0.7 )
nx.draw_networkx_labels(Ucc,pos,labels=labels,font_size=11,ax=ax)

plt.axis('off')
plt.savefig("/Users/jennie/Documents/urban informatics/Network/cw1/bc_university.png") # save as png
plt.show()

#closeness_centrality
pos = nx.spring_layout(Ucc, seed=2)
cloCent = nx.closeness_centrality(Ucc)
node_color = [20000.0 * Ucc.degree(v) for v in Ucc]
node_size =  [v * 10000 for v in cloCent.values()]
plt.figure(figsize=(15,15))
nx.draw_networkx(Ucc, pos=pos, with_labels=True,
                 node_color=node_color,
                 node_size=node_size, alpha=0.5 )
nx.draw_networkx_labels(Ucc,pos,labels=labels,font_size=11,ax=ax)

plt.axis('off')
plt.savefig("/Users/jennie/Documents/urban informatics/Network/cw1/cl_university.png") # save as png
plt.show()
#--------------------------------------------------------------------------
# Calculate the degree distribution of network-type from the bipartite projected graph
#--------------------------------------------------------------------------
N = bipartite.weighted_projected_graph(B,top_nodes)
degX,degY=bipartite.degrees(N,bottom_nodes,weight='weight')
#networks
c, d = zip(*degX)
degreeCount = collections.Counter(d)
deg, cnt = zip(*degreeCount.items())
set(degX)
#degree_sequence = sorted([d for n, d in N.degree()], reverse=True)  # degree sequence
# print "Degree sequence", degree_sequence
plt.rcParams['axes.facecolor']='grey'
plt.rcParams['savefig.facecolor']='grey'

fig, ax = plt.subplots(figsize=(15, 8))

plt.bar(deg, cnt, width=0.80, color='red', alpha=0.7)

plt.title("Degree Histogram and Graph of Network-types",fontsize=11)
plt.ylabel("Count of links",fontsize=11)
plt.xlabel("Degree",fontsize=11)
ax.set_xticks([d + 0.1 for d in deg])
ax.set_xticklabels(deg)
edgewidth = [ d['weight'] for (u,v,d) in N.edges(data=True)]
# draw graph in inset
plt.axes([0.4, 0.4, 0.5, 0.5])
pos = nx.spring_layout(N)
plt.axis('off')
nx.draw_networkx_nodes(N,pos,
                       node_color='r',
                       node_size=20,
                       alpha=0.7)
nx.draw_networkx_edges(N,pos,
                       width=1.0,
                       edge_color=edgewidth,
                       edge_cmap=plt.cm.Blues,
                       alpha=0.7)
plt.savefig("/Users/jennie/Documents/urban informatics/Network/cw1/degree_histogram_network-type.png") # save as png
plt.show()
sorted(N.degree(), key=operator.itemgetter(1), reverse=True)


#--------------------------------------------------------------------------
# Plot the connected components of the network-types
#--------------------------------------------------------------------------
fig, ax = plt.subplots(figsize=(15, 30))
#plt.axis('off')
plt.rcParams['axes.facecolor']='grey'
plt.rcParams['savefig.facecolor']='grey'
Ncc = sorted(nx.connected_component_subgraphs(N), key=len, reverse=True)[0]
pos = nx.spring_layout(Ncc, seed=1)
plt.title("Connected Component subgraph of Network-types",fontsize=11)
plt.axis('off')
edgewidthNcc = [ d['weight'] for (u,v,d) in Ncc.edges(data=True)]
nx.draw_networkx_nodes(Ncc,pos,
                       node_color='r',
                       node_size=500,
                       alpha=0.5)
nx.draw_networkx_edges(Ncc,pos,
                       width=1.0,
                       edge_color=edgewidthNcc,
                       edge_cmap=plt.cm.Blues,
                       alpha=0.5)
labels = {}
for idx, node in enumerate(Ncc.nodes()):
    labels[node] = node

nx.draw_networkx_labels(Ncc,pos,labels=labels,font_size=11,ax=ax)
plt.savefig("/Users/jennie/Documents/urban informatics/Network/cw1/cc_network-types.png") # save as png
plt.show()
sorted(Ncc.degree(), key=operator.itemgetter(1), reverse=True)
#--------------------------------------------------------------------------
# Since Ncc is connected we can calculate its diameter:
#--------------------------------------------------------------------------
nx.diameter(Ncc)
nx.average_shortest_path_length(Ncc)

#--------------------------------------------------------------------------
# Maximal Clique of network-type connected components
#--------------------------------------------------------------------------
cliques = list(nx.find_cliques(Ncc))
cliques

fig, ax = plt.subplots(figsize=(14, 6))
from networkx.algorithms.approximation import *
maxc = clique.max_clique(Ncc)
print("Clique Nodes: ",maxc)
print("Clique Size: ",len(maxc))
# A maximal clique is a clique that cannot be extended by including one more 
# adjacent node, meaning it is not a subset of a larger clique.
nodes = [n for n in maxc]
k = Ncc.subgraph(nodes)
nx.draw(k,with_labels=True, seed=1, node_color='g', edge_color='grey',alpha=0.7, label_color="black")
plt.savefig("/Users/jennie/Documents/urban informatics/Network/cw1/max_clique.png") # save as png
plt.show()









