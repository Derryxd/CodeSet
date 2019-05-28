# -*- coding: utf-8 -*-
"""
Created on Tue Jan  9 23:12:55 2018

@author: ldz
"""
#==============================================================================
'''名片管理系统'''
#==============================================================================
'''用来存储名片,列表可以不加global，自带全局变量功能'''
card_infors = [] 


def print_menu():
    '''打印功能菜单'''  #def '''xxx''' 函数文档说明
    print("="*50)
    print("  名片管理系统 V1.0  ")
    print(" 1.添加一个新的名片")
    print(" 2.删除一个名片")
    print(" 3.修改一个名片")
    print(" 4.查询一个名片")
    print(" 5.显示所有名片")  
    print(" 6.保存信息 ")   
    print(" 7.退出系统") 
    print("="*50)

def add_new_card_infor():
    '''添加一个新的名片'''
    new_name = input("请输入新的名字：")
    new_qq = input("请输入新的qq：")
    new_weixin = input("请输入新的微信：")
    new_addr = input("请输入新的地址：")
    
    '''定义一个新的字典，用来储存一个新的名片'''
    new_infor = {}
    new_infor['name'] = new_name
    new_infor['qq'] = new_qq
    new_infor['weixin'] = new_weixin
    new_infor['addr'] = new_addr

    '''将一个字典添加到列表中'''
    global card_infors
    card_infors.append(new_infor)
    
    #print(card_infor) #for test
    
def find_card_infor():
    '''用来查询一个名片'''
    global card_infors
    find_name = input("请输入要查询的姓名：")
    find_flag = 0 #默认表示没有找到
    for temp in card_infors:
        if find_name == temp["name"]:
            print("姓名\tQQ\t微信\t地址")
            print("%s\t%s\t%s\t%s\t" \
                  %(temp['name'],temp['qq'],temp['weixin'],temp['addr']))
            find_flag = 1 #表示找到了
            break
        
    '''判断是否找到了'''
    if find_flag == 0:
        print("查无此人...")
        
def show_all_infor():
    '''显示所有的名片信息'''
    global card_infors
    
    print("Name\tQQ\tWchat\tAddr")
#    print("姓名\tQQ\t微信\t地址")
    for temp in card_infors:
        print("%s\t%s\t%s\t%s\t" \
              %(temp['name'],temp['qq'],temp['weixin'],temp['addr']))

def save_2_file():
    '''把已经添加的信息保存到文件中'''
    f = open("backup.data",'w')

    f.write(str(card_infors))
    print("信息保存成功")
    
    f.close()
    
def load_infor():
    '''加载之前的数据'''
    global card_infors
    try:
        f = open('backup.data','r')
        '''将字符串str当成有效的表达式来求值并返回计算结果,即转回list列表'''
        card_infors = eval(f.read())  
        
        f.close
    
    except Exception:
        pass
    
def main():
    '''完成对整个程序的控制'''
    
    #加载之前的数据到程序中
    load_infor()
    
    while True:
        #1、打印功能提示
        print_menu()        
        
        #2、获取用户的输入
        num = int(input("请输入操作序号："))
        
        #3、根据用户的数据执行相应的功能
        if num == 1:
            add_new_card_infor()
        elif num ==2:
            pass
        elif num ==3:        
            pass
        elif num ==4:
            find_card_infor()
        elif num ==5:
            show_all_infor()
        elif num ==6:
            save_2_file()
        elif num ==7:
            break
        else:
            print("输入有误，请重新输入")
        print("")

if __name__ == "__main__":
    #调用主函数
    main()