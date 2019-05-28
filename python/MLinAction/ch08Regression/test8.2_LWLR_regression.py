# -*- coding: utf-8 -*-
"""
Created on Tue Apr  3 14:12:34 2018

@author: ldz
"""
# =============================================================================
'''local weighted linear regression'''
# =============================================================================
from regression import loadDataSet
from numpy import exp,mat,zeros,linalg,shape,diag,tile,array,sort
import matplotlib.pyplot as plt

def lwlr(testPoint, xMat, yMat, k=1.0):
    '''w = inv(X.T*W*X)*X.T*W*y'''
    m = shape(xMat)[0]
    #    weigths = mat(eye(m))
    weights = exp((array(tile(testPoint,[m,1])-xMat)**2).sum(axis=1)/(-2.0*k**2))
    weights = mat(diag(weights))
    xTx = xMat.T * (weights * xMat)
    if linalg.det(xTx) == 0.0:
        print("This matrix is singular, cannot do inverse")
        return
    ws = xTx.I * (xMat.T * (weights * yMat))
    return ws
def reg_plot(xMat,yMat,testPoint,yHat):
    x = array(sort(testPoint[:,1],axis=0))
    ind = array(testPoint[:,1]).argsort(axis=0)
    y = array(yHat)[ind]
    fig = plt.figure()
    ax = fig.add_subplot(111)
    ax.scatter(xMat[:,1].flatten().A[0], yMat[:,0].flatten().A[0],s=5)
    ax.plot(x,y)
    plt.show()

xMat, yMat = loadDataSet('ex0.txt')
xMat = mat(xMat); yMat = mat(yMat).T
testPoint = mat(xMat)
K=[0.003,0.01,1] 
for k in K:
    m = shape(xMat)[0]
    yHat = zeros(m)
    for i in range(m):
        yHat[i] = testPoint[i]*lwlr(testPoint[i],xMat,yMat,k)
    reg_plot(xMat,yMat,testPoint,yHat)
