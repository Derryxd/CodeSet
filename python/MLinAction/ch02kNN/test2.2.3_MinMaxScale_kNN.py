# -*- coding: utf-8 -*-
"""
Created on Thu Jan 18 21:12:59 2018

@author: ldz
"""
# =============================================================================
'''normalization--MinMaxScaler'''
# =============================================================================
''' newVal=(oldVal-min)/(max-min)'''
minVal = arrayData.min(0)
maxVal = arrayData.max(0)
ranges = maxVal - minVal
normData = zeros(shape(arrayData))
m = arrayData.shape[0]
normData = arrayData - tile(minVal, (m,1))
normData = arrayData/tile(ranges, (m,1))

'''可用sklearn实现该功能：
from sklearn import preprocessing
import numpy as np
X_train = np.array([[ 1., -1.,  2.],
...                     [ 2.,  0.,  0.],
...                     [ 0.,  1., -1.]])
min_max_scaler = preprocessing.MinMaxScaler()
X_train_minmax = min_max_scaler.fit_transform(X_train)
 X_train_minmax
array([[ 0.5       ,  0.        ,  1.        ],
       [ 1.        ,  0.5       ,  0.33333333],
       [ 0.        ,  1.        ,  0.        ]])
'''