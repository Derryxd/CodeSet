# -*- coding: utf-8 -*-
"""
Created on Thu Sep  6 20:27:10 2018
整理自：https://www.cnblogs.com/denny402/
@author: ldz
"""
# =============================================================================
'''
pillow包
标号 行号   内容
1   021  图片的打开与显示
2   039  图像通道\几何变换\裁剪
3   103  添加水印
4   122  图像中的像素访问
5   161  图像直方图
'''
# =============================================================================
from PIL import Image, ImageDraw,ImageFont
import matplotlib.pyplot as plt
import numpy as np
# =============================================================================
'''一、图片的打开与显示：'''
# =============================================================================
img = Image.open('dog.jpg')
#img.show()
plt.figure("dog")
plt.imshow(img)
plt.show()
#plt.axis('off')
print (img.size)  #图片的尺寸
print (img.mode ) #图片的模式
print (img.format)  #图片的格式
#img.save('dog_saved1.jpg')
'''imshow()函数格式为：
matplotlib.pyplot.imshow(X, cmap=None)
X: 要绘制的图像或数组。cmap: 颜色图谱（colormap), 默认绘制为RGB(A)颜色空间。'''
im  = np.array(img)
Img = Image.fromarray(im.astype('uint8')).convert('RGB')
# =============================================================================
'''二、图像通道\几何变换\裁剪'''
# =============================================================================
'''1、彩色图像转灰度图'''
gray_L = img.convert('L')
gray = np.array(gray_L)   #不转化为数值会报错，这点没弄明白
## 手动设置函数转化为灰度图：
#def rgb2gray(img):
#    rgb = np.array(img)
#    return np.dot(rgb[...,:3], [0.299, 0.587, 0.114])
#gray = rgb2gray(img)   
plt.figure("gray_dog")
plt.imshow(gray,cmap='gray')
#plt.imshow(gray, cmap=plt.get_cmap('gray_r'))
#plt.imshow(gray, cmap='gray_r')
#plt.axis('off')
#plt.show()
gray_L.save('dog_saved2.jpg')  #转为array的gray没有save的属性
'''2、通道分离与合并'''
r,g,b=img.split()   #分离三通道
pic_Merge=Image.merge('RGB',(r,g,b)) #合并三通道
r=np.array(r)
g=np.array(g)
b=np.array(b)
pic = np.array(pic_Merge)
plt.figure("channels")
plt.subplot(2,3,1), plt.title('origin')
plt.imshow(img),plt.axis('off')
plt.subplot(2,3,2), plt.title('gray')
plt.imshow(gray,cmap='gray'),plt.axis('off')
plt.subplot(2,3,3), plt.title('merge')
plt.imshow(pic),plt.axis('off')
plt.subplot(2,3,4), plt.title('r')
plt.imshow(r,cmap='gray'),plt.axis('off')
plt.subplot(2,3,5), plt.title('g')
plt.imshow(g,cmap='gray'),plt.axis('off')
plt.subplot(2,3,6), plt.title('b')
plt.imshow(b,cmap='gray'),plt.axis('off')
plt.savefig('dog_saved3.jpg')
plt.show()
'''3、图片裁剪:
从原图片中裁剪感兴趣区域（roi),裁剪区域由4-tuple决定，
该tuple中信息为(left, upper, right, lower)。
Pillow左边系统的原点（0，0）为图片的左上角。坐标中的数字单位为像素点。'''
plt.figure("crop")
plt.subplot(1,2,1), plt.title('origin')
plt.imshow(img),plt.axis('off')
box=(80,100,280,320)
roi=img.crop(box)
plt.subplot(1,2,2), plt.title('roi')
plt.imshow(roi),plt.axis('off')
plt.show()
'''4、Image类有resize()、rotate()和transpose()方法进行几何变换
transpose()和rotate()没有性能差别。'''
dst1 = img.resize((128, 128))
dst2 = img.rotate(45) # 顺时针角度表示
dst3 = img.transpose(Image.FLIP_LEFT_RIGHT) #左右互换
dst4 = img.transpose(Image.FLIP_TOP_BOTTOM) #上下互换
dst5 = img.transpose(Image.ROTATE_90)  #顺时针旋转
dst6 = img.transpose(Image.ROTATE_180)
dst7 = img.transpose(Image.ROTATE_270)
plt.figure("transform")
plt.imshow(dst1),plt.axis('off')
plt.show()
# =============================================================================
'''三、添加水印'''
# =============================================================================
'''1、添加文字水印'''
im2 = Image.open("dog.jpg").convert('RGBA')
txt=Image.new('RGBA', im2.size, (0,0,0,0))
fnt=ImageFont.truetype("c:/Windows/fonts/Tahoma.ttf", 20) #设置字体样式
d=ImageDraw.Draw(txt)
d.text((txt.size[0]-80,txt.size[1]-30), "cnBlogs",font=fnt, fill=(255,255,255,255))
out=Image.alpha_composite(im2, txt)
plt.figure('watermark')
plt.imshow(out)
#out.show()
'''2、添加小图片水印'''
#mark=Image.open("d:/logo_small.gif")
#layer=Image.new('RGBA', im.size, (0,0,0,0))
#layer.paste(mark, (im.size[0]-150,im.size[1]-60))
#out=Image.composite(layer,im,layer)
#out.show()
# =============================================================================
'''四、图像中的像素访问'''
# =============================================================================
print( im.shape ) 
print( im.dtype )
print( im.size )
print( type(im))
'''1、添加椒盐噪声'''
#随机生成5000个椒盐
rows,cols,dims=im.shape
for i in range(5000):
    x=np.random.randint(0,rows)
    y=np.random.randint(0,cols)
    im[x,y,:]=255
