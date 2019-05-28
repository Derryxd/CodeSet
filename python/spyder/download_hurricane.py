# -*- coding: utf-8 -*-
"""
Created on Tue Nov 13 12:03:07 2018

@author: ldz
"""

#import os
import re
import requests
from bs4 import BeautifulSoup

num = 714  #页数
p = re.compile("href=['\"]?([^'\"]*)['\"]?") 
root = "http://weather.unisys.com"
web = "http://weather.unisys.com/hurricanes/search?field_ocean_target_id=All&year[2]=All&category=All&type=All&items_per_page=12&page="
for i in range(num):
    html = requests.get(web+str(i)).content
    soup = BeautifulSoup(html, 'html.parser')

    fw = open('0.txt','w')
    fw.writelines(str(soup))
    fw.close()

    src = []
    fr= open('0.txt','r')
    for item in fr.readlines():
        if 'bookmark' in item:
            src.append(item)
    fr.close()  
    
          
    for j in range(len(src)):
        hrc = p.findall(src[j])[0]
        html = requests.get(root+hrc).content
        soup = BeautifulSoup(html, 'html.parser')
        fw = open('00.txt','w')
        fw.writelines(str(soup))
        fw.close()

        fr= open('00.txt','r')
        name = hrc.split('/')
        file_name = name[-3] + '_' + name[-2] + '_' + name[-1] + '.dat'
        for line in fr.readlines():
            if 'download?token' in line:
                dl = p.findall(line)[0]  #full path of download source
                print('Go to Download...')
                # print(full_path)
                print('hurricane name:' + file_name)
                r = requests.get(root + dl)
                try:
                    with open(file_name, "wb") as download:
                        download.write(r.content)
                except OSError as e:
                    print('[Errno 22] Invalid argument:' + name[-1])
                    print('this hurricane fail to be downloaded.')
                finally:
                	print('Out of Download...')
        fr.close()  
