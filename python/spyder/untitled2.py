# -*- coding: utf-8 -*-
"""
Created on Mon Nov 26 18:39:15 2018

@author: ldz
"""

i = 1
current_polygon_poi_list = []
while True:  # 使用while循环不断分页获取数据
    result = getpoi_page(cut.Url, cut.polygon, i, type_list)
    result = json.loads(result)  # 将字符串转换为json
    #print('第', str(i),'页，结果',result)
    if result['status'] is not '1':  # 接口返回的状态不是1代表异常
        print('======爬取错误，返回数据：' + json.dumps(result) )
        break
    pois = result['pois']
    if len(pois) < offset:  # 返回的数据不足分页页大小，代表数据爬取完
        current_polygon_poi_list.extend(pois)
        break
    current_polygon_poi_list.extend(pois)
    i += 1
print('===========当前polygon：', polygon,',爬取到的数据数量：' ,str(len(current_polygon_poi_list)))
#    return current_polygon_poi_lis