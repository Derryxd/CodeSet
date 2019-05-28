# -*- coding: utf-8 -*-
"""
Created on Thu Jan 18 21:40:37 2018

@author: ldz
"""
# =============================================================================
'''judge specific person'''
# =============================================================================
from kNN import file2matrix,autoNorm,classify0
resultList = ['not at all','in small doses','in large doses']
percentTats = float(raw_input(\
              "percentage of time spent playing video games:"))
ffMiles = float(raw_input(\
              "frequent flier miles earned per year:"))
iceCream = float(raw_input(\
              "liters of ice cream consumed per year:"))
datingDataMat,datingLabels = file2matrix('datingTestSet2.txt')       #load data setfrom file
normMat, ranges, minVals = autoNorm(datingDataMat)
inArr = array([ffMiles,percentTats,iceCream])
k=3  #k_th min for classification
classifierReasult = classify0((inArr-minVals)/ranges, \
                              normMat, datingLabels, k)
print( "You will probably like this person:",\
      resultList[classifierReasult-1])
'''
raw_input更符合用户输入的习惯，把任何用户输入都转换成字符串存储，在需要其它类型的数据时，调用相应的函数进行转换

input用户输入什么就存储什么，所以用户输入必须符合python语法要求，否则会出错
'''