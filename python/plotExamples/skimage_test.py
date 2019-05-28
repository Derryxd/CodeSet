# -*- coding: utf-8 -*-
"""
Created on Fri Sep  7 15:52:49 2018
整理自：https://www.cnblogs.com/denny402/
@author: ldz
"""
# =============================================================================
'''
skimage包
标号  行号   内容
1    0043  	图片的打开、显示与保存
2    0067  	图像像素的访问与裁剪
3    0118  	图像数据类型及颜色空间转换
4    0147  	图像的批量处理
5    0200  	图像的形变与缩放
6    0255  	对比度与亮度调整
7    0320  	直方图与均衡化
8    0331  	图像简单滤波
9    0446  	图像自动阈值分割
10   0479 	基本图形的绘制
11   0542	基本形态学滤波
12   0628	高级滤波
13   0693	霍夫线变换
14   0754	霍夫圆和椭圆变换
15   0840	边缘与轮廓
16   0925	高级形态学处理
17   1010	骨架提取与分水岭算法
'''
# =============================================================================
from skimage import io,data,data_dir,color,transform,exposure
from skimage import filters,feature,draw,morphology,measure,segmentation
from skimage.morphology import disk
from skimage.filters import rank
import skimage.morphology as sm
import scipy.ndimage
#from skimage.viewer import ImageViewer
import matplotlib.pyplot as plt
import matplotlib.patches
from copy import deepcopy
import numpy as np
import skimage as ski
# =============================================================================
print('''一、图片的打开、显示与保存''')
# =============================================================================
img0=io.imread('dog.jpg',as_grey=True)
plt.figure('dog')
io.imshow(img0)
img=data.chelsea()
print('图片相关属性:')
print(data_dir)
print(type(img))     #显示类型
print(img.shape)     #显示尺寸
print(img.shape[0])  #图片宽度
print(img.shape[1])  #图片高度
print(img.shape[2])  #图片通道数
print(img.size)   #显示总像素个数
print(img.max())  #最大像素值
print(img.min())  #最小像素值
print(img.mean()) #像素平均值
plt.figure('cat1')
io.imshow(img)
io.imsave('chelsea.jpg',img)
#viewer = ImageViewer(img)  #利用Qt工具来创建一块画布，从而在画布上绘制图像。
#plt.figure('cat2')
#viewer.show()
# =============================================================================
print('''二、图像像素的访问与裁剪''')
# =============================================================================
'''例1：输出小猫图片的G通道中的第20行30列的像素值'''
pixel=img[20,30,1]
print('输出具体像素值：')
print(pixel)
'''例2：显示红色单通道图片'''
R=img[:,:,0]
plt.figure('cat_R')
io.imshow(R)
'''例3：对小猫图片随机添加椒盐噪声'''
rows,cols,dims=img.shape
img_noise = deepcopy(img)  
'''使用深拷贝，防止后面的img都受到椒盐噪声污染'''
for i in range(5000):
    x=np.random.randint(0,rows)
    y=np.random.randint(0,cols)
    img_noise[x,y,:]=255
plt.figure('cat_Noise')    
io.imshow(img_noise)
'''例4：对小猫图片进行裁剪'''
roi=img[80:180,100:200,:]
plt.figure('cat_roi')  
io.imshow(roi)
'''对多个像素点进行操作，使用数组切片方式访问。切片方式返回的是以指定间隔下标访问该数组的像素值。
下面是有关灰度图像的一些例子:'''
#img[i,:] = im[j,:] # 将第 j 行的数值赋值给第 i 行
#img[:,i] = 100 # 将第 i 列的所有数值设为 100
#img[:100,:50].sum() # 计算前 100 行、前 50 列所有数值的和
#img[50:100,50:100] # 50~100 行，50~100 列（不包括第 100 行和第 100 列）
#img[i].mean() # 第 i 行所有数值的平均值
#img[:,-1] # 最后一列
#img[-2,:] (or im[-2]) # 倒数第二行
'''例5：将lena图片进行二值化，像素值大于128的变为1，否则变为0'''
img_gray=color.rgb2gray(img) # 转换结果为float64类型的数组，范围为[0,1]之间的灰度图
rows,cols=img_gray.shape
for i in range(rows):
    for j in range(cols):
        if (img_gray[i,j]<=0.5):
            img_gray[i,j]=0
        else:
            img_gray[i,j]=1
plt.figure('cat_binary')              
io.imshow(img_gray)
'''例6:先对R通道的所有像素值进行判断
如果大于170，则将这个地方的像素值变为[0,255,0], 即G通道值为255，R和B通道值为0。'''
reddish = img[:, :, 0] >170
img[reddish] = [0, 255, 0]
plt.figure('cat_ind')  
io.imshow(img)
# =============================================================================
print('''三、图像数据类型及颜色空间转换''')
# =============================================================================
'''1、转化数据类型：如float转uint8'''
img2 = np.array([0, 0.5, 1], dtype=float)
print('读取图片的数据类型：')
print(img2.dtype.name)
dst=ski.img_as_ubyte(img2)
print(dst.dtype.name)
'''2、颜色空间及其转换：(各种xx2xx)
转换函数，表示将arr从fromspace颜色空间转换到tospace颜色空间'''
hsv=color.convert_colorspace(img,'RGB','HSV')
plt.figure('cat_hsv')  
io.imshow(hsv)
'''3、根据标签值对图片进行着色:
skimage.color.label2rgb(arr)，将lena图片分成三类，然后用默认颜色对三类进行着色'''
gray=color.rgb2gray(img)
rows,cols=gray.shape
labels=np.zeros([rows,cols])
for i in range(rows):
    for j in range(cols):
        if(gray[i,j]<0.4):
            labels[i,j]=0
        elif(gray[i,j]<0.75):
            labels[i,j]=1
        else:
            labels[i,j]=2
dst=color.label2rgb(labels)
io.imshow(dst)
# =============================================================================
print('''四、图像的批量处理''')
# =============================================================================
'''1、批量读取同一种格式的图片'''
str=data_dir + '/*.png'
coll = io.ImageCollection(str)
print('图片集合数目：')
print(len(coll))
#显示结果为25, 说明系统自带了25张png的示例图片，这些图片都读取了出来，放在图片集合coll里。
#如果我们想显示其中一张图片，则可以在后加上一行代码：
plt.figure('batch')  
io.imshow(coll[10])
plt.title('batch')
'''2、批量读取混合种格式的图片：使用冒号'''
str='*.jpg : *.png'
coll = io.ImageCollection(str)
print(len(coll))
'''3、批量转换为灰度图'''
def convert_gray(f):
    rgb=io.imread(f)
    return color.rgb2gray(rgb)
