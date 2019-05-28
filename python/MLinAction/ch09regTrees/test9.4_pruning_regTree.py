# -*- coding: utf-8 -*-
"""
Created on Thu Apr  5 16:35:58 2018

@author: ldz
"""
# =============================================================================
'''pruning'''
# =============================================================================
from numpy import loadtxt,shape,mat,power
import matplotlib.pyplot as plt
from regTrees import createTree,binSplitDataSet

def isTree(obj):
    return (type(obj).__name__=='dict')

def getMean(tree):
    if isTree(tree['right']): tree['right'] = getMean(tree['right'])
    if isTree(tree['left']): tree['left'] = getMean(tree['left'])
    return (tree['left']+tree['right'])/2.0
    
def prune(tree, testData):
    if shape(testData)[0] == 0: return getMean(tree) #if we have no test data collapse the tree
    if (isTree(tree['right']) or isTree(tree['left'])):#if the branches are not trees try to prune them
        lSet, rSet = binSplitDataSet(testData, tree['spInd'], tree['spVal'])
    if isTree(tree['left']): tree['left'] = prune(tree['left'], lSet)
    if isTree(tree['right']): tree['right'] =  prune(tree['right'], rSet)
    #if they are now both leafs, see if we can merge them
    if not isTree(tree['left']) and not isTree(tree['right']):
        lSet, rSet = binSplitDataSet(testData, tree['spInd'], tree['spVal'])
        errorNoMerge = sum(power(lSet[:,-1] - tree['left'],2)) +\
            sum(power(rSet[:,-1] - tree['right'],2))
        treeMean = (tree['left']+tree['right'])/2.0
        errorMerge = sum(power(testData[:,-1] - treeMean,2))
        if errorMerge < errorNoMerge: 
            print("merging")
            return treeMean
        else: return tree
    else: return tree
    
fileName = 'ex2.txt'
testName = 'ex2test.txt'
dataSet = loadtxt(fileName)
testSet = loadtxt(testName)
trees = createTree(dataSet)
newTree = prune(trees,mat(testSet))

fig = plt.figure()
ax = fig.add_subplot(111)
ax.scatter(dataSet[:,0].tolist(), dataSet[:,1].tolist(), marker='o', s=50, c='red')
plt.show()
  