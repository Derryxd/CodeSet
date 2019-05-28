# -*- coding: utf-8 -*-
"""
Created on Thu Feb  1 10:14:55 2018

@author: ldz
"""
# =============================================================================
'''
作用：
将文件夹下的所有文件（包括子文件夹）中所含有的数字，从中文转化阿拉伯数字，从而方便排序
例子：
import cn2dig
filePath = r'E:\360data\重要数据\桌面\file\python\0test'  #最后一个字符是\会出错，最后不用加\
cn2dig.main(filePath)
结果：
旧文件:第一章.重改名:第1章
旧文件:第三章.重改名:第3章
旧文件:第二章.重改名:第2章
旧文件:第五章.重改名:第5章
旧文件:第四章.重改名:第4章
'''
# =============================================================================
import os

chs_arabic_map = {u'零':0, u'一':1, u'二':2, u'三':3, u'四':4,
    u'五':5, u'六':6, u'七':7, u'八':8, u'九':9,
    u'十':10, u'百':100, u'千':10 ** 3, u'万':10 ** 4,
    u'〇':0, u'壹':1, u'贰':2, u'叁':3, u'肆':4,
    u'伍':5, u'陆':6, u'柒':7, u'捌':8, u'玖':9,
    u'拾':10, u'佰':100, u'仟':10 ** 3, u'萬':10 ** 4,
    u'亿':10 ** 8, u'億':10 ** 8, u'幺': 1, u'两':2,
    u'０':0, u'１':1, u'２':2, u'３':3, u'４':4,
    u'５':5, u'６':6, u'７':7, u'８':8, u'９':9}
chs=list(chs_arabic_map.keys())

def main(filePath):
    '''主程序，输入为路径，格式为转义后的字符，引用了old2newName子程序'''
    for fileName in os.listdir(filePath):    
    #os.listdir('.')遍历文件夹内的每个文件名，并返回一个包含文件名的list
    #    name = file.replace(' ', '')   #去掉空格
        fileName = fileName + '.'  #若文件名最后为数字，我的算法会丢失该数字，故添加一个非数字字符，最后删掉
        newName = old2newName(fileName)
        newName = newName[:len(newName)-1]
        os.rename(filePath + '\\' + fileName, filePath + '\\' + newName)
        print('旧文件:' + fileName + '重改名:' + newName)

def old2newName(longStr):
    '''从文件名找出汉字数字后重名文件名，输入为文件名，格式为字符，引用了chinese2digital子程序'''
    longList = list(longStr)
    cnList = []
    wholeList = []  #文件名的结果
    result=[]       #数字的结果
    j = 0
    k = 0
    for achar in longList:
        if achar in chs:
            j = 1
            cnList.append(achar)
            k = 1
        else:
            wholeList.append(achar)
            j = 0
            if j!=k:  #找出文件名的所有数字，如第十二章第一节中的十二、一
                wholeList.pop()  #删除最后一个元素，因为要先添加数字进去，而添加该数字前已添加了一个非数字字符
                cnStr=''.join(cnList) 
                result.append(cnStr)
                dig = chinese2digital(cnStr,chs_arabic_map)
                wholeList.append(str(dig))
                wholeList.append(achar) #重新添加该字符
                cnList= [] 
                k = 0
    newName = ''.join(wholeList)
    return newName
        
def chinese2digital(uchars_chinese,chs_arabic_map):
    '''将汉字数字转化为阿拉伯数字，输入为汉字数字与映射字典'''
    total = 0
    r = 1 #表示单位：个十百千
    for i in range(len(uchars_chinese)-1,-1,-1):
        val = chs_arabic_map.get(uchars_chinese[i])
        if val >=10 and i==0:   #第一位为单位，如十三、百八十
            if val > r:
                r = val
                total += r      #将头尾的单位加上，如百八十
            else:               #比如十万
                r *= val
        elif val >= 10:         
            if val > r:
                r = val
            else:
                r = r*val
        else:
#            if val == 0 and r == 10:
#                total += 10         #如一万零十二的情况，但一千零一十会出结果为1020，放弃思考
#            else:
            total += r*val      #从最后逐步累计
    return total