str=data_dir+'/*.jpg'
coll = io.ImageCollection(str,load_func=convert_gray)
plt.figure('batch_gray')  
io.imshow(coll[1])
plt.title('batch_gray')
'''3、将myvideo.avi这个视频中每隔10帧的图片读取出来，放在图片集合中'''
#class AVILoader:
#    video_file = 'myvideo.avi'
#    def __call__(self, frame):
#        return video_read(self.video_file, frame)
#avi_load = AVILoader()
#frames = range(0, 1000, 10) # 0, 10, 20, ...
#ic =io.ImageCollection(frames, load_func=avi_load)
'''4、连接图片，构成一个维度更高的数组'''
#coll = io.ImageCollection('*.jpg')
#mat=io.concatenate_images(coll)
#print(len(coll))      #连接的图片数量
#print(coll[0].shape)   #连接前的图片尺寸，所有的都一样
'''使用concatenate_images(ic)函数的前提是读取的这些图片尺寸必须一致，否则会出错。'''
#mat=io.concatenate_images(coll)
#print(mat.shape)  #连接后的数组尺寸
'''5、改变图片的大小，批量（循环）保存图片'''
def convert_gray(f):
     rgb=io.imread(f)    #依次读取rgb图片
     gray=color.rgb2gray(rgb)   #将rgb图片转换成灰度图
     dst=transform.resize(gray,(256,256))  #将灰度图片大小转换为256*256
     return dst
pics = data_dir+'/*.jpg'
path = './'
coll = io.ImageCollection(pics,load_func=convert_gray)
for i in range(len(coll)):
    io.imsave(path + np.str(i) + '.jpg',coll[i])  #循环保存图片
# =============================================================================
print('''五、图像的形变与缩放''')
# =============================================================================
'''1、改变图片尺寸resize'''
img = data.camera()
dst=transform.resize(img, (80, 60))
plt.figure('resize')
plt.subplot(121)
plt.title('before resize')
plt.imshow(img,plt.cm.gray)
plt.subplot(122)
plt.title('after resize')
plt.imshow(dst,plt.cm.gray)
plt.show()
'''2、按比例缩放rescale'''
print('按比例缩放rescale效果：')
print(img.shape)  #图片原始大小 
print(transform.rescale(img, 0.1).shape)  #缩小为原来图片大小的0.1倍
print(transform.rescale(img, [0.5,0.25]).shape)  #缩小为原来图片行数一半，列数四分之一
print(transform.rescale(img, 2).shape)   #放大为原来图片大小的2倍
'''3、旋转rotate'''
print('旋转rotate效果：')
print(img.shape)  #图片原始大小
img1=transform.rotate(img, 60) #旋转90度，不改变大小 
print(img1.shape)
img2=transform.rotate(img, 30,resize=True)  #旋转30度，同时改变大小
print(img2.shape)   #结果图片被放大了 
plt.figure('resize')
plt.subplot(121)
plt.title('rotate 60')
plt.imshow(img1,plt.cm.gray)
plt.subplot(122)
plt.title('rotate  30')
plt.imshow(img2,plt.cm.gray)
plt.show()
'''4、图像金字塔:
以多分辨率来解释图像的一种有效但概念简单的结构就是图像金字塔。
图像金字塔最初用于机器视觉和图像压缩，一幅图像的金字塔是一系列以金字塔形状排列的分辨率逐步降低的图像集合。
金字塔的底部是待处理图像的高分辨率表示，而顶部是低分辨率的近似。
当向金字塔的上层移动时，尺寸和分辨率就降低。'''
img = data.astronaut()  #载入宇航员图片
rows, cols, dim = img.shape  #获取图片的行数，列数和通道数
pyramid = tuple(transform.pyramid_gaussian(img, downscale=2))  #产生高斯金字塔图像
#共生成了log(512)=9幅金字塔图像，加上原始图像共10幅，pyramid[0]-pyramid[1]
composite_image = np.ones((rows, int(cols + cols/2), 3), dtype=np.double)  #生成背景
composite_image[:rows, :cols, :] = pyramid[0]  #融合原始图像
i_row = 0
for p in pyramid[1:]:
    n_rows, n_cols = p.shape[:2]
    composite_image[i_row:i_row + n_rows, cols:cols + n_cols] = p  #循环融合9幅金字塔图像
    i_row += n_rows
