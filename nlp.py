#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Apr  9 18:33:21 2019

@author: k1758331
"""
import sys 
from importlib import reload 
reload(sys)  
sys.getdefaultencoding()

import nltk
import os
os.chdir('/Users/jennie/Documents/urban informatics/Mining/cw2/')

from nltk.corpus.reader.plaintext import CategorizedPlaintextCorpusReader
import re

from nltk.corpus import stopwords

import math
import textblob
from textblob import Word
from textblob import TextBlob
from nltk import word_tokenize
from nltk import ne_chunk, pos_tag, word_tokenize
from nltk.tree import Tree
#nltk.download('averaged_perceptron_tagger')
#nltk.download('maxent_ne_chunker')
#nltk.download('words')
def get_continuous_chunks(text):
     chunked = ne_chunk(pos_tag(word_tokenize(text)))
     continuous_chunk = []
     current_chunk = []
     for i in chunked:
             if type(i) == Tree:
                     current_chunk.append(" ".join([token for token, pos in i.leaves()]))
             elif current_chunk:
                     named_entity = " ".join(current_chunk)
                     if named_entity not in continuous_chunk:
                             continuous_chunk.append(named_entity)
                             current_chunk = []
             else:
                     continue
     return continuous_chunk



# create a corpus from the txt files given, with a file of categories to apply to the texts
corpus = CategorizedPlaintextCorpusReader(
                           'corpus/', 
                           r'.*\.txt',
                           cat_file="../textcats.prn")
"""
fileid="nytimes-2017.txt"
raw = corpus.raw(fileid)
raw = raw.replace("N.H.S.", "NHS")
words = word_tokenize(raw)
words = corpus.words(fileid)
clean0 = [word for word in words if word not in stoplist]
"""

bloblist = corpus.fileids()
#bloblist = corpus.fileids(categories='2016')
M=len(bloblist)
# Look at the categories
corpus.categories()

    
# for each file in the corpus

for fileid in bloblist:
    raw = corpus.raw(fileid)
    raw = raw.replace("N.H.S.", "NHS")
    raw = raw.replace("per cent", "%")
    raw = raw.replace("votes", "vote")
    raw = raw.replace("voted", "vote")
    words = word_tokenize(raw)
    # Bring in the default English NLTK stop words
    stoplist = stopwords.words('english')
    # Define additional stopwords in a string this will preserve the word image (without capital) mid sentence
    additional_stopwords = """also one The Media playback is unsupported on your device caption Image Images copyright Reuters AP Getty EPA said BBC"""
    # Split the additional stopwords string on each word and then add
    # those words to the NLTK stopwords list
    stoplist += additional_stopwords.split()
#    words = corpus.words(fileid)

    #fdist = nltk.FreqDist(words)
    # Apply the stoplist to the text retaining uppercase to remove additional stopwords
    clean0 = [word for word in words if word not in stoplist]
    for j, word in enumerate(clean0):
        if word=='May':
            clean0[j]='TMay'
    # revert back to original stoplist and lowercase
    stoplist = stopwords.words('english')
    clean1 = [word.lower() for word in clean0 if word.lower() not in stoplist]
    #remove punctuation and digits, any non-alpha characters
    clean2 = [word for word in clean1 if word.isalpha()]
    # group together words like concern concerns
#    clean3 = [Word(word).lemmatize() for word in clean2]
    fdistc2 = nltk.FreqDist(clean2)
    fdistc2.plot(20)

    print('Document: ',fileid)
    print(TextBlob(str(' '.join(clean2))).sentiment)
    print('Word count (without stop words) in the article: ',len(fdistc2))
    print('Most frequent term (word) in the article: "',fdistc2.max(),'"')
    print('Normalised frequency of most frequent word (normalised by the word count) ',round(fdistc2[fdistc2.max()]/len(fdistc2),3))
    TF = fdistc2[fdistc2.max()]
    print('Term frequency(TF) of the most frequent word in the article: ',TF) 
    named_entities = get_continuous_chunks(raw)
#    print('Named entities for ',fileid, ' are: ',named_entities)

    total=0
    for i, blob in enumerate(bloblist):
        raw = corpus.raw(blob)
        raw = raw.replace("N.H.S.", "NHS")
        raw = raw.replace("per cent", "%")
        raw = raw.replace("votes", "vote")
        raw = raw.replace("voted", "vote")

        words = word_tokenize(raw)

        stoplist = stopwords.words('english')
        # Define additional stopwords in a string
        additional_stopwords = """also one The Media playback is unsupported on your device caption Image Images copyright Reuters AP Getty EPA said BBC"""
        # Split the additional stopwords string on each word and then add
        # those words to the NLTK stopwords list
        stoplist += additional_stopwords.split()
#        words = corpus.words(blob)
        clean0 = [word for word in words if word not in stoplist]
        for j, word in enumerate(clean0):
            if word=='May':
                clean0[j]='TMay'
        # revert back to original stoplist and lowercase
        stoplist = stopwords.words('english')
        clean1 = [word.lower() for word in clean0 if word.lower() not in stoplist]
        #remove punctuation and digits, any non-alpha characters
        clean2 = [word for word in clean1 if word.isalpha()]
        # group together words like concern concerns
#        clean3 = [Word(word).lemmatize() for word in clean2]
        if fdistc2.max() in clean2:
            total += 1
             # Predict

        # telegraph-2017 telegraph-2016 nytimes-2018
    print('DF(T) # of documents that contain the term " ', fdistc2.max(),' ": ',total)
    #use scikit-learn IDF(T)
    IDF = math.log((1 + M)/( 1 + total))+1
    print('Inverse document frequency of the most frequent word in the article: ',round(IDF,3))
    print('TF-IDF for the most frequent word in the article: ', round(TF*IDF,3))
    print(' ')



#
    """
