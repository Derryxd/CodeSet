% �ü�������״
close all;
clc;clear;
%% Բ��
figure( 1 );
img = imread( 'sy_60294738471.jpg' );
imshow( img );
% ʹ����Բ��figure�ϴ���һ����Բ�����ĸ����������ͼ��λ�úʹ�С% [ ��Բ��Ӿ��ε����Ͻ�x�� ���Ͻ�y�� ���� ]
% �����Բ��figure�Ͽ�����ק
h = imellipse( gca, [ 150, 150, 300, 500 ] );
% �������ԲתΪһ����imgͬ����С�Ķ�ֵͼ��1��ʾ��Բ�ڲ���0��ʾ�ⲿ
BW = createMask( h );
% ���ݶ�ֵͼ������ͼ����Բ��Ķ�Ⱦ��
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
% imwrite( 'D:\newimg.jpg' );% ��ͼ���Ա���
% figure( 3 );
% newimg = newimg( 150 : 650, 150 : 450, : );%��Բ����Ӿ�������ٳ���
% imshow( newimg );
%% ����
% I2 = imcrop(I,rect)��
% %rect is a four-element position vector of the form [xmin ymin width height]
%% �����
% BW = roipoly(I, c, r)��
% %the polygon described by vectors c and r, which specify the column and row indices of each vertex, respectively. c and r must be the same size.
%% �ض�������
%��ԭͼ�ͼ��õ�ͼ�ֱ𱣴棬��imread���������������Ϊ��ɫΪ��0 0 0 ����������ض�����Ϊ��ɫ
%������'DisplayType', 'polygon'

