#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#g=nx.read_edgelist("/Users/jennie/Documents/analytics/bitcoin_network/soc-sign-bitcoinotc-edges.csv", delimiter=",")
#g=nx.read_edgelist("/Users/jennie/Documents/analytics/bitcoin_network/bit_test.csv", delimiter=",")

"""
Created on Mon Mar 19 15:53:36 2018

@author: jennie
"""
import networkx as nx
import ndlib.models.ModelConfig as mc
#import ndlib.models.epidemics.SIRModel as sir
import ndlib.models.epidemics.SIModel as si
from ndlib.viz.mpl.TrendComparison import DiffusionTrendComparison

#matplotlib.pyplot is a collection of command style functions that make matplotlib work like MATLAB
import matplotlib.pyplot as plt
from bokeh.io import output_notebook, show
import sys


# Network Definition
#g = nx.erdos_renyi_graph(1000, 0.1)

#h=nx.read_weighted_edgelist("/Users/jennie/Documents/analytics/xanax/lyricspairs_weight.csv", delimiter=",")
#g=nx.read_edgelist("/Users/jennie/Documents/analytics/bitcoin_network/soc-sign-bitcoinotc.csv", delimiter=",")
#g=nx.read_edgelist("/Users/jennie/Documents/analytics/bitcoin_network/bit_test.csv", delimiter=",")
#g=nx.read_edgelist("/Users/jennie/Documents/analytics/xanax/xanshort_nolabel.csv", delimiter=",")
#g=nx.read_edgelist("*.csv", delimiter=",")
G=nx.read_edgelist("/Users/jennie/Documents/analytics/xanax/lyrics_ngram.csv", delimiter=",")
print(nx.number_connected_components(G), "connected components")

options = {
        'node_color': 'cyan',
        'node_size': 1,
        'line_color': 'red',
        'linewidths': 0,
        'width': 0.1,
}
nx.draw_circular(G, **options)
plt.show()

G=nx.read_edgelist("/Users/jennie/Documents/analytics/xanax/xanshort.csv", delimiter=",")

import networkx as nx
import dynetx as dn
import matplotlib.pyplot as plt

g = dn.DynGraph(edge_removal=False)
g = dn.read_snapshots("/Users/jennie/Documents/analytics/xanax/lyrics_ngrams.txt", timestamptype=int)
pos=nx.spring_layout(g,scale=20) # double distance between all nodes
plt.figure(3,figsize=(10,10)) 
nx.draw(g,pos,node_size=10, font_size=8, with_labels=True)


list(g.stream_interactions())



import networkx as nx
import ndlib.models.ModelConfig as mc
import ndlib.models.opinions.AlgorithmicBiasModel as ab

# Network topology
g=nx.read_edgelist("/Users/jennie/Documents/analytics/xanax/lyrics_ngram.csv", delimiter=",")


# Model selection
model = ab.AlgorithmicBiasModel(g)

# Model configuration
config = mc.Configuration()
config.add_model_parameter("epsilon", 0.32)
config.add_model_parameter("gamma", 1)
model.set_initial_status(config)

# Simulation execution
iterations = model.iteration_bunch(200)
trends = model.build_trends(iterations)

from bokeh.io import output_notebook, show
from ndlib.viz.bokeh.DiffusionTrend import DiffusionTrend

viz = DiffusionTrend(model, trends)
p = viz.plot(width=400, height=400)
show(p)


# Graph
pos = nx.draw_random(g)
pos=nx.spring_layout(G,scale=20) # double distance between all nodes
plt.figure(3,figsize=(20,20)) 
nx.draw(g,pos,node_size=10, font_size=8, with_labels=True)



import louvain
import pycairo
import igraph as ig
from igraph import *
G = Graph.Read_Ncol("/Users/jennie/Documents/analytics/xanax/lyrics_ngram_nolabel.txt", directed=True)
partition = louvain.find_partition(G, louvain.ModularityVertexPartition)
ig.plot(partition) 

G = ig.Graph.Famous('Zachary')
partition = louvain.ModularityVertexPartition(g)
partition = louvain.find_partition(g, louvain.ModularityVertexPartition);
#import matplotlib.pyplot as plt
# Find modularity
part = community.best_partition(g)
mod = community.modularity(part,g)
#import community
# Plot, color nodes using community structure
values = [part.get(node) for node in g.nodes()]
nx.draw_spring(g, cmap=plt.get_cmap('jet'), node_color = values, node_size=30, with_labels=False)
plt.show()












import dynetx as dn

#g = nx.erdos_renyi_graph(1000, 0.1)
#g = dn.read_snapshots("/Users/jennie/Documents/analytics/xanax/lyrics_ngram_nolabel.txt", timestamptype=int)

plt.show()
H = g.time_slice(2015, 2018)
H.interactions()

for e in g.stream_interactions():
        print (e)
        
#nx.draw(G,node_size=100, with_labels=True)
colors = ['b', 'g', 'r']
c = colors.pop(0)
#node_size = [int(G.pop[n] / 300.0) for n in G]
nx.draw_networkx_edges(G, G.target, edge_color=c, width=4, alpha=0.5)
nx.draw_networkx_nodes(G, G.source, node_size=node_size, node_color=c, alpha=0.5)
nx.draw_networkx_nodes(G, G.source, node_size=5, node_color='k')
plt.figure(figsize=(5, 5))
plt.show()

plt.clf()
#    colors = ['b', 'g', 'r']
#    for G in g:
#        c = colors.pop(0)
#        node_size = [int(G.pop[n] / 300.0) for n in G]
#        nx.draw_networkx_edges(G, G.pos, edge_color=c, width=4, alpha=0.5)
#        nx.draw_networkx_nodes(G, G.pos, node_size=node_size, node_color=c, alpha=0.5)
#        nx.draw_networkx_nodes(G, G.pos, node_size=5, node_color='k')
#
#    for c in city:
#        x, y = city[c]
#        plt.text(x, y + 0.1, c)
plt.show()

