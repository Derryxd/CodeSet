% 画风速风向时序图,顺时针表示

%4502风速
% data1=importdata('C:\Users\lixingyu\Desktop\釗姐任务\数据处理\同期风速风向图\5月比较（风速大）\4502#20170429-20171107-May-10min.txt');
% data(1)=importdata('C:\Users\lixingyu\Desktop\釗姐任务\数据处理\同期风速风向图\5月比较（风速大）/4502#20170429-20171107-May_60min.txt');
data1=importdata('4502#20170429-20171107-May-10min.txt');
data=importdata('4502#20170429-20171107-May_60min.txt');
% for i=1:1 不能用，用了会变成沿着x轴的箭头;
    val_speed1=data1.data(:,37);
    val_direc1=pi/2-data1.data(:,17)*pi/180;%默认为逆时针，这里pi/2-转化为逆时针
    [u1,v1]=pol2cart(val_direc1,val_speed1);
    z1=u1+v1*i;
    val_speed1=data(1).data(:,37);
    val_direc1=pi/2-data(1).data(:,17)*pi/180;%默认为逆时针，这里pi/2-转化为逆时针
    [u,v]=pol2cart(val_direc1,val_speed1);
    z=u+v*i;
    figure(1)
    feather(z1(1:144),'r')
    set(gca,'Xtick',0:24:288)
    xlab1=0:4:24;
    set(gca,'Xticklabel',xlab1)
    %添加标题
    title('speed-4502#5月-10min')
    hold on
    feather(z(1:24),'b')
%         set(gca,'Xtick',0:4:24)
% %     axis([0 26 -5 0])     
%     xlab1=0:4:24;
%     set(gca,'Xticklabel',xlab1)
%     %添加标题
%     title('speed-4502#5月-60min')
    hold off 
    


