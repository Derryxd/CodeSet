#!/usr/bin/env python2
# coding = utf-8

from scipy.io  import netcdf
#from scipy.io.netcdf import NetCDFFile
import os
#import pdb,sqlite3
import numpy as np
import random

def MKdir(dir_py):
    '''make dir '''
    if not os.path.exists(dir_py):
        os.makedirs(dir_py)

def readtxt(txt, directory):
    f = open( directory + '/' + txt,'r' )
    content = f.readlines()
    f.close()    
    return content

def LS(suffix,directory):
    LS_common  =  ('ls {}/*.' + suffix).format(directory)
    LS_files =  os.popen(LS_common).readlines()  
    return LS_files

def MKlog(dir_run): 
    '''check the out files in the run'''
    out_files =  LS('out', dir_run)
    tmpt = []
    for files in out_files:
        tmpt.append( files.split('/')[-1].split('.')[0] )
    '''create the py logs'''
    file_log = dir_py + '/' + str(max(tmpt)) + '.pylog'
    if not os.path.exists( file_log ):
        os.system( r"touch {}".format( file_log )  )
    return file_log

def ncDump(dir_run):
    '''make dir of ncfile to store the info of ncdump'''
    dir_nc = root + '/' + 'ncfile'
    if not os.path.exists(dir_nc):
        MKdir(dir_nc)
        '''check the nc files in the run'''    
        out_files =  LS('nc', dir_nc)
        '''store the ncdump info in txt'''
        for item in out_files:
            file_name = item.split('/')[-1].split('.')[0].split('-')[0] + '.txt'
            if not os.path.exists(dir_nc + '/' + file_name):
                f = open(dir_nc + '/' + file_name, 'w')
                NCDUMP = 'ncdump -h {}'.format(item)
                content = os.popen(NCDUMP).readlines()
                f.writelines(content)
                f.close()

def initLog(dir_py):
    '''check the pylog dir in the run'''
    if not os.path.exists(dir_py):
        MKdir(dir_py)
    '''create th first pylog'''
    if not os.path.exists(dir_py + '/0.pylog'):
        f = open(dir_py + '/0.pylog','w' )
        f.write('Begin to record the log by python script that whether outcome are right after change the language from fortran to c. \n')
        f.write('PS: This "0.pylog" is just desciption which can be ignored.\n\n')
        f.write('The Existing C Scripts:\n')
        f.write('# clock0f\n')
        f.write('The New C Scripts:\n')
        f.write('NONE\n\n')
        f.write('The Existing H files:\n')
        f.write('! def-undef\n')
        f.write('The New H files:\n')
        f.write('NONE\n')
        
def toTest(nc, var):
    print nc
    eps = 1e-08
#    nc = ['MMEAN0001-02.nc']
    num = [1,2,3,4,5,6]
    for index, ncfile in enumerate(nc):
        print 'FILE', index, 'Varibles checked in the ',  ncfile
        randi = []
        for i in range(3):
            randi.append(random.randint(0,29))
#          print randi
        num[index] = []
        for varible in var[index/2].strip().split(','):
            print varible
            f_tmpt = netcdf.netcdf_file(orgn + '/' + ncfile, 'r')
            f_test = netcdf.netcdf_file(dir_run + '/' + ncfile, 'r')
            tmpt = f_tmpt.variables[varible][0,randi]
            test = f_test.variables[varible][0,randi]
            diff = tmpt - test
            num[index].append(len(np.where( (diff>=-eps)&(diff<=eps) )[0]) )
            f_tmpt.close()
            f_test.close()
        if (index == 2  or  index == 3) :
            num[index+2] = []
            print  'Varibles checked in the ', ncfile
            for varible in var[2].strip().split(','):
                print varible
                f_tmpt = netcdf.netcdf_file(orgn + '/' + ncfile, 'r')
                f_test = netcdf.netcdf_file(dir_run + '/' + ncfile, 'r')
                tmpt = f_tmpt.variables[varible][0]
                test = f_test.variables[varible][0]
                diff = tmpt - test
                num[index+2].append(len(np.where( (diff>=-eps)&(diff<=eps) )[0]) )            
                f_tmpt.close()
                f_test.close()
    return num
    
