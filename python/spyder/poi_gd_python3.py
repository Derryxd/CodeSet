# -*- coding: utf-8 -*-

from urllib.parse import quote
from urllib import request
import json
import xlwt
from xlrd import open_workbook
from xlutils.copy import copy
 
# TODO
amap_web_key = '6b5cd40b08532294dd9c3e52712dfda1'
filename = r'E:\360data\重要数据\桌面\Program Set\python\download\wj.xls'
cityname = "武进区"
classfiled = "村庄级地名"
 
poi_search_url = "http://restapi.amap.com/v3/place/text"
poi_boundary_url = "https://ditu.amap.com/detail/get/detail"
 
 
# 根据城市名称和分类关键字获取poi数据
def getpois(cityname, keywords):
    i = 1
    poilist = []
    while True:  # 使用while循环不断分页获取数据
        result = getpoi_page(cityname, keywords, i)
        result = json.loads(result)  # 将字符串转换为json
        if result['status'] is not '1':
            return
        if len(result['pois']) < 25:
            hand(poilist, result)
            write_to_excel(poilist, cityname, keywords)
            break
        hand(poilist, result)
        if i == 1:
            write_to_excel(poilist, cityname, keywords)
        else:
            contact_read_excel(poilist)
        i = i + 1
    return poilist
 
 
# 追加数据到excel中
def contact_read_excel(poilist):
    rexcel = open_workbook(filename)  # 用wlrd提供的方法读取一个excel文件
    rows = rexcel.sheets()[0].nrows  # 用wlrd提供的方法获得现在已有的行数
    excel = copy(rexcel)  # 用xlutils提供的copy方法将xlrd的对象转化为xlwt的对象
    table = excel.get_sheet(0)  # 用xlwt对象的方法获得要操作的sheet
    print('原有的行', rows)
    for i in range(len(poilist)):
        table.write(rows + i, 0, poilist[i]['id'])
        table.write(rows + i, 1, poilist[i]['name'])
        table.write(rows + i, 2, poilist[i]['location'])
        table.write(rows + i, 3, poilist[i]['pname'])
        table.write(rows + i, 4, poilist[i]['pcode'])
        table.write(rows + i, 5, poilist[i]['cityname'])
        table.write(rows + i, 6, poilist[i]['citycode'])
        table.write(rows + i, 7, poilist[i]['adname'])
        table.write(rows + i, 8, poilist[i]['adcode'])
        table.write(rows + i, 9, poilist[i]['address'])
        table.write(rows + i, 10, poilist[i]['type'])
    excel.save(filename)  # xlwt对象的保存方法，这时便覆盖掉了原来的excel
 
#数据写入excel
def write_to_excel(poilist, cityname, classfield):
    # 一个Workbook对象，这就相当于创建了一个Excel文件
    book = xlwt.Workbook(encoding='utf-8', style_compression=0)
    sheet = book.add_sheet(classfield, cell_overwrite_ok=True)
    #第一行(列标题)
    sheet.write(0, 0, 'id')
    sheet.write(0, 1, 'name')
    sheet.write(0, 2, 'location')
    sheet.write(0, 3, 'pname')
    sheet.write(0, 4, 'pcode')
    sheet.write(0, 5, 'cityname')
    sheet.write(0, 6, 'citycode')
    sheet.write(0, 7, 'adname')
    sheet.write(0, 8, 'adcode')
    sheet.write(0, 9, 'address')
    sheet.write(0, 10, 'type')
#    sheet.write(0, 11, 'boundary')
    for i in range(len(poilist)):
        # 根据poi的id获取边界数据
#        bounstr =''
#        bounlist = getBounById(poilist[i]['id'])
#        if(len(bounlist) > 1):
#            bounstr = str(bounlist)
        #每一行写入
        sheet.write(i + 1, 0, poilist[i]['id'])
        sheet.write(i + 1, 1, poilist[i]['name'])
        sheet.write(i + 1, 2, poilist[i]['location'])
        sheet.write(i + 1, 3, poilist[i]['pname'])
        sheet.write(i + 1, 4, poilist[i]['pcode'])
        sheet.write(i + 1, 5, poilist[i]['cityname'])
        sheet.write(i + 1, 6, poilist[i]['citycode'])
        sheet.write(i + 1, 7, poilist[i]['adname'])
        sheet.write(i + 1, 8, poilist[i]['adcode'])
        sheet.write(i + 1, 9, poilist[i]['address'])
        sheet.write(i + 1, 10, poilist[i]['type'])
#        sheet.write(i + 1, 11, bounstr)
    # 最后，将以上操作保存到指定的Excel文件中
    book.save(r'E:\360data\重要数据\桌面\Program Set\python\download\\' + cityname +'.xls')
 
 
# 将返回的poi数据装入集合返回
def hand(poilist, result):
    # result = json.loads(result)  # 将字符串转换为json
    pois = result['pois']
    for i in range(len(pois)):
        poilist.append(pois[i])
 
 
# 单页获取pois
def getpoi_page(cityname, keywords, page):
    req_url = poi_search_url + "?key=" + amap_web_key + '&extensions=all&keywords=' + quote(
        keywords) + '&city=' + quote(cityname) + '&citylimit=true' + '&offset=25' + '&page=' + str(
        page) + '&output=json'
    data = ''
    with request.urlopen(req_url) as f:
        data = f.read()
        data = data.decode('utf-8')
    return data

#根据id获取边界数据
def getBounById (id):
    req_url = poi_boundary_url + "?id=" + id
    with request.urlopen(req_url) as f:
        data = f.read()
        data = data.decode('utf-8')
        dataList = []
        datajson = json.loads(data)  # 将字符串转换为json
        datajson = datajson['data']
        datajson = datajson['spec']
        if len(datajson) == 1:
            return  dataList
        if datajson.get('mining_shape') != None:
            datajson = datajson['mining_shape']
            shape = datajson['shape']
            dataArr = shape.split(';')

            for i in dataArr:
                innerList = []
#                f1 = float(i.split(',')[0])
                innerList.append(float(i.split(',')[0]))
                innerList.append(float(i.split(',')[1]))
                dataList.append(innerList)
        return dataList
 
if __name__ == "__main__": 
    # 获取城市分类数据
    pois = getpois(cityname, classfiled)
    print('写入成功')
    
    #根据获取到的poi数据的id获取边界数据
    #dataList = getBounById('B02F4027LY')
    #print(type(dataList))
    
    #print(str(dataList))