整理自：https://www.cnblogs.com/denny402
matplotlib.pyplot 				 		skimage
1	024 颜色图谱  	 	 cmap			01	134 主要子模块列表					
2	047 创建窗口     	 figure			02	151 自带示例图					
3	058 绘制子图         subplot		03	158 数组数据类型					
4	072 划分子图         subplots		04	169 数据转化				   img_as_xxx					
5	081 调整图片显示布局 tight_layout	05	178 颜色空间转化			   color.convert_colorspace					
6	091 设置图像与坐标轴标题 			06	192 批量操作函数			   io.ImageCollection					
7	115 总结 							07	199 图像亮度与对比度的调整	   exposure					
										08	223 直方图 					   exposure.histogram					
										09	244 形态学变换				   morphology
										10	278 简单滤波 				   filters && feature
										11	299 高级滤波				   filters.rank
										12	333 图像阈值分割			   filters
										13  350 霍夫线、圆和椭圆变换       transform
										14	393 边缘与轮廓（检测边缘见10） measure  
										15  414 高级形态学处理			   morphology
										16  460 骨架提取与分水岭算法	   morphology
										17	488 基本图形的绘制			   draw

	
一、matplotlib.pyplot模块

1st：
plt.imshow(image,plt.cm.gray)
plt.imshow(img,cmap=plt.cm.jet)
颜色图谱cmap	描述
autumn			红-橙-黄
bone			黑-白，x线
cool			青-洋红
copper			黑-铜
flag			红-白-蓝-黑
gray			黑-白
hot				黑-红-黄-白
hsv				hsv颜色空间，红-黄-绿-青-蓝-洋红-红
inferno			黑-红-黄
jet				蓝-青-黄-红
magma			黑-红-白
pink			黑-粉-白
plasma			绿-红-黄
prism			红-黄-绿-蓝-紫-...-绿模式（光谱的七色：红、橙、黄、绿、青、蓝、紫）
spring			洋红-黄
summer			绿-黄
viridis			蓝-绿-黄
winter			蓝-绿

2nd：
figure（）函数来创建显示窗口
函数：matplotlib.pyplot.figure(num=None, figsize=None, dpi=None, facecolor=None, edgecolor=None)
参数：(所有都是可选的，都有默认值，因此调用该函数时可以不带任何参数)
	  num: 整型或字符型都可以。如果设置为整型，则该整型数字表示窗口的序号。如果设置为字符型，则该字符串表示窗口的名称
	  	   用该参数来命名窗口，如果两个窗口序号或名相同，则后一个窗口会覆盖前一个窗口
	  figsize: 设置窗口大小。是一个tuple型的整数，如figsize=（8，8），第一个数为长，对应列数；第二个为宽，对应行数
	  dpi 	 : 整形数字，表示窗口的分辨率
	  facecolor: 窗口的背景颜色
	  edgecolor: 窗口的边框颜色

3rd：
subplot（）函数来划分子图，函数格式为：
matplotlib.pyplot.subplot(nrows, ncols, plot_number)
nrows: 子图的行数
ncols: 子图的列数
plot_number: 当前子图的编号
也可以用fig.add_subplot(nrows, ncols, plot_number)，含义相同
例子如下：
	   	plt.subplot(121)
	   	plt.title('filt_real_freq=0.6')
	   	plt.imshow(filt_real,plt.cm.gray)  
	   	ax = fig.add_subplot(121)
	   	ax = plt.subplot(121)

4th：
subplots()函数来创建并划分窗口，注意，比前面的subplot()函数多了一个s。
函数：matplotlib.pyplot.subplots(nrows=1, ncols=1)
参数：nrows: 所有子图行数，默认为1
	  ncols: 所有子图列数，默认为1
返回一个窗口figure, 和一个tuple型的ax对象，该对象包含所有的子图,可结合ravel()函数列出所有子图
例子：fig, axes = plt.subplots(2, 2, figsize=(7, 6))
	  ax0, ax1, ax2, ax3 = axes.ravel()

