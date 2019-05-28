from urllib.parse import quote
from urllib import request
import json
import xlwt
 
 
amap_web_key = '6b5cd40b08532294dd9c3e52712dfda1'
poi_search_url = "http://restapi.amap.com/v3/place/text"
poi_boundary_url = "https://ditu.amap.com/detail/get/detail"
 
#¸ù¾Ý³ÇÊÐÃû³ÆºÍ·ÖÀà¹Ø¼ü×Ö»ñÈ¡poiÊý¾Ý
def getpois(cityname, keywords):
    i = 1
    poilist = []
    while True : #Ê¹ÓÃwhileÑ­»·²»¶Ï·ÖÒ³»ñÈ¡Êý¾Ý
       result = getpoi_page(cityname, keywords, i)
       result = json.loads(result)  # ½«×Ö·û´®×ª»»Îªjson
       if result['count'] == '0':
           break
       hand(poilist, result)
       i = i + 1
    return poilist
 
#Êý¾ÝÐ´Èëexcel
def write_to_excel(poilist, cityname, classfield):
    # Ò»¸öWorkbook¶ÔÏó£¬Õâ¾ÍÏàµ±ÓÚ´´½¨ÁËÒ»¸öExcelÎÄ¼þ
    book = xlwt.Workbook(encoding='utf-8', style_compression=0)
    sheet = book.add_sheet(classfield, cell_overwrite_ok=True)
    #µÚÒ»ÐÐ(ÁÐ±êÌâ)
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
    sheet.write(0, 11, 'boundary')
    for i in range(len(poilist)):
        # ¸ù¾ÝpoiµÄid»ñÈ¡±ß½çÊý¾Ý
        bounstr =''
        bounlist = getBounById(poilist[i]['id'])
        if(len(bounlist) > 1):
            bounstr = str(bounlist)
        #Ã¿Ò»ÐÐÐ´Èë
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
        sheet.write(i + 1, 11, bounstr)
    # ×îºó£¬½«ÒÔÉÏ²Ù×÷±£´æµ½Ö¸¶¨µÄExcelÎÄ¼þÖÐ
    book.save(r'd:\\' + cityname +'.xls')
 
#½«·µ»ØµÄpoiÊý¾Ý×°Èë¼¯ºÏ·µ»Ø
def hand(poilist, result):
    #result = json.loads(result)  # ½«×Ö·û´®×ª»»Îªjson
    pois = result['pois']
    for i in range(len(pois)) :
        poilist.append(pois[i])
 
#µ¥Ò³»ñÈ¡pois
def getpoi_page(cityname, keywords, page):
    req_url = poi_search_url + "?key=" + amap_web_key + '&extensions=all&keywords=' + quote(keywords) + '&city=' + quote(cityname) + '&citylimit=true' + '&offset=25' + '&page=' + str(page) + '&output=json'
    data = ''
    with request.urlopen(req_url) as f:
        data = f.read()
        data = data.decode('utf-8')
    return data
 
#¸ù¾Ýid»ñÈ¡±ß½çÊý¾Ý
def getBounById (id):
    req_url = poi_boundary_url + "?id=" + id
    with request.urlopen(req_url) as f:
        data = f.read()
        data = data.decode('utf-8')
        dataList = []
        datajson = json.loads(data)  # ½«×Ö·û´®×ª»»Îªjson
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
                f1 = float(i.split(',')[0])
                innerList.append(float(i.split(',')[0]))
                innerList.append(float(i.split(',')[1]))
                dataList.append(innerList)
        return dataList
 
 
#»ñÈ¡³ÇÊÐ·ÖÀàÊý¾Ý
cityname = "Öéº£"
classfiled = "´óÑ§"
pois = getpois(cityname, classfiled)
 
#将数据写入excel
write_to_excel(pois, cityname, classfiled)
print('写入成功')
 
#根据获取到的poi数据的id获取边界数据
#dataList = getBounById('B02F4027LY')
#print(type(dataList))
 
#print(str(dataList))
'''
  返回的边界数据格式--方便高德地图前端展示
  [[113.559199, 22.239364], [113.559693, 22.238274], [113.55677, 22.237162], 
  [113.557008, 22.236653], [113.555582, 22.236117], [113.555747, 22.235742], 
  [113.555163, 22.235538], [113.555027, 22.235831], [113.554934, 22.235875], 
  [113.554088, 22.235522], [113.553919, 22.235885], [113.553905, 22.235961], 
  [113.556167, 22.236835], [113.55561, 22.238172], [113.55494, 22.237933], 
  [113.554607, 22.238652], [113.554593, 22.238697], [113.554597, 22.238765], 
  [113.554614, 22.238834], [113.554646, 22.238885], [113.558612, 22.240406], 
  [113.558799, 22.240258], [113.559199, 22.239364]] 
'''