plt.figure('pyramid')
plt.imshow(composite_image)
plt.show()
#除了高斯金字塔，还有其他种类的金字塔，如pyramid_laplacian
# =============================================================================
print('''六、对比度与亮度调整''')
# =============================================================================
'''1、gamma调整:I=I**g'''
image = ski.img_as_float(data.moon())
gam1= exposure.adjust_gamma(image, 2)   #调暗
gam2= exposure.adjust_gamma(image, 0.5)  #调亮
plt.figure('adjust_gamma',figsize=(8,8))
plt.subplot(131)
plt.title('origin image')
plt.imshow(image,plt.cm.gray)
plt.axis('off')
plt.subplot(132)
plt.title('gamma=2')
plt.imshow(gam1,plt.cm.gray)
plt.axis('off')
plt.subplot(133)
plt.title('gamma=0.5')
plt.imshow(gam2,plt.cm.gray)
plt.axis('off')
plt.show()
'''2、log对数调整:I=log(I)'''
result=exposure.is_low_contrast(image)
log1= exposure.adjust_log(image)   #对数调整
plt.figure('adjust_gamma',figsize=(8,8))
plt.subplot(121)
plt.title('origin image')
plt.imshow(image,plt.cm.gray)
plt.axis('off')
plt.subplot(122)
plt.title('log')
plt.imshow(log1,plt.cm.gray)
plt.axis('off')
plt.show()
'''3、判断图像对比度是否偏低'''
result=exposure.is_low_contrast(image)
print('图像对比度是否偏低:')
print(result)
'''4、调整强度'''
#[51, 102, 153]输出为[  0 127 255]
#即像素最小值由51变为0，最大值由153变为255，整体进行了拉伸，但是数据类型没有变，还是uint8
image = np.array([51, 102, 153], dtype=np.uint8)
mat=exposure.rescale_intensity(image)
print('拉伸效果:')
print(mat)
#可以通过img_as_float()函数将unit8类型转换为float型，实际上还有更简单的方法，就是乘以1.0
#而float类型的范围是[0,1]，因此对float进行rescale_intensity 调整后，范围变为[0,1],而不是[0,255]
image = np.array([51, 102, 153], dtype=np.uint8)
print('拉伸效果（结果为float）:')
print(image*1.0)
#如果原始像素值不想被拉伸，只是等比例缩小，就使用in_range参数，如：
image = np.array([51, 102, 153], dtype=np.uint8)
tmp=image*1.0
mat=exposure.rescale_intensity(tmp,in_range=(0,255))
print('等比例缩小:')
print(mat)
#如果参数in_range的[main,max]范围要比原始像素值的范围[min,max] 大或者小，那就进行裁剪，如：
mat=exposure.rescale_intensity(tmp,in_range=(0,102))
print('等比例缩小（裁剪效果）:')
print(mat)
#如果一个数组里面有负数，现在想调整到正数，就使用out_range参数。如：
image = np.array([-10, 0, 10], dtype=np.int8)
mat=exposure.rescale_intensity(image, out_range=(0, 127))
print('调整到正数:')
print(mat)
# =============================================================================
print('''七、直方图与均衡化''')
# =============================================================================
'''1、普通直方图：分别生成两个bin再绘图，每个bin的统计量是一样的，
但numpy返回的是每个bin的两端的范围值，而skimage返回的是每个bin的中间值'''
img =data.astronaut()*1.0
hist1=np.histogram(img, bins=2)   #用numpy包计算直方图
hist2=exposure.histogram(img, nbins=2)  #用skimage计算直方图
# 分成两个bin，每个bin的统计量是一样的，
# 但numpy返回的是每个bin的两端的范围值，而skimage返回的是每个bin的中间
print('numpy和skimage计算的直方图结果')
print(hist1)
print(hist2)
plt.figure("Histogram ")
arr=img.flatten()
n, bins, patches = plt.hist(arr, bins=256, normed=1,edgecolor='None',facecolor='red')  
plt.show()
'''2、彩色图片三通道直方图'''
plt.figure("Histogram _3color",figsize=(8,8))
ar=img[:,:,0].flatten()
plt.hist(ar, bins=256, normed=1,facecolor='r',edgecolor='r',hold=1)
ag=img[:,:,1].flatten()
plt.hist(ag, bins=256, normed=1, facecolor='g',edgecolor='g',hold=1)
ab=img[:,:,2].flatten()
plt.hist(ab, bins=256, normed=1, facecolor='b',edgecolor='b')
plt.show()
'''3、直方图均衡化'''
img=data.moon()
plt.figure("Histogram _Equalization",figsize=(8,8))
arr=img.flatten()
plt.subplot(221)
plt.imshow(img,plt.cm.gray)  #原始图像
plt.subplot(222)
plt.hist(arr, bins=256, normed=1,edgecolor='None',facecolor='red') #原始图像直方图
img1=exposure.equalize_hist(img)
arr1=img1.flatten()
plt.subplot(223)
plt.imshow(img1,plt.cm.gray)  #均衡化图像
plt.subplot(224)
plt.hist(arr1, bins=256, normed=1,edgecolor='None',facecolor='red') #均衡化直方图
plt.show()
# =============================================================================
print('''八、图像简单滤波''')
# =============================================================================
'''1、边缘检测'''
img = data.camera()
plt.figure("edges1_detection",figsize=(8,8))
edges1 = filters.sobel(img)
edges2 = filters.roberts(img)
edges3 = filters.scharr(img)
edges4 = filters.prewitt(img)
plt.subplot(221)
plt.imshow(edges1,plt.cm.gray)
plt.title('sobel')
plt.subplot(222)
plt.imshow(edges2,plt.cm.gray)
plt.title('roberts')
plt.subplot(223)
plt.imshow(edges3,plt.cm.gray)
plt.title('scharr')
plt.subplot(224)
plt.imshow(edges4,plt.cm.gray)
plt.title('prewitt')
fig = plt.figure("edges2_detection",figsize=(8,4))
edges1 = feature.canny(img)   #sigma=1
edges2 = feature.canny(img,sigma=3)   #sigma=3
plt.subplot(121)
plt.imshow(edges1,plt.cm.gray) 
plt.title('sigma=1') 
plt.subplot(122)
plt.imshow(edges2,plt.cm.gray)
plt.title('sigma=3')
fig.suptitle('canny')
plt.show()
'''2、纹理特征提取'''
filt_real, filt_imag = filters.gabor(img,frequency=0.6)   
fig = plt.figure('gabor',figsize=(8,4))
plt.subplot(121)
plt.title('filt_real_freq=0.6')
plt.imshow(filt_real,plt.cm.gray)  
plt.subplot(122)
plt.title('filt-imag_freq=0.6')
plt.imshow(filt_imag,plt.cm.gray)
fig.suptitle('gabor')
plt.show()
'''3、平滑滤波（两种画子图标题的方法）'''
fig = plt.figure('gaussian',figsize=(8,4))
edges1 = filters.gaussian(img,sigma=0.4,multichannel=False)   
edges2 = filters.gaussian(img,sigma=5,multichannel=False)    
ax = fig.add_subplot(121)
plt.imshow(edges1,plt.cm.gray) 
ax.set_title('sigma=0.4')
ax = fig.add_subplot(122) 
plt.imshow(edges2,plt.cm.gray)
ax.set_title('sigma=5')
fig.suptitle('gaussian')
plt.show()
fig = plt.figure('median',figsize=(8,4))
edges1 = filters.median(img,disk(5))
edges2= filters.median(img,disk(9))
plt.subplot(121)
plt.imshow(edges1,plt.cm.gray)  
plt.title('disk(5)')
plt.subplot(122)
plt.imshow(edges2,plt.cm.gray)
plt.title('disk(9)')
fig.suptitle('median')
plt.show()
'''4、水平、垂直、交叉边缘检测（filters）'''
edges1 = filters.sobel_h(img)  
edges2 = filters.sobel_v(img) 
dst =filters.roberts_neg_diag(img) 
plt.figure('Edges_v_h_cross',figsize=(8,8))
plt.subplot(221)
plt.title('horizontal_edge')
plt.imshow(edges1,plt.cm.gray)  
plt.subplot(222)
plt.title('vertical_edge')
plt.imshow(edges2,plt.cm.gray)
plt.subplot(223)
plt.title('origin image')
plt.imshow(img,plt.cm.gray)
plt.subplot(224)
plt.title('cross_edge')
plt.imshow(dst,plt.cm.gray)
plt.show()
# =============================================================================
print('''九、图像自动阈值分割''')
# =============================================================================
'''1、分别基于Otsu、Yen、Li的阈值分割方法'''
image = data.camera()
plt.figure('thresh',figsize=(8,12))
plt.subplot(321)
plt.title('original image')
plt.imshow(image,plt.cm.gray)
plt.subplot(322)
plt.title('binary_otsu image')
thresh = filters.threshold_otsu(image)   #返回一个阈值
dst = (image <= thresh)*1.0              #根据阈值进行分割
plt.imshow(dst,plt.cm.gray)
plt.subplot(323)
plt.title('binary_yen image')
dst = (image <= filters.threshold_yen(image) )*1.0 
plt.imshow(dst,plt.cm.gray)
plt.subplot(324)
plt.title('binary_li image')
dst = (image <= filters.threshold_li(image) )*1.0 
plt.imshow(dst,plt.cm.gray)
'''2、基于isodata的阈值分割方法'''
plt.subplot(325)
plt.title('binary_isodata image')
dst = (image <= filters.threshold_isodata(image) )*1.0 
plt.imshow(dst,plt.cm.gray)
'''2、基于local的阈值分割方法'''
plt.subplot(326)
plt.title('binary_local image')
dst = filters.threshold_local(image, 15, method='gaussian') #返回一个阈值图像
plt.imshow(dst,plt.cm.gray)
plt.show()
# =============================================================================
print('''十、基本图形的绘制''')
# =============================================================================
plt.figure('draw',figsize=(8,16))
'''1、画线条'''
plt.subplot(421)
plt.title('line')
img=data.chelsea()
rr, cc =draw.line(1, 150, 270, 450)
img[rr, cc] =255
plt.imshow(img,plt.cm.gray)
'''2、绘制其他色彩直线'''
plt.subplot(422)
plt.title('colored line')
img=data.chelsea()
rr, cc =draw.line(1, 150, 270, 250)
draw.set_color(img,[rr,cc],[0,0,255])
plt.imshow(img,plt.cm.gray)
'''3、贝塞儿曲线'''
plt.subplot(423)
plt.title('Bethel curve')
img=data.chelsea()
rr, cc=draw.bezier_curve(150,50,50,280,260,400,2)
draw.set_color(img,[rr,cc],[255,0,0])
plt.imshow(img,plt.cm.gray)
'''4、多边形'''
plt.subplot(424)
plt.title('polygon')
img=data.chelsea()
Y=np.array([10,10,60,60])
X=np.array([200,400,400,200])
rr, cc=draw.polygon(Y,X)
draw.set_color(img,[rr,cc],[255,0,0])
plt.imshow(img,plt.cm.gray)
'''5、画圆'''
plt.subplot(425)
plt.title('circle')
img=data.chelsea()
rr, cc=draw.circle(150,150,50)
draw.set_color(img,[rr,cc],[255,0,0])
plt.imshow(img,plt.cm.gray)
'''6、椭圆'''
plt.subplot(426)
plt.title('ellipse')
img=data.chelsea()
rr, cc=draw.ellipse(150, 150, 30, 80)
draw.set_color(img,[rr,cc],[255,0,0])
plt.imshow(img,plt.cm.gray)
'''7、画空心圆'''
plt.subplot(427)
plt.title('hollow circle')
img=data.chelsea()
rr, cc=draw.circle_perimeter(150,150,50)
draw.set_color(img,[rr,cc],[255,0,0])
plt.imshow(img,plt.cm.gray)
'''8、空心椭圆'''
plt.subplot(428)
plt.title('hollow ellipse')
img=data.chelsea()
rr, cc=draw.ellipse_perimeter(150, 150, 30, 80)
draw.set_color(img,[rr,cc],[255,0,0])
plt.imshow(img,plt.cm.gray)
plt.show()
# =============================================================================
print('''十一、基本形态学滤波''')
# =============================================================================
img=data.checkerboard()
'''1、膨胀（dilation)'''
dst1=sm.dilation(img,sm.square(5))  #用边长为5的正方形滤波器进行膨胀滤波
dst2=sm.dilation(img,sm.square(15))  #用边长为15的正方形滤波器进行膨胀滤波
fig = plt.figure('morphology',figsize=(12,4))
fig.suptitle('dilation')
plt.subplot(131)
plt.title('origin image')
plt.imshow(img,plt.cm.gray)
plt.subplot(132)
plt.title('morphological image')
plt.imshow(dst1,plt.cm.gray)
plt.subplot(133)
plt.title('morphological image')
plt.imshow(dst2,plt.cm.gray)
plt.show()
'''2、腐蚀（erosion)'''
dst1=sm.erosion(img,sm.square(5))  #用边长为5的正方形滤波器进行膨胀滤波
dst2=sm.erosion(img,sm.square(25))  #用边长为25的正方形滤波器进行膨胀滤波
fig = plt.figure('morphology',figsize=(12,4))
fig.suptitle('erosion')
plt.subplot(131)
plt.title('origin image')
plt.imshow(img,plt.cm.gray)
plt.subplot(132)
plt.title('morphological image')
plt.imshow(dst1,plt.cm.gray)
plt.subplot(133)
plt.title('morphological image')
plt.imshow(dst2,plt.cm.gray)
plt.show()
'''3、开运算（opening)'''
img=color.rgb2gray(io.imread('mor.png'))
dst=sm.opening(img,sm.disk(9))  #用边长为9的圆形滤波器进行膨胀滤波
plt.figure('morphology',figsize=(8,8))
plt.subplot(121)
plt.title('origin image')
plt.imshow(img,plt.cm.gray)
plt.axis('off')
plt.subplot(122)
plt.title('morphological image：opening')
plt.imshow(dst,plt.cm.gray)
plt.axis('off')
plt.show()
'''4、闭运算（closing)'''
img=color.rgb2gray(io.imread('mor.png'))
dst=sm.closing(img,sm.disk(9))  #用边长为5的圆形滤波器进行膨胀滤波
plt.figure('morphology',figsize=(8,8))
plt.subplot(121)
plt.title('origin image')
plt.imshow(img,plt.cm.gray)
plt.axis('off')
plt.subplot(122)
plt.title('morphological image：closing')
plt.imshow(dst,plt.cm.gray)
plt.axis('off')
plt.show()
'''5、白帽（white-tophat)'''
img=color.rgb2gray(io.imread('mor.png'))
dst=sm.white_tophat(img,sm.square(21))  
plt.figure('morphology',figsize=(8,8))
plt.subplot(121)
plt.title('origin image')
plt.imshow(img,plt.cm.gray)
plt.axis('off')
plt.subplot(122)
plt.title('morphological image：white-tophat')
plt.imshow(dst,plt.cm.gray)
plt.axis('off')
plt.show()
'''6、黑帽（black-tophat)'''
img=color.rgb2gray(io.imread('mor.png'))
dst=sm.black_tophat(img,sm.square(21))  
plt.figure('morphology',figsize=(8,8))
plt.subplot(121)
plt.title('origin image')
plt.imshow(img,plt.cm.gray)
plt.axis('off')
plt.subplot(122)
plt.title('morphological image：black-tophat')
plt.imshow(dst,plt.cm.gray)
plt.axis('off')
plt.show()
# =============================================================================
print('''十二、高级滤波''')
# =============================================================================
img =color.rgb2gray(data.astronaut())
'''1、autolevel'''
auto =rank.autolevel(img, disk(5))  #半径为5的圆形滤波器
plt.figure('filters1',figsize=(8,8))
plt.subplot(121)
plt.title('origin image')
plt.imshow(img,plt.cm.gray)
plt.subplot(122)
plt.title('filted image：autolevel')
plt.imshow(auto,plt.cm.gray)
plt.show()
'''2、bottomhat 与 tophat'''
auto =rank.bottomhat(img, disk(5))  #半径为5的圆形滤波器
plt.figure('filters2',figsize=(8,8))
plt.subplot(121)
plt.title('origin image')
plt.imshow(img,plt.cm.gray)
plt.subplot(122)
plt.title('filted image：bottomhat && tophat')
plt.imshow(auto,plt.cm.gray)
plt.show()
'''3、enhance_contrast'''
auto =rank.enhance_contrast(img, disk(5))  #半径为5的圆形滤波器
plt.figure('filters3',figsize=(8,8))
plt.subplot(121)
plt.title('origin image')
plt.imshow(img,plt.cm.gray)
plt.subplot(122)
plt.title('filted image：enhance_contrast')
plt.imshow(auto,plt.cm.gray)
plt.show()
'''4、entropy'''
dst =rank.entropy(img, disk(5))  #半径为5的圆形滤波器
plt.figure('filters4',figsize=(8,8))
plt.subplot(121)
plt.title('origin image')
plt.imshow(img,plt.cm.gray)
plt.subplot(122)
plt.title('filted image：entropy')
plt.imshow(dst,plt.cm.gray)
plt.show()
'''5、equalize'''
dst =rank.equalize(img, disk(5))  #半径为5的圆形滤波器
plt.figure('filters5',figsize=(8,8))
plt.subplot(121)
plt.title('origin image')
plt.imshow(img,plt.cm.gray)
plt.subplot(122)
plt.title('filted image：equalize')
plt.imshow(dst,plt.cm.gray)
plt.show()
'''6、gradient'''
dst =rank.gradient(img, disk(5))  #半径为5的圆形滤波器
plt.figure('filters6',figsize=(8,8))
plt.subplot(121)
plt.title('origin image')
plt.imshow(img,plt.cm.gray)
plt.subplot(122)
plt.title('filted image：gradient')
plt.imshow(dst,plt.cm.gray)
plt.show()
'''7、其它滤波器：具体见笔记'''
# =============================================================================
print('''十三、霍夫线变换''')
# =============================================================================
'''1、简单例子'''
# 构建测试图片
image = np.zeros((100, 100))  #背景图
idx = np.arange(25, 75)    #25-74序列
image[idx[::-1], idx] = 255  # 线条\
image[idx, idx] = 255        # 线条/
# hough线变换
h, theta, d = transform.hough_line(image)
#生成一个一行三列的窗口（可显示三张图片）.
fig, (ax0, ax1,ax2) = plt.subplots(1, 3, figsize=(8, 6))
plt.tight_layout()
#显示原始图片
ax0.imshow(image, plt.cm.gray)
ax0.set_title('Input image')
ax0.set_axis_off()
#显示hough变换所得数据
ax1.imshow(np.log(1 + h))
ax1.set_title('Hough transform')
ax1.set_xlabel('Angles (degrees)')
ax1.set_ylabel('Distance (pixels)')
ax1.axis('image')
#显示检测出的线条
ax2.imshow(image, plt.cm.gray)
row1, col1 = image.shape
for _, angle, dist in zip(*transform.hough_line_peaks(h, theta, d)):
    y0 = (dist - 0 * np.cos(angle)) / np.sin(angle)
    y1 = (dist - col1 * np.cos(angle)) / np.sin(angle)
    ax2.plot((0, col1), (y0, y1), '-r')
