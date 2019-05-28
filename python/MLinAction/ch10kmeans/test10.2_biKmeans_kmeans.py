# -*- coding: utf-8 -*-
"""
Created on Tue Apr  3 22:50:50 2018

@author: ldz
"""
# =============================================================================
'''biKmeans'''
# =============================================================================
from numpy import mat,zeros,shape,inf,mean,nonzero
from kMeans import kMeans,distEclud
import matplotlib.pyplot as plt

fileName = 'testSet2.txt'
num = len(open(fileName).readline().split('\t'))
dataMat = []
fr = open(fileName)
for line in fr.readlines():
    lineArr =[]
    curLine = line.strip().split('\t')
    for i in range(num):
        lineArr.append(float(curLine[i]))
    dataMat.append(lineArr)

dataSet = mat(dataMat)
k = 3
m = shape(dataSet)[0]
clusterAssment = mat(zeros((m,2)))
centroid0 = mean(dataSet, axis=0).tolist()[0]
centList =[centroid0] #create a list with one centroid
for j in range(m):#calc initial Error
    clusterAssment[j,1] = distEclud(mat(centroid0), dataSet[j,:])**2
while (len(centList) < k):
    lowestSSE = inf
    for i in range(len(centList)):
        ptsInCurrCluster = dataSet[nonzero(clusterAssment[:,0].A==i)[0],:]#get the data points currently in cluster i
        centroidMat, splitClustAss = kMeans(ptsInCurrCluster, 2, distEclud)
        sseSplit = sum(splitClustAss[:,1])#compare the SSE to the currrent minimum
        sseNotSplit = sum(clusterAssment[nonzero(clusterAssment[:,0].A!=i)[0],1])
        print("sseSplit, and notSplit: ",sseSplit,sseNotSplit)
        if (sseSplit + sseNotSplit) < lowestSSE:
            bestCentToSplit = i
            bestNewCents = centroidMat
            bestClustAss = splitClustAss.copy()
            lowestSSE = sseSplit + sseNotSplit
    bestClustAss[nonzero(bestClustAss[:,0].A == 1)[0],0] = len(centList) #change 1 to 3,4, or whatever
    bestClustAss[nonzero(bestClustAss[:,0].A == 0)[0],0] = bestCentToSplit
    print( 'the bestCentToSplit is: ',bestCentToSplit)
    print ('the len of bestClustAss is: ', len(bestClustAss))
    centList[bestCentToSplit] = bestNewCents[0,:].tolist()[0]#replace a centroid with two best centroids 
    centList.append(bestNewCents[1,:].tolist()[0])
    clusterAssment[nonzero(clusterAssment[:,0].A == bestCentToSplit)[0],:]= bestClustAss#reassign new clusters, and SSE
centList = mat(centList)
    
fig = plt.figure()
rect=[0.1,0.1,0.8,0.8]
scatterMarkers=['s', 'o', '^', '8', 'p', \
                'd', 'v', 'h', '>', '<']
axprops = dict(xticks=[], yticks=[])
ax0=fig.add_axes(rect, label='ax0', **axprops)
imgP = plt.imread('Portland.png')
ax0.imshow(imgP)
ax1=fig.add_axes(rect, label='ax1', frameon=False)
for i in range(k):
    ptsInCurrCluster = dataSet[nonzero(clusterAssment[:,0].A==i)[0],:]
    markerStyle = scatterMarkers[i % len(scatterMarkers)]
    ax1.scatter(ptsInCurrCluster[:,0].flatten().A[0], ptsInCurrCluster[:,1].flatten().A[0], marker=markerStyle, s=90)
ax1.scatter(centList[:,0].flatten().A[0], centList[:,1].flatten().A[0], marker='+', s=300)
plt.show()

