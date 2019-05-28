# -*- coding: utf-8 -*-
"""
Created on Sun Jan  7 15:55:41 2018

@author: ldz
"""

class SweetPotato:
#==============================================================================
#定义一个类：new->init->其他->del
#==============================================================================
    #特殊固定含义的方法    
    def __init__(self):
        self.cookedString = "生的"
        self.cookedLevel = 0
        self.condiments =[] #为了存储多个数据
        self.__num = 100 
        
    def __new__(cls):#cls指向类对象，必须有返回值
        return object.__new__(cls) #返回值代表创建对象的引用
        
    def __str__(self):
        return "地瓜状态:%s(%d),添加作料有:%s" \
        %(self.cookedString,self.cookedLevel,self.condiments)
#        %(self.cookedString,self.cookedLevel,str(self.condiments))

    #普通自定义的方法    
    def cook(self,cooked_time):
        #用局部变量保存上次调用对象的属性
        self.cookedLevel += cooked_time
        if self.cookedLevel >=0 and self.cookedLevel <3:
            self.cookedString = "生的"
        elif self.cookedLevel >=3 and self.cookedLevel <5:
            self.cookedString = "半生不熟的"
        elif self.cookedLevel >=5 and self.cookedLevel <8:
            self.cookedString = "熟了的"         
        elif self.cookedLevel >=8 :
            self.cookedString = "糊了的"    

    def addCondiments(self,item):
        self.condiments.append(item)
        
    #私有方法 ： 私有方法和私有属性不会被子类继承   
    def __send(self):
        print("给ta吃")
        
    #共有方法    
    def send(self, gender):
        if gender == "lady":
            self.__send()
        else:
            print("走开")
            
#==============================================================================
# 创建对象
#==============================================================================
di_gua = SweetPotato()
print(di_gua)

#==============================================================================
# 开始烤地瓜
#==============================================================================
di_gua.cook(1)
print(di_gua)
di_gua.cook(1)
di_gua.addCondiments("盐")
print(di_gua)
di_gua.cook(2)
print(di_gua)
di_gua.cook(1)
print(di_gua)
di_gua.addCondiments("蜜糖")
di_gua.cook(3)
print(di_gua)
a=111

di_gua.send("nande")
di_gua.send("lady")