ax2.axis((0, col1, row1, 0))
ax2.set_title('Detected lines')
ax2.set_axis_off()
plt.show()
'''2、实际例子'''
#使用Probabilistic Hough Transform.
image = data.camera()
edges = feature.canny(image, sigma=2, low_threshold=1, high_threshold=25)
lines = transform.probabilistic_hough_line(edges, threshold=10, line_length=5,line_gap=3)
# 创建显示窗口.
fig, (ax0, ax1, ax2) = plt.subplots(1, 3, figsize=(12, 4))
plt.tight_layout()
#显示原图像
ax0.imshow(image, plt.cm.gray)
ax0.set_title('Input image')
ax0.set_axis_off()
#显示canny边缘
ax1.imshow(edges, plt.cm.gray)
ax1.set_title('Canny edges')
ax1.set_axis_off()
#用plot绘制出所有的直线
ax2.imshow(edges * 0)
for line in lines:
    p0, p1 = line
    ax2.plot((p0[0], p1[0]), (p0[1], p1[1]))
row2, col2 = image.shape
ax2.axis((0, col2, row2, 0))
ax2.set_title('Probabilistic Hough')
ax2.set_axis_off()
plt.show()
# =============================================================================
print('''十四、霍夫圆和椭圆变换''')
# =============================================================================
'''例1：绘制两个圆形，用霍夫圆变换将它们检测出来。'''
img = np.zeros((250, 250,3), dtype=np.uint8)
rr, cc = draw.circle_perimeter(60, 60, 50)  #以半径50画一个圆
rr1, cc1 = draw.circle_perimeter(150, 150, 60) #以半径60画一个圆
img[cc, rr,:] =255
img[cc1, rr1,:] =255
fig, (ax0,ax1) = plt.subplots(1,2, figsize=(8, 5))
ax0.imshow(img)  #显示原图
ax0.set_title('origin image')
hough_radii = np.arange(50, 80, 5)  #半径范围
hough_res =transform.hough_circle(img[:,:,0], hough_radii)  #圆变换 
centers = []  #保存所有圆心点坐标
accums = []   #累积值
radii = []    #半径
for radius, h in zip(hough_radii, hough_res):
    #每一个半径值，取出其中两个圆
    num_peaks = 2
    peaks =feature.peak_local_max(h, num_peaks=num_peaks) #取出峰值
    centers.extend(peaks)
    accums.extend(h[peaks[:, 0], peaks[:, 1]])
    radii.extend([radius] * num_peaks)
