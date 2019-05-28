# -*- coding: utf-8 -*-
"""
Created on Mon Nov 26 10:43:38 2018

@author: HuiShui
"""

"""
通过高德地图爬取POI数据-分割中国地块
由于高德矩形获取POI智能返回10000条数据，
所以将中国地图版块分割成小与1000的矩形框
"""
import requests
import time
import json
from urllib import request
import xlwt

#矩形框
class Rect:
    def __init__(self,xmin,ymin,xmax,ymax):
        self.xmin = xmin;
        self.ymin = ymin;
        self.xmax = xmax;
        self.ymax = ymax;

class Cut:
    def __init__(self):
        self.typelist = type_list;
        self.polygon=[];
        self.polygon_list=[]; # 矩形边界集合
        self.key=amap_web_key;
        self.filePath="E:\矩形区域.txt";
        #self.Url="http://restapi.amap.com/v3/place/polygon?polygon=108.640287,26.043184;110.579374,27.275355&key=dc44a8ec8db3f9ac82344f9aa536e678&extensions=all&offset=5&page=1";
        self.Url = "http://restapi.amap.com/v3/place/polygon?polygon=";
    #切分地块
    def CutChina(self,rect):
        url=self.Url;
        url=self.Url+str(rect.xmin)+","+str(rect.ymin)+","+str(rect.xmax)+","+str(rect.ymax) + '&types=' + self.typelist +'&key='+self.key+"&extensions=all&offset=25&page=1"
        print(url);
        data=self.DownHtml(url=url);
        jsonData=json.loads(data)
        count=int(jsonData["count"])
        print(count);
        if count<900:
            self.polygon=str(rect.xmin)+","+str(rect.ymin)+","+str(rect.xmax)+","+str(rect.ymax);
            self.polygon_list.append(self.polygon)
            file=open(self.filePath,"a")
            file.writelines(str(rect.xmin)+","+str(rect.ymin)+","+str(rect.xmax)+","+str(rect.ymax)+"\n");
            file.close();
            print("写入数据");
        else:
            middleX=(rect.xmin+rect.xmax)/2;
            middleY = (rect.ymin + rect.ymax) / 2;
            rect1 = Rect(xmin=rect.xmin,ymin=rect.ymin,xmax=middleX,ymax=middleY);
            rect2 = Rect(xmin=middleX, ymin=rect.ymin, xmax=rect.xmax, ymax=middleY);
            rect3 = Rect(xmin=rect.xmin, ymin=middleY, xmax=middleX, ymax=rect.ymax);
            rect4 = Rect(xmin=middleX, ymin=middleY, xmax=rect.xmax, ymax=rect.ymax);
            #使用递归调用
            time.sleep(1)  # 休眠1秒
            self.CutChina(rect=rect1);
            time.sleep(1)  # 休眠1秒
            self.CutChina(rect=rect2);
            time.sleep(1)  # 休眠1秒
            self.CutChina(rect=rect3);
            time.sleep(1)  # 休眠1秒
            self.CutChina(rect=rect4);
    #下载数据
    def DownHtml(self,url):
        request = requests.get(url=url, timeout=(5, 27));
        html = request.text;
        request.close();
        return html;
    
# 根据矩形坐标获取poi数据
def getpois(Url, polygon, type_list):
    i = 1
    current_polygon_poi_list = []
    while True:  # 使用while循环不断分页获取数据
        result = getpoi_page(Url, polygon, i, type_list)
        result = json.loads(result)  # 将已编码的 JSON 字符串解码为 Python 对象，result此时数据结构为dict
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
    return current_polygon_poi_list

# 单页获取pois
def getpoi_page(Url, polygon, page, type_list):
    req_url = Url  + polygon + "&key=" + amap_web_key + '&extensions=all' + '&offset=' + str(offset) + '&types=' + type_list + '&page=' + str(page) + '&output=json'
    print(req_url)
    data = ''
    with request.urlopen(req_url) as f:
        data = f.read()
        data = data.decode('utf-8')
    return data
 
# 数据写入excel
def write_to_excel(poilist, filename):
    # 一个Workbook对象，这就相当于创建了一个Excel文件
    book = xlwt.Workbook(encoding='utf-8', style_compression=0)
    sheet = book.add_sheet('0', cell_overwrite_ok=True)
    # 第一行(列标题)
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
    for i in range(len(poilist)):
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
    book.save(filename)
 
if __name__=="__main__":
    
    #初始化
    amap_web_key='0b2d45f781cc4db42543d7f1189d295e'; #高德地图官网申请的Web API KEY
    poi_search_url = "http://restapi.amap.com/v3/place/polygon"  # URL
    offset=25; # 分页请求数据时的单页大小
    filename = r'E:\22.xls'   #爬取到的数据写入的EXCEL路径
#    # POI分类集合
#    #class_list = ['医院']
#    #type_list = '090000|090100|090101|090102|090200|090201|090202|090203|090204|090205|090206|090207|090208|090209|090210|090211'
#    #type_list = '090000|090100|090101|090102|090200|090201|090202|090203|090204|090205|090206|090207|090208|090209|090210|090211|090300|090400|090500|090600|090601|090602|090700|090701|090702'
#    #class_list = ['村子']
#    type_list = '190108|190109'
#    #class_list = ['学校']
#    #type_list = '140000|140100|140101|140102|140200|140201|140300|140400|140500|140600|140700|140800|140900|141000|141100|141101|141102|141103|141104|141105|141200|141201|141202|141203|141204|141205|141206|141207|141300|141400|141500'
#    #class_list = ['交通设施']
#    #type_list = '150000|150100|150101|150102|150104|150105|150106|150107|150200|150201|150202|150203|150204|150205|150206|150207|150208|150209|150210|150300|150301|150302|150303|150304|150400|150500|150501|150600|150700|150701|150702|150703|150800|150900|150903|150904|150905|150906|150907|150908|150909|151000|151100|151200|151300'
#    #class_list = ['公司企业']
#    #type_list = '170000|170100|170200|170201|170202|170203|170204|170205|170206|170207|170208|170209|170300|170400|170401|170402|170403|170404|170405|170406|170407|170408'
#    cut = Cut();
#    #开始先创建矩形存储文件
#    file=open(cut.filePath,"w+");
#    file.writelines("xmin,ymin,xmax,ymax\n");
#    file.close();
#    #开始分割中国区域
#    rect=Rect(xmin=119.626,ymin=31.38,xmax=120.21,ymax=31.84);
#    cut.CutChina(rect);
#    print("程序完成结束")
    
    all_poi_list = [] #爬取到的所有数据
 
    for polygon in cut.polygon_list:
        polygon_poi_list = getpois(cut.Url, polygon, type_list)
        all_poi_list.extend(polygon_poi_list)
     
    print('爬取完成,总的数量', len(all_poi_list))
    write_to_excel(all_poi_list, filename)
    print('写入成功')
    


    