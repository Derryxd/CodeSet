% clear all ; close all;
load newll;
% plot
scrsz=get(0,'screensize');  %(3,4)为屏幕的宽度和高度
% figure('position',scrsz); %全屏显示
tic
%% res2
data=ncread('E:\360data\重要数据\桌面\ocn_analysis\res2\MMEAN0001-01.nc','ts');
lon_grid=ncread('E:\360data\重要数据\桌面\ocn_analysis\res2\MMEAN0001-01.nc','lon');
lat_grid=ncread('E:\360data\重要数据\桌面\ocn_analysis\res2\MMEAN0001-01.nc','lat');
a=data(:,:,1);
[x y]=meshgrid(lat_grid,lon_grid);
x=double(x);y=double(y);
g1=subplot(1,2,2);                      %gca=g
set(gca,'position',[0.54 0.3 0.4 0.4]); %图形范围[left bottom width height] 
lat=[-90 90];
lon=[0 360];
axesm('MapProjection','eqdcylin','maplatlimit',lat,'maplonlimit',lon);  %h
%gca:g1=h，即subplot与axesm为同一图形坐标轴
axis off                                %除去axes的外部坐标
axis normal
tightmap;                               %除去空白空间
% setm(gca); %查看当前可以设置的所有图形坐标轴(map axes)的属性  
setm(gca,'Frame','on');                 %使框架可见  
setm(gca,'Grid','off');                 %关闭网格  
setm(gca,'MLabelLocation',60);          %标上经度刻度标签,每隔60度  
setm(gca,'MeridianLabel','on');         %设置经度刻度标签可见  
setm(gca,'PLabelLocation',-90:30:90)    %标上经度刻度标签,[-90:30:90]  
setm(gca,'ParallelLabel','on');         %设置经度刻度标签可见  
setm(gca,'MLabelParallel','south');     %将经度刻度标签放在南方,即下部    
setm(gca,'PLabelMeridian','west');      %将纬度刻度标签放在西方,即左边（后可填数字，代表所在经度处）      
setm(gca,'Origin',[0,180,0]);           %设置地图的中心位置和绕中心点和地心点的轴旋转角度[latitude longitude orientation]
h1=plotm(nlat,nlon,'k');
hold on
contourfm(x,y,a,30,'linestyle','none'); %将数据分成30份，并删去等值线 [c,h2]
cb=colorbar('southoutside','position',[0.54 0.2 0.4 0.06]);
caxis([min(a(:)) max(a(:))])            %cb颜色范围
colormap(jet(30))                       %cmap设置
set(get(cb,'XLabel'),'String','SST')
hold off
clearvars a
toc
%Elapsed time is 5.139933 seconds.
%% res05
% tic
% data=ncread('E:\360data\重要数据\桌面\ocn_analysis\res05\MMEAN0001-01.nc','ts');
% lon_grid=ncread('E:\360data\重要数据\桌面\ocn_analysis\res05\MMEAN0001-01.nc','lon');
% lat_grid=ncread('E:\360data\重要数据\桌面\ocn_analysis\res05\MMEAN0001-01.nc','lat');
% [x y]=meshgrid(lat_grid,lon_grid);
% x=double(x);y=double(y);
% g2=subplot(1,2,2);         %gca=g
% gca
% set(gca,'position',[0.54 0.3 0.4 0.4]);%图形范围[left bottom width height] 
% lat=[-90 90];
% lon=[0 360];
% axesm('MapProjection','eqdcylin','maplatlimit',lat,'maplonlimit',lon);   %h
% %gca:g2=h，即subplot与axesm为同一图形坐标轴
% axis off    %除去axes的外部坐标
% axis normal
% tightmap;
% % setm(gca);%查看当前可以设置的所有图形坐标轴(map axes)的属性  
% setm(gca,'Frame','on');                 %使框架可见  
% setm(gca,'Grid','off');                 %关闭网格  
% setm(gca,'MLabelLocation',60);          %标上经度刻度标签,每隔60度  
% setm(gca,'MeridianLabel','on');         %设置经度刻度标签可见  
% setm(gca,'PLabelLocation',-90:30:90)    %标上经度刻度标签,[-90:30:90]  
% setm(gca,'ParallelLabel','on');         %设置经度刻度标签可见  
% setm(gca,'MLabelParallel','south');     %将经度刻度标签放在南方,即下部    
% setm(gca,'PLabelMeridian','west');      %将纬度刻度标签放在西方,即左边（后可填数字，代表所在经度处）      
% setm(gca,'Origin',[0,180,0]);           %设置地图的中心位置和绕中心点和地心点的轴旋转角度[latitude longitude orientation]
% plotm(nlat,nlon,'k');%h1
% hold on
% contourfm(x,y,data(:,:,1),30,'linestyle','none');    %将数据分成30份，并删去等值线 [c,h2]
% cb=colorbar('southoutside','position',[0.54 0.2 0.4 0.06]);
% % caxis([-20 30]) %cb颜色范围
% % colormap(jet)   %cmap设置
% set(get(cb,'XLabel'),'String','SST')
% hold off
% toc
% %Elapsed time is 44.121983 seconds.