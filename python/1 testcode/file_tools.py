# -*- coding: utf-8 -*-
"""
Created on Thu Nov  1 10:43:47 2018

@author: ldz
"""

# -*- coding: utf-8 -*-
"""
Created on Wed Oct 31 14:10:22 2018

@author: ldz
"""

#import xlrd
#import datetime

def fileName(path):
    '''查看当前目录下的所有文件名'''
    import os
    files = []
    for root, dirs, file in os.walk(path):  
#        print(root,'\n') #当前目录路径  
#        print(dirs,'\n') #当前路径下所有子目录  
#        print(file,'\n') #当前路径下所有非目录子文件
        files+=file
    return sorted(list(set(files)))

def fileSelect(path,suffix):
    '''
    找出某种后缀的文件
    path:   absolute path of one file
    suffix: .xx（后缀）
    '''
    files_f90 = []
    files = fileName(path)
    for item in files:
        if item.rsplit('.',1)[-1] == suffix:
            files_f90.append(item)
    return files_f90

def numOfLines(path_save, files):
    '''统计一个文件夹下的某种后缀文件的行数并保存到info_save.txt中'''
    nums = []
    f = open(path_save + '\\' + 'info_save.txt','w') 
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
            
def readFile(path,file):
    ''' 
    读取文本文件
    path: absolute path of one file
    file: list type containing filename
    '''
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
    import re
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

def outputToExcel(header,dicts,name,excel):
    '''
    将字典内容输出到excel中
    header: simple list tpye ['序号','文件号','key值','各个value值...']
    dicts:  {key:value}, where value=[[...],...,[...]] is nested list
    name:   name of sheet
    excel:  absolute path of excel file
    '''
    import xlwt
    row = 1
    num = 1
    book = xlwt.Workbook(encoding='utf-8')
    sheet = book.add_sheet(name)#在打开的excel中添加一个sheet
    for i in range(len(header)):
        sheet.write(0,i,header[i])
    for key, value in dicts.items():
        sheet.write(row,1,str(num))
        sheet.write(row,2,key)
        for item in value:
            sheet.write(row,0,str(row))
            for j in item:
                sheet.write(row,j+3,item[j])
            row += 1
        num += 1
    path_excel = path_save + '\\' + excel  #excel绝对路径
    book.save(path_excel)

def mkdir(path):
    # 引入模块
    import os
    path=path.strip()       # 去除首位空格
    path=path.rstrip("\\")  # 去除尾部 \ 符号
 
    # 判断路径是否存在
    # 存在     True
    # 不存在   False
    isExists=os.path.exists(path)
 
    # 判断结果
    if not isExists:
        # 如果不存在则创建目录
        # 创建目录操作函数
        os.makedirs(path) 
 
        print(path + ' 创建成功')
        return True
    else:
        # 如果目录存在则不创建，并提示目录已存在
        print(path + ' 目录已存在')
    return False
    
if __name__ == '__main__':        
    path = r'E:\360data\重要数据\桌面\licom\src.pop2 - v1.0.0'
    #a = os.listdir(path)
    path_save = path.rsplit('\\',1)[0]         #保存txt文件所在路径

    
    
    
    
    