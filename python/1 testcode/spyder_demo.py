# -*- coding: utf-8 -*-
"""
Created on Wed Nov 15 23:03:11 2017

@author: ldz
"""



#import urllib3
#字典的另一种定义方式

"""
values = {}
values['username'] = "1016903103@qq.com"
values['password'] = "XXXX" 
"""

'''
url = 'http://www.server.com/login'
user_agent = 'Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)'  
values = {'username' : 'Derrys',  'password' : 'xxx' }  
headers = { 'User-Agent' : 'Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)'  ,
                        'Referer':'http://www.zhihu.com/articles' }
data = urllib3.encode_multipart_formdata(values)  
request = urllib3.request(url, data, headers)  
response = urllib3.urlopen(request)  
page = response.read()
print(response.read())
'''
import urllib.request
with urllib.request.urlopen('http://www.python.org/') as f:
    print(f.read(300))