#画出最接近的圆
image =np.copy(img)
for idx in np.argsort(accums)[::-1][:2]:
    center_x, center_y = centers[idx]
    radius = radii[idx]
    cx, cy =draw.circle_perimeter(center_y, center_x, radius)
    image[cy, cx] =(255,0,0)
ax1.imshow(image)
ax1.set_title('detected image')
plt.show()
'''例2，检测出图中存在的硬币。'''
image = ski.img_as_ubyte(data.coins()[0:95, 70:370]) #裁剪原图片
edges =feature.canny(image, sigma=3, low_threshold=10, high_threshold=50) #检测canny边缘
fig, (ax0,ax1) = plt.subplots(1,2, figsize=(8, 5))
ax0.imshow(edges, cmap=plt.cm.gray)  #显示canny边缘
ax0.set_title('original iamge')
hough_radii = np.arange(15, 30, 2)  #半径范围
hough_res =transform.hough_circle(edges, hough_radii)  #圆变换 
centers = []  #保存中心点坐标
accums = []   #累积值
radii = []    #半径
for radius, h in zip(hough_radii, hough_res):
    #每一个半径值，取出其中两个圆
    num_peaks = 2
    peaks =feature.peak_local_max(h, num_peaks=num_peaks) #取出峰值
    centers.extend(peaks)
    accums.extend(h[peaks[:, 0], peaks[:, 1]])
    radii.extend([radius] * num_peaks)
