# -*- coding: utf-8 -*-
"""
Created on Fri Apr  6 15:32:10 2018

@author: ldz
"""

import apriori
dataSet = apriori.loadDataSet()
C1 = apriori.createC1(dataSet)
D=list(map(set,dataSet))