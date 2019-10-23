#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""


@author: jennie
"""

import pandas as pd
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
#!pip install seaborn
import pylab as pl
from sklearn import metrics
import sklearn.cluster as cluster
from scipy.cluster.hierarchy import dendrogram
from sklearn.cluster import AgglomerativeClustering
import os
os.chdir('/Users/jennie/Documents/urban informatics/Mining/cw1')


"""
CLUSTERING
"""
ta = pd.read_csv('data/tripadvisor.csv',encoding = "ISO-8859-1")
X = ta.drop('User ID', 1)

"""
plot_dendrogram aquired from:
https://github.com/scikit-learn/scikit-learn/blob/70cf4a676caa2d2dad2e3f6e4478d64bcb0506f7/
examples/cluster/plot_hierarchical_clustering_dendrogram.py
"""
def plot_dendrogram(model, **kwargs):

    # Children of hierarchical clustering
    children = model.children_

    # Distances between each pair of children
    # Since we don't have this information, we can use a uniform one for plotting
    distance = np.arange(children.shape[0])

    # The number of observations contained in each cluster level
    no_of_observations = np.arange(2, children.shape[0]+2)

    # Create linkage matrix and then plot the dendrogram
    linkage_matrix = np.column_stack([children, distance, no_of_observations]).astype(float)
   
    # Plot the corresponding dendrogram
    dendrogram(linkage_matrix, **kwargs)

cpool = [ '#bd2309', '#bbb12d', '#1480fa']
cmap3 = matplotlib.colors.ListedColormap(cpool[0:3], 'indexed')
matplotlib.cm.register_cmap(cmap=cmap3)

cpool = [ '#bd2309', '#bbb12d', '#1480fa', '#14fa2f', '#000000']
cmap5 = matplotlib.colors.ListedColormap(cpool[0:5], 'indexed')
matplotlib.cm.register_cmap(cmap=cmap5)

cpool = [ '#bd2309', '#bbb12d', '#1480fa', '#14fa2f', '#000000',
         '#faf214', '#2edfea', '#ea2ec4', '#ea2e40', '#cdcdcd']
cmap10 = matplotlib.colors.ListedColormap(cpool[0:10], 'indexed')
matplotlib.cm.register_cmap(cmap=cmap10)



#set the colors for the dendrogram labels
label_colors3 = {'0':'#bd2309', '1':'#bbb12d', '2':'#1480fa'}
label_colors5 = {'0':'#bd2309', '1':'#bbb12d', '2':'#1480fa', '3':'#14fa2f', '4':'#000000'}
label_colors10 = {'0':'#bd2309', '1':'#bbb12d', '2':'#1480fa', '3':'#14fa2f', '4':'#000000', '5':'#faf214', '6':'#2edfea', '7':'#ea2ec4', '8':'#ea2e40', '9':'#cdcdcd'}
#run the model for 3 clusters
ac3 = AgglomerativeClustering( n_clusters=3).fit( X )

#create a 3 cluster dendrogram - with colored cluster identifier labels
plt.figure(figsize=(10,5))
plt.title('Hierarchical Clustering Dendrogram K=3')
ax = plot_dendrogram(ac3, labels=ac3.labels_,leaf_rotation = 180.,leaf_font_size = 6.,color_threshold=0.7, above_threshold_color="grey")
ax = plt.gca()
xlbls = ax.get_xmajorticklabels()
for lbl in xlbls:
    lbl.set_color(label_colors3[lbl.get_text()])
plt.show()

print("Silhouette: ",metrics.silhouette_score(X, ac3.labels_, metric='euclidean'))
print("Calinski_Harabaz: ",metrics.calinski_harabaz_score(X, ac3.labels_))

pl.figure(figsize=(10,5))
pl.scatter(X["Category 3"], X["Category 4"], c=ac3.labels_,s=50, cmap=cmap3)
pl.xlabel( 'Category 3' )
pl.ylabel( 'category 4' )
pl.title( '3 Cluster K-Means' )
 
ac5 = cluster.AgglomerativeClustering( n_clusters=5).fit( X )

plt.figure(figsize=(10,5))
plt.title('Hierarchical Clustering Dendrogram K=5')
ax = plot_dendrogram(ac5, labels=ac5.labels_,leaf_rotation = 180.,leaf_font_size = 6.,color_threshold=0.7, above_threshold_color="grey")
ax = plt.gca()
xlbls = ax.get_xmajorticklabels()
for lbl in xlbls:
    lbl.set_color(label_colors5[lbl.get_text()])

plt.show()

print("Silhouette: ",metrics.silhouette_score(X, ac5.labels_, metric='euclidean'))
print("Calinski_Harabaz: ",metrics.calinski_harabaz_score(X, ac5.labels_))

pl.figure(figsize=(10,5))
pl.scatter(X["Category 3"], X["Category 4"], c=ac5.labels_,s=50, cmap=cmap5)
pl.xlabel( 'Category 3' )
pl.ylabel( 'category 4' )
pl.title( '5 Cluster K-Means' )


ac10 = cluster.AgglomerativeClustering( n_clusters=10).fit( X )

plt.figure(figsize=(10,5))
plt.title('Hierarchical Clustering Dendrogram K=10')
ax = plot_dendrogram(ac10, labels=ac10.labels_,leaf_rotation = 180.,leaf_font_size = 6.,color_threshold=0.7, above_threshold_color="grey")
ax = plt.gca()
xlbls = ax.get_xmajorticklabels()
for lbl in xlbls:
    lbl.set_color(label_colors10[lbl.get_text()])
#    print(label_colors[lbl.get_text()])

plt.show()

print("Silhouette: ",metrics.silhouette_score(X, ac10.labels_, metric='euclidean'))
print("Calinski_Harabaz: ",metrics.calinski_harabaz_score(X, ac10.labels_))

pl.figure(figsize=(10,5))
pl.scatter(X["Category 3"], X["Category 4"], c=ac10.labels_,s=50, cmap=cmap10)
pl.xlabel( 'Category 3' )
pl.ylabel( 'category 4' )
pl.title( '10 Cluster K-Means' )






