% close all;
data=ncread('E:\360data\��Ҫ����\����\ocn_analysis\res2\MMEAN0001-01.nc','ts');
lon_grid=ncread('E:\360data\��Ҫ����\����\ocn_analysis\res2\MMEAN0001-01.nc','lon');
lat_grid=ncread('E:\360data\��Ҫ����\����\ocn_analysis\res2\MMEAN0001-01.nc','lat');
[x,y]=meshgrid(lon_grid,lat_grid);

load coast
scrsz=get(0,'screensize');%(3,4)Ϊ��Ļ�Ŀ�Ⱥ͸߶�
figure('position',scrsz); %ȫ����ʾ
bb=subplot(1,2,1);
[c,hh]=contourf(x,y,data(:,:,1)',30);    %�����ݷֳ�30��
hold on
aa=plot(nlon,nlat,'-k','linewidth',1);
hold off
set(hh,'Color','none');                  %ȥ����ֵ��
gca
set(gca,'linewidth',2,'fontsize',12,'ylim',[-90 90],'xlim',[0 360], ...
    'position',[0.05 0.3 0.4 0.45],...
    'xtick',0:60:360,'xticklabel',{'0','60��E','120��E','180��','120W','60W','0'}, ...
    'ytick',-90:30:90,'yticklabel',{'90S','60S','30S','0','30N','60N','90N'});
%%shading flat       %(��ȱʧֵ��ȥ����ֵ��)  
colorbar('southoutside','position',[0.05 0.2 0.4 0.06])

subplot(1,2,2)
plot(long,lat,'-k','linewidth',1);
% hold on 
% [c,h]=contour(x,y,data(:,:,1)',9,'linecolor','k','linewidth',0.5);
% text_handle=clabel(c,h);   %�����ֵ����ֵ
% set(h,'levellist',-5:10:35,'textlist',-5:10:35);   %���õ�ֵ�߼��
% hold off
set(gca,'linewidth',2,'fontsize',12,'ylim',[-90 90],'xlim',[-180 180], ...
    'position',[0.5 0.3 0.4 0.45],...
    'xtick',-180:60:180,'xticklabel',{'180W','120W','60W','0','60E','120E','180E'}, ...
    'ytick',-90:30:90,'yticklabel',{'90S','60S','30S','0','30N','60N','90N'});


