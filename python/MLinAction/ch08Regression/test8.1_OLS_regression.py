# -*- coding: utf-8 -*-
"""
Created on Tue Apr  3 12:26:37 2018

@author: ldz
"""
# =============================================================================
'''OLS:regression'''
# =============================================================================
from numpy import mat,linalg,corrcoef
import matplotlib.pyplot as plt

fileName = 'ex0.txt'
numFeat = len(open(fileName).readline().split('\t'))-1 #get number of fields 
dataMat = []; labelMat = []
fr = open(fileName)
for line in fr.readlines():
    lineArr =[]
    curLine = line.strip().split('\t')
    for i in range(numFeat):
        lineArr.append(float(curLine[i]))
    dataMat.append(lineArr)
    labelMat.append(float(curLine[-1]))
'''w=inv(X.T*T)*X.T*Y'''  
xMat = mat(dataMat); yMat = mat(labelMat).T
xTx = xMat.T*xMat
if linalg.det(xTx) == 0.0:
    print("This matrix is singular, cannot do inverse")
#    return
ws = xTx.I * (xMat.T*yMat)
'''plot'''
fig = plt.figure()
ax = fig.add_subplot(111)
ax.scatter(xMat[:,1].flatten().A[0], yMat[:,0].flatten().A[0])
'''拟合曲线：需要先排序'''
xCopy = xMat.copy()
xCopy.sort(0)
yHat = xCopy*ws
ax.plot(xCopy[:,1],yHat)
plt.show()
'''相关系数:对行向量求相关'''
print('corrcoef = ' + str(corrcoef((xMat*ws).T, yMat.T)) )




