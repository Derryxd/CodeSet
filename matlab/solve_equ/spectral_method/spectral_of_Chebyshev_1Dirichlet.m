%�����ڱ߽�������
%% ��һ��߽�������u|(�߽�)=g
%�Զ�ά�ȴ�������Ϊ�����ּ򵥱߽磨�߽�Ϊ0���͸��ӱ߽�
%��Dt)u=(D2x+D2y)u
clear all;close all;addpath(genpath(pwd));
%% �򵥱߽磨-2<x<2��
%u=0;               |x|=2,|y|=2
%u=1-sqrt(x^2+y^2);  x^2+y^2<=1,t=0
%u=0;                x^2+y^2>1 ,t=0
L=4;N=40;
%�����б�ѩ���󵼾���
h=L/2;
[D,x]=cheb(N);
D=D/h;D2=D^2;
D2=D2(2:N,2:N);     %�߽�ֵΪ0��ɾ����β�С���; �������ͬ������
x=L/2*x;y=x;
[X,Y]=meshgrid(x(2:N),y(2:N));
%��ʼ����
u=max(0,1-sqrt(X.^2+Y.^2));
%���
t=[0 0.02 0.1 0.5];
tic
[t,usol]=ode45('heat1',t,u(:),[],N,D2);
toc
%Elapsed time is 15.234705 seconds.
%��ͼ
figure(1)
for n=1:4
    subplot(2,2,n)
    u=zeros(N+1);
    u(2:N,2:N)=reshape(usol(n,:),N-1,N-1);
    surfl(x,y,u),shading interp
    axis([-2 2 -2 2 0 1])
    xlabel x, ylabel y ,zlabel u
    title(['t=' num2str(t(n))]);
end

clear all;
%% ���ӱ߽磨-1<x<1��
%u=0;                    |x|=1,|y|=1
%u=1-|y|;                 x=1
%u=1-sqrt((x-1)^2+y^2);  (x-1)^2+y^2<=1,t=0
%u=0;                    (x-1)^2+y^2>1 ,t=0
L=2;N=20;  
%�����б�ѩ���󵼾���
h=L/2;
[D,x]=cheb(N);
D=D/h;D2=D^2;           %����ɾȥ��β
x=L/2*x;y=x;
[X,Y]=meshgrid(x,y);
%��ʼ����
u=max(0,1-sqrt((X-1).^2+Y.^2));
%���
t=[0 0.001 0.02 0.5];
tic
%��Ҫ�Ա߽�����ת���ɹ���t�ı�ֵ�����������tΪ�Ա����ĳ�΢�ַ���
[t,usol]=ode45('heat2',t,u(:),[],N,D2);  
toc
%Elapsed time is 2.470909 seconds.
%��ͼ
figure(2)
for n=1:4
    subplot(2,2,n)
    u=reshape(usol(n,:),N+1,N+1);
    surfl(x,y,u),shading interp
    axis([-1 1 -1 1 0 1])
    xlabel x, ylabel y ,zlabel u
    title(['t=' num2str(t(n))]);
end