if __name__ == '__main__':
    G=nx.read_edgelist("/Users/jennie/Documents/analytics/xanax/xanshort_nolabel.csv", delimiter=",")




    print("Song lyrics containing 'Xan' and converted ngrams")
    print("Graph has %d nodes with %d edges"
          % (nx.number_of_nodes(G), nx.number_of_edges(G)))
    print("%d connected components" % nx.number_connected_components(G))

    for (source, target) in [('xanax', 'fuck'),
                             ('panties', 'xan'),
                             ('molly', 'bitch'),
                             ('yellow', 'niggas')]:
        print("Shortest path between %s and %s is" % (source, target))
        try:
            sp = nx.shortest_path(G, source, target)
            for n in sp:
                print(n)
                plt.show(sp)
        except nx.NetworkXNoPath:
            print("None")














plt.savefig("/Users/jennie/Documents/analytics/xanax/Networkx_xanax.png")

print("node degree clustering")
for v in nx.nodes(G):
    print('%s %d %f' % (v, nx.degree(G, v), nx.clustering(G, v)))

# print the adjacency list to terminal
try:
    nx.write_adjlist(G, sys.stdout)
except TypeError:  # Python 3.x
    nx.write_adjlist(G, sys.stdout.buffer)

nx.draw(G,node_size=50, with_labels=True)
plt.show()




# Model Selection
#model = sir.SIRModel(h)
model = si.SIModel(h)

#print(model)

# Each model has its own parameters: in order to completely 
# instantiate the simulation we need to specify them using a 
# Configuration object:

# Model Configuration
config = mc.Configuration()
#infection probability
config.add_model_parameter('beta',0.05)
#config.add_model_parameter('beta', 0.04)
#recovery probability
#config.add_model_parameter('lambda', 0.01)
#removal probability
#config.add_model_parameter('gamma', 0.01)
#initial infection status
#config.add_model_parameter("percentage_infected", 0.40)
model.set_initial_status(config)

# The model configuration allows you to specify model parameters 
# (as in this scenario) as well as nodes and edges (e.g. 
# individual thresholds).

# It allows you to specify the initial percentage of infected 
# nodes using the percentage_infected model parameter.

# It is also possible to explicitly specify an initial set of 
# infected nodes: see :ref:`model_conf` for the complete set of use cases.

# Simulation
iterations = model.iteration_bunch(100)
trends = model.build_trends(iterations)

#from ndlib.viz.mpl.DiffusionTrend import DiffusionTrend
#viz = DiffusionTrend(model, trends)
#viz.plot()

from bokeh.io import output_notebook, show
from ndlib.viz.bokeh.DiffusionTrend import DiffusionTrend

viz = DiffusionTrend(model, trends)
p = viz.plot(width=400, height=400)
show(p)
#----------------------------------------------------------------------------
#from ndlib.viz.bokeh.DiffusionPrevalence import DiffusionPrevalence

#viz2 = DiffusionPrevalence(model, trends)
#p2 = viz2.plot(width=400, height=400)
#show(p2)

#from ndlib.viz.bokeh.MultiPlot import MultiPlot
#vm = MultiPlot()
#vm.add_plot(p)
#vm.add_plot(p2)
#m = vm.plot()
#show(m)














import dynetx as dn
g = dn.DynGraph()

g=dn.read_snapshots("/Users/jennie/Documents/analytics/xanax/xanaxnodesdyn.csv", delimiter=",",timestamptype=int)
dn.draw(g)
plt.show()


import networkx as nx
import dynetx as dn
import ndlib.models.ModelConfig as mc
import ndlib.models.dynamic.DynSIRModel as sir

# Dynamic Network topology
dg = dn.DynGraph()

for t in range(1982, 2018):
#    g = nx.erdos_renyi_graph(200, 0.05)
    g = dn.read_snapshots("/Users/jennie/Documents/analytics/xanax/xanaxnodesdyn.csv", delimiter=",",timestamptype=int)
    dg.add_interactions_from(g.edges(), t)

nx.draw(dg)
plt.show()

# Model selection
model = sir.DynSIRModel(dg)

# Model Configuration
config = mc.Configuration()
config.add_model_parameter('beta', 0.04)
config.add_model_parameter('gamma', 0.01)
config.add_model_parameter("addicted", 0.40)
model.set_initial_status(config)

# Simulate snapshot based execution
iterations = model.execute_snapshots()

# Simulation interaction graph based execution
iterations = model.execute_iterations()
trends = model.build_trends(iterations)
from ndlib.viz.mpl.DiffusionTrend import DiffusionTrend
viz = DiffusionTrend(model, trends)
viz.plot()







import networkx as nx
import dynetx as dn
import ndlib.models.ModelConfig as mc
import ndlib.models.dynamic.DynSIRModel as sir

# Dynamic Network topology
dg = dn.DynGraph()

for t in range(0, 3):
    g = nx.erdos_renyi_graph(200, 0.05)
    dg.add_interactions_from(g.edges(), t)

# Model selection
model = sir.DynSIRModel(dg)

# Model Configuration
config = mc.Configuration()
config.add_model_parameter('beta', 0.01)
config.add_model_parameter('gamma', 0.01)
config.add_model_parameter("percentage_infected", 0.1)
model.set_initial_status(config)

# Simulate snapshot based execution
iterations = model.execute_snapshots()

# Simulation interaction graph based execution
iterations = model.execute_iterations()

