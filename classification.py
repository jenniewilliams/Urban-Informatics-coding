#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""


@author: jennie
"""
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
#!pip install seaborn
from sklearn import metrics
from sklearn.metrics import accuracy_score
from sklearn.metrics import classification_report
from sklearn.model_selection import train_test_split
from sklearn.model_selection import cross_validate
from sklearn.tree import DecisionTreeClassifier
from sklearn import linear_model
from sklearn.metrics import mean_squared_error, r2_score

import sklearn.linear_model as lm
#!pip install scikit-plot
import scikitplot as skplt
from mlxtend.plotting import plot_decision_regions


import os
os.chdir('/Users/jennie/Documents/urban informatics/Mining/cw1')

"""
from sklearn import cluster
from sklearn.preprocessing import scale
from sklearn import datasets, linear_model
from sklearn.datasets import load_iris
import random
"""

#----------------------------------------------------------------------------
# Load the titanic data and 
#----------------------------------------------------------------------------
df = pd.read_csv('data/titanic.csv',encoding = "ISO-8859-1")
#df["Age"].describe()
#fill in missing ages with the median age
df["Age"].fillna(df.groupby("Pclass")["Age"].transform("median"), inplace=True)

#----------------------------------------------------------------------------
# Write a script that reads in the Titanic data set and splits the data into training
# and test sets, using test size =0.10 (i.e., test is 10% of the data set). 
#----------------------------------------------------------------------------
train_set, test_set = train_test_split(df,test_size=0.10,random_state=0)
train_set.info()


#----------------------------------------------------------------------------
# For each dataframe: train, test, total
#(a) How many instances are in the data set?
#(b) How many female passengers?
#(c) How many male passengers?
#(e) How many passengers died?
#(d) How many passengers survived?
#(f) How many female passengers survived?
#(g) How many female passengers died?
#(h) How many male passengers survived?
#(i) How many male passengers died?
#(j) How many children died?
#----------------------------------------------------------------------------

# (a)
print(len(train_set), " training instances + ", len(test_set)," test instances = ", len(df)," total instances")

# (b) & (c)
print("Number of male and female passengers in train ds: \n",train_set['Sex'].value_counts())
print("Number of male and female passengers in test ds: \n",test_set['Sex'].value_counts())
print("Number of male and female passengers in titanic ds: \n",df['Sex'].value_counts())

# (d) & (e)
print("Number of died(0) and survived(1) in train ds: \n",train_set['Survived'].value_counts())
print("Number of died(0) and survived(1) in test ds: \n",test_set['Survived'].value_counts())
print("Number of died(0) and survived(1) in titanic ds: \n",df['Survived'].value_counts())

# (f) & (g) & (h) & (i)
print("Number of male and female, died(0) and survived(1) in train ds: \n",pd.crosstab(train_set.Sex, train_set.Survived))
print("Number of male and female, died(0) and survived(1) in test ds: \n",pd.crosstab(test_set.Sex, test_set.Survived))
print("Number of male and female, died(0) and survived(1) in titanic ds: \n",pd.crosstab(df.Sex, df.Survived))

#(j)
# a child is considered nowadays to be under 18 years of age..... and we need
# to consider the fact that some records have missing values for Age.....
print(len(train_set[(train_set['Age']>=0) & (train_set['Age']<18) & (train_set['Survived']==0)]))
print(len(test_set[(test_set['Age']>=0) & (test_set['Age']<18) & (test_set['Survived']==0)]))
print(len(df[(df['Age']>=0) & (df['Age']<18) & (df['Survived']==0)]))

"""
3. (10 marks) Select any two attributes and build a decision tree using scikit-learn which
predicts passenger survival. Test the performance of your model on the test data. Report the
accuracy score and confusion matrix. Include a drawing of your tree in your report. Explain
which attributes you have chosen to use and why
"""
# I choose Pclass and SexN because I understand that the lower the class the less chance you had 
# of survival and women would be higher priority for lifeboat access than men
#pd.crosstab(df.Pclass, [df.Survived, df.Age])

X = train_set[['Pclass','Age']]
y = train_set.Survived

Xt = test_set[['Pclass','Age']]
yt = test_set.Survived

#model = DecisionTreeClassifier(criterion='gini')
#clf = DecisionTreeClassifier(max_depth=3)
clf = DecisionTreeClassifier()
clf.fit(X,y)
#?DecisionTreeClassifier
from sklearn.tree import export_graphviz

export_graphviz(
        clf,
        out_file="titanic_tree_age.dot",
        impurity=True
        )

# dot  -Tpng titanic_tree.dot -o titanic_tree.png

# use our model to predict survival for our test data
#Test the performance of your model on the test data.
y_hat = clf.predict(Xt)
target_names = ['died (survival=0)', 'survived (survival=1)']
print("Classification performance of decision tree classifier:")
print(classification_report(yt, y_hat, target_names=target_names))

# Prediction accuracy
print("\n Accuracy of predicted survival: " + str(round(accuracy_score(yt, y_hat) * 100,2)) + "%")
    
# Confusion Matrix
pd.DataFrame(
    metrics.confusion_matrix(yt, y_hat),
    columns=['Predict Died', 'Predict Survived'],
    index=['Actual Died', 'Actual Survived']
)
"""
4. (10 marks) Build a logistic regression model using scikit-learn which predicts passenger
survival. Test the performance of your model on the test data. Report the accuracy score
and confusion matrix. Plot the ROC curve and the decision boundary, and include these
plots in your report.
"""
# logistic regression
#clogreg = lm.LogisticRegression(solver='lbfgs', multi_class='multinomial' )
clogreg = lm.LogisticRegression(solver='lbfgs', random_state=0)
clogreg.fit(X,y)

y_hat_l = clogreg.predict(Xt)

target_names = ['died (survival=0)', 'survived (survival=1)']
print("Classification performance of logistic regression classifier:")
print(classification_report(yt, y_hat_l, target_names=target_names))
print("\n Accuracy of predicted survival: " + str(round(accuracy_score(yt, y_hat_l) * 100,2)) + "%")

#print ('accuracy score = ' , metrics.accuracy_score( yt , y_hat ))

pd.DataFrame(
    metrics.confusion_matrix(yt, y_hat_l),
    columns=['Predict Died', 'Predict Survived'],
    index=['Actual Died', 'Actual Survived']
)


probs = clogreg.predict_proba(Xt)
skplt.metrics.plot_roc(yt, probs,plot_micro=False, plot_macro=False, )
#?skplt.metrics.plot_roc
plt.show()

Xtn = np.array(Xt)
Xn = np.array(X)
yn = np.array(y)
fig = plt.figure(figsize=(8,10))
scatter_kwargs = {'s': 120, 'edgecolor': None, 'alpha': 0.7}
scatter_highlight_kwargs = {'s': 20, 'c':'w', 'edgecolor': None, 'label': 'Test data', 'alpha': 0.7}
ax=plot_decision_regions(Xn, yn, clf=clogreg, colors = 'black,limegreen', 
                      X_highlight=Xtn, legend=2, 
                      scatter_kwargs=scatter_kwargs,
                      scatter_highlight_kwargs=scatter_highlight_kwargs)
#?plot_decision_regions
# Adding axes annotations
plt.xlabel('Passenger class')
plt.ylabel('Age')
plt.title('Decision Region for Logistic Regression Classifier')
#plt.axes().set_xlim([0, 4])
handles, labels = ax.get_legend_handles_labels()
ax.legend(handles, 
          ['Died', 'Survived','Test data'],
          framealpha=0.3, scatterpoints=1)
xint = []
locs, labels = plt.xticks()
for each in locs:
    xint.append(int(each))
plt.xticks(xint)
plt.show()

"""
5. (10 marks) Build a linear regression model using scikit-learn which predicts Age 
based on Fare. Test the performance of your model on the test data. Report the R2 
score and the mean squared error. Plot the regression line and include this plot in 
your report.
"""
# Create linear regression object
regr = linear_model.LinearRegression()
XR = train_set[['Fare']]
#XR.describe()
yl = train_set.Age

XRt = test_set[['Fare']]
#XRt.describe()
ytl = test_set.Age

# Train the model using the training sets
regr.fit(XR, yl)

# Make predictions using the testing set
y_pred = regr.predict(XRt)

# The intercept
print('Intercept: ', regr.intercept_)
# The coefficients
print('Coefficient: ', regr.coef_)
print('The regression equation: Age = ',np.round_(regr.intercept_,3),' + ',np.round_(regr.coef_[0],3),' x Fare')
# The mean squared error
print("Mean squared error: %.2f"
      % mean_squared_error(ytl, y_pred))
print('Variance score: %.2f' % r2_score(ytl, y_pred))

# Explained variance score: 1 is perfect prediction
"""
The r2_score function computes R², the coefficient of determination. 
It provides a measure of how well future samples are likely to be predicted by the model. 
Best possible score is 1.0 and it can be negative (because the model can be arbitrarily 
worse). 
A constant model that always predicts the expected value of y, disregarding the input 
features, would get a R^2 score of 0.0.
"""

scores = cross_validate(regr, XR, yl, cv=5, scoring='r2',return_train_score=True)

plt.figure()
plt.xlabel('Fare')
plt.ylabel('Age')
plt.title('Plot of Partitioned Data')
plt.plot( XR, yl, 'ko', markersize=5, label='train' )
plt.plot( XRt, ytl, 's', color='limegreen', markersize=5, label='test' )
plt.legend()
plt.axes().set_xlim([0, 550])
plt.show()


# Plot test fit
plt.figure()
plt.xlabel('Fare')
plt.ylabel('Age')
plt.title('Plot of Test Data with Regression Line')
plt.scatter(XRt, ytl, marker='s',  color='limegreen')
plt.plot(XRt, y_pred, color='red', linewidth=2)
plt.axes().set_xlim([0, 550])
plt.show()



















