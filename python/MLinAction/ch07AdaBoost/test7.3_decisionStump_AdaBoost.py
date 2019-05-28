# -*- coding: utf-8 -*-
"""
Created on Fri Mar  2 10:32:52 2018

@author: ldz
"""
# =============================================================================
'''单层决策树decision stump'''
# =============================================================================
from numpy import ones,shape,mat,zeros,inf

def stumpClassify(dataMatrix,dimen,threshVal,threshIneq):
    '''弱分类器，大于或小于某个阈值则为1，否则为-1'''
    #just classify the data
    retArray = ones((shape(dataMatrix)[0],1))
    if threshIneq == 'lt':
        retArray[dataMatrix[:,dimen] <= threshVal] = -1.0
    else:
        retArray[dataMatrix[:,dimen] > threshVal] = -1.0
    return retArray
    
'''data'''
D = mat(ones((5,1))/5)
dataArr = mat([[ 1. ,  2.1],
        [ 1.5,  1.6],
        [ 1.3,  1. ],
        [ 1. ,  1. ],
        [ 2. ,  1. ]])
classLabels = [1.0, 1.0, -1.0, -1.0, 1.0]

'''build stump：生成一个弱分类器'''
#def buildStump(dataArr,classLabels,D):
dataMatrix = mat(dataArr); labelMat = mat(classLabels).T
m,n = shape(dataMatrix)
numSteps = 10.0; bestStump = {}; bestClasEst = mat(zeros((m,1)))
minError = inf #init error sum, to +infinity
for i in range(n):#loop over all dimensions
    rangeMin = dataMatrix[:,i].min(); rangeMax = dataMatrix[:,i].max();
    stepSize = (rangeMax-rangeMin)/numSteps
    for j in range(-1,int(numSteps)+1):#loop over all range in current dimension
        for inequal in ['lt', 'gt']: #go over less than and greater than
            threshVal = (rangeMin + float(j) * stepSize)
            predictedVals = stumpClassify(dataMatrix,i,threshVal,inequal)#call stump classify with i, j, lessThan
            errArr = mat(ones((m,1)))
            errArr[predictedVals == labelMat] = 0
            print("predictedVals",predictedVals.T,"errArr",errArr.T)
            weightedError = D.T*errArr  #calc total error multiplied by D
            print("split: dim %d, thresh %.2f, thresh ineqal: %s, the weighted error is %.3f" % (i, threshVal, inequal, weightedError))
            if weightedError < minError:
                '''选错误率最小的阈值及符号（大于或小于）'''
                minError = weightedError
                bestClasEst = predictedVals.copy()
                bestStump['dim'] = i
                bestStump['thresh'] = threshVal
                bestStump['ineq'] = inequal
print('\n')
print('bestStump=\n' + str(bestStump))
print('minError=\n' + str(minError))
print('bestClasEst=\n' + str(bestClasEst))


