% close all;
data=ncread('E:\360data\重要数据\桌面\ocn_analysis\res2\MMEAN0001-01.nc','ts');
lon_grid=ncread('E:\360data\重要数据\桌面\ocn_analysis\res2\MMEAN0001-01.nc','lon');
lat_grid=ncread('E:\360data\重要数据\桌面\ocn_analysis\res2\MMEAN0001-01.nc','lat');
[x,y]=meshgrid(lon_grid,lat_grid);

load coast
scrsz=get(0,'screensize');%(3,4)为屏幕的宽度和高度
figure('position',scrsz); %全屏显示
bb=subplot(1,2,1);
[c,hh]=contourf(x,y,data(:,:,1)',30);    %将数据分成30份
hold on
aa=plot(nlon,nlat,'-k','linewidth',1);
hold off
set(hh,'Color','none');                  %去掉等值线
gca
set(gca,'linewidth',2,'fontsize',12,'ylim',[-90 90],'xlim',[0 360], ...
    'position',[0.05 0.3 0.4 0.45],...
    'xtick',0:60:360,'xticklabel',{'0','60°E','120°E','180°','120W','60W','0'}, ...
    'ytick',-90:30:90,'yticklabel',{'90S','60S','30S','0','30N','60N','90N'});
%%shading flat       %(无缺失值可去掉等值线)  
colorbar('southoutside','position',[0.05 0.2 0.4 0.06])

subplot(1,2,2)
plot(long,lat,'-k','linewidth',1);
% hold on 
% [c,h]=contour(x,y,data(:,:,1)',9,'linecolor','k','linewidth',0.5);
% text_handle=clabel(c,h);   %加入等值线数值
% set(h,'levellist',-5:10:35,'textlist',-5:10:35);   %设置等值线间距
% hold off
set(gca,'linewidth',2,'fontsize',12,'ylim',[-90 90],'xlim',[-180 180], ...
    'position',[0.5 0.3 0.4 0.45],...
    'xtick',-180:60:180,'xticklabel',{'180W','120W','60W','0','60E','120E','180E'}, ...
    'ytick',-90:30:90,'yticklabel',{'90S','60S','30S','0','30N','60N','90N'});