Files2016 = corpus.fileids(categories='2016')

blob.noun_phrases
raw = corpus.raw(Files2016)
named_entities = get_continuous_chunks(raw)
print('Named entities for 2016 are: ',named_entities)

nytFile = corpus.fileids(categories='nytimes')
raw = corpus.raw(nytFile)
named_entities = get_continuous_chunks(raw)
print('Named entities for NY Times are: ',named_entities)

telFile = corpus.fileids(categories='telegraph')
raw = corpus.raw(telFile)
named_entities = get_continuous_chunks(raw)
print('Named entities for the Telegraph are: ',named_entities)
"""
#----------------------------------------------------------------
# named entities.......
"""
from nltk import ne_chunk, pos_tag, word_tokenize
from nltk.tree import Tree
!nltk.download('averaged_perceptron_tagger')
!nltk.download('maxent_ne_chunker')
!nltk.download('words')
def get_continuous_chunks(text):
     chunked = ne_chunk(pos_tag(word_tokenize(text)))
     continuous_chunk = []
     current_chunk = []
     for i in chunked:
             if type(i) == Tree:
                     current_chunk.append(" ".join([token for token, pos in i.leaves()]))
             elif current_chunk:
                     named_entity = " ".join(current_chunk)
                     if named_entity not in continuous_chunk:
                             continuous_chunk.append(named_entity)
                             current_chunk = []
             else:
                     continue
     return continuous_chunk
#names = str(' '.join(clean0))
#named_entities = get_continuous_chunks(names)
Files2016 = corpus.fileids(categories='2016')
#named_entities = get_continuous_chunks(Files2016)
#print('Named entities for ',Files2016, ' are: ',named_entities)
names = str(' '.join(Files2016))
named_entities = get_continuous_chunks(names)


raw = corpus.raw(Files2016)
raw = raw.replace("N.H.S.", "NHS")
raw = raw.replace("per cent", "%")
raw = raw.replace("votes", "vote")
raw = raw.replace("voted", "vote")
words = word_tokenize(raw)
cleanx = [word for word in words if word not in stoplist]
from textblob import TextBlob
blob = TextBlob(raw)
blob.tags
blob.noun_phrases
blob.sentences
blob.sentiment


