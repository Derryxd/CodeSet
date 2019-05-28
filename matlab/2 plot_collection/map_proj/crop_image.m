% 裁剪各种形状
close all;
clc;clear;
%% 圆形
figure( 1 );
img = imread( 'sy_60294738471.jpg' );
imshow( img );
% 使用椭圆在figure上创建一个椭圆，这四个数决定你截图的位置和大小% [ 椭圆外接矩形的左上角x， 左上角y， 宽，长 ]
% 这个椭圆在figure上可以拖拽
h = imellipse( gca, [ 150, 150, 300, 500 ] );
% 把这个椭圆转为一个和img同样大小的二值图，1表示椭圆内部，0表示外部
BW = createMask( h );
% 根据二值图构建截图，椭圆外的都染黑
[ w, h, d3 ] = size( img );
newimg = zeros( w, h, d3, 'uint8' );
for i = 1 :    d3    
    band = img( :, :, i );    
    newband = zeros( w, h, 'uint8' );    
    newband( BW ) = band( BW );    
    newimg( :, :, i ) = newband;
end
figure( 2 );
imshow( newimg );
% imwrite( 'D:\newimg.jpg' );% 截图可以保存
% figure( 3 );
% newimg = newimg( 150 : 650, 150 : 450, : );%椭圆的外接矩形区域抠出来
% imshow( newimg );
%% 矩形
% I2 = imcrop(I,rect)；
% %rect is a four-element position vector of the form [xmin ymin width height]
%% 多边形
% BW = roipoly(I, c, r)；
% %the polygon described by vectors c and r, which specify the column and row indices of each vertex, respectively. c and r must be the same size.
%% 特定区域外
%将原图和剪裁的图分别保存，再imread后，两矩阵相减，因为黑色为（0 0 0 ），相减后，特定区域为黑色
%或者用'DisplayType', 'polygon'

