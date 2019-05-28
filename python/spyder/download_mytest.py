# -*- coding: utf-8 -*-
#python3

# http://www.phy.pku.edu.cn/climate/class/cm2010/CM06-GCM-applications.pdf
'''正则化表达'''
# <a[^>]*href=['\"]?([^'\"]*)['\"]?  

# 爬下一页的办法是：1，定位到下一页的标签，用selenium中的click来模拟点击事件，再获取下一页的源码
# 2.用正则获取下一页的href链接，再用requests打开这一页获取源码


import os
# import re
import requests
from bs4 import BeautifulSoup

html = requests.get('http://www.phy.pku.edu.cn/climate/class/class.php').content
soup = BeautifulSoup(html, 'html5lib')
pdf_path = soup.find_all('a')    # findAll("a",  href=re.compile("xxxxx"))
url_path = 'http://www.phy.pku.edu.cn/climate/class/'
for item in pdf_path:
    url = item['href']
    full_path = url_path + url
    name = item.get_text()
    # file_name = name + re.findall('/(.*)',url)
    file_name = name + url.rsplit('/', 1)[1]
    # print(name, url)
    print('Go to Download...')
    # print(full_path)
    print('file name:' + file_name)
    r = requests.get(full_path)
    try:
        with open(file_name, "wb") as download:
            download.write(r.content)
    except OSError as e:
        print('[Errno 22] Invalid argument:' + name)
        print('this file fail to be downloaded.')
    finally:
    	print('Out of Download...')



