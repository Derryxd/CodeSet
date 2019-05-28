# -*- coding: utf-8 -*-
"""
Created on Tue Jan  9 16:45:48 2018

@author: ldz
"""

class Dog(object):
#==============================================================================
# 单例模式：重复创建对象，减少对内容的占用
#==============================================================================
    __instance = None
    __init_flag = False
    
    def __new__(cls,name):
        if cls.__instance == None :
            cls.__instance = object.__new__(cls)
            return cls.__instance
        else:
            #return上一次创建的对象的引用
            return cls.__instance

    def __init__(self, name):
        self.name = name
    '''
    #若只想初始化一次
    def __init__(self, name)
        if Dog.__init_flag == False
            self.name = name
            Dog.__init_flag = True
    '''
#==============================================================================
# 所创建的a和b的id一样，但是要new中的参数个数要匹配好
#==============================================================================
a = Dog("a")
print(id(a))
print(a.name)

b = Dog("b")
print(id(b))
print(b.name)    

print(a.name) #--->b