5th：
tight_layout()函数来调整显示的布局。
函数：matplotlib.pyplot.tight_layout(pad=1.08, h_pad=None, w_pad=None, rect=None)
参数：(所有的参数都是可选的，调用该函数时可省略所有的参数)
	  pad: 主窗口边缘和子图边缘间的间距，默认为1.08
	  h_pad, w_pad: 子图边缘之间的间距，默认为 pad_inches
	  rect: 一个矩形区域，如果设置这个值，则将所有的子图调整到这个矩形区域内
一般调用为：
plt.tight_layout()  #自动调整subplot间的参数

6th：
使用句柄设置标题及坐标轴信息的方法			
fig.suptitle('Title')						图表总标题  （fig为subplots的返回值）
ax.set_title('Sub_Title')					子图表的标题（ax为subplots的返回值，或者ax = fig.add_subplot(121)）
ax.set_xticks([0,25,50,75,100]) 			实现设置坐标标记点
ax.set_xticklabels(words,rotation,fontsize) 在设置的标记点写标记词；其他的参数分别是设置字体的倾斜度以及字体的大小
ax.set_title('subplot_title')				设置图片的标题
ax.set_xlabel('xlabel_name')			    设置横轴的名称
例子如下：
		import matplotlib.pyplot as plt
		from numpy.random import randn
		x = range(100)
		y = randn(100)
		fig = plt.figure()
		ax = fig.add_subplot(1,1,1)
		ax.plot(x,y,'k--')
		ax.set_xticks([0,25,50,75,100])
		ax.set_xticklabels(['one','two','three','four','five'],rotation=45,fontsize=  'small')
		ax.set_title('www.jb51.net - Demo Figure')
		ax.set_xlabel('Time')
		fig.suptitle('Super_title')
		plt.show()
注意：见<skimage_test.py>中的"八图像简单滤波、3高斯滤波和中值滤波"处分别用了两种画子图标题的方法

