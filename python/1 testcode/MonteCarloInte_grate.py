# -*- coding: utf-8 -*-
"""
Created on Thu Mar 15 22:27:52 2018

@author: ldz
"""
# =============================================================================
'''MonteCarloIntegrate'''
# =============================================================================
'''e^x在[-1,1]之间的积分，使用正态分布抽样'''
# \int^{1}_{-1}e^x dx= \int^{1}_{-1}\frac{e^x}{\frac{1}{\sqrt{2\pi}}e^{-\frac{x^2}{2}}}*\frac{1}{\sqrt{2\pi}}e^{-\frac{x^2}{2}}dx\approx\frac{\sqrt{2\pi}}{N}\sum_{i=1}^{N}e^{x_i+\frac{x_i^2}{2}}
# E[X]=E[g(Y)],Y为正态分布抽样
import random
import numpy as np
import math

N = 10000
sum = 0
for i in range(N):
        rg = random.gauss(0,1)
        if rg > 1 or rg < -1:
                continue
        sum += np.exp(rg + 0.5 * (rg**2))

sum *= math.sqrt(2 * math.pi)
sum /= N

print(sum)