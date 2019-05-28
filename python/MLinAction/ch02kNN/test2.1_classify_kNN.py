# -*- coding: utf-8 -*-
"""
Created on Tue Jan 16 16:47:01 2018

@author: ldz
"""

#from numpy import *
from numpy import array,tile
import operator
#from os import listdir
#==============================================================================
'''data set'''
#==============================================================================
data = array([[1.0,1.1],[1.0,1.0],[0,0],[0,0.1]])
labels = ['A','A','B','B']
dIn = array([0,0]  )  #array区别于matrix
#==============================================================================
'''calculate distance'''
#==============================================================================
dSize = data.shape[0]               #数组维数，属于ndarray的操作
diff = tile(dIn, (dSize,1)) - data  #相当于repmat(matlab)、conform_dims(ncl)
sqDiff = diff**2                    #数组相乘为元素对应相乘（区别于dot）
sqDist = sqDiff.sum(axis=1)         #求列的和，属于ndarray的操作
dist = sqDist**0.5
#==============================================================================
'''pick the k_th shortest points'''
#==============================================================================
indSort = dist.argsort() #排序后的原序列索引，属于ndarray的操作
classCount = {}          #字典：{'key1':value1,'key2':value2,...}
k = 3                    #取前k个点 
for i in range(k):
    voteIlabel = labels[indSort[i]]
    #以下为统计对应标签的个数：get为取key的value，即classC的key中有label，
    #则对应value继续加一，没有则默认value为0并加一
    classCount[voteIlabel] = classCount.get(voteIlabel,0)+1
#==============================================================================
'''sort the dict(classCount)'''   
#==============================================================================
sortDict = sorted(classCount.items(),key=operator.itemgetter(1),\
                  reverse=True)      
#items属于dict（字典）的操作，取键值对[('key1',value1),('key2',value2),...]
#operator模块提供的itemgetter函数用于获取对象的哪些维的数据，参数为一些序号
#对value从大到小排序
print('the most possible label of dIn is: ' + sortDict[0][0])
             
             
             
 