7th：
总结，绘制和显示图片常用到的函数有：
函数名			功能								调用格式
figure			创建一个显示窗口					plt.figure(num=1,figsize=(8,8)
imshow			绘制图片							plt.imshow(image)
show			显示窗口							plt.show()
subplot			划分子图							plt.subplot(2,2,1)
title			设置子图标题(与subplot结合使用）	plt.title('origin image')
axis			是否显示坐标尺						plt.axis('off')
subplots		创建带有多个子图的窗口				fig,axes=plt.subplots(2,2,figsize=(8,8))
ravel			为每个子图设置变量					ax0,ax1,ax2,ax3=axes.ravel()
set_title		设置子图标题（与axes结合使用）		ax0.set_title('first window')
tight_layout	自动调整子图显示布局				plt.tight_layout()


二、skimage包
skimage包的全称是scikit-image SciKit (toolkit for SciPy) ，它对scipy.ndimage进行了扩展，提供了更多的图片处理功能。
它是由python语言编写的，由scipy 社区开发和维护。skimage包由许多的子模块组成，各个子模块提供不同的功能。

1st：
主要子模块列表如下：
子模块名称　	主要实现功能
io				读取、保存和显示图片或视频
data			提供一些测试图片和样本数据
color			颜色空间变换
filters			图像增强、边缘检测、排序滤波器、自动阈值等
draw			操作于numpy数组上的基本图形绘制，包括线条、矩形、圆和文本等
transform		几何变换或其它变换，如旋转、拉伸和拉东变换等
morphology		形态学操作，如开闭运算、骨架提取等
exposure		图片强度调整，如亮度调整、直方图均衡等
feature			特征检测与提取等
measure			图像属性的测量，如相似性或等高线等
segmentation	图像分割  具体见:http://scikit-image.org/docs/stable/api/skimage.segmentation.html
restoration		图像恢复		 http://scikit-image.org/docs/stable/api/skimage.restoration.html	
util			通用函数		 http://scikit-image.org/docs/stable/search.html?q=util&check_keywords=yes&area=default

2nd：
skimage程序自带了一些示例图片，如果我们不想从外部读取图片，就可以直接使用这些示例图片：
astronaut宇航员图片	coffee一杯咖啡图片	clock时钟图片		 		camera拿相机的人图片	
coins硬币图片		moon月亮图片		checkerboard棋盘图片  	 	chelsea小猫图片	
page书页图片		horse马图片		    hubble_deep_field星空图片	text文字图片
immunohistochemistry结肠图片

3rd：
在skimage中，一张图片就是一个简单的numpy数组，数组的数据类型有很多种，相互之间也可以转换。这些数据类型及取值范围如下表所示：
DataType	 Range
uint8		0 to 255
uint16		0 to 65535
uint32		0 to 232
float	  -1 to 1 or 0 to 1
int8	  -128 to 127
int16	  -32768 to 32767
int32	  -231 to 231 - 1

4th：
Function name	Description
img_as_float	Convert to 64-bit floating point.
img_as_ubyte	Convert to 8-bit uint.
img_as_uint		Convert to 16-bit uint.
img_as_int		Convert to 16-bit int.
注：可以通过img_as_float()函数将unit8类型转换为float型，实际上还有更简单的方法，就是乘以1.0
	还可以通过图像的颜色空间转换来改变数据类型。

5th：
常用的颜色空间有灰度空间、rgb空间、hsv空间和cmyk空间。颜色空间转换以后，图片类型都变成了float型。
所有的颜色空间转换函数，都放在skimage的color模块内。列举常用的如下：
skimage.color.rgb2gray(rgb)
skimage.color.rgb2grey(rgb)
skimage.color.rgb2hsv(rgb)
skimage.color.rgb2lab(rgb)
skimage.color.gray2rgb(image)
skimage.color.hsv2rgb(hsv)
skimage.color.lab2rgb(lab)
实际上，上面的所有转换函数，都可以用一个函数来代替：
skimage.color.convert_colorspace(arr, fromspace, tospace)，表示将arr从fromspace颜色空间转换到tospace颜色空间。
skimage.color.label2rgb(arr), 则可以根据标签值对图片进行着色

6th：
批量操作函数ImageCollection，放在io模块内的，带两个参数。
函数：skimage.io.ImageCollection(load_pattern,load_func=None)
参数：load_pattern, 表示图片组的路径，可以是一个str字符串
	  load_func回调函数，我们对图片进行批量处理就可以通过这个回调函数实现
注意：回调函数默认为imread(),即默认这个函数是批量读取图片

7th：
exposure模块用于图像亮度与对比度的调整
1、gamma调整
原理：I=I**g
      对原图像的像素，进行幂运算，得到新的像素值。公式中的g就是gamma值。
      如果gamma>1, 新图像比原图像暗
      如果gamma<1,新图像比原图像亮
函数：skimage.exposure.adjust_gamma(image, gamma=1)
      gamma参数默认为1，原像不发生变化 
2、log对数调整
原理：I=log(I)，这个刚好和gamma相反
函数：skimage.exposure.adjust_log(image)
3、判断图像对比度是否偏低
函数：is_low_contrast(img)
	  返回一个bool型值
4、调整强度
函数：skimage.exposure.rescale_intensity(image, in_range='image', out_range='dtype')
参数：in_range 表示输入图片的强度范围，默认为'image', 表示用图像的最大/最小像素值作为范围
	  out_range 表示输出图片的强度范围，默认为'dype', 表示用图像的类型的最大/最小值作为范围
默认情况下，输入图片的[min,max]范围被拉伸到[dtype.min, dtype.max]，如果dtype=uint8, 那么dtype.min=0, dtype.max=255
如果原始像素值不想被拉伸，只是等比例缩小，就使用in_range参数；
如果参数in_range的[main,max]范围要比原始像素值的范围[min,max] 大或者小，那就进行裁剪；
如果一个数组里面有负数，现在想调整到正数，就使用out_range参数。

8th：
1、计算直方图
函数：skimage.exposure.histogram(image, nbins=256)计算直方图
返回：返回一个tuple（hist, bins_center), 前一个数组是直方图的统计量，后一个数组是每个bin的中间值
注意：在numpy包中，也提供了一个计算直方图的函数histogram(),两者大同小义
2、绘制直方图
绘图都可以调用matplotlib.pyplot库来进行，其中的hist函数可以直接绘制直方图。
函数：n, bins, patches = plt.hist(arr, bins=10, normed=0, facecolor='black', edgecolor='black',alpha=1，histtype='bar')
参数：（非常多，但常用的就这六个，只有第一个是必须的，后面四个可选)
	  arr: 需要计算直方图的一维数组
	  bins: 直方图的柱数，可选项，默认为10
	  normed: 是否将得到的直方图向量归一化。默认为0
	  facecolor: 直方图颜色
	  edgecolor: 直方图边框颜色
	  alpha: 透明度
	  histtype: 直方图类型，‘bar’, ‘barstacked’, ‘step’, ‘stepfilled’
