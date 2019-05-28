# -*- coding: utf-8 -*-
"""
Created on Sun Jan  7 19:53:22 2018

@author: ldz
"""

#==============================================================================
'''父类：python3推荐object为默认总的父类'''
#==============================================================================
class Animal(object):  
    def __init__(self):
        self.num1 = 100
        self.__num2 = 200
    def eat(self):
        print("eat...")
    def drink(self):
        print("drink..")
    def run(self):
        print("run..")
    def __tt(self):
        print(self.__num2+100)
    def test1(self):
        print(self.__num2)
        self.__tt()
        
#==============================================================================
'''子类：son(father)'''
#==============================================================================
class Dog(Animal):
    def bark(self):
        print("wangwang")

class ShenXian(object):
    def test2(self):
        print("bangbang")
        
class XiaoTianQuan(Dog,ShenXian):
    def fly(self):
        print("fly..")
    def bark(self):
        print("houhou")
        '''第一种调用被重写的父类的方法'''
        #Dog.bark(self)  #父类的名字.父类的方法(self)
        '''第二种'''
        super().bark()
        '''or
        super(当前父类的名字, self).父类的方法名()
        '''
        
#==============================================================================
'''main'''
#==============================================================================
xiaotq = XiaoTianQuan()
xiaotq.fly()
xiaotq.bark()
xiaotq.eat()
xiaotq.test1() #可用父类的共有方法中的私有方法，而不能直接引用父类的私有方法和属性
xiaotq.test2()

print(XiaoTianQuan.__mro__) #类名.__mro__(C3算法)：父类的调用顺序

     
#==============================================================================
'''__mro__查看调用顺序'''
#==============================================================================
class Base(object):
    pass
class A(Base):
    pass
class B(Base):
    pass
class C(A,B):
    pass

c=C()

print(B.__mro__)