clear all;close all;clc
i=1:24;
data=i.^2;
scrsz=get(0,'screensize');%(3,4)为屏幕的宽度和高度
figure('position',scrsz); %全屏显示
x=0:23;  
%    x  y   点线:、正方形s  边缘颜色          表面颜色              表面大小       边缘线宽
plot(x,data/10,':s','MarkerEdgeColor','b','MarkerFaceColor','k','Markersize',8,'linewidth',1);
hold on ;
plot(x,data-2,'o','MarkerEdgeColor','b','MarkerFaceColor','g','Markersize',8,'linewidth',1);
hold off
%设置当前坐标轴gca
%         坐标边框宽度   字体大小     y轴小刻度-开                         y轴范围
set(gca,'linewidth',1,'fontsize',16,'YMinorTick','on','XMinorTick','off','Ylim',[0 55],'Xlim',[0 23] ...
    ,'Position',[0.1 0.2 0.8 0.7] ... %图形范围[left bottom width height] 
    ,'xTick',0:6:18,'xTicklabel',{'00:00','06:00','12:00','18:00'},'clim',[0 100]);
%    x轴刻度值         重新给定对应刻度                                颜色范围
xlabel('\fontsize{20}time');
ylabel('\fontsize{20}magnitude(a^3/b_r)');  %加y轴标签，^加上标，_加下标
x=3;y=8;
text(x,y,'abc','fontsize',20);              %在x，y处加字符
legend('plot1','plot2');









