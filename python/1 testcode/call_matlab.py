# -*- coding: utf-8 -*-
"""
Created on Wed Nov  8 22:05:04 2017

@author: ldz
"""

import matlab.engine
eng = matlab.engine.start_matlab()
y = eng.myLS(matlab.double([[1.],[2.]]),matlab.double([[3.],[4.]]))
print(y)