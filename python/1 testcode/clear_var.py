# -*- coding: utf-8 -*-
"""
Created on Thu Jan 11 00:22:24 2018

@author: ldz
"""
#==============================================================================
'''通过globals()获取全局变量然后将其中不需要的内容删除
例如下面的程序保留函数，类，模块，删除所有其它全局变量'''
#==============================================================================
def clear():

    for key, value in globals().items():

        if callable(value) or value.__class__.__name__ == "module":

            continue

        del globals()[key]

'''删除变量并释放内存'''        
import gc 
a=11
del a
gc.collect()