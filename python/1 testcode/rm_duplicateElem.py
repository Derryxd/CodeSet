# -*- coding: utf-8 -*-
"""
Created on Tue Jan  9 23:07:14 2018

@author: ldz
"""

#fisrt
a = [1,2,3,1,2,3]
b=[]
for i in a:
    if i not in b:
        b.append(i)

#second
f = set(a)
c = list(f)