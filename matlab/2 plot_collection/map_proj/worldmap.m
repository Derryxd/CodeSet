%%   
clear;clc;close all  
maps %�鿴��ǰ���õĵ�ͼͶӰ��ʽ  
  
%% ����������,ȫ�򺣰���  
load coast  
  
%% ��ͼ  
figure
h1=axesm('MapProjection','robinson');
h2=patchm(lat,long,'g');  
gca
 %% ��������  
% setm(gca);%�鿴��ǰ�������õ�����ͼ��������(map axes)������  
setm(gca,'Frame','on');%ʹ��ܿɼ�  
getm(gca,'Frame');%ʹ��getm���Ի�ȡָ����ͼ�������������  
setm(gca,'Grid','on');%������  
setm(gca,'MLabelLocation',60);%���Ͼ��ȿ̶ȱ�ǩ,ÿ��60��  
setm(gca,'MeridianLabel','on');%���þ��ȿ̶ȱ�ǩ�ɼ�  
setm(gca,'PLabelLocation',[-90:30:90])%���Ͼ��ȿ̶ȱ�ǩ,[-90:30:90]  
setm(gca,'ParallelLabel','on');%���þ��ȿ̶ȱ�ǩ�ɼ�  
setm(gca,'MLabelParallel','south');%�����ȿ̶ȱ�ǩ�����Ϸ�,���²�    
setm(gca,'Origin',[0,90,0]);%���õ�ͼ������λ�ú������ĵ�͵��ĵ������ת�Ƕ�[latitude longitude orientation]  
setm(gca,'PLabelMeridian',90);%��γ�ȱ�ǩ�����ھ���Ϊ90�ȵĵط�  

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
% axesm eckert4; %ע��axesm�����m����?,����ʹ��maps����鿴���еĵ�ͼͶӰ�ķ�ʽ,Ȼ��ѡһ��  
% framem; gridm;%��ʾ��ܺ�������,ע����涼���˸�m,��ʾmap  
% axis off %�ر��ⲿ������,�ⲿ�����᲻ͬ��map axes  
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
% setm(h1,'PLabelMeridian','west','MLabelParallel','south');%����������λ��
% setm(h1,'Origin',[0 114]);
% grid off;
% h=geoshow('landareas.shp','FaceColor', [0.8 0.8 0.8]);
% % ��δ������������ƻ�����ͼ�Լ����������ע��ʽ�����Ƶ�ͼ��ɫ��ͶӰ���ġ���Χ�ȵȡ�����������ȫ���ǣ�����
% % ��һ�����Խ���Ժ�ĺܶ�ͨ�����⡣
% % ����һ������plotm��textm�ȵȣ���ʵһ�����־����׾��Ǹ�plot��text�÷���ȫһ���ġ��������ͦ��ѧ�ģ�������
%         plotm(poss(1,1),poss(2,1),'o','markersize',8,'MarkerFaceColor','y');
%         textm(poss(1,1)+8,poss(2,1)-10,prn, 'fontname','Times New Rom','FontWeight','Bold','Color','K','fontsize',14);%