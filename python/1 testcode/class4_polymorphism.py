# -*- coding: utf-8 -*-
"""
Created on Mon Jan  8 00:12:41 2018

@author: ldz
"""

class Dog(object):
    def print_self(self):
        print("wangwang")
        
class XiaoTianQuan(Dog):
    def print_self(self):
        print("WaWa")
        
def introduce(tmp):
    tmp.print_self()
    
dog1 = Dog()
dog2 = XiaoTianQuan()

introduce(dog1)
introduce(dog2)