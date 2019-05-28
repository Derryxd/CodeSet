# -*- coding: utf-8 -*-
"""
Created on Tue Jan  9 17:01:54 2018

@author: ldz
"""
#==============================================================================
'''异常处理：异常会传递到最后'''
#==============================================================================
try:
    11/0
    open('xx.txt')
    print(num)
    print('1111')
except (NameError, FileNotFoundError):
    print("aiyaya")
except Exception as heng:
    print("emmmmm")
    print(heng)
else:
    print("yeppppp")
finally:
    print("huuuuu")
    
print("22222")

#==============================================================================
'''异常的嵌套'''
#==============================================================================
import time 
try:
    f = open('test.txt')
    try:
        while True:
            content = f.readline()
            if len(content) == 0:
                break
            time.sleep(2)
            print(content)
    except:
        '''
        #如果在读取文件的过程中，产生了异常，那么会捕获到
        #比如 按下了 ctrl+c
        '''
        pass
    finally:
        f.close()
        print('close file')
except:
    print("No file")

#==============================================================================
# 自定义异常：raise 类（参数）
#==============================================================================
class ShortInputException(Exception):
    ''' 自定义的异常类，exception为所有异常的父类'''
    def __inti__(self, length, atleast):
        #super().__init__()
        self.length = length
        self.atleast = atleast
        
def main():
    try:
        s = input('pls input:')
        if len(s) < 3:
        #raise引发一个定义的异常
        raise ShortInputException(len(s)),3)
    except ShortInputException as result:
        print('输入长度是%d，长度至少为%d'%(result.length,result.atleast))
    else:
        print('No Exception')
        
main()      
'''
如果raise不接任何东西，则为异常抛出，交回给系统
'''        
        