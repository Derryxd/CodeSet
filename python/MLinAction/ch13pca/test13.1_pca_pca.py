# -*- coding: utf-8 -*-
"""
Created on Wed Apr  4 20:10:37 2018

@author: ldz
"""
# =============================================================================
'''pca'''
# =============================================================================
from numpy import loadtxt,cov,mean,linalg,mat,argsort

dataMat = loadtxt('testSet.txt')
topNfeat = 1
meanVals = mean(dataMat, axis=0)
meanRemoved = dataMat - meanVals #remove mean
covMat = cov(meanRemoved, rowvar=0)
eigVals,eigVects = linalg.eig(mat(covMat))
eigValInd = argsort(eigVals)            #sort, sort goes smallest to largest
eigValInd = eigValInd[:-(topNfeat+1):-1]  #cut off unwanted dimensions
redEigVects = eigVects[:,eigValInd]       #reorganize eig vects largest to smallest
lowDDataMat = meanRemoved * redEigVects#transform data into new dimensions
reconMat = (lowDDataMat * redEigVects.T) + meanVals

