clear;clc;close all;
m=480;n=1440;
D=shaperead('landareas.shp','UseGeoCoords',true);
%% A:�������ں����ƽ������24Сʱ���
for i=1:4
    fid=fopen('amount2016_sum_season_yu_24.dat','r');
    A(:,:,i)=fread(fid,[n,m],'float');
end
A(A==-9999)=nan;
fclose all;
a=A(:);
%��ͼ
figure(1)
R=[4 59.875 0.125];%R=[cells/degree northern_latitude_limit western_longitude_limit]
h=axesm('MapProjection','lambcyln');framem; gridm;%�ȼ��ڣ�axesm('lambcyln','grid','on','frame','on')
% axesm('mercator','MapLatLimit',[-70 80])
set(h,'Position',[-0.1,0.1,1.2,1]);%[left bottom width height]�����û������units����ֵ��ʾ������
axis off
geoshow(A(:,:,2)',R,'DisplayType','texturemap');
hold on
geoshow([D.Lat],[D.Lon],'Color','black');
hcb = colorbar('southoutside');
set(hcb,'Position',[0.25,0.2,0.5,0.1])
set(get(hcb,'Xlabel'),'String','a��JJA�ֲ�')
%% B:��24Сʱ��ӣ��������ں����ƽ��
for i=1:4
    fid=fopen('amount_sum_season_LST.dat','r');
    B(:,:,i)=fread(fid,[n,m],'float');
end
B(B==-9999)=nan;
b=B(:);
fclose all;
figure(2)
R=[4 59.875 0.125];%R=[cells/degree northern_latitude_limit western_longitude_limit]
h=axesm('MapProjection','lambcyln');framem; gridm;%�ȼ��ڣ�axesm('lambcyln','grid','on','frame','on')
% axesm('mercator','MapLatLimit',[-70 80])
set(h,'Position',[-0.1,0.1,1.2,1]);%[left bottom width height]�����û������units����ֵ��ʾ������
axis off
geoshow(B(:,:,2)',R,'DisplayType','texturemap');
hold on
geoshow([D.Lat],[D.Lon],'Color','black');
hcb = colorbar('southoutside');
set(hcb,'Position',[0.25,0.2,0.5,0.1])
set(get(hcb,'Xlabel'),'String','b��JJA�ֲ�')
%% ����
disp(strcat('maxa=',num2str(max(a))))
disp(strcat('suma=',num2str(nansum(a))))
disp(strcat('findaΪ0�ĸ���',num2str(numel(find(a==0)))))
disp('~~~~�������ķָ���~~~~')
disp(strcat('maxb=',num2str(max(b))))
disp(strcat('sumb=',num2str(nansum(b))))
disp(strcat('findbΪ0�ĸ���',num2str(numel(find(b==0)))))
C=a-b;
[x,y]=find(C~=0);     %������0��λ�ã����Ƕ����в��ĵط���
