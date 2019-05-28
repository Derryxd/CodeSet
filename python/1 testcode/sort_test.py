# -*- coding: utf-8 -*-
"""
Created on Fri Jan  5 23:04:58 2018

@author: ldz
"""

a = [{'age':20,'name':'a'},{'age':17,'name':'b'},{'age':22,'name':'c'}]
a.sort(key = lambda x:x['age'])
print(a)