!pip install pattern
from pattern.en import parsetree
s = parsetree(cleanx)

cfd = nltk.ConditionalFreqDist(
        (year , word))
for year in cleanx.categories()
    for word in words:
        cfd = nltk.ConditionalFreqDist((year , word))
        print(cfd['eu']['brexit'])




#!pip install textblob


bbcFiles = corpus.fileids(categories='bbc')
guardFiles = corpus.fileids(categories='guardian')
indFiles = corpus.fileids(categories='independen')
nytFile = corpus.fileids(categories='nytimes')
teleFile = corpus.fileids(categories='telegraph')
Files2016 = corpus.fileids(categories='2016')
Files2017 = corpus.fileids(categories='2017')
Files2018 = corpus.fileids(categories='2018')
Files2019 = corpus.fileids(categories='2019')



#------------------------------------------------------------------------------
#Code for graphs on statistics
       
import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd
st = pd.read_csv('txtstats.csv')
st.info()
#st['NormFreq1'] = st['NormFreq']*100
f, axs = plt.subplots(nrows=3, ncols=2, figsize=(9, 12))
f.tight_layout() 
axs = axs.flatten()

plt.xticks((2016, 2017, 2018, 2019), ("2016", "2017", "2018", "2019"))
ax = sns.lineplot(x="year", y="Polarity", hue="Outlet", style="Outlet", markers=True,data=st)#raws = corpus.raw(fileid)


plt.xticks((2016, 2017, 2018, 2019), ("2016", "2017", "2018", "2019"))
ax = sns.lineplot(x="year", y="Subjectivity", hue="Outlet", style="Outlet", markers=True,data=st)#raws = corpus.raw(fileid)

plt.xticks((2016, 2017, 2018, 2019), ("2016", "2017", "2018", "2019"))
ax = sns.lineplot(x="year", y="normf", hue="Outlet", style="Outlet", markers=True,data=st)#raws = corpus.raw(fileid)

plt.xticks((2016, 2017, 2018, 2019), ("2016", "2017", "2018", "2019"))
ax = sns.lineplot(x="year", y="Termfreq", hue="Outlet", style="Outlet", markers=True,data=st)#raws = corpus.raw(fileid)

plt.xticks((2016, 2017, 2018, 2019), ("2016", "2017", "2018", "2019"))
ax = sns.lineplot(x="year", y="Invdocfreq", hue="Outlet", style="Outlet", markers=True,data=st)#raws = corpus.raw(fileid)

plt.xticks((2016, 2017, 2018, 2019), ("2016", "2017", "2018", "2019"))
ax = sns.lineplot(x="year", y="TF_IDF", hue="Outlet", style="Outlet", markers=True,data=st)#raws = corpus.raw(fileid)
#plt.savefig('dist.png')    
plt.show()
#,ax=axs[1]
#math.log(M/total)
#math.log((1+M)/(1+total))+1

# spare code

#code for detecting leave remain sentiment
import nltk.classify.util
from nltk.classify import NaiveBayesClassifier
from nltk.corpus import names
""" 
"""
def word_feats(words):
    return dict([(word, True) for word in words])
"""
""" 
def word_feats(words):
    return dict([(words, True)])

positive_vocab = [ 'remain' ]
negative_vocab = [ 'leave' ]
 
positive_features = [(word_feats(pos), 'pos') for pos in positive_vocab]
negative_features = [(word_feats(neg), 'neg') for neg in negative_vocab]
 
train_set = negative_features + positive_features
 
classifier = NaiveBayesClassifier.train(train_set) 


    neg = 0
    pos = 0
    for word in clean2:
        print(word)
        classResult = classifier.classify( word_feats(word))
        print(classResult)
        if classResult == 'neg':
            neg = neg + 1
        if classResult == 'pos':
            pos = pos + 1
                    
    print('Remain: ' + str(float(pos)))
    print('Leave: ' + str(float(neg)))
    print('Remain: ' + str(float(pos)/len(clean2)))
    print('Leave: ' + str(float(neg)/len(clean2)))

