# -*- coding: utf-8 -*-
"""
Created on Wed Jan 17 17:13:19 2018

@author: ldz
"""
#from numpy import *
from numpy import zeros
#==============================================================================
'''read the txt to matric'''
#==============================================================================
filename = 'datingTestSet2.txt'
fid = open(filename)
'''readlines：返回格式为list，将文件一行内容存放到一个字符串变量中'''
listData = fid.readlines()  
num = len(listData)         
arrayData = zeros((num,3))   
classLabelVector = []
index = 0
for line in listData:
    '''strip:把这个字符串头和尾的空格，以及位于头尾的\n \t之类给删掉'''
    line = line.strip()
    '''split：以间隔符(如tab键)将str变为若干list'''
    listFromLine = line.split('\t') 
    arrayData[index,:] = listFromLine[0:3]
    classLabelVector.append(int(listFromLine[-1]))  #-1指最后的值
    index += 1
    
