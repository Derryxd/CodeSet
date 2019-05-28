# -*- coding: utf-8 -*-
"""
Created on Sat Jan  6 00:03:43 2018

@author: ldz
"""

a = 4 
b = 5

#交换方法一
c = 0
c = a
a = b
b = c

#交换方法二
a = a+b
b = a-b
a = a-b

#交换方法三
a,b = b,a 