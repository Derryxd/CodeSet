# -*- coding: utf-8 -*-
"""
Created on Tue Jan  9 22:27:58 2018

@author: ldz
"""

#==============================================================================
'''显示脚本名字，程序传参组合为列表'''
#==============================================================================
import sys
print(sys.argv) 

name = sys.argv[0] #第0个是脚本名字
print("热烈欢迎%s的到来"%name)

#==============================================================================
'''缺省参数：例子中的c''' 
#==============================================================================
def test(a,b,c=100,*args):
    print(a)
    print(c) 
    '''out---->c=101'''
    print(args)
test(20,11,101,1001)

#==============================================================================
'''
argv、kwargs的使用:
*arg表示任意多个无名参数，类型为tuple(元组)，
**kwargs表示关键字参数，为dict(字典)   
'''
#==============================================================================
def fun_var_args(a,farg, *args):  
    print("farg:", farg) 
    ''' *args可以当作可容纳多个变量组成的tuple'''
    print(args)
    for value in args:  
        print("another arg:", value) 
fun_var_args(1,"two",3) 

def fun_var_kwargs(farg, **kwargs):  
    print("farg:", farg)
    '''myarg2和myarg3被视为key， 感觉**kwargs可以当作容纳多个key和value的dictionary'''
    print(kwargs)
    for key in kwargs:  
        print("another keyword kwarg: %s: %s"%(key, kwargs[key]) )
fun_var_kwargs(farg=1, myarg2="two", myarg3=3)  

#==============================================================================
'''实参形式'''
#==============================================================================
def fun_var_args_call(arg1, arg2, arg3):  
    print( "arg1:", arg1 ) 
    print( "arg2:", arg2 ) 
    print( "arg3:", arg3 ) 
args = ["two", 3] #list  
#args = ("two", 3) #or :tuple 
fun_var_args_call(1, *args)  


def fun_var_args_call(arg1, arg2, arg3):  
    print( "arg1:", arg1 ) 
    print( "arg2:", arg2 ) 
    print("arg3:", arg3  )
  
kwargs = {"arg3": 3, "arg2": "two"} # dictionary  
fun_var_args_call(1, **kwargs)  