#画出最接近的5个圆
image = color.gray2rgb(image)
for idx in np.argsort(accums)[::-1][:5]:
    center_x, center_y = centers[idx]
    radius = radii[idx]
    cx, cy =draw.circle_perimeter(center_y, center_x, radius)
    image[cy, cx] = (255,0,0)
ax1.imshow(image)
ax1.set_title('detected image')
plt.show()
'''例3：检测出咖啡图片中的椭圆杯口（很慢，有错误）'''
##加载图片，转换成灰度图并检测边缘
#image_rgb = data.coffee()[0:220, 160:420] #裁剪原图像，不然速度非常慢
#image_gray = color.rgb2gray(image_rgb)
#edges = feature.canny(image_gray, sigma=2.0, low_threshold=0.55, high_threshold=0.8)
##执行椭圆变换
#result =transform.hough_ellipse(edges, accuracy=20, threshold=250,min_size=100, max_size=120)
#result.sort(order='accumulator') #根据累加器排序
##估计椭圆参数
#best = list(result[-1])  #排完序后取最后一个
#yc, xc, a, b = [int(round(x)) for x in best[1:5]]
#orientation = best[5]
##在原图上画出椭圆
#cy, cx =draw.ellipse_perimeter(yc, xc, a, b, orientation)
#image_rgb[cy, cx] = (0, 0, 255) #在原图中用蓝色表示检测出的椭圆
##分别用白色表示canny边缘，用红色表示检测出的椭圆，进行对比
#edges = color.gray2rgb(edges)
#edges[cy, cx] = (250, 0, 0) 
#fig2, (ax1, ax2) = plt.subplots(ncols=2, nrows=1, figsize=(8, 4))
#ax1.set_title('Original picture')
#ax1.imshow(image_rgb)
#ax2.set_title('Edge (white) and result (red)')
#ax2.imshow(edges)
#plt.show()
# =============================================================================
print('''十五、边缘与轮廓''')
# =============================================================================
'''1、轮廓：简单例子'''
#生成二值测试图像
img=np.zeros([100,100])
img[20:40,60:80]=1  #矩形
rr,cc=draw.circle(60,60,10)  #小圆
rr1,cc1=draw.circle(20,30,15) #大圆
img[rr,cc]=1
img[rr1,cc1]=1
#检测所有图形的轮廓
contours = measure.find_contours(img, 0.5)
#绘制轮廓
fig, (ax0,ax1) = plt.subplots(1,2,figsize=(8,8))
ax0.imshow(img,plt.cm.gray)
ax1.imshow(img,plt.cm.gray)
for n, contour in enumerate(contours):
    ax1.plot(contour[:, 1], contour[:, 0], linewidth=2)
ax1.axis('image')
ax1.set_xticks([])
ax1.set_yticks([])
plt.show()
'''2、轮廓：实际例子'''
#生成二值测试图像
img=color.rgb2gray(data.horse())
#检测所有图形的轮廓
contours = measure.find_contours(img, 0.5)
#绘制轮廓
fig, axes = plt.subplots(1,2,figsize=(8,8))
ax0, ax1= axes.ravel()
ax0.imshow(img,plt.cm.gray)
ax0.set_title('original image')
rows,cols=img.shape
ax1.axis([0,rows,cols,0])
for n, contour in enumerate(contours):
    ax1.plot(contour[:, 1], contour[:, 0], linewidth=2)
