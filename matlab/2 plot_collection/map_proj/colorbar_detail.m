%%
close all;clear all;clc
a=peaks;
cmin=min(a(:));cmax=max(a(:));
cb=colormap(jet(5));
cb(1,:)=[1 1 1];    %设置颜色矩阵
figure  %原图
contourf(a)
colorbar
figure  %新图
aa=a;               %建立画图矩阵
b=[-8 -1 0 3 5 9];  %预设范围
for i=1:5           %按照预设范围，将元数据分块
aa(a>=b(i)&a<b(i+1))=i-0.5;
end
contourf(aa);
caxis([0 5]);       %颜色刻度范围
cm=colormap(cb);    %引用颜色矩阵
hc=colorbar;
set(hc,'yTick',0:1:5)   %y处刻度
set(hc,'YTickLabel',b)  %刻度具体值
clearvars cb hc cmax cmin
%%
% [x,y,z] = peaks(25);
% % c = zeros(size(z));
% % c(z>min(min(z))&z<-1) = 0;
% % c(z>=-1) = 1;
% surf(x,y,z,c);hc = colorbar;
% % axis([-3 1])
% % colormap([1 0 0;0 1 0])
% % set(hc,'YTick',[0 0.5 1])
% % set(hc,'YTickLabel',[min(min(z)) -1 max(max(z))])