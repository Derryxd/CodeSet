# -*- coding: utf-8 -*-
"""
Created on Wed Jan 17 21:51:27 2018

@author: ldz
"""
#==============================================================================
'''scatter plot'''
#==============================================================================
from numpy import *
import matplotlib
import matplotlib.pyplot as plt

n = size(arrayData,1)
#n=1
colors = [20,30,50]
markers = ['red','green','blue']
legends = ["Did Not Like", "Liked in Small Doses", "Liked in Large Doses"]
handles = []
fig = plt.figure()
ax = fig.add_subplot(111)
for i in range(n):
	xcord = []; ycord = []
   #也可以用np.where(array(classLabelVector) == i+1)
   #np.where(condition,do_if_true,else_for_false)
	ind = (array(classLabelVector) == i+1)
	xcord = arrayData[ind,1]
	ycord = arrayData[ind,2]
	#ax.scatter(xcord,ycord, c=colors, s=markers)    
	type_scatter = ax.scatter(xcord, ycord, s=colors[i],\
                           c=markers[i], label=legends[i])
	handles.append(type_scatter)
	print(type_scatter)
ax.legend(handles, legends, loc='upper right')
ax.axis([-2,25,-0.2,2.0])
plt.xlabel('Percentage of Time Spent Playing Video Games')
plt.ylabel('Liters of Ice Cream Consumed Per Week')
plt.show()        
'''
fig = plt.figure()
ax = fig.add_subplot(111)
#ax.scatter(arrayData[:,1], arrayData[:,2])
ax.scatter(arrayData[:,1], arrayData[:,2], \
           15.0*array(classLabelVector), 15.0*array(classLabelVector))
ax.axis([-2,25,-0.2,2.0])
plt.xlabel('Percentage of Time Spent Playing Video Games')
plt.ylabel('Liters of Ice Cream Consumed Per Week')
plt.show()
'''


