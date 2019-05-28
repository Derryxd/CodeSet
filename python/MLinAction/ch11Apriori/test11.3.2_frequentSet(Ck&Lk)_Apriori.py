# -*- coding: utf-8 -*-
"""
Created on Fri Apr  6 22:56:04 2018

@author: ldz
"""
# =============================================================================
'''生成频繁项集Ck&Lk'''
# =============================================================================
from apriori import scanD,createC1,loadDataSet

def aprioriGen(Lk, k): #creates Ck
    retList = []
    lenLk = len(Lk)
    for i in range(lenLk):
        for j in range(i+1, lenLk): 
            L1 = list(Lk[i])[:k-2]; L2 = list(Lk[j])[:k-2]
            L1.sort(); L2.sort()
            if L1==L2: #if first k-2 elements are equal
                retList.append(Lk[i] | Lk[j]) #set union
    return retList

dataSet = loadDataSet()
minSupport = 0.5
'''def apriori(dataSet, minSupport = 0.5):'''
C1 = createC1(dataSet)
D = list(map(set, dataSet))
L1, supportData = scanD(D, C1, minSupport)
L = [L1]
k = 2
while (len(L[k-2]) > 0):
    Ck = aprioriGen(L[k-2], k)
    Lk, supK = scanD(D, Ck, minSupport)#scan DB to get Lk
    supportData.update(supK)
    L.append(Lk)
    k += 1
#return L, supportData