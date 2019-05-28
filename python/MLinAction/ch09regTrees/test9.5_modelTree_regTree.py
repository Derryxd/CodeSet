# -*- coding: utf-8 -*-
"""
Created on Thu Apr  5 22:55:04 2018

@author: ldz
"""
# =============================================================================
'''model tree'''
# =============================================================================
from numpy import loadtxt,shape,mat,power,ones,linalg
import matplotlib.pyplot as plt
from regTrees import createTree

def linearSolve(dataSet):   #helper function used in two places
    dataSet = mat(dataSet)
    m,n = shape(dataSet)
    X = mat(ones((m,n))); Y = mat(ones((m,1)))#create a copy of data with 1 in 0th postion
    X[:,1:n] = dataSet[:,0:n-1]; Y = dataSet[:,-1]#and strip out Y
    xTx = X.T*X
    if linalg.det(xTx) == 0.0:
        raise NameError('This matrix is singular, cannot do inverse,\n\
        try increasing the second value of ops')
    ws = xTx.I * (X.T * Y)
    return ws,X,Y

def modelLeaf(dataSet):#create linear model and return coeficients
    ws,X,Y = linearSolve(dataSet)
    return ws

def modelErr(dataSet):
    ws,X,Y = linearSolve(dataSet)
    yHat = X * ws
    return sum(power(Y - yHat,2))

dataSet = loadtxt('exp2.txt')
Trees = createTree(dataSet,modelLeaf,modelErr,(1,10))

fig = plt.figure()
ax = fig.add_subplot(111)
ax.scatter(dataSet[:,0].tolist(), dataSet[:,1].tolist(), marker='o', s=50, c='red')
plt.show()
  