clear all; 
close all;
imag = imread('face7.jpg');  %读取关键帧
imag = rgb2gray(imag);        %转化为灰度图
subplot(131);imshow(imag);title('原图'); 
[high,width] = size(imag);   % 获得图像的高度和宽度
F2 = double(imag);        
U = double(imag);       
uSobel = imag;
for i = 2:high - 1   %sobel边缘检测
    for j = 2:width - 1
        Gx = (U(i+1,j-1) + 2*U(i+1,j) + F2(i+1,j+1)) - (U(i-1,j-1) + 2*U(i-1,j) + F2(i-1,j+1));
        Gy = (U(i-1,j+1) + 2*U(i,j+1) + F2(i+1,j+1)) - (U(i-1,j-1) + 2*U(i,j-1) + F2(i+1,j-1));
        uSobel(i,j) = sqrt(Gx^2 + Gy^2); 
    end
end 
subplot(132);imshow(im2uint8(uSobel));title('边缘检测后');  %画出边缘检测后的图像
% Matlab自带函数边缘检测
% K为获取得到的关键帧的灰度图
BW3 = edge(imag,'sobel', 0.09);
subplot(133);imshow(BW3,[]):title('Matlab自带函数边缘检测');