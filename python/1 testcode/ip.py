# encoding=utf8　
'''
# -*- coding: utf-8 -*-
'''
import sys 
import os
# reload(sys) # Python2.5 初始化后会删除 sys.setdefaultencoding 这个方法，我们需要重新载入 
# sys.setdefaultencoding('utf-8') 
import numpy as np 
# import caffe
import matplotlib.pyplot as plt 
import PIL
import skimage
from copy import deepcopy as dp 
import lmdb

# def main():
#     print 'imported several packages'