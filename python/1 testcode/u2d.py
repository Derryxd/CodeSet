# -*- coding: utf-8 -*-
"""
Created on Wed Jan 17 19:19:32 2018

@author: ldz
"""
#==============================================================================
'''
实现unix文件转换成dos文件格式：
类unix系统使用回车标识回车换行'\n'
windows系统用回车换行标识回车换行'\r\n'
　　类unix文件拷贝到windows系统，就会丢失换行标识
　　windows文件拷贝到类unix系统，就会出现"^M"标识
'''
#==============================================================================
def unix2dos(fname):
#    import sys
    import glob
    import os
    src_file = glob.glob(fname)
    print('需要修改的文件列表：' + str(src_file))
#    print(fname)
    if os.path.isdir('dosfile') == False:
        os.makedirs('dosfile')   
    for aname in src_file:
        src_fobj = open(aname)
        dst_file = 'dosfile' + '/' +  aname
        abs_path = os.path.abspath(dst_file)
        dst_fobj = open(abs_path, 'w')
        for line in src_fobj:
            '''当rm为空时，默认删除空白符（包括'\n', '\r', '\t', ' ')'''
            dst_fobj.write(line.rstrip('\r\n') + '\r\n') #rstrip(rm)
        src_fobj.close()
        dst_fobj.close()
        print(aname + '文件转换成功')
#if __name__ == "__main__":
#    unix2dos(sys.argv[1:])