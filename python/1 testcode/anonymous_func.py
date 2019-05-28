# -*- coding: utf-8 -*-
"""
Created on Fri Jan  5 23:46:29 2018

@author: ldz
"""

def test(a,b,func):
    '''匿名函数'''
    result = func(a,b)
    print(result)

if __name__ == '__main__':
    func_new = eval(input("请输入一个新的匿名函数:"))

    '''test(11,22,lambda x,y:x*y)'''
    test(11,22,func_new)

    
# =============================================================================
'''
 result = {
   'a': lambda x: x * 5,
   'b': lambda x: x + 7,
   'c': lambda x: x - 2
 }[value](x)
 '''
# =============================================================================
