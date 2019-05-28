# -*- coding: utf-8 -*-
"""
Created on Tue Aug  7 18:11:59 2018
@author: lixy
This script is used to read wind tower data and WRF_out data, and calculate
the mean_diff, RMSE, relation 
画时间序列和玫瑰图
"""

# -*- coding: utf-8 -*-


import pandas as pd
import numpy as np 
import matplotlib.pyplot as plt
import os,glob
from windrose import WindroseAxes 
from windrose import WindAxes 
from datetime import datetime,timedelta
from dateutil.relativedelta import relativedelta
from windrose import wrpdf
#from pylab import *  # 支持中文
#mpl.rcParams['font.sans-serif'] = ['SimHei']



def readMerge(diri, file):
    ''' read CFT file '''
    f=open(diri+'\\'+file)
    content=pd.read_csv(f,header=0)
    content['time']=pd.to_datetime(content['time'],format="%Y-%m-%d %H:%M:%S")
    content.index=content['time']
    height=content.columns[1][3:6]
    del content['time']
    f.close()
    return content,height

def plot_month_timeseries(ws_CFT,ws_WRF,diro,file_Merge,start_month):
    '''画月变化'''
    ws_WRF.values[ws_WRF.values==0]=np.nan
    ws_WRF=ws_WRF.dropna()    
    ws_WRF.values[ws_WRF.values==0]=np.nan
    ws_WRF=ws_WRF.dropna() 
    ws_month_WRF=ws_WRF.resample('M').mean()    
    ws_month_WRF=ws_month_WRF.groupby(ws_month_WRF.index.month).agg('mean')
    ws_month_CFT=ws_CFT.resample('M').mean()    
    ws_month_CFT=ws_month_CFT.groupby(ws_month_CFT.index.month).agg('mean')    
    plt.plot(ws_month_WRF,marker='',label="WRF")    
    plt.plot(ws_month_CFT,marker='',label="CFT")        
    plt.title(file_WRF[0:-5]+'_'+ws_WRF.name[3:6]+'月变化')
    plt.legend()
    plt.savefig(diro+'\\'+file_WRF[6:10]+'_'+ws_WRF.name[3:-1]+'Month_timeseries.png')
    plt.show()      



def set_legend(ax): 
    l = ax.legend(shadow=True, bbox_to_anchor=[-0.1, 0], loc='lower left') 
    plt.setp(l.get_texts(), fontsize=10) 

def plot_windrose(ws,wd,diro,file_Merge):
    '''画风向玫瑰图'''
    ####wind frequence rose################################################
    numbins = [0, 5, 10, 15, 20, 25]
    ax = WindroseAxes.from_ax(fig = plt.figure(figsize=(5,5)))
    ax.set_title(file_Merge[6:10]+'_'+ws.name[3:]+'风向')
    ax.bar(wd, ws, bins=numbins, normed=True,nsector=16,opening=0.8, edgecolor='white') 
    set_legend(ax) 
    plt.savefig(diro+'\\'+file_Merge[6:10]+'_'+ws.name[3:]+'Windrose.png')
    plt.show()    

def plot_wind_rose_we_mb(ws,wd,diro,file_Merge,density):
    """做风能玫瑰图"""
    density = density
    we = ws**3*density*0.5
    ax = WindroseAxes.from_ax(fig = plt.figure(figsize=(5,5)))
    numbins = [0, 200, 400, 600, 800, 1000]
    ax.bar(wd, we, bins=numbins, normed=True, \
           opening=0.8, edgecolor='white', we='windenergy')
    ax.set_legend()
    ax.set_title(file_Merge[6:10]+'_'+ws.name[3:]+'风能')
    plt.savefig(diro+'\\'+file_Merge[6:10]+'_'+ws.name[3:]+'Windenergy.png',bbox_inches='tight',dpi=96)

def plot_weibull(ws,diro,file_Merge):
    '''画weibull分布图''' 
    ws.values[ws.values==0]=np.nan
    ws=ws.dropna()
    binn = np.arange(0.0, 30.0, 1)
    ax2, params = wrpdf(ws, bins=binn, Nx=100, bar_color='darkgreen', \
                        plot_color='royalblue', Nbins=26, \
                        ax = WindAxes.from_ax(fig = plt.figure(figsize=(6,4))))
    ax2.text(15, 0.1,"A = %.2f, K = %.2f" % (params[3],params[1]),fontsize=12)
    ax2.set_title(file_Merge[6:10]+'_'+ws.name[3:])
    plt.savefig(diro+'\\'+file_Merge[6:10]+'_'+ws.name[3:]+'Weibull.png',bbox_inches='tight',dpi=96)
    plt.show()
    
def plot_timeseries_ws(ws_CFT,ws_WRF,diro,file_Merge):
    '''画风速时间序列'''
    fig = plt.figure(figsize=(25,6)); ax1 = fig.add_subplot(1, 1, 1)
    ax1.plot(ws_CFT.index,ws_CFT,marker='',label="CFT")
    ax1.plot(ws_WRF.index,ws_WRF,marker='',label="WRF")
    plt.title(file_Merge[6:10]+'_'+'ws')
    ax1.legend(loc='best')
    plt.ylim(0,20)
    plt.savefig(diro+'\\'+file_Merge[6:10]+'ws_time_series.png', dpi=600, \
                bbox_inches='tight')
    plt.show()
    
