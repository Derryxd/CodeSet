# -*- coding: utf-8 -*-
"""
Created on Wed Oct 31 14:10:22 2018

@author: ldz
"""
import os
import re
#import xlrd
import xlwt
#import datetime

def fileName(path):
    '''查看当前目录下的所有文件名'''
    files = []
    for root, dirs, file in os.walk(path):  
#        print(root,'\n') #当前目录路径  
#        print(dirs,'\n') #当前路径下所有子目录  
#        print(file,'\n') #当前路径下所有非目录子文件
        files+=file
    return sorted(list(set(files)))

def F90Select(files):
    '''找出f90文件'''
    files_f90 = []
    for item in files:
        if item.rsplit('.',1)[-1] == 'F90':
            files_f90.append(item)
    return files_f90

def numOfLines(files):
    '''统计每个f90文件的行数并保存到txt中'''
    nums = []
    f = open(path_save + '\\' + 'info_f90.txt','w') 
    f.write('序号' +'\t'+ '行数' +'\t'+ '文件名' +'\n')
    for index_f, file in enumerate(files, start=1):
        try:
            content = readFile(file)
            nums.append(len(content)) 
        except UnicodeDecodeError as e:
            nums.append(0)
        finally:
            print(index_f,'\t',file)
            f.write(str(index_f) +'\t'+ str(len(content)) +'\t'+ file +'\n')
    f.close()
    print('文件总行数：',sum(nums))
    return nums
            
def readFile(file):
    ''' 读取文本文件'''
    f = open(path + '\\' + file,'r')
    content = f.readlines()
    f.close()
    return content

def removeBlankDict(dictionary):
    '''删除字典中value为空的键值对'''
    for key in list(dictionary.keys()):
        if not dictionary.get(key):
            del dictionary[key]   
    return dictionary

def infoFunc(files):
    '''找出子程序在哪个f90文件被创建'''
    err  = []
    tmpt = []
    lines= []
    func_info = {}
    p=re.compile(r"^.*Subroutine *(\S+)",re.I)
    for index_f, file in enumerate(files, start=1):
        try:
            content = readFile(file)
            for index, line in enumerate(content, start=1):
                if re.search('subroutine', line, re.IGNORECASE) \
                and not re.search('end', line, re.IGNORECASE)    \
                and not re.search('!', line):
                    lines.append(line)
#                    func = line.strip().split('(')[0].strip().split(' ')[-1]
                    func = re.findall(p,line)[0].split('(')[0] #正则化
                    if re.search('\(', line):
                        para = 'TRUE'
                    else:
                        para = 'NONE'
                    tmpt = [file,index,para]
                    func_info[func] = []
                    func_info[func].append(tmpt)
        except UnicodeDecodeError as e:
            print('UnicodeDecodeError of f90 file:',file)
            err.append(file)
    f_err = open(path_save + '\\' + 'logDecodeError.txt','w')
    f_err.write('UnicodeDecodeError error happen in theses files:\n')
    for item in err:
        f_err.write(item + '\n')
    f_err.close()
    return func_info,lines

def infoFile(files):
    '''统计每个文件调用了哪些子程序'''
    lines= []
    file_info = {}
    p=re.compile(r"^.*Call *(\S+)",re.I)
    for index_f, file in enumerate(files, start=1):
        try:
            content = readFile(file)
            tmpt = []
            file_info[file] = []
            for index, line in enumerate(content, start=1):
                if re.search('call', line, re.IGNORECASE) \
                and not re.search('!', line):
                    lines.append(line)
#                    try:
#                        func = line.strip().rsplit('(')[-2].strip().rsplit(' ')[-1]
#                    except IndexError as e:
#                        func = line.strip().rsplit('(')[-1].strip().rsplit(' ')[-1]
                    func = p.findall(line)[0].split('(')[0]
                    if re.search('\(', line):
                        para = 'TRUE'
                    else:
                        para = 'NONE'
                    tmpt = [func,index,para]
                    file_info[file].append(tmpt)
        except UnicodeDecodeError as e:
            pass
    info_file = removeBlankDict(file_info)
    return info_file,lines

def infoModu(files):
    '''统计每个文件调用了哪些模块'''
    lines= []
    modules = []
    modu_info = {}
    p=re.compile(r"^.*Use *(\S+)",re.I)
    for item in files:
        if 'mod' in item:
            modules.append(item)
    for index_f, file in enumerate(files, start=1):
        try:
            content = readFile(file)
            tmpt = []
            modu_info[file] = []
            for index, line in enumerate(content, start=1):
                if re.search('mod', line, re.IGNORECASE)  \
                and re.search('use', line, re.IGNORECASE) \
                and not re.search('!', line):
                    lines.append(line)
