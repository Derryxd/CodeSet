# -*- coding: utf-8 -*-
"""
Created on Mon Jan 15 13:04:50 2018

@author: ldz
"""


aa=[1,2,3]
bb=[4,5,6]
cc=[aa[i]+bb[i] for i in range(min(len(aa),len(bb)))]
print(cc)

import numpy
a = [1, 2, 3, 4]
b = [5, 6, 7, 8]
a_array = numpy.array(a)
b_array = numpy.array(b)
c_array = a_array + b_array
d_array = a_array - b_array
print(c_array)
print(d_array)