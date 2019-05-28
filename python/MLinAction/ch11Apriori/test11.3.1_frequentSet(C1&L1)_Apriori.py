# -*- coding: utf-8 -*-
"""
Created on Fri Apr  6 13:55:57 2018

@author: ldz
"""
# =============================================================================
'''生成频繁项集C1&L1'''
# =============================================================================
from numpy import mat

dataSet = [[1, 3, 4], [2, 3, 5], [1, 2, 3, 5], [2, 5]]
'''def createC1(dataSet):'''
C1 = []
for transaction in dataSet:
    for item in transaction:
        if not [item] in C1:
            C1.append([item])
C1.sort()
Ck = list(map(frozenset, C1))#use frozen set so we
#                            #can use it as a key in a dict
#    return C1

minSupport=0.5
D = list(map(set,dataSet))
'''def scanD(D, Ck, minSupport):'''
ssCnt = {}
for tid in D:
    for can in Ck:
        if can.issubset(tid):
            if not can in ssCnt: ssCnt[can]=1
#            if not ssCnt.has_key(can): ssCnt[can]=1
            else: ssCnt[can] += 1
numItems = float(len(D))
retList = []
supportData = {}
for key in ssCnt:
    support = ssCnt[key]/numItems
    if support >= minSupport:
        retList.insert(0,key)
    supportData[key] = support
#return retList, supportData





