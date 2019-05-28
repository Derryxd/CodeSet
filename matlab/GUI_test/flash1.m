clear;close all;clc
%参数调整
filename= 'test.gif'; %你的gif文件的名字
t1=0.5;t=0.5;%t1:第一张图暂停的时间，t其他时间间隔，用来控制播放速度，单位秒
%By HarryLau,2578004536@qq.com
ext = {'\*.jpeg', '\*.jpg', '\*.png', '\*.pgm', '\*.tig', '\*.bmp'};  d = [ ];
for i = 1:length(ext)
    d =[d; dir( [cd,ext{i}] ) ]; % cd:当前路径
end
str = {d.name};
if length(str) ~= 0
    [Selection,ok] = listdlg('ListString',str,'name','Choose pictures','PromptString',...
        'Please choose pictures','SelectionMode','Multiple', 'ListSize',[400,200]);
else
    error('No picture find , add filename extension or change path.')
end
set(0,'defaultfigurecolor','w');

for i = 1:length(Selection)
    figure(i)
     imshow((imread(str{Selection(i)})),'InitialMagnification','fit')% Or :  d(Selection(i)).name == str{Selection}
     title(str(Selection(i)));
    frame=getframe(i);
    im=frame2im(frame);%制作gif文件，图像必须是index索引图像
    [I,map]=rgb2ind(im,256);
    k=i-0;
    if k==1
        imwrite(I,map,filename,'gif','Loopcount',inf,...
            'DelayTime',t1);%loopcount只是在i==1的时候才有用
    else
        imwrite(I,map,filename,'gif','WriteMode','append',...
            'DelayTime',t);%DelaylayTime用于设置gif文件的播放快慢
    end
end