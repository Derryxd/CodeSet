clear;clc;close all;
m=480;n=1440;
D=shaperead('landareas.shp','UseGeoCoords',true);
%% A:先做季节和年的平均，再24小时相加
for i=1:4
    fid=fopen('amount2016_sum_season_yu_24.dat','r');
    A(:,:,i)=fread(fid,[n,m],'float');
end
A(A==-9999)=nan;
fclose all;
a=A(:);
%画图
figure(1)
R=[4 59.875 0.125];%R=[cells/degree northern_latitude_limit western_longitude_limit]
h=axesm('MapProjection','lambcyln');framem; gridm;%等价于：axesm('lambcyln','grid','on','frame','on')
% axesm('mercator','MapLatLimit',[-70 80])
set(h,'Position',[-0.1,0.1,1.2,1]);%[left bottom width height]（如果没有设置units，数值表示比例）
axis off
geoshow(A(:,:,2)',R,'DisplayType','texturemap');
hold on
geoshow([D.Lat],[D.Lon],'Color','black');
hcb = colorbar('southoutside');
set(hcb,'Position',[0.25,0.2,0.5,0.1])
set(get(hcb,'Xlabel'),'String','a的JJA分布')
%% B:先24小时相加，后做季节和年的平均
for i=1:4
    fid=fopen('amount_sum_season_LST.dat','r');
    B(:,:,i)=fread(fid,[n,m],'float');
end
B(B==-9999)=nan;
b=B(:);
fclose all;
figure(2)
R=[4 59.875 0.125];%R=[cells/degree northern_latitude_limit western_longitude_limit]
h=axesm('MapProjection','lambcyln');framem; gridm;%等价于：axesm('lambcyln','grid','on','frame','on')
% axesm('mercator','MapLatLimit',[-70 80])
set(h,'Position',[-0.1,0.1,1.2,1]);%[left bottom width height]（如果没有设置units，数值表示比例）
axis off
geoshow(B(:,:,2)',R,'DisplayType','texturemap');
hold on
geoshow([D.Lat],[D.Lon],'Color','black');
hcb = colorbar('southoutside');
set(hcb,'Position',[0.25,0.2,0.5,0.1])
set(get(hcb,'Xlabel'),'String','b的JJA分布')
%% 区别
disp(strcat('maxa=',num2str(max(a))))
disp(strcat('suma=',num2str(nansum(a))))
disp(strcat('finda为0的个数',num2str(numel(find(a==0)))))
disp('~~~~华丽丽的分割线~~~~')
disp(strcat('maxb=',num2str(max(b))))
disp(strcat('sumb=',num2str(nansum(b))))
disp(strcat('findb为0的个数',num2str(numel(find(b==0)))))
C=a-b;
[x,y]=find(C~=0);     %不等于0的位置，就是二者有差别的地方。
