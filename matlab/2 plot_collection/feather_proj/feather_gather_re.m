close all;clc;
%% feather plot
% object:4502����
% ps:�����ٷ���ʱ��ͼ,˳ʱ���ʾ 
% author: lixy
% date: 2018/1/23
%% read data
%10min����
file = '4502#20170429-20171107-May-10min.txt';
path = '.';
data10=importdata([path '\' file]);
%60min����
file = '4502#20170429-20171107-May_60min.txt';
path = '.';
data60=importdata([path '\' file]);    
%% process data
%10min����
val_speed10=data10.data(:,37);
val_direc10=pi/2-data10.data(:,17)*pi/180;  %Ĭ��Ϊ��ʱ�룬����pi/2-ת��Ϊ��ʱ��
[u10,v10] = pol2cart(val_direc10,val_speed10);
z10 = u10+v10*1i;                           %������ʾ
%60min����
val_speed60=data60.data(:,37);
val_direc60=pi/2-data60.data(:,17)*pi/180;  %Ĭ��Ϊ��ʱ�룬����pi/2-ת��Ϊ��ʱ��
[u60,v60] = pol2cart(val_direc60,val_speed60);
z60 = u60+v60*1i;                           %������ʾ
%Ϊ�Ա��������ϣ�ʹ֮����һ������ȱʧֵ�
scaling = 6;                                %�������ϳ��ȱ���
size_z60= length(z60);
tmp_mat = nan(size_z60, scaling);          
tmp_mat(:,1) = z60;
z60_re = reshape(tmp_mat.',[length(z10),1]); %ת�ú�ı����size��ʹ֮��z10һ��
%% plot
xlabel=0:4:24;
scrsz=get(0,'screensize');   %(3,4)Ϊ��Ļ�Ŀ�Ⱥ͸߶�
%����һ��ķ�������  
figure(1)      
feather(z10(1:144),'r')
hold on
feather(z60_re(1:144),'b')
hold off
set(gca,'Xtick',0:24:288)
set(gca,'Xticklabel',xlabel)
title('speed-4502#5��-10min')  %��ӱ���
set(gcf,'Position',scrsz)      %ȫ����ʾ