返回：n: 直方图向量，是否归一化由参数normed设定
      bins: 返回各个bin的区间范围
      patches: 返回每个bin里面包含的数据，是一个list

9th:
对图像进行形态学变换。变换对象一般为灰度图或二值图，功能函数放在morphology子模块内。
1、膨胀（dilation)
函数：skimage.morphology.dilation(image, selem=None）
原理：一般对二值图像进行操作。找到像素值为1的点，将它的邻近像素点都设置成这个值。
      1值表示白，0值表示黑，因此膨胀操作可以扩大白色值范围，压缩黑色值范围。一般用来扩充边缘或填充小的孔洞。
2、腐蚀（erosion)
函数：skimage.morphology.erosion(image, selem=None）
原理：和膨胀相反的操作，将0值扩充到邻近像素。扩大黑色部分，减小白色部分。可用来提取骨干信息，去掉毛刺，去掉孤立的像素。
3、开运算（opening)
函数：skimage.morphology.openning(image, selem=None）
原理：先腐蚀再膨胀，可以消除小物体或小斑块。
4、闭运算（closing)
函数：skimage.morphology.closing(image, selem=None）
原理：先膨胀再腐蚀，可用来填充孔洞。
5、白帽（white-tophat)
函数：skimage.morphology.white_tophat(image, selem=None）
原理：将原图像减去它的开运算值，返回比结构化元素小的白点
6、黑帽（black-tophat)
函数：skimage.morphology.black_tophat(image, selem=None）
原理：将原图像减去它的闭运算值，返回比结构化元素小的黑点，且将这些黑点反色。
7、滤波器selem
表示结构元素，用于设定局部区域的形状和大小。滤波器的大小，对操作结果的影响非常大，一般设置为奇数。各形状滤波器列举如下：
morphology.square: 正方形
morphology.disk:  平面圆形
morphology.ball: 球形
morphology.cube: 立方体形
morphology.diamond: 钻石形
morphology.rectangle: 矩形
morphology.star: 星形
morphology.octagon: 八角形
morphology.octahedron： 八面体
8、注意：如果处理图像为二值图像（只有0和1两个值），则可以调用以下函数，它们比处理灰度图像要快
binary_dilation binary_erosion binary_opening binary_closing

10th：
对图像进行滤波，可以有两种效果：一种是平滑滤波，用来抑制噪声；另一种是微分算子，可以用来检测边缘和特征提取。
1、提取边缘特征（canny属于feature模块，而其他属于filters模块）
sobel算子  ：skimage.filters.sobel(image, mask=None)
roberts算子：edges = filters.roberts(img)
scharr算子 ：edges = filters.scharr(img)
prewitt算子：edges = filters.prewitt(img)
canny算子  ：skimage.feature.canny(image，sigma=1.0)
2、纹理特征提取（也可以进行边缘检测）
gabor滤波  ：skimage.filters.gabor(image, frequency) 
通过修改frequency值来调整滤波效果，返回一对边缘结果，一个是用真实滤波核的滤波结果，一个是想象的滤波核的滤波结果。
3、平滑滤波（可以消除噪声）
gaussian   ：skimage.filters.gaussian(image, sigma)          多维的滤波器，通过调节sigma的值来调整滤波效果，可以消除高斯噪声。
median	   ：skimage.filters.median(image,skimage.morphology.disk)  需要用skimage.morphology模块来设置滤波器的形状。
4、水平、垂直、交叉边缘检测（filters）
水平边缘检测：sobel_h, prewitt_h, scharr_h
垂直边缘检测：sobel_v, prewitt_v, scharr_v
交叉边缘检测：roberts_neg_diag(image）  核分别为   :  0  1  和  1  0
			  roberts_pos_diag(image）  	         -1  0 		0 -1
注意：可使用Roberts的十字交叉核来进行过滤，以达到检测交叉边缘的目的。这些交叉边缘实际上是梯度在某个方向上的一个分量 									 

11th:
以下提供更多更强大的滤波方法，这些方法放在filters.rank子模块内，需要用户自己设定滤波器的形状和大小，故需导入morphology模块来设定。
1、autolevel
原理：这个词在photoshop里面翻译成自动色阶，用局部直方图来对图片进行滤波分级。该滤波器局部地拉伸灰度像素值的直方图，以覆盖整个像素值范围。
函数：skimage.filters.rank.autolevel(image, selem）
2、bottomhat 与 tophat
原理：bottomhat: 此滤波器先计算图像的形态学闭运算，然后用原图像减去运算的结果值，有点像黑帽操作。
	  tophat:    此滤波器先计算图像的形态学开运算，然后用原图像减去运算的结果值，有点像白帽操作。
函数：skimage.filters.rank.bottomhat(image, selem）
	  skimage.filters.rank.tophat(image, selem）
3、enhance_contrast
原理：对比度增强。求出局部区域的最大值和最小值，然后看当前点像素值最接近最大值还是最小值，然后替换为最大值或最小值。
函数：skimage.filters.rank.enhance_contrast(image, selem）
4、entropy
原理：求局部熵，熵是使用基为2的对数运算出来的。该函数将局部区域的灰度值分布进行二进制编码，返回编码的最小值。
函数：skimage.filters.rank.entropy(image, selem）
5、equalize
原理：均衡化滤波。利用局部直方图对图像进行均衡化滤波。
函数：skimage.filters.rank.equalize(image, selem）
6、gradient
原理：返回图像的局部梯度值（如：最大值-最小值），用此梯度值代替区域内所有像素值。
函数：skimage.filters.rank.gradient(image, selem）
7、其它滤波器（调用方式一样）
最大值滤波器（maximum)：返回图像局部区域内的最大值，用此最大值代替该区域内所有像素值。
最小值滤波器（minimum)：返回图像局部区域内的最小值，用此最小值取代该区域内所有像素值。
均值滤波器（mean) 	  :	返回图像局部区域内的均值，用此均值取代该区域内所有像素值。
中值滤波器（median)	  :	返回图像局部区域内的中值，用此中值取代该区域内所有像素值。
莫代尔滤波器（modal)  : 返回图像局部区域内的modal值，用此值取代该区域内所有像素值。
otsu阈值滤波（otsu)	  :	返回图像局部区域内的otsu阈值，用此值取代该区域内所有像素值。
阈值滤波（threshhold) : 将图像局部区域中的每个像素值与均值比较，大于则赋值为1，小于赋值为0，得到一个二值图像。
减均值滤波（subtract_mean):  将局部区域中的每一个像素，减去该区域中的均值。
求和滤波（sum) 		  : 求局部区域的像素总和，用此值取代该区域内所有像素值。
注意：selem表示结构化元素，用于设定滤波器

12th：
图像阈值分割是一种广泛应用的分割技术，利用图像中要提取的目标区域与其背景在灰度特性上的差异，把图像看作具有不同灰度级的两类区域(目标区域和背景区域)的组合，选取一个比较合理的阈值，以确定图像中每个像素点应该属于目标区域还是背景区域，从而产生相应的二值图像。
在filters模块中，我们可以手动指定一个阈值，从而来实现分割。也可以让系统自动生成一个阈值，下面几种方法就是用来自动生成阈值。
1、分别基于Otsu、Yen、Li的阈值分割方法
函数：thresh = filters.threshold_otsu(image, nbins=256)
	  thresh = filters.threshold_otsu(image, nbins=256) 
	  thresh = filters.threshold_otsu(image, nbins=256)
注意：参数image是指灰度图像，返回一个阈值
2、基于isodata的阈值分割方法
函数：thresh = filters.threshold_isodata(image)  
阈值计算方法：threshold = (image[image <= threshold].mean() +image[image > threshold].mean()) / 2.0
3、基于local的阈值分割方法
函数：skimage.filters.threshold_local(image, block_size, method='gaussian'）
参数：block_size: 块大小，指当前像素的相邻区域大小，一般是奇数（如3，5，7。。。）
	  method: 用来确定自适应阈值的方法，有'mean', 'generic', 'gaussian' 和 'median'。省略时默认为gaussian
注意：该函数直接返回一个阈值后的图像，而不是阈值

13th：
霍夫变换是放在tranform模块内，主要是用来检测图片中的几何形状，包括直线、圆、椭圆等。
1、霍夫线变换
原理：对于平面中的一条直线，在笛卡尔坐标系中，可用y=mx+b来表示，其中m为斜率，b为截距。
      但是如果直线是一条垂直线，则m为无穷大，所以通常我们在另一坐标系中表示直线，即极坐标系下的r=xcos(theta)+ysin(theta)。
      从而可用（r,theta）来表示一条直线，其中r为该直线到原点的距离，theta为该直线的垂线与x轴的夹角。
      对于一个给定的点（x0,y0), 我们在极坐标下绘出所有通过它的直线（r,theta)，将得到一条正弦曲线。
      如果将图片中的所有非0点的正弦曲线都绘制出来，则会存在一些交点。所有经过这个交点的正弦曲线，说明都拥有同样的(r,theta), 意味着这些点在一条直线上。
