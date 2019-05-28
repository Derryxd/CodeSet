close all;clc;
%% feather plot
% object:4502风速
% ps:画风速风向时序图,顺时针表示 
% author: lixy
% date: 2018/1/23
%% read data
%10min资料
file = '4502#20170429-20171107-May-10min.txt';
path = '.';
data10=importdata([path '\' file]);
%60min资料
file = '4502#20170429-20171107-May_60min.txt';
path = '.';
data60=importdata([path '\' file]);    
%% process data
%10min资料
val_speed10=data10.data(:,37);
val_direc10=pi/2-data10.data(:,17)*pi/180;  %默认为逆时针，这里pi/2-转化为逆时针
[u10,v10] = pol2cart(val_direc10,val_speed10);
z10 = u10+v10*1i;                           %复数表示
%60min资料
val_speed60=data60.data(:,37);
val_direc60=pi/2-data60.data(:,17)*pi/180;  %默认为逆时针，这里pi/2-转化为逆时针
[u60,v60] = pol2cart(val_direc60,val_speed60);
z60 = u60+v60*1i;                           %复数表示
%为对比两组资料，使之长度一样，用缺失值填补
scaling = 6;                                %两组资料长度倍数
size_z60= length(z60);
tmp_mat = nan(size_z60, scaling);          
tmp_mat(:,1) = z60;
z60_re = reshape(tmp_mat.',[length(z10),1]); %转置后改变矩阵size，使之与z10一样
%% plot
xlabel=0:4:24;
scrsz=get(0,'screensize');   %(3,4)为屏幕的宽度和高度
%画第一天的风速资料  
figure(1)      
feather(z10(1:144),'r')
hold on
feather(z60_re(1:144),'b')
hold off
set(gca,'Xtick',0:24:288)
set(gca,'Xticklabel',xlabel)
title('speed-4502#5月-10min')  %添加标题
set(gcf,'Position',scrsz)      %全屏显示