ax1.axis('image')
ax1.set_title('contours')
plt.show()
'''3、逼近多边形曲线'''
#生成二值测试图像
hand = np.array([[1.64516129, 1.16145833],
                 [1.64516129, 1.59375],
                 [1.35080645, 1.921875],
                 [1.375, 2.18229167],
                 [1.68548387, 1.9375],
                 [1.60887097, 2.55208333],
                 [1.68548387, 2.69791667],
                 [1.76209677, 2.56770833],
                 [1.83064516, 1.97395833],
                 [1.89516129, 2.75],
                 [1.9516129, 2.84895833],
                 [2.01209677, 2.76041667],
                 [1.99193548, 1.99479167],
                 [2.11290323, 2.63020833],
                 [2.2016129, 2.734375],
                 [2.25403226, 2.60416667],
                 [2.14919355, 1.953125],
                 [2.30645161, 2.36979167],
                 [2.39112903, 2.36979167],
                 [2.41532258, 2.1875],
                 [2.1733871, 1.703125],
                 [2.07782258, 1.16666667]])

#检测所有图形的轮廓
new_hand = hand.copy()
for _ in range(5):
    new_hand =measure.subdivide_polygon(new_hand, degree=2)
# approximate subdivided polygon with Douglas-Peucker algorithm
appr_hand =measure.approximate_polygon(new_hand, tolerance=0.02)
print("Number of coordinates:", len(hand), len(new_hand), len(appr_hand))
fig, axes= plt.subplots(2,2, figsize=(9, 8))
ax0,ax1,ax2,ax3=axes.ravel()
ax0.plot(hand[:, 0], hand[:, 1],'r')
ax0.set_title('original hand')
ax1.plot(new_hand[:, 0], new_hand[:, 1],'g')
ax1.set_title('subdivide_polygon')
ax2.plot(appr_hand[:, 0], appr_hand[:, 1],'b')
ax2.set_title('approximate_polygon')
ax3.plot(hand[:, 0], hand[:, 1],'r')
ax3.plot(new_hand[:, 0], new_hand[:, 1],'g')
ax3.plot(appr_hand[:, 0], appr_hand[:, 1],'b')
ax3.set_title('all')
plt.show()
# =============================================================================
print('''十六、高级形态学处理''')
# =============================================================================
'''1、单目标凸包'''
#生成二值测试图像
img=color.rgb2gray(data.horse())
img=(img<0.5)*1
chull = morphology.convex_hull_image(img)
#绘制轮廓
fig, axes = plt.subplots(1,2,figsize=(8,8))
ax0, ax1= axes.ravel()
ax0.imshow(img,plt.cm.gray)
ax0.set_title('original image')
ax1.imshow(chull,plt.cm.gray)
ax1.set_title('convex_hull image')
'''2、多目标凸包'''
#生成二值测试图像
img=color.rgb2gray(data.coins())
#检测canny边缘,得到二值图片
edgs=feature.canny(img, sigma=3, low_threshold=10, high_threshold=50) 
chull = morphology.convex_hull_object(edgs)
#绘制轮廓
fig, axes = plt.subplots(1,2,figsize=(8,8))
ax0, ax1= axes.ravel()
ax0.imshow(edgs,plt.cm.gray)
ax0.set_title('many objects')
ax1.imshow(chull,plt.cm.gray)
ax1.set_title('convex_hull image')
plt.show()
'''3、连通区域标记'''
#编写一个函数来生成原始二值图像
def microstructure(l=256):
    n = 5
    x, y = np.ogrid[0:l, 0:l]  #生成网络
    mask = np.zeros((l, l))
    generator = np.random.RandomState(1)  #随机数种子
    points = l * generator.rand(2, n**2)
    mask[(points[0]).astype(np.int), (points[1]).astype(np.int)] = 1
    mask = scipy.ndimage.gaussian_filter(mask, sigma=l/(4.*n)) #高斯滤波
    return mask > mask.mean()
data_pic = microstructure(l=128)*1 #生成测试图片
labels=measure.label(data_pic,connectivity=2)  #8连通区域标记
dst=color.label2rgb(labels)  #根据不同的标记显示不同的颜色
print('regions number:',labels.max()+1)  #显示连通区域块数(从0开始标记)
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(8, 4))
ax1.imshow(data_pic, plt.cm.gray, interpolation='nearest')
ax1.axis('off')
ax2.imshow(dst,interpolation='nearest')
ax2.axis('off')
fig.tight_layout()
plt.show()
'''4、删除小块区域'''
#编写一个函数来生成原始二值图像
data_pic = microstructure(l=128) #生成测试图片
dst=morphology.remove_small_objects(data_pic,min_size=300,connectivity=1)
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(8, 4))
ax1.imshow(data_pic, plt.cm.gray, interpolation='nearest')
ax2.imshow(dst,plt.cm.gray,interpolation='nearest')
fig.tight_layout()
plt.show()
'''5、综合示例：阈值分割+闭运算+连通区域标记+删除小区块+分色显示'''
#加载并裁剪硬币图片
image = data.coins()[50:-50, 50:-50]
thresh =filters.threshold_otsu(image) #阈值分割
bw =morphology.closing(image > thresh, morphology.square(3)) #闭运算
cleared = bw.copy()  #复制
segmentation.clear_border(cleared)  #清除与边界相连的目标物
label_image =measure.label(cleared)  #连通区域标记
borders = np.logical_xor(bw, cleared) #异或
label_image[borders] = -1
image_label_overlay =color.label2rgb(label_image, image=image) #不同标记用不同颜色显示
fig,(ax0,ax1)= plt.subplots(1,2, figsize=(8, 6))
ax0.imshow(cleared,plt.cm.gray)
ax1.imshow(image_label_overlay)
for region in measure.regionprops(label_image): #循环得到每一个连通区域属性集
    #忽略小区域
    if region.area < 100:
        continue
    #绘制外包矩形
    minr, minc, maxr, maxc = region.bbox
    rect = matplotlib.patches.Rectangle((minc, minr), maxc - minc, maxr - minr,
                              fill=False, edgecolor='red', linewidth=2)
    ax1.add_patch(rect)