函数：h, theta, d = skimage.transform.hough_line(img)
参数：h: 霍夫变换累积器
      theta: 点与x轴的夹角集合，一般为0-179度
      distance: 点到原点的距离，即上面的所说的r
绘制图中直线绘：
函数：skimage.transform.hough_line_peaks(hspace, angles, dists）
	  用这个函数可以取出峰值点，即交点，也即原图中的直线。返回的参数与输入的参数一样。
注意：绘制线条的时候，要从极坐标转换为笛卡尔坐标，公式为：y=(r-x*cos(angle))/sin(angle)
2、概率霍夫线变换
函数：skimage.transform.probabilistic_hough_line(img, threshold=10, line_length=5,line_gap=3)
参数：img: 待检测的图像
	  threshold： 阈值，可先项，默认为10
	  line_length: 检测的最短线条长度，默认为50
	  line_gap: 线条间的最大间隙。增大这个值可以合并破碎的线条。默认为10
返回：lines: 线条列表, 格式如((x0, y0), (x1, y0))，标明开始点和结束点
3、霍夫圆变换
原理：在极坐标中，圆的表示方式为：x=x0+rcosθ ；y=y0+rsinθ，圆心为(x0,y0),r为半径，θ为旋转度数，值范围为0-359。
	  如果给定圆心点和半径，则其它点是否在圆上，我们就能检测出来了。
	  在图像中，我们将每个非0像素点作为圆心点，以一定的半径进行检测：
	  如果有一个点在圆上，我们就对这个圆心累加一次。如果检测到一个圆，那么这个圆心点就累加到最大，成为峰值。
	  因此，在检测结果中，一个峰值点，就对应一个圆心点。
函数：skimage.transform.hough_circle(image, radius)
参数：radius是一个数组，表示半径的集合，如[3，4，5，6]
返回：一个3维的数组（radius index, M, N), 第一维表示半径的索引，后面两维表示图像的尺寸
4、霍夫椭圆变换
函数：skimage.transform.hough_ellipse(img,accuracy, threshold, min_size, max_size)
参数：img: 待检测图像
	  accuracy: 使用在累加器上的短轴二进制尺寸，是一个double型的值，默认为1
	  thresh: 累加器阈值，默认为4
	  min_size: 长轴最小长度，默认为4
	  max_size: 短轴最大长度，默认为None,表示图片最短边的一半
