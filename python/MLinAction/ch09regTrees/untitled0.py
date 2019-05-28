# -*- coding: utf-8 -*-
"""
Created on Thu Apr  5 16:07:05 2018

@author: ldz
"""
from numpy import loadtxt,eye,mat,nonzero,mean,var,shape,array,inf
import matplotlib.pyplot as plt
fileName = 'ex0.txt'
#dataSet = loadtxt(fileName)
##dataSet = mat(dataSet)
##trees = createTree(dataSet)
#
#fig = plt.figure()
#ax = fig.add_subplot(111)
#ax.scatter(dataSet[:,1].tolist(), dataSet[:,2].tolist(), marker='o', s=50, c='red')
#plt.show()


dataSet = mat(dataSet)
m,n = shape(dataSet)
X = mat(ones((m,n))); Y = mat(ones((m,1)))#create a copy of data with 1 in 0th postion
X[:,1:n] = dataSet[:,0:n-1]; Y = dataSet[:,-1]#and strip out Y
xTx = X.T*X
if linalg.det(xTx) == 0.0:
    raise NameError('This matrix is singular, cannot do inverse,\n\
    try increasing the second value of ops')
ws = xTx.I * (X.T * Y)
