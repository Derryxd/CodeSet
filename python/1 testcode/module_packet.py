# -*- coding: utf-8 -*-
"""
Created on Tue Jan  9 17:09:30 2018

@author: ldz
"""

#==============================================================================
'''模块module：py脚本  &&  包Packet：文件夹(包括__init__.py) '''
#==============================================================================
'''__pycache__：字节码''' 

''' 两种__init__设置: '''
'''第一种：__all__:只有all里面的东西才能被引用，并直接用''' 
from test import *
sendmsg.testS()
'''第二种：from . import xxx：__all__和xxx都能被引用，但用类的形式'''
import test
test.recvmsg.testR()

''' 
    #一般用法（当前路径、系统路径）
import xxx
from xxx import yyy,zzz
from xxx import *
import xxx as yyy
    #进阶用法（指定路径）
import sys
sys.path.append('xxx/...')
import yyy
'''

'''只有test1才能被import，其他的变量、类都不能被引用'''
__all__ = ["test1","Test"] 
 
def test1():
    print("111")

def test2():
    print('222')

class Test(object):
    pass

num = 100   #不能被引用

'''
#运行该脚本，输出"__main__"，被引用，则输出引用脚本的名字    
print(__name__)
'''

'''被import时，脚本会执行一遍，故需额外设置避免多余运行'''
if __name__ == "__main__":
    test1()
    test2()
  