返回：一个 [(accumulator, y0, x0, a, b, orientation)] 数组：
		accumulator表示累加器，（y0,x0)表示椭圆中心点，（a,b)分别表示长短轴，orientation表示椭圆方向
注意：霍夫椭圆变换速度非常慢，应避免图像太大。

14th：
1、查找轮廓（find_contours)
measure模块中的find_contours()函数，可用来检测二值图像的边缘轮廓。
函数：skimage.measure.find_contours(array, level)
参数：array: 一个二值数组图像
	  level: 在图像中查找轮廓的级别值
返回：轮廓列表集合，可用for循环取出每一条轮廓
2、逼近多边形曲线
逼近多边形曲线有两个函数：subdivide_polygon（)和 approximate_polygon（）
subdivide_polygon（)采用B样条（B-Splines)来细分多边形的曲线，该曲线通常在凸包线的内部
函数：skimage.measure.subdivide_polygon(coords, degree=2, preserve_ends=False)
参数：coords: 坐标点序列
	  degree: B样条的度数，默认为2
	  preserve_ends: 如果曲线为非闭合曲线，是否保存开始和结束点坐标，默认为false
返回：细分为的坐标点序列
approximate_polygon（）是基于Douglas-Peucker算法的一种近似曲线模拟。它根据指定的容忍值来近似一条多边形曲线链，该曲线也在凸包线的内部。
函数：skimage.measure.approximate_polygon(coords, tolerance)
参数：coords: 坐标点序列
	  tolerance: 容忍值
