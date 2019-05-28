# -*- coding: utf-8 -*-
from scipy.io import netcdf  as nc
from scipy.io.netcdf import NetCDFFile as Dataset
import sqlite3
import pdb
import os 
import numpy as np 
import matplotlib.pyplot as plt

driver="e"
db=driver+":\\python\\Tmp_Data_Base.db3"
conn = sqlite3.connect(db)
cur=conn.cursor() 
folder='Z:\\python_program\\file_zoo_00Z\\'

 
for row in cur.execute("select localfile,varname,beijing_time from  wrf_file_info where beijing_time=2014091111 and varname='temp2m' "):
    filename=folder+row[0]   #从数据库中提取文件名称
    print filename
   
    
    
    
    
    fex_id=os.path.isfile(filename) 
    if fex_id ==True :
        try:
            cdf=Dataset(filename,"r")
            tmp=cdf.variables["temp2m"][:]  #提取这个变量的所有值
            tmp_shape=tmp.shape
            dim_n=tmp_shape[0]
            x_n=tmp_shape[1]  #给出这个变量在X方向的长度
            y_n=tmp_shape[2]  #给出这个变量在Y方向的长度
            vdata=tmp[dim_n-1] #如果是一维的，那么给出的数字是1，但是起始的是0，要比自然数少1，所以这里减1。print tmp   
            print tmp_shape 
            pdb.set_trace() 
        except:
            print 'failure to get the data from var'



 
#v1=np.array(vdata)  #本身这就是个两维的数组，这个两维的数组变成1行的就可以直接reshape一下。
#v2=v1.reshape(1,x_n*y_n)

#x= np.linspace(0,10,1000)
#y=np.sin(x)
#z=np.cos(x)
#plt.figure(figsize=(8,4))
#plt.plot(x,y)
#plt.show()


#y1=v1[0,0:290]
#print 'y1===',y1
#x1=np.linspace(0,290,y1.size)
#print 'x1===',x1,x1.size
#plt.figure(figsize=(8,4))
#plt.plot(x1,y1)
#plt.show

#T2=v2[0:290]
#T3=v1[1,0:290]
#T4=v2[0+291:290+291]

#a=T1-T2
#b=T3-T4

#pdb.set_trace()

        
        
#cid=nc.netcdf_file(filename, 'r')
#var = cid.variables['temp2m'][:]  #这里给出的是一个字典形的数据。而且字典里面的变量必须显性表示，这下就麻烦了。
#var_name = cid.variables
       
       
       
       
       
       
       # -*- coding: utf-8 -*-
#from scipy.io import netcdf  as nc
#from scipy.io.netcdf import NetCDFFile as Dataset
#import sqlite3
#import pdb
#import os 
#import numpy as np 
#import matplotlib.pyplot as plt
#
## driver="j"
#db="/home/work/tmp_python/Tmp_Data_Base.db3"
#conn = sqlite3.connect(db)
#cur=conn.cursor() 
#folder="/home/work/tmp_python/file_nc/"
#
# 
#for row in cur.execute("select localfile,varname,beijing_time from  wrf_file_info where beijing_time=2014072023 and varname='temp2m' "):
#    filename=folder+row[0]   #从数据库中提取文件名称
#    print filename
#    fex_id=os.path.isfile(filename) 
#    if fex_id ==True :
#        try:
#            cdf=Dataset(filename,"r")
#            tmp=cdf.variables["temp2m"][:]  #提取这个变量的所有值
#            tmp_shape=tmp.shape
#            dim_n=tmp_shape[0]
#            x_n=tmp_shape[1]  #给出这个变量在X方向的长度
#            y_n=tmp_shape[2]  #给出这个变量在Y方向的长度
#            vdata=tmp[dim_n-1] #如果是一维的，那么给出的数字是1，但是起始的是0，要比自然数少1，所以这里减1。print tmp   
##             print vdata 
#        except:
#            print 'failure to get the data from var'
#            
#v1=np.array(vdata)  #本身这就是个两维的数组，这个两维的数组变成1行的就可以直接reshape一下。(219, 291)
#v2=v1.reshape(1,x_n*y_n)  #从一个2维的数组变为一个1维的数组,按照行的方式进行拼接的。
## x1=np.linspace(0,v2.size-1,v2.size)
## x1=np.linspace(0,63729-1,63729)
## plt.figure(figsize=(8,4))
## # plt.plot(x1,v2,color='red')
## # print x1.size   63729
## print v2.size, v2.shape
## print x1.size, x1.shape
#
## print 'dddd==',y_n
## ylint=y_n
## xlint=58 #219
## zlint1=ylint*(xlint-1)
## zlint2=ylint*xlint
## print zlint1,zlint2
## y1=v1[xlint,0:ylint]
## print 'y1===',y1.size
## y2=v2[0,zlint1:zlint2]  #this var have the same demision for 2, it is very curiously 
## print 'y2.size===',y2.size
## y3=y1-y2
## x1=np.linspace(0,xlint,y1.size)
## print 'x1===',x1.size
## plt.figure(figsize=(8,4))
## plt.plot(x1,y1,color='red')
## plt.plot(x1,y2,color='blue')
## plt.plot(x1,y3,color='black')
## plt.show()
#
#
#
