# -*- coding: utf-8 -*-
"""
Created on Thu Jan 18 21:20:35 2018

@author: ldz
"""
# =============================================================================
'''testDatingClassifier'''
# =============================================================================
from kNN import file2matrix,autoNorm,classify0
hoRatio = 0.10      #hold out 10%
k = 3
datingDataMat,datingLabels = file2matrix('datingTestSet2.txt')       #load data setfrom file
normMat, ranges, minVals = autoNorm(datingDataMat)
m = normMat.shape[0]
numTestVecs = int(m*hoRatio)
errorCount = 0.0
for i in range(numTestVecs):
    classifierResult = classify0(normMat[i,:],normMat[numTestVecs:m,:],datingLabels[numTestVecs:m],k)
    print "the classifier came back with: %d, the real answer is: %d" % (classifierResult, datingLabels[i])
    if (classifierResult != datingLabels[i]): errorCount += 1.0
print( "the total error rate is: %f" % (errorCount/float(numTestVecs)) )
print( "number of error:" + str(errorCount) )
print( "number of test:" + str(numTestVecs) )