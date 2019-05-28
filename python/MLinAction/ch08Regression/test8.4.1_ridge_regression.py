# -*- coding: utf-8 -*-
"""
Created on Tue Apr  3 15:48:09 2018

@author: ldz
"""
# =============================================================================
'''shrinkage method: rigde regression'''
# =============================================================================
from regression import loadDataSet
from numpy import exp,mat,zeros,linalg,shape,eye,mean,var
import matplotlib.pyplot as plt

def ridge(xMat, yMat, lam=0.2):
    '''w = inv(X.T*X+lambda*I)*X.T*y'''
    xTx = xMat.T*xMat
    denom = xTx + eye(shape(xMat)[1])*lam
    if linalg.det(denom) == 0.0:
        print("This matrix is singular, cannot do inverse")
        return
    ws = denom.I * (xMat.T*yMat)
    return ws


xMat, yMat = loadDataSet('abalone.txt')
xMat = mat(xMat); yMat = mat(yMat).T
yMean = mean(yMat,0)
yMat = yMat - yMean     #to eliminate X0 take mean off of Y
#regularize X's
xMeans = mean(xMat,0)   #calc mean then subtract it off
xVar = var(xMat,0)      #calc variance of Xi then divide by it
xMat = (xMat - xMeans)/xVar
numTestPts = 30
wMat = zeros((numTestPts,shape(xMat)[1]))
for i in range(numTestPts):
    ws = ridge(xMat,yMat,exp(i-10))
    wMat[i,:]=ws.T


fig = plt.figure()
ax = fig.add_subplot(111)
ax.plot(wMat)
plt.show()