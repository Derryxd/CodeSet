# -*- coding: utf-8 -*-
"""
Created on Sun Jan 14 20:54:24 2018

@author: ldz
"""
#==============================================================================
'''老王开枪--DongGe'''
#==============================================================================
class Person(object):
    """docstring for Person"""
    def __init__(self, name):
        super(Person, self).__init__()
        self.name =  name
        self.gun = None #记录枪对象的引用
        self.hp = 100

    def installZidan(self, danjia_temp, zidan_temp):
        '''安装子弹'''
        #弹夹.保存子弹(子弹)
        danjia_temp.baocun_zidan(zidan_temp)

    def installDanjia(self, gun_temp, danjia_temp):
        '''安装弹夹'''
        #枪.弹夹（弹夹）
        gun_temp.baocun_danjia(danjia_temp)

    def takeGun(self, gun_temp):
        self.gun = gun_temp
        
    def __str__(self):
        if self.gun:
            return "%s的血量为%d，他有枪\n\t%s"%(self.name, self.hp, self.gun)
        else:
            if self.hp > 0:
                return "%s的血量为%d，他没枪"%(self.name, self.hp)
            else:
                return "%s 已挂..."%(self.name)
        
    def shot(self, diren_temp):
        '''枪射出子弹，攻击敌人'''
        self.gun.fire(diren_temp)
        
    def deHp(self, power):
        self.hp -= power
        
class Gun(object):
    """docstring for Gun"""
    def __init__(self, name):
        super(Gun, self).__init__()
        self.name = name #枪的类型
        self.danjia = None #记录弹夹对象的引用

    def baocun_danjia(self, danjia_temp):
        '''用一个属性保存对弹夹的引用'''
        self.danjia = danjia_temp

    def __str__(self):
        if self.danjia:
            return "枪的信息：%s；%s"%(self.name, self.danjia)
        else:
            return "枪的信息：%s，枪没有弹夹"%(self.name)
        
    def fire(self, diren_temp):
        '''从弹夹取子弹，子弹从枪中飞出，击中敌人'''
        zidan_temp = self.danjia.tanchu_zidan()
        if zidan_temp:
            zidan_temp.hit(diren_temp)
        else:
            print("弹夹中没有子弹了...")
                
class Danjia(object):
    """docstring for Danjia"""
    def __init__(self, max_num):
        super(Danjia, self).__init__()
        self.max_num = max_num  #弹夹的最大容量
        self.zidan_list = []    #记录子弹的引用

    def baocun_zidan(self, zidan_temp):
        '''保存子弹'''
        self.zidan_list.append(zidan_temp)
        
    def __str__(self):
        return "弹夹信息为：%d/%d"%(len(self.zidan_list), self.max_num)
    
    def tanchu_zidan(self, ):
        '''弹出最上面的子弹'''
        if self.zidan_list:
            return self.zidan_list.pop()
        else:
            return None
        
class Zidan(object):
        """docstring for Zidan"""
        def __init__(self, power):
            super(Zidan, self).__init__()
            self.power = power  #子弹威力
        
        def hit(self, diren_temp):
            '''敌人掉血'''
            diren_temp.deHp(self.power)
            
def main():
    '''主程序，控制流程'''
    pass

    #1创建老王对象
    laowang = Person('老王')

    #2创建枪对象
    ak47 = Gun('AK47')
    
    #3创建弹夹对象
    dj = Danjia(20)
    
    #4创建子弹
    for i in range(15):
        zd = Zidan(10)
    
        #5老王填装子弹（子弹-弹夹）
        laowang.installZidan(dj, zd)
    
    #6装上弹夹（弹夹-枪）
    laowang.installDanjia(ak47, dj)

#    #test:弹夹信息、枪的信息
#    print(dj)
#    print(ak47)
    
    #7老王拿枪
    laowang.takeGun(ak47)
    
    #测试
    print(laowang)
    
    #8创建敌人
    diren = Person('DiRen')
    print(diren)
    
    #9设计
    for i in range(11):
        laowang.shot(diren)
        print(diren)
        print(laowang)
    
    
    
if __name__ == '__main__':
    main()
    