返回：近似的多边形曲线坐标序列

15th：
形态学处理，除了最基本的膨胀、腐蚀、开/闭运算、黑/白帽处理外，还有一些更高级的运用，如凸包，连通区域标记，删除小块区域等。
1、凸包：指一个凸多边形，这个凸多边形将图片中所有的白色像素点都包含在内
convex_hull_image()是将图片中的所有目标看作一个整体，因此计算出来只有一个最小凸多边形。
函数：skimage.morphology.convex_hull_image(image)
参数：为二值图像
返回：一个逻辑二值图像，在凸包内的点为True, 否则为False
convex_hull_object（）函数适用于图中有多个目标物体，对每一个物体计算一个最小凸多边形。
函数：skimage.morphology.convex_hull_object(image, neighbors=8)
参数：image是一个二值图像，neighbors表示是采用4连通还是8连通，默认为8连通
2、连通区域标记
原理：在二值图像中，如果两个像素点相邻且值相同（同为0或同为1），那么就认为这两个像素点在一个相互连通的区域内。
	  而同一个连通区域的所有像素点，都用同一个数值来进行标记，这个过程就叫连通区域标记。
	  在判断两个像素是否相邻时，我们通常采用4连通或8连通判断。
	  在图像中，最小的单位是像素，每个像素周围有8个邻接像素，常见的邻接关系有2种：4邻接与8邻接。
	  	4邻接一共4个点，即上下左右。8邻接的点一共有8个，包括了对角线位置的点。
函数：skimage.measure.label（image,connectivity=None)
参数：image表示需要处理的二值图像，connectivity表示连接的模式，1代表4邻接，2代表8邻接
返回：一个标记数组（labels), 从0开始标记
注意：在代码中，有些地方乘以1，则可以将bool数组快速地转换为int数组
3、连通区域操作：如计算面积、外接矩形、凸包面积等
函数：skimage.measure.regionprops(label_image)
返回所有连通区块的属性列表，常用的属性列表如下表：
属性名称			类型		描述
area				int			区域内像素点总数
bbox				tuple		边界外接框(min_row, min_col, max_row, max_col)
centroid			array　 	质心坐标
convex_area			int			凸包内像素点总数
convex_image		ndarray		和边界外接框同大小的凸包　　
coords				ndarray		区域内像素点坐标
Eccentricity		float		离心率
equivalent_diameter float		和区域面积相同的圆的直径
euler_number		int　　		区域欧拉数
extent 				float		区域面积和边界外接框面积的比率
filled_area			int			区域和外接框之间填充的像素点总数
perimeter 			float		区域周长
label				int			区域标记
4、删除小块区域
有些时候，我们只需要一些大块区域，那些零散的、小块的区域，我们就需要删除掉，则可以使用morphology子模块的remove_small_objects（)函数。
函数：skimage.morphology.remove_small_objects(ar, min_size=64, connectivity=1, in_place=False)
参数：ar: 待操作的bool型数组
	  min_size: 最小连通区域尺寸，小于该尺寸的都将被删除，默认为64
	  connectivity: 邻接模式，1表示4邻接，2表示8邻接
	  in_place: bool型值，如果为True,表示直接在输入图像中删除小块区域，否则进行复制后再删除，默认为False
