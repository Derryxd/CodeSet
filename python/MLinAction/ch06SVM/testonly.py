# -*- coding: utf-8 -*-
"""
Created on Tue Mar 27 16:56:27 2018

@author: ldz
"""

# =============================================================================
# #
# =============================================================================
from numpy import loadtxt,mat

#load data
filename = ''
txtdata = loadtxt(filename)
a = mat(txtdata)

#hyperparameter
C #惩罚项系数
toler #容错率
maxIter #迭代次数

#train: SMO(一次更新一对参数)
判断哪些是向量机
随机选择两个alpha（0~C）
f(Xi) = sum(alphs*y*(w*x)+b)
Error(i) = f(Xi)-y. 




#test


#print and plot