#                    func = line.strip().split('(')[0].strip().split(' ')[-1]
                    func = p.findall(line)[0].split(',')[0]
                    if re.search('only', line):
                        only = 'TRUE'
                    else:
                        only = 'NONE'
                    tmpt = [func,index,only]
                    modu_info[file].append(tmpt)
        except UnicodeDecodeError as e:
            pass
    info_modu = removeBlankDict(modu_info)
    return info_modu,lines,modules
    
def infoModFile(files):
    '''找出哪个f90文件创建了模块'''
    lines= []
    file_info = {}
    p=re.compile(r"^.*Module *(\S+)",re.I)
    for index_f, file in enumerate(files, start=1):
        try:
            content = readFile(file)
            tmpt = []
            file_info[file] = []
            for index, line in enumerate(content, start=1):
                if re.search('module', line, re.IGNORECASE) \
                and not re.search('end', line, re.IGNORECASE) \
                and not re.search('!', line):
                    lines.append(line)
#                    try:
#                        func = line.strip().rsplit('(')[-2].strip().rsplit(' ')[-1]
#                    except IndexError as e:
#                        func = line.strip().rsplit('(')[-1].strip().rsplit(' ')[-1]
                    func = p.findall(line)[0].split('(')[0]
                    tmpt = [func,index]
                    file_info[file].append(tmpt)
        except UnicodeDecodeError as e:
            pass
    info_file = removeBlankDict(file_info)
    return info_file,lines

def outputToExcel(dictinary,name,excel):
    '''
    将字典内容输出到excel中
    header: simple list tpye
    dicts:  {key:value}, where value=[[...],...,[...]] is nested list
    name:   name of sheet
    excel:  absolute path of excel file
    '''
    row = 1
    num = 1
    book = xlwt.Workbook(encoding='utf-8')
    sheet = book.add_sheet(name)#在打开的excel中添加一个sheet

    for i in range(len(header[1])):
        sheet.write(0,i,header[int(name[1])-1][i])
    for key, value in dictinary.items():
        sheet.write(row,0,str(num))
        sheet.write(row,1,key)
        for item in value:
            sheet.write(row,2,item[0])
            sheet.write(row,3,item[1])
            sheet.write(row,4,item[2])
            row += 1
        num += 1
    path_excel = path_save + '\\' + excel  #excel绝对路径
    book.save(path_excel)

def findDo(files):
    '''统计每个文件调用了哪些模块'''
    numsDo = []
    for index_f, file in enumerate(files, start=1):
        try:
            content = readFile(file)
            tmpt = 0
            for index, line in enumerate(content, start=1):
                if 'end do' in line.lower():
                    tmpt = tmpt + 1
            numsDo.append(tmpt)
        except UnicodeDecodeError as e:
            numsDo.append(0)
            print(file)
    return numsDo

if __name__ == '__main__':        
    path = r'E:\360data\重要数据\桌面\licom\src.pop2 - v1.0.0'
#    #a = os.listdir(path)
    path_save = path.rsplit('\\',1)[0]         #保存txt文件所在路径
#    files = fileName(path)                     #统计上述路径下的文件
#    files_f90 = F90Select(files)               #找出f90文件
#    nums = numOfLines(files_f90)                
#    info_func,lines_func = infoFunc(files_f90) #找出子程序在哪个f90文件被创建
#    info_file,lines_file = infoFile(files_f90) #统计每个文件调用了哪些子程序
#    info_modu,lines_modu,modules = infoModu(files_f90) #统计每个文件调用了哪些模块
#    header=[ ['序号','子程序','文件名','行号','参数'], \
#         ['序号','文件名','子程序','行号','参数'], \
#         ['序号','文件名','模块','行号','ONLY'] ]
    
#    outputToExcel(header,info_func,'表1：子程序统计信息','info_func.xls')
#    outputToExcel(header,info_file,'表2：f90文件调用子程序信息','info_file.xls')
#    outputToExcel(header,info_modu,'表3：f90文件调用模块信息','info_modules.xls')    
    #树状图表示，上述两个字典合并为一个新字典
#    f_num = open(path_save + '\\' + 'num_f90.txt','w+')
#    f_fun = open(path_save + '\\' + 'func_f90.txt','w+')
#    f_f90 = open(path_save + '\\' + 'f90_func.txt','w+')
#    f_num.close()
#    f_fun.close()
#    f_f90.close()
    numsDo = findDo(files_f90)
    info_modFile,lines_modFile = infoModFile(files_f90)

# =============================================================================
    a = files_f90
    b = list(info_modFile.keys())
    bb = list(info_file.keys())
    c = []
    for i in a:
        if i not in b and i not in bb:
            c.append(i)
# =============================================================================
    
        