fig.tight_layout()
plt.show()
# =============================================================================
print('''十七、骨架提取与分水岭算法''')
# =============================================================================
'''1、简单例子进行骨架提取'''
#创建一个二值图像用于测试
image = np.zeros((400, 400))
#生成目标对象1(白色U型)
image[10:-10, 10:100] = 1
image[-100:-10, 10:-10] = 1
image[10:-10, -100:-10] = 1
#生成目标对象2（X型）
rs, cs = draw.line(250, 150, 10, 280)
for i in range(10):
    image[rs + i, cs] = 1
rs, cs = draw.line(10, 150, 250, 280)
for i in range(20):
    image[rs + i, cs] = 1
#生成目标对象3（O型）
ir, ic = np.indices(image.shape)
circle1 = (ic - 135)**2 + (ir - 150)**2 < 30**2
circle2 = (ic - 135)**2 + (ir - 150)**2 < 20**2
image[circle1] = 1
image[circle2] = 0
#实施骨架算法
skeleton =morphology.skeletonize(image)
#显示结果
fig, (ax1, ax2) = plt.subplots(nrows=1, ncols=2, figsize=(8, 4))
ax1.imshow(image, cmap=plt.cm.gray)
ax1.axis('off')
ax1.set_title('original', fontsize=20)
ax2.imshow(skeleton, cmap=plt.cm.gray)
ax2.axis('off')
ax2.set_title('skeleton', fontsize=20)
fig.tight_layout()
plt.show()
'''2、利用系统自带的马图片进行骨架提取'''
image=color.rgb2gray(data.horse())
image=1-image #反相
#实施骨架算法
skeleton =morphology.skeletonize(image)
#显示结果
fig, (ax1, ax2) = plt.subplots(nrows=1, ncols=2, figsize=(8, 4))
ax1.imshow(image, cmap=plt.cm.gray)
ax1.axis('off')
ax1.set_title('original', fontsize=20)
ax2.imshow(skeleton, cmap=plt.cm.gray)
ax2.axis('off')
ax2.set_title('skeleton', fontsize=20)
fig.tight_layout()
plt.show()
'''3、利用中轴变换方法计算前景（1值）目标对象的宽度（有错误）'''
##编写一个函数，生成测试图像
#def microstructure2(l=256):
#    n = 5
#    x, y = np.ogrid[0:l, 0:l]
#    mask = np.zeros((l, l))
#    generator = np.random.RandomState(1)
#    points = l * generator.rand(2, n**2)
#    mask[(points[0]).astype(np.int), (points[1]).astype(np.int)] = 1
#    mask = scipy.ndimage.gaussian_filter(mask, sigma=l/(4.*n))
#    return mask > mask.mean()
#data_pic = microstructure2(l=64) #生成测试图像
##计算中轴和距离变换值
#skel, distance =morphology.medial_axis(data_pic, return_distance=True)
##中轴上的点到背景像素点的距离
#dist_on_skel = distance * skel
#fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(8, 4))
#ax1.imshow(data_pic, cmap=plt.cm.gray, interpolation='nearest')
##用光谱色显示中轴
#ax2.imshow(dist_on_skel, cmap=plt.cm.spectral, interpolation='nearest')
#ax2.contour(data, [0.5], colors='w')  #显示轮廓线
#fig.tight_layout()
#plt.show()
'''4、基于距离变换的分山岭图像分割'''
#创建两个带有重叠圆的图像
x, y = np.indices((80, 80))
x1, y1, x2, y2 = 28, 28, 44, 52
r1, r2 = 16, 20
mask_circle1 = (x - x1)**2 + (y - y1)**2 < r1**2
mask_circle2 = (x - x2)**2 + (y - y2)**2 < r2**2
image = np.logical_or(mask_circle1, mask_circle2)
#现在我们用分水岭算法分离两个圆
distance = scipy.ndimage.distance_transform_edt(image) #距离变换
local_maxi =feature.peak_local_max(distance, indices=False, footprint=np.ones((3, 3)),
                            labels=image)   #寻找峰值
markers = scipy.ndimage.label(local_maxi)[0] #初始标记点
labels =morphology.watershed(-distance, markers, mask=image) #基于距离变换的分水岭算法
fig, axes = plt.subplots(nrows=2, ncols=2, figsize=(8, 8))
axes = axes.ravel()
ax0, ax1, ax2, ax3 = axes
ax0.imshow(image, cmap=plt.cm.gray, interpolation='nearest')
ax0.set_title("Original")
ax1.imshow(-distance, cmap=plt.cm.jet, interpolation='nearest')
ax1.set_title("Distance")
ax2.imshow(markers, cmap=plt.cm.spectral, interpolation='nearest')
ax2.set_title("Markers")
ax3.imshow(labels, cmap=plt.cm.spectral, interpolation='nearest')
ax3.set_title("Segmented")
for ax in axes:
    ax.axis('off')
fig.tight_layout()
plt.show()
'''5、基于梯度的分水岭图像分割'''
image =color.rgb2gray(data.camera())
denoised = filters.rank.median(image, morphology.disk(2)) #过滤噪声
#将梯度值低于10的作为开始标记点
markers = filters.rank.gradient(denoised, morphology.disk(5)) <10
markers = scipy.ndimage.label(markers)[0]
gradient = filters.rank.gradient(denoised, morphology.disk(2)) #计算梯度
labels =morphology.watershed(gradient, markers, mask=image) #基于梯度的分水岭算法
fig, axes = plt.subplots(nrows=2, ncols=2, figsize=(6, 6))
axes = axes.ravel()
ax0, ax1, ax2, ax3 = axes
ax0.imshow(image, cmap=plt.cm.gray, interpolation='nearest')
ax0.set_title("Original")
ax1.imshow(gradient, cmap=plt.cm.spectral, interpolation='nearest')
ax1.set_title("Gradient")
ax2.imshow(markers, cmap=plt.cm.spectral, interpolation='nearest')
ax2.set_title("Markers")
ax3.imshow(labels, cmap=plt.cm.spectral, interpolation='nearest')
ax3.set_title("Segmented")
for ax in axes:
    ax.axis('off')
fig.tight_layout()
plt.show()
















