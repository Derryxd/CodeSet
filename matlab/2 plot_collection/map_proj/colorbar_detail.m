%%
close all;clear all;clc
a=peaks;
cmin=min(a(:));cmax=max(a(:));
cb=colormap(jet(5));
cb(1,:)=[1 1 1];    %������ɫ����
figure  %ԭͼ
contourf(a)
colorbar
figure  %��ͼ
aa=a;               %������ͼ����
b=[-8 -1 0 3 5 9];  %Ԥ�跶Χ
for i=1:5           %����Ԥ�跶Χ����Ԫ���ݷֿ�
aa(a>=b(i)&a<b(i+1))=i-0.5;
end
contourf(aa);
caxis([0 5]);       %��ɫ�̶ȷ�Χ
cm=colormap(cb);    %������ɫ����
hc=colorbar;
set(hc,'yTick',0:1:5)   %y���̶�
set(hc,'YTickLabel',b)  %�̶Ⱦ���ֵ
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