plt.figure("Salt And Pepper Noise")
plt.imshow(im)
plt.axis('off')
plt.show()
'''2、将lena图像二值化，像素值大于128的变为1，否则变为0'''
rows,cols=gray.shape
for i in range(rows):
    for j in range(cols):
        if (gray[i,j]<=128):
            gray[i,j]=0
        else:
            gray[i,j]=1
plt.figure("Binaryzation")
plt.imshow(gray,cmap='gray')
plt.axis('off')
plt.show()
'''如果要对多个像素点进行操作，可以使用数组切片方式访问。
切片方式返回的是以指定间隔下标访问 该数组的像素值。下面是有关灰度图像的一些例子：'''
#img3[i,:] = im[j,:] # 将第 j 行的数值赋值给第 i 行
#img3[:,i] = 100 # 将第 i 列的所有数值设为 100
#img3[:100,:50].sum() # 计算前 100 行、前 50 列所有数值的和
#img3[50:100,50:100] # 50~100 行，50~100 列（不包括第 100 行和第 100 列）
#img3[i].mean() # 第 i 行所有数值的平均值
#img3[:,-1] # 最后一列
#img3[-2,:] (or im[-2]) # 倒数第二行
# =============================================================================
'''五、图像直方图'''
# =============================================================================
'''0、使用reshape和flatten进行一、二维之间的转换'''
'''1、灰度直方图
n, bins, patches = plt.hist(arr, bins, normed, facecolor, alpha)
hist的参数非常多，但常用的就这五个，只有第一个是必须的，后面四个可选
arr: 需要计算直方图的一维数组
bins: 直方图的柱数，可选项，默认为10
normed: 是否将得到的直方图向量归一化。默认为0
facecolor: 直方图颜色
alpha: 透明度
返回值 ：
n: 直方图向量，是否归一化由参数设定
bins: 返回各个bin的区间范围
patches: 返回每个bin里面包含的数据，是一个list'''
img=np.array(Image.open('dog.jpg').convert('L'))
plt.figure("hist1")
arr = img.flatten()
n, bins, patches = plt.hist(arr, bins=256, normed=1, facecolor='green', alpha=0.75)  
plt.show()
'''2、彩色直方图'''
src=Image.open('dog.jpg')
r,g,b=src.split()
plt.figure("hist2")
ar=np.array(r).flatten()
plt.hist(ar, bins=256, normed=1,facecolor='r',edgecolor='r',hold=1)
ag=np.array(g).flatten()
plt.hist(ag, bins=256, normed=1, facecolor='g',edgecolor='g',hold=1)
ab=np.array(b).flatten()
plt.hist(ab, bins=256, normed=1, facecolor='b',edgecolor='b')
plt.show()














