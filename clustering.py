#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""


@author: jennie
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
#!pip install seaborn
import seaborn as sns
import pylab as pl
from sklearn import metrics
import sklearn.cluster as cluster
from mlxtend.plotting import plot_decision_regions
import os
os.chdir('/Users/jennie/Documents/urban informatics/Mining/cw1')

"""
CLUSTERING
"""
ta = pd.read_csv('data/tripadvisor.csv',encoding = "ISO-8859-1")
ta.info()
print("There are ",len(ta), " instances in the Trip Advisor data ")

f, axs = plt.subplots(nrows=5, ncols=2, figsize=(9, 12))
f.tight_layout() 
axs = axs.flatten()
for i in np.arange(10):
    j=i+1
    str="Category %s" %j
    ax = axs[i]
    sns.distplot(ta[str],ax=ax)
plt.savefig('dist.png')    
plt.show()

X = ta.drop('User ID', 1)

km3 = cluster.KMeans(n_clusters=3).fit(X)

print("Within clusters: ",km3.inertia_)
bet3=0
cen3 = km3.cluster_centers_
for i in np.arange( 3 ):
    for o in np.arange(i+1, 3):
        bet3i = ( np.square(cen3[i][0]-cen3[o][0]) 
            + np.square(cen3[i][1]-cen3[o][1]) 
            + np.square(cen3[i][2]-cen3[o][2]) 
            + np.square(cen3[i][3]-cen3[o][3])
            + np.square(cen3[i][4]-cen3[o][4])
            + np.square(cen3[i][5]-cen3[o][5])
            + np.square(cen3[i][6]-cen3[o][6])
            + np.square(cen3[i][7]-cen3[o][7])
            + np.square(cen3[i][8]-cen3[o][8])
            + np.square(cen3[i][9]-cen3[o][9]))
        bet3 += bet3i
print("Between clusters: ",bet3)
overall_cluster_score3 = bet3/km3.inertia_
print("Overall cluster score: ",overall_cluster_score3)
print("Silhouette: ",metrics.silhouette_score(X, km3.labels_, metric='euclidean'))
print("Calinski_Harabaz: ",metrics.calinski_harabaz_score(X, km3.labels_))

pl.figure(figsize=(7,9))
pl.scatter(X["Category 3"], X["Category 4"], c=km3.labels_,s=50, cmap='viridis')
pl.scatter(cen3[:, 2], cen3[:, 3], c='red', s=100);
pl.xlabel( 'Category 3' )
pl.ylabel( 'category 4' )
pl.title( '3 Cluster K-Means' )

km5 = cluster.KMeans(n_clusters=5).fit(X)
labels5 = km5.labels_
print("Within clusters: ",km5.inertia_)
bet5=0
cen5 = km5.cluster_centers_
for i in np.arange( 5 ):
    for o in np.arange(i+1, 5):
        bet5i = ( np.square(cen5[i][0]-cen5[o][0]) 
            + np.square(cen5[i][1]-cen5[o][1]) 
            + np.square(cen5[i][2]-cen5[o][2]) 
            + np.square(cen5[i][3]-cen5[o][3])
            + np.square(cen5[i][4]-cen5[o][4])
            + np.square(cen5[i][5]-cen5[o][5])
            + np.square(cen5[i][6]-cen5[o][6])
            + np.square(cen5[i][7]-cen5[o][7])
            + np.square(cen5[i][8]-cen5[o][8])
            + np.square(cen5[i][9]-cen5[o][9]))
        bet5 += bet5i
print("Between clusters: ",bet5)
overall_cluster_score5 = bet5/km5.inertia_
print("Overall cluster score: ",overall_cluster_score5)
print("Silhouette: ",metrics.silhouette_score(X, km5.labels_, metric='euclidean'))
print("Calinski_Harabaz: ",metrics.calinski_harabaz_score(X, km5.labels_))

pl.figure(figsize=(7,9))
pl.scatter(X["Category 3"], X["Category 4"], c=km5.labels_,s=50, cmap='viridis')
pl.scatter(cen5[:, 2], cen5[:, 3], c='red', s=100);
pl.xlabel( 'Category 3' )
pl.ylabel( 'category 4' )
pl.title( '5 Cluster K-Means' )



km10 = cluster.KMeans(n_clusters=10).fit(X)
labels10 = km10.labels_
print("Within clusters: ",km10.inertia_)
bet10=0
cen10 = km10.cluster_centers_
for i in np.arange( 10 ):
    for o in np.arange(i+1, 10):
        bet10i = ( np.square(cen10[i][0]-cen10[o][0]) 
            + np.square(cen10[i][1]-cen10[o][1]) 
            + np.square(cen10[i][2]-cen10[o][2]) 
            + np.square(cen10[i][3]-cen10[o][3])
            + np.square(cen10[i][4]-cen10[o][4])
            + np.square(cen10[i][5]-cen10[o][5])
            + np.square(cen10[i][6]-cen10[o][6])
            + np.square(cen10[i][7]-cen10[o][7])
            + np.square(cen10[i][8]-cen10[o][8])
            + np.square(cen10[i][9]-cen10[o][9]))
        bet10 += bet10i
print("Between clusters: ",bet10)
overall_cluster_score10 = bet10/km10.inertia_
print("Overall cluster score: ",overall_cluster_score10)
print("Silhouette: ",metrics.silhouette_score(X, km10.labels_, metric='euclidean'))
print("Calinski_Harabaz: ",metrics.calinski_harabaz_score(X, km10.labels_))

pl.figure(figsize=(7,9))
pl.scatter(X["Category 3"], X["Category 4"], c=km10.labels_,s=50, cmap='viridis')
pl.scatter(cen10[:, 2], cen10[:, 3], c='red', s=50);
pl.xlabel( 'Category 3' )
pl.ylabel( 'category 4' )
pl.title( '10 Cluster K-Means' )










