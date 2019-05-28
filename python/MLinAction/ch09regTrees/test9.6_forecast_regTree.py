# -*- coding: utf-8 -*-
"""
Created on Thu Apr  5 23:15:06 2018

@author: ldz
"""
# =============================================================================
'''forecast'''
# =============================================================================
from numpy import loadtxt,shape,mat,zeros,ones,corrcoef
import matplotlib.pyplot as plt
from regTrees import createTree,isTree,modelLeaf

def regTreeEval(model, inDat):
    return float(model)

def modelTreeEval(model, inDat):
    n = shape(inDat)[1]
    X = mat(ones((1,n+1)))
    X[:,1:n+1]=inDat
    return float(X*model)

def treeForeCast(tree, inData, modelEval=regTreeEval):
    if not isTree(tree): return modelEval(tree, inData)
    if inData[tree['spInd']] > tree['spVal']:
        if isTree(tree['left']): return treeForeCast(tree['left'], inData, modelEval)
        else: return modelEval(tree['left'], inData)
    else:
        if isTree(tree['right']): return treeForeCast(tree['right'], inData, modelEval)
        else: return modelEval(tree['right'], inData)
        
def createForeCast(tree, testData, modelEval=regTreeEval):
    m=len(testData)
    yHat = mat(zeros((m,1)))
    for i in range(m):
        yHat[i,0] = treeForeCast(tree, mat(testData[i]), modelEval)
    return yHat

fileName = 'bikeSpeedVsIq_train.txt'
testName = 'bikeSpeedVsIq_test.txt'
TrainMat = mat(loadtxt(fileName))
TestMat = mat(loadtxt(testName))

treesConstant = createTree(TrainMat,ops=(1,20))
yHat1 = createForeCast(treesConstant,TestMat[:,0])
print(corrcoef(yHat1,TestMat[:,1],rowvar=0)[0,1])

treesModel = createTree(TrainMat,modelLeaf,ops=(1,20))
yHat2 = createForeCast(treesModel,TestMat[:,0],modelTreeEval)
print(corrcoef(yHat2,TestMat[:,1],rowvar=0)[0,1])

fig = plt.figure()
ax = fig.add_subplot(311)
ax.scatter(TestMat[:,0].tolist(), yHat1.tolist(), marker='o', s=20, c='red')
ax = fig.add_subplot(312)
ax.scatter(TestMat[:,0].tolist(), yHat2.tolist(), marker='o', s=20, c='red')
ax = fig.add_subplot(313)
ax.scatter(TestMat[:,0].tolist(), TestMat[:,1].tolist(), marker='o', s=20, c='blue')
plt.show()




