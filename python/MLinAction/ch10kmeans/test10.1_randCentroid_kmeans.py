# -*- coding: utf-8 -*-
"""
Created on Tue Apr  3 20:58:59 2018

@author: ldz
"""
# =============================================================================
'''rand centroid'''
# =============================================================================
from numpy import mat,zeros,sqrt,power,shape,inf,mean,nonzero,random
#from kMeans import loadDataSet

def distEclud(vecA, vecB):
    return sqrt((power(vecA - vecB, 2)).sum(axis=1)) #la.norm(vecA-vecB)

def randCent(dataSet, k):
    n = shape(dataSet)[1]
    centroids = mat(zeros((k,n)))#create centroid mat
    for j in range(n):#create random cluster centers, within bounds of each dimension
        minJ = min(dataSet[:,j]) 
        rangeJ = float(max(dataSet[:,j]) - minJ)
        centroids[:,j] = mat(minJ + rangeJ * random.rand(k,1))
    return centroids
    
fileName = 'testSet.txt'
num = len(open(fileName).readline().split('\t'))
dataMat = []
fr = open(fileName)
for line in fr.readlines():
    lineArr =[]
    curLine = line.strip().split('\t')
    for i in range(num):
        lineArr.append(float(curLine[i]))
    dataMat.append(lineArr)

k=4 
dataSet = mat(dataMat)
m = shape(dataSet)[0]
clusterAssment = mat(zeros((m,2)))#create mat to assign data points 
                                  #to a centroid, also holds SE of each point
centroids = randCent(dataSet, k)
clusterChanged = True
while clusterChanged:
    clusterChanged = False
    for i in range(m):#for each data point assign it to the closest centroid
        minDist = inf; minIndex = -1
        for j in range(k):
            distJI = distEclud(centroids[j,:],dataSet[i,:])
            if distJI < minDist:
                minDist = distJI; minIndex = j
        if clusterAssment[i,0] != minIndex: clusterChanged = True
        clusterAssment[i,:] = minIndex,minDist**2
    print(centroids)
    for cent in range(k):#recalculate centroids
        ptsInClust = dataSet[nonzero(clusterAssment[:,0].A==cent)[0]]#get all the point in this cluster
        centroids[cent,:] = mean(ptsInClust, axis=0) #assign centroid to mean 
