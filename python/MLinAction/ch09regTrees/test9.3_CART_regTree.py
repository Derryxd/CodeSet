# -*- coding: utf-8 -*-
"""
Created on Thu Apr  5 12:46:37 2018

@author: ldz
"""
# =============================================================================
'''CART:classification and regression trees'''
# =============================================================================
from numpy import loadtxt,nonzero,mean,var,shape,inf
import matplotlib.pyplot as plt

def binSplitDataSet(dataSet, feature, value):
    '''最后的[0]应该不需要（已去除）'''
    mat0 = dataSet[nonzero(dataSet[:,feature] > value)[0],:]
    mat1 = dataSet[nonzero(dataSet[:,feature] <= value)[0],:]
    return mat0,mat1

def regLeaf(dataSet):#returns the value used for each leaf
    return mean(dataSet[:,-1])

def regErr(dataSet):
    return var(dataSet[:,-1]) * shape(dataSet)[0]

def chooseBestSplit(dataSet, leafType=regLeaf, errType=regErr, ops=(1,4)):
    tolS = ops[0]; tolN = ops[1]
    #if all the target variables are the same value: quit and return value
    if len(set(dataSet[:,-1].T.tolist())) == 1: #exit cond 1
        return None, leafType(dataSet)
    m,n = shape(dataSet)
    #the choice of the best feature is driven by Reduction in RSS error from mean
    S = errType(dataSet)
    bestS = inf; bestIndex = 0; bestValue = 0
    for featIndex in range(n-1):
        for splitVal in set(dataSet[:,featIndex]):
            mat0, mat1 = binSplitDataSet(dataSet, featIndex, splitVal)
            if (shape(mat0)[0] < tolN) or (shape(mat1)[0] < tolN): continue
            newS = errType(mat0) + errType(mat1)
            if newS < bestS: 
                bestIndex = featIndex
                bestValue = splitVal
                bestS = newS
    #if the decrease (S-bestS) is less than a threshold don't do the split
    if (S - bestS) < tolS: 
        return None, leafType(dataSet) #exit cond 2
    mat0, mat1 = binSplitDataSet(dataSet, bestIndex, bestValue)
    if (shape(mat0)[0] < tolN) or (shape(mat1)[0] < tolN):  #exit cond 3
        return None, leafType(dataSet)
    return bestIndex,bestValue#returns the best feature to split on
                              #and the value used for that split
def createTree(dataSet, leafType=regLeaf, errType=regErr, ops=(1,4)):#assume dataSet is NumPy Mat so we can array filtering
    feat, val = chooseBestSplit(dataSet, leafType, errType, ops)#choose the best split
    if feat == None: return val #if the splitting hit a stop condition return val
    regTree = {}
    regTree['spInd'] = feat
    regTree['spVal'] = val
    lSet, rSet = binSplitDataSet(dataSet, feat, val)
    regTree['left'] = createTree(lSet, leafType, errType, ops)
    regTree['right'] = createTree(rSet, leafType, errType, ops)
    return regTree  
                        
#a=mat(eye(4))
#mat1,mat2 = binSplitDataSet(a,1,0.5)
fileName = 'ex0.txt'
dataSet = loadtxt(fileName)
#dataSet = mat(dataSet)
trees = createTree(dataSet)

fig = plt.figure()
ax = fig.add_subplot(111)
ax.scatter(dataSet[:,1].tolist(), dataSet[:,2].tolist(), marker='o', s=50, c='red')
plt.show()



