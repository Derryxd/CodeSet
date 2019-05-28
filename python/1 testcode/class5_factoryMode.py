# -*- coding: utf-8 -*-
"""
Created on Tue Jan  9 15:03:00 2018

@author: ldz
"""

#==============================================================================
#汽车店设计 
#==============================================================================
class Store(object):
    def select_car(self):
        pass
    def order(self,car_type):
        return self.select_car(car_type)

#==============================================================================
# 工厂方法模式:父类定义方法不实现，在子类中实现    
#==============================================================================
class Car2Store(Store):
    def select_car(self):
        return Factory2().select_car_by_type(car_type)
    
class Factory2(object):    
    pass
    

class CarStore(Store):
    #库存
    def __init__(self):
        self.factory = Factory()
        
    def order(self, money, car_type):
        #预约
        if money>50000:
            return self.factory.select_car_by_type(car_type)
        
#==============================================================================
# 简单工厂模式：解耦，使强耦合变弱耦合，添加车型类，使得对预定程序影响不大
#==============================================================================
class Factory(object):
    def select_car_by_type(self, car_type):
        if car_type == "宝马":
            return BaoMa()
        elif car_type == "大车":
            return DaChe()
    
class Car():
    def move(self):
        print("bubu")
    def music(self):
        print("dingdongding")
    def stop(self):
        print("ziziziz")

class BaoMa(Car):
    pass
    
class DaChe(Car):
    pass
    
car_store = CarStore()
car = car_store.order(100000,"宝马")
car.move()
car.music()
car.stop()
    