返回：删除了小块区域的二值图像

16th：
骨架提取与分水岭算法也属于形态学处理范畴，都放在morphology子模块内。
1、骨架提取（二值图像细化）
这种算法能将一个连通区域细化成一个像素的宽度，用于特征提取和目标拓扑表示，morphology子模块提供了两个函数：Skeletonize（）和medial_axis（）
skeletonize在每一次传递中，边界像素都被识别并删除，条件是它们不会破坏相应对象的连接性。
函数：skimage.morphology.skeletonize(image)
注意：输入和输出都是一幅二值图像
medial_axis就是中轴的意思，利用中轴变换方法计算前景（1值）目标对象的宽度。
函数：skimage.morphology.medial_axis(image, mask=None, return_distance=False)
参数：mask: 掩模。默认为None, 如果给定一个掩模，则在掩模内的像素值才执行骨架算法
	  return_distance: bool型值，默认为False. 如果为True, 则除了返回骨架，还将距离变换值也同时返回
注意：这里的距离指的是中轴线上的所有点与背景点的距离
2、分水岭算法
原理：分水岭在地理学上就是指一个山脊，水通常会沿着山脊的两边流向不同的“汇水盆”。
	  分水岭算法是一种用于图像分割的经典算法，是基于拓扑理论的数学形态学的分割方法。
	  如果图像中的目标物体是连在一起的，则分割起来会更困难，分水岭算法经常用于处理这类问题，通常会取得比较好的效果。
	  分水岭算法可以和距离变换结合，寻找“汇水盆地”和“分水岭界限”，从而对图像进行分割。
	  二值图像的距离变换就是每一个像素点到最近非零值像素点的距离，我们可以使用scipy包来计算距离变换。
基于距离变换的分山岭图像分割：
原理：两个重叠的圆的例子中，将两圆分开。
	  我们先计算圆上的这些白色像素点到黑色背景像素点的距离变换，选出距离变换中的最大值作为初始标记点（如果是反色的话，则是取最小值）。
	  从这些标记点开始的两个汇水盆越集越大，最后相交于分山岭。从分山岭处断开，我们就得到了两个分离的圆。
基于梯度的分水岭图像分割：
原理：分水岭算法也可以和梯度相结合，来实现图像分割。
	  一般梯度图像在边缘处有较高的像素值，而在其它地方则有较低的像素值，理想情况下，分山岭恰好在边缘。
	  因此，我们可以根据梯度来寻找分山岭。
注意：具体见代码

17th：
1、画线条
函数：skimage.draw.line(r1,c1,r2,c2)
参数：r1,r2: 开始点的行数和结束点的行数
	  c1,c2: 开始点的列数和结束点的列数
想画其它颜色的线条
函数：skimage.draw.set_color(img, coords, color)
例子： 	rr, cc =draw.line(1, 150, 270, 250)
		draw.set_color(img,[rr,cc],[0,0,255])
2、画圆
函数：skimage.draw.circle(cy, cx, radius）
参数：cy和cx表示圆心点，radius表示半径
3、多边形
函数：skimage.draw.polygon(Y,X)
参数：Y为多边形顶点的行集合，X为各顶点的列值集合。
4、椭圆
函数：skimage.draw.ellipse(cy, cx, yradius, xradius）
参数：cy和cx为中心点坐标，yradius和xradius代表长短轴。
5、贝塞儿曲线
函数：skimage.draw.bezier_curve(y1,x1,y2,x2,y3,x3,weight)
参数：y1,x1表示第一个控制点坐标
	  y2,x2表示第二个控制点坐标
	  y3,x3表示第三个控制点坐标
	  weight表示中间控制点的权重，用于控制曲线的弯曲度。
6、画空心圆
函数：skimage.draw.circle_perimeter(yx,yc,radius)
参数：yx,yc是圆心坐标，radius是半径
7、空心椭圆
函数：skimage.draw.ellipse_perimeter(cy, cx, yradius, xradius）
参数：cy,cx表示圆心
	  yradius,xradius表示长短轴


