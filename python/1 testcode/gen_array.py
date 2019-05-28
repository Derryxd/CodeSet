# -*- coding: utf-8 -*-
"""
Created on Tue Jan  9 22:32:52 2018

@author: ldz
"""

#fisrt
a=[]
i=0
while i<=77:
    a.append(i)
    i += 1
    
#second:range类似切片
b=[]
bb=[]
'''python3中，range()并不会直接产生结果，当调用时才产生具体的值'''
for i in range(10,78):
    b.append(i)
for i in range(0,10,2):
    bb.append(i)    
    
#third
c = [11 for i in range(1,18)]
d = [i for i in range(1,18)]
dd = [i for i in range(1,18) if i%2==0]
e = [ i for i in range(3) for j in range(2)]
ee = [ (i,j) for i in range(3) for j in range(2)]
