% �����ٷ���ʱ��ͼ,˳ʱ���ʾ

%4502����
% data1=importdata('C:\Users\lixingyu\Desktop\ᓽ�����\���ݴ���\ͬ�ڷ��ٷ���ͼ\5�±Ƚϣ����ٴ�\4502#20170429-20171107-May-10min.txt');
% data(1)=importdata('C:\Users\lixingyu\Desktop\ᓽ�����\���ݴ���\ͬ�ڷ��ٷ���ͼ\5�±Ƚϣ����ٴ�/4502#20170429-20171107-May_60min.txt');
data1=importdata('4502#20170429-20171107-May-10min.txt');
data=importdata('4502#20170429-20171107-May_60min.txt');
% for i=1:1 �����ã����˻�������x��ļ�ͷ;
    val_speed1=data1.data(:,37);
    val_direc1=pi/2-data1.data(:,17)*pi/180;%Ĭ��Ϊ��ʱ�룬����pi/2-ת��Ϊ��ʱ��
    [u1,v1]=pol2cart(val_direc1,val_speed1);
    z1=u1+v1*i;
    val_speed1=data(1).data(:,37);
    val_direc1=pi/2-data(1).data(:,17)*pi/180;%Ĭ��Ϊ��ʱ�룬����pi/2-ת��Ϊ��ʱ��
    [u,v]=pol2cart(val_direc1,val_speed1);
    z=u+v*i;
    figure(1)
    feather(z1(1:144),'r')
    set(gca,'Xtick',0:24:288)
    xlab1=0:4:24;
    set(gca,'Xticklabel',xlab1)
    %��ӱ���
    title('speed-4502#5��-10min')
    hold on
    feather(z(1:24),'b')
%         set(gca,'Xtick',0:4:24)
% %     axis([0 26 -5 0])     
%     xlab1=0:4:24;
%     set(gca,'Xticklabel',xlab1)
%     %��ӱ���
%     title('speed-4502#5��-60min')
    hold off 
    


