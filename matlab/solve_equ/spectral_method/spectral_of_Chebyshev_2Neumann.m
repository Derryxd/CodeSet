%非周期边界条件下
%% 第二类边界条件：Du|(边界)=g
%解决思路：
%将诺依曼边界条件转化为一类条件，故需求解边界处的值
%即，Du(1)=(D00 ... D0n)*(u0 ... un)'=D00*u0 + (D01 ... D0n)*(u1 ... un)
%若Du(1)=0,则u0=-inv(D00)*(D01 ... D0n)*(u1 ... un)=-D00\(D01 ... D0n)*(u1 ... un)
%以一维热传导方程、二维波动方程、二维Barkley模型为例
clear all;close all;addpath(genpath(pwd));
%% 预处理：
%使用odes函数时，需要将u的边界条件转为针对(Dt)u的边界条件
%             ，且需要二阶混合偏导(D2tx)u连续可交换求导顺序
%如边界绝热条件，(Dx)u=0|(x=+-1)等价为(Dt(Dx))u=0，再交换顺序为(Dx(Dt))u=0
%该处理详情见func中的heat1D.m和wave_tank.m文件
%为避免这一不便，可使用欧拉法处理导数(Dt)u，处理方法见二维Barkley模型程序
%% 一维热传导方程
%（Dt)u=(D2x+D2y)u
% (Dx)u=0;            x=+-1
% u=1+cos(pi*x)       x=+-1
L=2;N=20;
%构造切比雪夫求导矩阵
h=L/2;
[D,x]=cheb(N);
D=D/h;D2=D^2;
x=h*x;
%初始条件
u=1+cos(pi*x);
%诺依曼边界条件
BC=-D([1 N+1],[1 N+1])\D([1 N+1],2:N);    %因为Du=0
%求解
t=0:0.01:0.4;
[t,usol]=ode45('heat1D',t,u,[],N,D2,BC);
%画图
figure(1)
X=L/2:-0.05:-L/2;
u=interp2(x,t,usol,X,t,'cubic');
waterfall(X,t,u)
axis([-1 1 0 0.4 0 2])
xlabel x, ylabel t ,zlabel u
title('两端绝热条件下一维热传导方程的解');

clear all;
%包含周期边界条件和非周期边界
%% 二维波动方程
% (D2t)u=(D2x+D2y)u ,   -3<x<3, -1<y<1
% (Dy)u=0|(|y|=1)   ;   u|(x=-3)=u|(x=-3)
% u=exp(-8*((x+1.5)^2+u^2))|(t=0)
% (Dt)u|(t=0)=-(Dx)u|(t=0)
%x方向
Lx=6; Nx=50;
x=Lx/Nx*(-Nx/2:Nx/2-1)';
h=2*pi/Nx;
col=[0 0.5*(-1).^(1:Nx-1).*cot((1:Nx-1)*h/2)]';
Dx=(2*pi/Lx)*toeplitz(col,col([1 Nx:-1:2]));
col=[-pi^2/(3*h^2)-1/6 -0.5*(-1).^(1:Nx-1)./sin(h*(1:Nx-1)/2).^2];
D2x=(2*pi/Lx)^2*toeplitz(col);
%y方向
Ly=2; Ny=20;
[Dy,y]=cheb(Ny);
Dy=Dy/(Ly/2);D2y=Dy^2;y=Ly/2*y;
%诺依曼边界条件，处理了(Dy)u
BCy=-Dy([1 Ny+1],[1 Ny+1])\Dy([1 Ny+1],2:Ny);
%初始条件，引入v=(Dt)u，将高阶方程转为为一阶方程组
%修改后如下：
% (Dt)u=v           ,   -3<x<3, -1<y<1
% (Dt)v=(D2x+D2y)u 
% (Dy)v=0|(|y|=1)   ;   u|(x=-3)=u|(x=-3)
% u=exp(-8*((x+1.5)^2+u^2))|(t=0)
% v|(t=0)=-(Dx)u|(t=0)
[X,Y]=meshgrid(x,y);
u=exp(-8*((X+1.5).^2+Y.^2));
v=-u*Dx';
uv=[u(:);v(:)];
%求解
t=0:2:4;
[t,uvsol]=ode45('wave_tank',t,uv,[],Nx,Ny,D2x,D2y,BCy);
%画图
figure(2)
for n=1:3
    subplot(3,1,n)
    uu=reshape(uvsol(n,1:end/2),Ny+1,Nx);
    mesh(x,y,uu),view(-10,60),grid off
    title(['t=' num2str(t(n))])
    axis([-3 3 -1 1 -0.15 1])
    xlabel x, ylabel y ,zlabel u
end

clear all;
%非周期边界，使用欧拉法
%% 二维Barkley模型(反应-扩散系统)
% (Dt)u=d*(D2x+D2y)u+u(1-u)/epsilon*(u-(b+v)/a)
% (Dt)v=u-v          ,  -60<x,y<60
% (Dn)u=(Dn)v=0      ,  边界无化学物质进出
%其中：
%u、v为两种相互转化的化学物质浓度，d为扩散系数，a、b和e为系统参数
L=120;N=90;
%构造切比雪夫求导矩阵
h=L/2;
[D,x]=cheb(N);
D=D/h;D2=D^2;
x=h*x;y=x;
%边界条件
BCx=-(D([1 N+1],2:N)')/(D([1 N+1],[1 N+1])');  %u在x方向排列为各行，故需转置
BCy=-D([1 N+1],[1 N+1])\D([1 N+1],2:N);
%初始条件
u_old=zeros(N+1,N+1);v_old=u_old;
u_old(N/2,1:N/2)=0.5;v_old(N/2,1:N/2)=0.5;
u_old(N/2-1,1:N/2)=1;v_old(N/2+1,1:N/2)=1;
usol(:,:,1)=u_old;vsol(:,:,1)=v_old;
%求解,其中(D2*u')'=u*D2'
dt=0.002;epsilon=0.02;a=0.5;b=0.01;d=1.6;
for n=1:3
    for m=1:2500
        u=u_old+dt*(d*(u_old*(D2')+D2*u_old)+ ...
            1/epsilon*u_old.*(1-u_old).*(u_old-(b+v_old)/a));
        v=v_old+dt*(u_old-v_old);
        u([1 N+1],:)=BCy*u(2:N,:); u(:,[1 N+1])=u(:,2:N)*BCx;
        v([1 N+1],:)=BCy*u(2:N,:); v(:,[1 N+1])=u(:,2:N)*BCx;
        u_old=u;v_old=v;
    end
    usol(:,:,n+1)=u;v(:,:,n+1)=v;
end
%画图
figure(3)
for n=1:4
    subplot(2,2,n)
    gca=pcolor(x,y,usol(:,:,n));
    set(gca,'LineStyle','none'),axis off
    shading interp ,axis square
end
text(-2*N,-N,'螺旋波产生的过程');
 
