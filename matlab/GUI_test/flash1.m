clear;close all;clc
%��������
filename= 'test.gif'; %���gif�ļ�������
t1=0.5;t=0.5;%t1:��һ��ͼ��ͣ��ʱ�䣬t����ʱ�������������Ʋ����ٶȣ���λ��
%By HarryLau,2578004536@qq.com
ext = {'\*.jpeg', '\*.jpg', '\*.png', '\*.pgm', '\*.tig', '\*.bmp'};  d = [ ];
for i = 1:length(ext)
    d =[d; dir( [cd,ext{i}] ) ]; % cd:��ǰ·��
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
    im=frame2im(frame);%����gif�ļ���ͼ�������index����ͼ��
    [I,map]=rgb2ind(im,256);
    k=i-0;
    if k==1
        imwrite(I,map,filename,'gif','Loopcount',inf,...
            'DelayTime',t1);%loopcountֻ����i==1��ʱ�������
    else
        imwrite(I,map,filename,'gif','WriteMode','append',...
            'DelayTime',t);%DelaylayTime��������gif�ļ��Ĳ��ſ���
    end
end