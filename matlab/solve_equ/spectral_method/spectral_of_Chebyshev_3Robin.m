%非周期边界条件下
%% 第三类边界条件：Du|(边界)+u|(边界)=g
%解决思路与第二类相似，以二维热传导方程为例
clear all;close all;addpath(genpath(pwd));
%% 预处理：
%使用odes函数时，需要将u的边界条件转为针对(Dt)u的边界条件
%             ，且需要二阶混合偏导(D2tx)u连续可交换求导顺序
%如边界绝热条件，(Dx)u=0|(x=+-1)等价为(Dt(Dx))u=0，再交换顺序为(Dx(Dt))u=0
%该处理详情见func中的heat2D.m
%% 二维热传导方程
% (D2t)u=(D2x+D2y)u ,   -1<x,y<1
% (u+a*(Dx)u)=0|(x=1)
% (Dx)u|(x=-1)=(Dy)u|(|y|=1)=0
% u=(1+cos(pi*x))*(1+cos(pi*y));
L=2;N=20;a=0.1;
%构造切比雪夫求导矩阵
h=L/2;
[D,x]=cheb(N);
D=D/h;D2=D^2;
x=h*x;y=x;
%罗宾边界条件，处理了(Dy)u
BCx=-(a*D([1 N+1],[1 N+1])+[1 0;0 0])\(a*D([1 N+1],2:N));
BCy=-D([1 N+1],[1 N+1])\D([1 N+1],2:N);
%初始条件
[X,Y]=meshgrid(x,y);
u=(1+cos(pi*X)).*(1+cos(pi*Y));
%求解
t=[0 0.05 0.2 4];
[t,usol]=ode45('heat2D',t,u(:),[],N,D2,BCx,BCy);
%画图
figure(1)
for n=1:4
    subplot(2,2,n)
    uu=reshape(usol(n,:),N+1,N+1);
    surfl(x,y,uu),shading interp
    title(['t=' num2str(t(n))])
    axis([-1 1 -1 1 0 4]),view(15,15)
    xlabel x, ylabel y ,zlabel u
    %误差
    E=h*u*D'+u;max(abs(E(:,1)))
end
