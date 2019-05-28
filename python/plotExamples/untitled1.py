# -*- coding: utf-8 -*-
"""
Created on Sun Sep  9 13:38:03 2018

@author: ldz
"""
from skimage import io,data,data_dir,color,transform,exposure
from skimage import filters,feature,draw,morphology
from skimage.morphology import disk
from skimage.filters import rank
import skimage.morphology as sm
import matplotlib.pyplot as plt
from copy import deepcopy
import numpy as np
import skimage as ski
image_rgb = data.coffee()[0:220, 160:420] #裁剪原图像，不然速度非常慢
image_gray = color.rgb2gray(image_rgb)
edges = feature.canny(image_gray, sigma=2.0, low_threshold=0.55, high_threshold=0.8)
#执行椭圆变换
result =transform.hough_ellipse(edges, accuracy=20, threshold=250,min_size=100, max_size=120)
result.sort(order='accumulator') #根据累加器排序
#估计椭圆参数
best = list(result[-1])  #排完序后取最后一个
yc, xc, a, b = [int(round(x)) for x in best[1:5]]
orientation = best[5]
#在原图上画出椭圆
cy, cx =draw.ellipse_perimeter(yc, xc, a, b, orientation)
image_rgb[cy, cx] = (0, 0, 255) #在原图中用蓝色表示检测出的椭圆
#分别用白色表示canny边缘，用红色表示检测出的椭圆，进行对比
edges = color.gray2rgb(edges)
edges[cy, cx] = (250, 0, 0) 
fig2, (ax1, ax2) = plt.subplots(ncols=2, nrows=1, figsize=(8, 4))
ax1.set_title('Original picture')
ax1.imshow(image_rgb)
ax2.set_title('Edge (white) and result (red)')
ax2.imshow(edges)
plt.show()