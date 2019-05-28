function img_rotate=my_img_rotate(origin_img,radian)
% 旋转后图像=my_img_rotate(源图像,旋转弧度) 0<旋转弧度<pi/2

% 算法:		图像旋转处理(顺时针)
% 创建时间:	2012-3-26(晚)
% 创建人:	abee
% 博客:		http://blog.csdn.net/abee23
% QQ:		8281845

% (abee:我会非常推荐你保留上面5行message的)


%得到包围盒图的大小(保存旋转后的图像)
[h,w,dump]=size(origin_img);

new_img_size 	= (h^2+w^2)^0.5;
img_rotate	= uint8(zeros(new_img_size,new_img_size,3));	%像素是整数

img_rotate_ipt	= imrotate(origin_img,-radian*57.3);		%IPT提示的旋转函数

%注意访问矩阵时,下标是整型的.
%如果单是一个转移,那么将有一点些的像素复制不过去(像素空洞问题)
%但是向上+0.5或者向下-0.5时,多两次复制,这样就能够复制全部点过去了.

cos_val	= cos(radian);
sin_val	= sin(radian);

%计算(x,y)的新坐标,并把像素复制到新坐标(包围盒图).
%时间复杂度:O(n^2)
for x0=1:w
	for y0=1:h
		x = uint32(x0*cos_val - y0*sin_val + h*sin_val);	%完善下边(齿距)
		y = uint32(x0*sin_val + y0*cos_val + 0.5);
		img_rotate(y,x,:) = origin_img(y0,x0,:);

		x = uint32(x0*cos_val - y0*sin_val + h*sin_val + 0.5);	%完善右边(齿距)
		y = uint32(x0*sin_val + y0*cos_val );			% 
		img_rotate(y,x,:) = origin_img(y0,x0,:);

		x = uint32(x0*cos_val - y0*sin_val + h*sin_val + 0.5);	%完善上边(齿距)
		y = uint32(x0*sin_val + y0*cos_val - 0.5);
		img_rotate(y,x,:) = origin_img(y0,x0,:);

		x = uint32(x0*cos_val - y0*sin_val + h*sin_val );	%完善左边(齿距)
		y = uint32(x0*sin_val + y0*cos_val -0.5);
		img_rotate(y,x,:) = origin_img(y0,x0,:);
	end
end

% 显示旋转效果
figure;
imshow(img_rotate);

% 显示IPT的旋转转效果
figure;
imshow(img_rotate_ipt);
%与imrotate的差别:就是原最右下角的点不一样.
