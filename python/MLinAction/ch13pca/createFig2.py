'''
Created on Jun 1, 2011

@author: Peter
'''
from numpy import *
import matplotlib
import matplotlib.pyplot as plt
import pca

dataMat = pca.loadtxt('testSet.txt')
lowDMat, reconMat = pca.pca(dataMat, 1)

fig = plt.figure()
ax = fig.add_subplot(111)
ax.scatter(dataMat[:,0], dataMat[:,1], marker='^', s=90)
ax.scatter(reconMat[:,0].tolist(), reconMat[:,1].tolist(), marker='o', s=50, c='red')
plt.show()