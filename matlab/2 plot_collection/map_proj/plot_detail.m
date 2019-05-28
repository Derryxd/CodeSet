clear all;close all;clc
i=1:24;
data=i.^2;
scrsz=get(0,'screensize');%(3,4)Ϊ��Ļ�Ŀ�Ⱥ͸߶�
figure('position',scrsz); %ȫ����ʾ
x=0:23;  
%    x  y   ����:��������s  ��Ե��ɫ          ������ɫ              �����С       ��Ե�߿�
plot(x,data/10,':s','MarkerEdgeColor','b','MarkerFaceColor','k','Markersize',8,'linewidth',1);
hold on ;
plot(x,data-2,'o','MarkerEdgeColor','b','MarkerFaceColor','g','Markersize',8,'linewidth',1);
hold off
%���õ�ǰ������gca
%         ����߿���   �����С     y��С�̶�-��                         y�᷶Χ
set(gca,'linewidth',1,'fontsize',16,'YMinorTick','on','XMinorTick','off','Ylim',[0 55],'Xlim',[0 23] ...
    ,'Position',[0.1 0.2 0.8 0.7] ... %ͼ�η�Χ[left bottom width height] 
    ,'xTick',0:6:18,'xTicklabel',{'00:00','06:00','12:00','18:00'},'clim',[0 100]);
%    x��̶�ֵ         ���¸�����Ӧ�̶�                                ��ɫ��Χ
xlabel('\fontsize{20}time');
ylabel('\fontsize{20}magnitude(a^3/b_r)');  %��y���ǩ��^���ϱ꣬_���±�
x=3;y=8;
text(x,y,'abc','fontsize',20);              %��x��y�����ַ�
legend('plot1','plot2');