def plot_timeseries_wd(wd_CFT,wd_WRF,diro,file_Merge):
    '''画风向时间序列'''
    fig = plt.figure(figsize=(25,6)); ax1 = fig.add_subplot(1, 1, 1)
    ax1.plot(wd_CFT.index,wd_CFT,marker='',label="CFT")
    ax1.plot(wd_WRF.index,wd_WRF,marker='',label="WRF")
    plt.title(file_Merge[6:10]+'_'+'wd')
    ax1.legend(loc='best')
    plt.ylim(0,360)
    plt.savefig(diro+'\\'+file_Merge[6:10]+'wd_time_series.png', dpi=600, \
            bbox_inches='tight')
    plt.show()
        
#def plotDistribute(df_M,diro,file_Merge):
#    '''画频率分布图'''
#    hist_CFT, bins = np.histogram(df_M['ws_'+height+'_CFT'],30,[0,30])
#    hist_WRF, bins = np.histogram(df_M['ws_'+height+'_WRF'],30,[0,30])
#    hist_CFT=hist_CFT/len(df_M['ws_'+height+'_CFT'])
#    hist_WRF=hist_WRF/len(df_M['ws_'+height+'_WRF'])
#    hist_diff=hist_WRF-hist_CFT
#    bins_value=np.arange(0.5,30.5,1)
#    plt.bar(bins_value,hist_CFT,0.4,color="blue")
#    plt.xlabel('Value')
#    plt.ylabel('Frequency')
#    plt.xticks(np.arange(0,31,2))
#    plt.yticks(np.arange(0,0.161,0.02)) 
#    plt.title(file_Merge[6:10]+'CFT')
#    plt.savefig(diro+'\\'+file_Merge[6:10]+'CFT_hist_frequency.png', dpi=600, \
#                bbox_inches='tight')    
#    plt.show()
#    
#    plt.bar(bins_value,hist_WRF,0.4,color="orange")
#    plt.xlabel('Value')
#    plt.ylabel('Frequency')  
#    plt.xticks(np.arange(0,31,2))
#    plt.yticks(np.arange(0,0.161,0.02))
#    plt.title(file_Merge[6:10]+'WRF')
#    plt.savefig(diro+'\\'+file_Merge[6:10]+'WRF_hist_frequency.png', dpi=600, \
#                bbox_inches='tight') 
#    plt.show()
#    '''画频率差值分布图'''
#    plt.bar(bins_value,hist_diff,0.4,color="green")
#    plt.xlabel('Value')
#    plt.ylabel('Frequency')
#    plt.xticks(np.arange(0,31,2))
##    plt.yticks(np.arange(0,0.161,0.02))    
#    plt.title(file_Merge[6:10]+'WRF-CFT')
#    plt.savefig(diro+'\\'+file_Merge[6:10]+'diff_hist_frequency.png', dpi=600, \
#                bbox_inches='tight') 
#    plt.show()
#    '''画频率差值*风速bin值分布图'''
#    plt.bar(bins_value,hist_diff*bins_value,0.4,color="green")
#    plt.xlabel('Value')
#    plt.ylabel('Frequency x bins')  
#    plt.xticks(np.arange(0,31,2))
##    plt.yticks(np.arange(0,0.161,0.02))    
#    plt.title(file_Merge[6:10]+'WRF-CFT')
#    plt.savefig(diro+'\\'+file_Merge[6:10]+'diffxbins_hist_frequency.png', dpi=600, \
#                bbox_inches='tight') 
#    plt.show()    
#    
#    


if __name__ == '__main__':
    diri=r"F:\\2 GOLDWRF项目\\3 河北怀来WRF项目\\4 优化与发电量结果\\2 WRFout+WT\\数据\\合成结果"
    diro=r"F:\\2 GOLDWRF项目\\3 河北怀来WRF项目\\4 优化与发电量结果\\2 WRFout+WT\\2 画图"
    os.chdir(diri)
    file_Merge= glob.glob('Merge_1690#_WRF_90m.csv')

    for i in range(len(file_Merge)):
        f=open(diri+'\\'+file_Merge[i])           
        df_M,height=readMerge(diri,file_Merge[i])   
        start_time=datetime(2009,10,31)
        end_time=datetime(2010,10,31)
        start_month=datetime(2009,11,1)
        df_M=df_M[start_time:end_time]
        '''画CFT图'''
        ws_CFT=df_M['ws_'+height+'_CFT']
        wd_CFT=df_M['wd_'+height+'_CFT']
        density=1.175
        draw=plot_windrose(ws_CFT,wd_CFT,diro,file_Merge[i])#风向玫瑰图
        draw=plot_wind_rose_we_mb(ws_CFT,wd_CFT,diro,file_Merge[i],density)#风能玫瑰图
        draw=plot_weibull(ws_CFT,diro,file_Merge[i])#观测weibull分布
        '''画WRF图'''
        ws_WRF=df_M['ws_'+height+'_WRF']
        wd_WRF=df_M['wd_'+height+'_WRF']
        draw=plot_windrose(ws_WRF,wd_WRF,diro,file_Merge[i])#风向玫瑰图
        draw=plot_wind_rose_we_mb(ws_WRF,wd_WRF,diro,file_Merge[i],density)#风能玫瑰图
        draw=plot_weibull(ws_WRF,diro,file_Merge[i])#观测weibull分布       
        '''画WRF和CFT图'''
        ws_WRF_month=ws_WRF['2010-3']
        ws_CFT_month=ws_CFT['2010-3']
        wd_WRF_month=wd_WRF['2010-3']
        wd_CFT_month=wd_CFT['2010-3']        
        draw=plot_month_timeseries(ws_CFT,ws_WRF,diro,file_Merge[i],start_month)#月变化时间序列
        draw=plot_timeseries_ws(ws_CFT_month,ws_WRF_month,diro,file_Merge[i])#某月风速时间序列
        draw=plot_timeseries_wd(wd_CFT_month,wd_WRF_month,diro,file_Merge[i])#某月风向时间序列
#
#        
    
  







