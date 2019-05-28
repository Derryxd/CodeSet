# -*- coding: utf-8 -*-
"""
Created on Tue Jan  9 21:43:20 2018

@author: ldz
"""
#==============================================================================
''' 模块的发布和安装'''
#==============================================================================
from distutils.core import setup

setup(name="dongGe",version="1.0",description="dongGe's module",author="dongGe", \
      author_email='xxx',py_modules=['test.sendmsg','test.recvmsg'])

'''第一步：组件包和模块
mkdir&cd test --> vi send&recv.py --> vi __init__.py --> cd ..  && vi setup.py'''

'''第二步：建构模块
run setup.py build'''
#==============================================================================
'''建构后目录：lib文件夹'''
# running build
# running build_py
# creating build
# creating build\lib
# creating build\lib\test
# copying test\__init__.py -> build\lib\test
# copying test\sendmsg.py -> build\lib\test
# copying test\recvmsg.py -> build\lib\test
#==============================================================================

'''第三步：生成发布压缩包
run setup.py sdist'''
#==============================================================================
'''打包后，生成最终发布压缩包dongGe-1.0.tar.gz，目录结构：dist文件夹和MANIFEST文件'''
# running sdist
# running check
# warning: check: missing required meta-data: url
# 
# warning: sdist: manifest template 'MANIFEST.in' does not exist (using default file list)
# 
# warning: sdist: standard file not found: should have one of README, README.txt
# 
# writing manifest file 'MANIFEST'
# creating dongGe-1.0\test
# making hard links in dongGe-1.0...
# hard linking test\__init__.py -> dongGe-1.0\test
# hard linking test\recvmsg.py -> dongGe-1.0\test
# hard linking test\sendmsg.py -> dongGe-1.0\test
# creating 'dist\dongGe-1.0.zip' and adding 'dongGe-1.0' to it
# adding 'dongGe-1.0\PKG-INFO'
# adding 'dongGe-1.0\setup.py'
# adding 'dongGe-1.0\test\recvmsg.py'
# adding 'dongGe-1.0\test\sendmsg.py'
# adding 'dongGe-1.0\test\__init__.py'
# removing 'dongGe-1.0' (and everything under it)
# error removing dongGe-1.0: [WinError 32] 另一个程序正在使用此文件，进程无法访问。: 'dongGe-1.0\\setup.py'
# error removing dongGe-1.0: [WinError 145] 目录不是空的。: 'dongGe-1.0'
#==============================================================================

'''第四步：解压压缩包并安装
run setup.py install'''
#==============================================================================
''' 安装到系统路径里,生成目录：dongGe-1.0'''
# running install
# running build
# running build_py
# running install_lib
# creating D:\Anaconda3\envs\python34\Lib\site-packages\test
# copying build\lib\test\recvmsg.py -> D:\Anaconda3\envs\python34\Lib\site-packages\test
# copying build\lib\test\sendmsg.py -> D:\Anaconda3\envs\python34\Lib\site-packages\test
# copying build\lib\test\__init__.py -> D:\Anaconda3\envs\python34\Lib\site-packages\test
# byte-compiling D:\Anaconda3\envs\python34\Lib\site-packages\test\recvmsg.py to recvmsg.cpython-34.pyc
# byte-compiling D:\Anaconda3\envs\python34\Lib\site-packages\test\sendmsg.py to sendmsg.cpython-34.pyc
# byte-compiling D:\Anaconda3\envs\python34\Lib\site-packages\test\__init__.py to __init__.cpython-34.pyc
# running install_egg_info
# Writing D:\Anaconda3\envs\python34\Lib\site-packages\dongGe-1.0-py3.4.egg-info
#==============================================================================








