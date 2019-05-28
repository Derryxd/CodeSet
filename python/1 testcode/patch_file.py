# -*- coding: utf-8 -*-
"""
Created on Tue Jan  9 23:29:56 2018

@author: ldz
"""

#==============================================================================
'''rename'''
#==============================================================================
import os
folder_name = input()
#or 
#folder_name =''
file_names = os.listdir(folder_name)
'''3'''
for name in file_names:
    print(name)
    old_file_name = 'aaa'
    new_file_name = 'bbb'
    os.rename(old_file_name, old_file_name)

#==============================================================================
'''folder'''
#==============================================================================
import os,sys
base = 'E:/'
i = 1
for j in range(100):
    file_name = base+str(i)
    os.mkdir(file_name)
    i=i+1

#==============================================================================
'''file'''
#==============================================================================
index = 0
count = 0
f_in = open("%d.txt" % index, "w")
with open("big.txt", "r") as f_out:
    for line in f_out:
        count += 1
        f_in.write(line)

        # 读满1000行之后，行计数置零，小文件序号加一，创建一个新的文件写信息
        if count == 1000:
            f_in.close()
            count = 0
            index += 1
            f_in = open("%d.txt" % index, "w")
            
#==============================================================================
'''delete:根据文件名（日期命名）和大小删除'''          
#==============================================================================
import os
directory = "E:\\学习日志\\"
os.chdir(directory) # 改变当前工作目录
cwd = os.getcwd() # 查看当前工作目录
print("--------------current working directory : " + cwd + "----------")

def deleteBySize(minSize):
    """删除小于minSize的文件（单位：K）"""
    files = os.listdir(os.getcwd()) # 列出目录中文件
    for file in files:
    ##    print file + " : " + str(os.path.getsize(file))
        if os.path.getsize(file) < minSize * 1000:
            os.remove(file)
            print(file + " deleted.")
    return

def deleteNullFile():
    '''删除所有大小为0的文件'''
    files = os.listdir(os.getcwd()) # 列出目录中文件
    for file in files:
        if os.path.getsize(file) == 0: #得到文件大小，如果是目录返回0
            os.remove(file)
            print(file + " deleted")
    return

def create():
    '''根据本地时间创建新文件，如果已存在则不创建'''
    import time
    #将指定的struct_time(默认为当前时间)，根据指定的格式化字符串输出
    t = time.strftime('%Y-%m-%d',time.localtime()) 
    suffix = ".docx"
    newFile =os.getcwd() + "\\" + t + suffix 
    if not os.path.exists(newFile):
        f = open(newFile,'w')
        f.close()
        print newFile + " created."
    else:
        print newFile + " already exist."
    return

hint = '''funtion : 
        1    create new file
        2    delete null file
        3    delete by size
        q    quit\n
please input number: '''
while True:
    option = raw_input(hint)
    if cmp(option,"1") == 0:
        create()
    elif cmp(option,"2") == 0:
        deleteNullFile()
    elif cmp(option,"3") == 0:
        minSize = raw_input("minSize(K) : ")
        deleteBySize(minSize)
    elif cmp(option,"q") == 0:
        print "quit !"
        break
    else:
        print ("disabled input. please try again...")