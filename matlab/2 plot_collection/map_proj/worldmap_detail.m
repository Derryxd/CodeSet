% clear all ; close all;
load newll;
% plot
scrsz=get(0,'screensize');  %(3,4)Ϊ��Ļ�Ŀ�Ⱥ͸߶�
% figure('position',scrsz); %ȫ����ʾ
tic
%% res2
data=ncread('E:\360data\��Ҫ����\����\ocn_analysis\res2\MMEAN0001-01.nc','ts');
lon_grid=ncread('E:\360data\��Ҫ����\����\ocn_analysis\res2\MMEAN0001-01.nc','lon');
lat_grid=ncread('E:\360data\��Ҫ����\����\ocn_analysis\res2\MMEAN0001-01.nc','lat');
a=data(:,:,1);
[x y]=meshgrid(lat_grid,lon_grid);
x=double(x);y=double(y);
g1=subplot(1,2,2);                      %gca=g
set(gca,'position',[0.54 0.3 0.4 0.4]); %ͼ�η�Χ[left bottom width height] 
lat=[-90 90];
lon=[0 360];
axesm('MapProjection','eqdcylin','maplatlimit',lat,'maplonlimit',lon);  %h
%gca:g1=h����subplot��axesmΪͬһͼ��������
axis off                                %��ȥaxes���ⲿ����
axis normal
tightmap;                               %��ȥ�հ׿ռ�
% setm(gca); %�鿴��ǰ�������õ�����ͼ��������(map axes)������  
setm(gca,'Frame','on');                 %ʹ��ܿɼ�  
setm(gca,'Grid','off');                 %�ر�����  
setm(gca,'MLabelLocation',60);          %���Ͼ��ȿ̶ȱ�ǩ,ÿ��60��  
setm(gca,'MeridianLabel','on');         %���þ��ȿ̶ȱ�ǩ�ɼ�  
setm(gca,'PLabelLocation',-90:30:90)    %���Ͼ��ȿ̶ȱ�ǩ,[-90:30:90]  
setm(gca,'ParallelLabel','on');         %���þ��ȿ̶ȱ�ǩ�ɼ�  
setm(gca,'MLabelParallel','south');     %�����ȿ̶ȱ�ǩ�����Ϸ�,���²�    
setm(gca,'PLabelMeridian','west');      %��γ�ȿ̶ȱ�ǩ��������,����ߣ���������֣��������ھ��ȴ���      
setm(gca,'Origin',[0,180,0]);           %���õ�ͼ������λ�ú������ĵ�͵��ĵ������ת�Ƕ�[latitude longitude orientation]
h1=plotm(nlat,nlon,'k');
hold on
contourfm(x,y,a,30,'linestyle','none'); %�����ݷֳ�30�ݣ���ɾȥ��ֵ�� [c,h2]
cb=colorbar('southoutside','position',[0.54 0.2 0.4 0.06]);
caxis([min(a(:)) max(a(:))])            %cb��ɫ��Χ
colormap(jet(30))                       %cmap����
set(get(cb,'XLabel'),'String','SST')
hold off
clearvars a
toc
%Elapsed time is 5.139933 seconds.
%% res05
% tic
% data=ncread('E:\360data\��Ҫ����\����\ocn_analysis\res05\MMEAN0001-01.nc','ts');
% lon_grid=ncread('E:\360data\��Ҫ����\����\ocn_analysis\res05\MMEAN0001-01.nc','lon');
% lat_grid=ncread('E:\360data\��Ҫ����\����\ocn_analysis\res05\MMEAN0001-01.nc','lat');
% [x y]=meshgrid(lat_grid,lon_grid);
% x=double(x);y=double(y);
% g2=subplot(1,2,2);         %gca=g
% gca
% set(gca,'position',[0.54 0.3 0.4 0.4]);%ͼ�η�Χ[left bottom width height] 
% lat=[-90 90];
% lon=[0 360];
% axesm('MapProjection','eqdcylin','maplatlimit',lat,'maplonlimit',lon);   %h
% %gca:g2=h����subplot��axesmΪͬһͼ��������
% axis off    %��ȥaxes���ⲿ����
% axis normal
% tightmap;
% % setm(gca);%�鿴��ǰ�������õ�����ͼ��������(map axes)������  
% setm(gca,'Frame','on');                 %ʹ��ܿɼ�  
% setm(gca,'Grid','off');                 %�ر�����  
% setm(gca,'MLabelLocation',60);          %���Ͼ��ȿ̶ȱ�ǩ,ÿ��60��  
% setm(gca,'MeridianLabel','on');         %���þ��ȿ̶ȱ�ǩ�ɼ�  
% setm(gca,'PLabelLocation',-90:30:90)    %���Ͼ��ȿ̶ȱ�ǩ,[-90:30:90]  
% setm(gca,'ParallelLabel','on');         %���þ��ȿ̶ȱ�ǩ�ɼ�  
% setm(gca,'MLabelParallel','south');     %�����ȿ̶ȱ�ǩ�����Ϸ�,���²�    
% setm(gca,'PLabelMeridian','west');      %��γ�ȿ̶ȱ�ǩ��������,����ߣ���������֣��������ھ��ȴ���      
% setm(gca,'Origin',[0,180,0]);           %���õ�ͼ������λ�ú������ĵ�͵��ĵ������ת�Ƕ�[latitude longitude orientation]
% plotm(nlat,nlon,'k');%h1
% hold on
% contourfm(x,y,data(:,:,1),30,'linestyle','none');    %�����ݷֳ�30�ݣ���ɾȥ��ֵ�� [c,h2]
% cb=colorbar('southoutside','position',[0.54 0.2 0.4 0.06]);
% % caxis([-20 30]) %cb��ɫ��Χ
% % colormap(jet)   %cmap����
% set(get(cb,'XLabel'),'String','SST')
% hold off
% toc
% %Elapsed time is 44.121983 seconds.