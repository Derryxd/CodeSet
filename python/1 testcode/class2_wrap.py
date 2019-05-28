# -*- coding: utf-8 -*-
"""
Created on Sun Jan  7 17:32:35 2018

@author: ldz
"""
#==============================================================================
'''定义一个类:类对象（类属性、实例方法、类方法）'''
#==============================================================================
class Home:
    '''类属性:需要用类方法引用修改'''
    nn = 0
    num = 0
    '''实例方法（推荐：self）'''
    def __init__(self, new_area, new_info, new_addr):
        self.area = new_area
        self.info = new_info
        self.addr = new_addr
        self.left_area = new_area
        self.contain_items = []
        self.nums = 0
        
    def __str__(self):
        msg = "房子的总面积:%d，可用面积:%d，户型:%s，地址:%s" \
        %(self.area, self.left_area, self.info, self.addr)
        msg += "\n当前房间有%d件物品:%s"%(self.nums, self.contain_items)
        return msg
    
    def add_item(self, item):
        '''可确保权限操作：另外定义方法实现'''
#        self.left_area -= item.area
#        self.contain_items.append(item.name)
        '''实例属性'''
        self.left_area -= item.get_area()
        self.contain_items.append(item.get_name())  
        self.nums += 1
        #类属性（+1）
        Home.num += 1

    def __del__(self):  
        '''要引用指数为0时才会被调用'''
        print("搬家了")
        
    '''类方法 (默认：@classmethod；推荐：cls)'''
    @classmethod
    def add_num(cls):
        cls.nn = 100    
#    #or:实例方法中需指明类
#    def test(cls):
#        Home.nn = 100           
        
    '''静态方法（跟类和实例对象无关，可以没有参数）'''
    @staticmethod
    def happy():
        print('住新家啦')
    
class Bed:
    def __init__(self, new_name, new_area):
        self.name = new_name
        self.area = new_area
        
    def __str__(self):
        return "%s占用面积:%d"%(self.name, self.area)
    
    def get_name(self):
        return self.name
    
    def get_area(self):
        return self.area
    
#==============================================================================
'''描述房子：实例对象（实例属性共享一个类属性，方法指向类对象方法）'''
#==============================================================================
fangzi = Home(129,"三室一厅","北京市")
print(fangzi)
fangzi.happy()#通过实例对象调用静态方法
Home.happy()  #通过类    调用静态方法

bed1 = Bed("bigbed",10)
fangzi.add_item(bed1)
print(bed1)
print(fangzi)
bed2 = Bed("smallbed",5)
fangzi.add_item(bed2)
print(bed2)
print(fangzi)

print(Home.num)
print(fangzi.num)

#==============================================================================
''' 可以通过类或类创造的对象调用类方法'''
#==============================================================================
Home.add_num()  #第一种
print(Home.num)
bed3 = Bed("hahalbed",50)
fangzi.add_item(bed3)
print(bed3)
print(fangzi)
print(fangzi.num)

fangzi.add_num() #第二种
print(Home.num)

#==============================================================================
''' 设置删除提示'''
#==============================================================================
del fangzi