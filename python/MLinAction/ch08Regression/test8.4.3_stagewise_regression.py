# -*- coding: utf-8 -*-
"""
Created on Tue Apr  3 16:52:21 2018

@author: ldz
"""
# =============================================================================
'''shrinkage method: stagewise regression'''
# =============================================================================
from regression import loadDataSet,regularize
from numpy import mat,zeros,shape,mean,inf
import matplotlib.pyplot as plt

def rssError(yArr,yHatArr): #yArr and yHatArr both need to be arrays
    return ((yArr-yHatArr)**2).sum()

def stageWise(xArr,yArr,eps=0.01,numIt=100):
    xMat = mat(xArr); yMat=mat(yArr).T
    yMean = mean(yMat,0)
    yMat = yMat - yMean     #can also regularize ys but will get smaller coef
    xMat = regularize(xMat)
    m,n=shape(xMat)
    #returnMat = zeros((numIt,n)) #testing code remove
    ws = zeros((n,1)); wsTest = ws.copy(); wsMax = ws.copy()
    for i in range(numIt):
#        print(ws.T)
        lowestError = inf; 
        for j in range(n):
            for sign in [-1,1]:
                wsTest = ws.copy()
                wsTest[j] += eps*sign
                yTest = xMat*wsTest
                rssE = rssError(yMat.A,yTest.A)
                if rssE < lowestError:
                    lowestError = rssE
                    wsMax = wsTest
        ws = wsMax.copy()
        #returnMat[i,:]=ws.T
    return ws

xMat, yMat = loadDataSet('abalone.txt')
weights = stageWise(xMat,yMat,0.001,2000)


fig = plt.figure()
ax = fig.add_subplot(111)
ax.plot(weights)
plt.show()
