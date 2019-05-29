%非周期边界条件下
%% 第一类边界条件：u|(边界)=g
%以二维热传导方程为例，分简单边界（边界为0）和复杂边界
%（Dt)u=(D2x+D2y)u
clear all;close all;addpath(genpath(pwd));
%% 简单边界（-2<x<2）
%u=0;               |x|=2,|y|=2
%u=1-sqrt(x^2+y^2);  x^2+y^2<=1,t=0
%u=0;                x^2+y^2>1 ,t=0
L=4;N=40;
%构造切比雪夫求导矩阵
h=L/2;
[D,x]=cheb(N);
D=D/h;D2=D^2;
D2=D2(2:N,2:N);     %边界值为0，删除首尾行、列; 求解网格同样处理
x=L/2*x;y=x;
[X,Y]=meshgrid(x(2:N),y(2:N));
%初始条件
u=max(0,1-sqrt(X.^2+Y.^2));
%求解
t=[0 0.02 0.1 0.5];
tic
[t,usol]=ode45('heat1',t,u(:),[],N,D2);
toc
%Elapsed time is 15.234705 seconds.
%画图
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
%% 复杂边界（-1<x<1）
%u=0;                    |x|=1,|y|=1
%u=1-|y|;                 x=1
%u=1-sqrt((x-1)^2+y^2);  (x-1)^2+y^2<=1,t=0
%u=0;                    (x-1)^2+y^2>1 ,t=0
L=2;N=20;  
%构造切比雪夫求导矩阵
h=L/2;
[D,x]=cheb(N);
D=D/h;D2=D^2;           %不用删去首尾
x=L/2*x;y=x;
[X,Y]=meshgrid(x,y);
%初始条件
u=max(0,1-sqrt((X-1).^2+Y.^2));
%求解
t=[0 0.001 0.02 0.5];
tic
%需要对边界条件转化成关于t的边值条件，求解以t为自变量的常微分方程
[t,usol]=ode45('heat2',t,u(:),[],N,D2);  
toc
%Elapsed time is 2.470909 seconds.
%画图
figure(2)
for n=1:4
    subplot(2,2,n)
    u=reshape(usol(n,:),N+1,N+1);
    surfl(x,y,u),shading interp
    axis([-1 1 -1 1 0 1])
    xlabel x, ylabel y ,zlabel u
    title(['t=' num2str(t(n))]);
end

