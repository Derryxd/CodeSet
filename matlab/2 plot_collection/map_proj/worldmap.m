%%   
clear;clc;close all  
maps %查看当前可用的地图投影方式  
  
%% 　导入数据,全球海岸线  
load coast  
  
%% 绘图  
figure
h1=axesm('MapProjection','robinson');
h2=patchm(lat,long,'g');  
gca
 %% 设置属性  
% setm(gca);%查看当前可以设置的所有图形坐标轴(map axes)的属性  
setm(gca,'Frame','on');%使框架可见  
getm(gca,'Frame');%使用getm可以获取指定的图形坐标轴的属性  
setm(gca,'Grid','on');%打开网格  
setm(gca,'MLabelLocation',60);%标上经度刻度标签,每隔60度  
setm(gca,'MeridianLabel','on');%设置经度刻度标签可见  
setm(gca,'PLabelLocation',[-90:30:90])%标上经度刻度标签,[-90:30:90]  
setm(gca,'ParallelLabel','on');%设置经度刻度标签可见  
setm(gca,'MLabelParallel','south');%将经度刻度标签放在南方,即下部    
setm(gca,'Origin',[0,90,0]);%设置地图的中心位置和绕中心点和地心点的轴旋转角度[latitude longitude orientation]  
setm(gca,'PLabelMeridian',90);%将纬度标签放置在经度为90度的地方  

% %%
% load korea  
% figure;  
% worldmap(map, refvec)  
%   
% % Display the Korean data grid as a texture map.   
% geoshow(gca,map,refvec,'DisplayType','texturemap');  
% demcmap(map)  
%   
% % Display the land area boundary as black lines.  
% S = shaperead('landareas','UseGeoCoords',true);  
% geoshow([S.Lat], [S.Lon],'Color','black');  
% 
% 
% %%   
% clear;clc;close all  
% load geoid  
% % Create a figure with an Eckert projection.  
% figure  
% axesm eckert4; %注意axesm后面的m了吗?,可以使用maps命令查看所有的地图投影的方式,然后选一个  
% framem; gridm;%显示框架和网格线,注意后面都多了个m,表示map  
% axis off %关闭外部坐标轴,外部坐标轴不同于map axes  
%   
% % Display the geoid as a texture map.   
% geoshow(geoid, geoidrefvec, 'DisplayType', 'texturemap');  
%   
% % Create a colorbar and title.  
% hcb = colorbar('southoutside');  
% set(get(hcb,'Xlabel'),'String','EGM96 Geoid Heights in Meters.')  
%   
% % Mask out all the land.  
% geoshow('landareas.shp', 'FaceColor', 'white');  

%%
% lat=[-90 90];
% lon=[-180 180];
% worldmap(lat,lon);
% h1=axesm('MapProjection','eqdcylin','maplatlimit',lat,'maplonlimit',lon,...
%     'frame','on','parallellabel','on','meridianlabel','on','flinewidth',1,'plabellocation',5,'mlabellocation',10);
% 
% setm(h1,'fedgecolor',[.6 .6 .6], 'fontname','Times New Rom','fontsize',12);
% setm(h1,'grid','on');
% setm(h1,'LabelFormat','none');%{compass} | signed | none
% setm(h1,'PLabelMeridian','west','MLabelParallel','south');%横纵坐标轴位置
% setm(h1,'Origin',[0 114]);
% grid off;
% h=geoshow('landareas.shp','FaceColor', [0.8 0.8 0.8]);
% % 这段代码是用来绘制基本地图以及设置坐标标注格式，控制地图颜色、投影中心、范围等等。基本设置完全涵盖，相信
% % 这一个可以解决以后的很多通用问题。
% % 另外一个就是plotm、textm等等，其实一看名字就明白就是跟plot、text用法完全一样的。这个命名挺科学的，哈哈。
%         plotm(poss(1,1),poss(2,1),'o','markersize',8,'MarkerFaceColor','y');
%         textm(poss(1,1)+8,poss(2,1)-10,prn, 'fontname','Times New Rom','FontWeight','Bold','Color','K','fontsize',14);%