def toLog(dir_src, num, var):
    '''check the pylog dir in the run'''
    if not os.path.exists(dir_py):
        MKdir(dir_py)
    '''create th newest pylog'''
    MKlog(dir_run)
    LS_files = LS('pylog', dir_py)
    read = LS_files[-2].strip()
    write = LS_files[-1].strip()
    f_read = open(read,'r')
    f_write = open(write,'w')
    old_c = []
    old_h = []
    for line in f_read.readlines():
        if '#' in line:
            old_c = old_c + line[2::].strip().split(',')
        if '!' in line:
            old_h = old_h + line[2::].strip().split(',')
    f_read.close()
    new_c = []
    new_h = []
    for line in LS('c', dir_src):
        item = line.strip().split('/')[-1].split('.')[-2] 
        if not item in old_c:
            new_c.append(item)
    for line in LS('h', dir_src):
        item = line.strip().split('/')[-1].split('.')[-2]
        if not item in old_h:
            new_h.append(item)
    f_write.write('The Existing C Scripts:\n')
    f_write.write('# ')
    for index, item in enumerate(old_c, start =1 ):
        if index%5==0:
            f_write.write('\n# ')
        f_write.write(item)
        f_write.write(',')
    f_write.write('\n')
    f_write.write('The New C Scripts:\n')
    f_write.write('# ')
    for index, item in enumerate(new_c, start =1 ):
        if index%5==0:
            f_write.write('\n# ')
        f_write.write(item)
        f_write.write(',')
    f_write.write('\n\n')
    f_write.write('The Existing H files:\n')
    f_write.write('! ')
    for index, item in enumerate(old_h, start =1 ):
        if index%5==0:
            f_write.write('\n# ')
        f_write.write(item)
        f_write.write(',')
    f_write.write('\n')
    f_write.write('The New H files:\n')
    f_write.write('! ')
    for index, item in enumerate(new_h, start =1 ):
        if index%5==0:
            f_write.write('\n# ')
        f_write.write(item)
        f_write.write(',')
    f_write.write('\n\n')
    vari=[1,2,3,4,5,6]
    vari[0] = var[0]
    vari[1] = var[0]
    vari[2] = var[1]
    vari[3] = var[2]
    vari[4] = var[1]
    vari[5] = var[2]
    ncc = [ 'budget0001-01.nc' , 'budget0001-03.nc', 'MMEAN0001-02.nc', 'MMEAN0001-02.nc', 'MMEAN0001-04.nc', 'MMEAN0001-04.nc']  
    num = np.array(num)
    num[num == 235440] = 0
    num[num == 78480] = 0
    tmpt = np.where (num>0 )
    if not len(tmpt):
        for i in range(len(tmpt[0])):
            f_write.write('Varible  '+vari[1][i]+' in '+ncc[0][i]+'is wrong.\n')
    f_write.close()
    

     
    
if  __name__ == '__main__' :
    test = 'Ttest_noice2'
    root = '/home/ldz/licom/output/' + test 
    orgn =  '/home/ldz/licom/output/Origin/run/'
    dir_py = root + '/'  + 'pylog'   
    dir_run = root + '/' + 'run'
    dir_src = root + '/' + 'ocn/source'
    file_log = MKlog(dir_run)
    ncDump(dir_run) 
    initLog(dir_py)
    nc = [ 'budget0001-01.nc' , 'budget0001-03.nc', 'MMEAN0001-02.nc', 'MMEAN0001-04.nc']   
    var = readtxt( 'var.txt', dir_py) 
    num =toTest(nc, var)
    toLog(dir_src, num, var)
    



    