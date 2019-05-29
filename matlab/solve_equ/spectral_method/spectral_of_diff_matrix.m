%周期边界条件下
%% 二维平流-扩散方程
%公式：
% (Dt)omega=v*(D2x+D2y)omega+(Dx)omega*(Dy)psi-(Dy)omega*(Dx)psi
% (D2x+D2y)psi=omega
%说明：
% psi:流函数(stream func)
% omega:涡量(vorticity
% v:constant value
% 一式右边：第一部分为扩散部分，第二部分为平流部分
% 流函数可看做涡量的一个参量，即已知初始omega，先求psi，做积分运算，得下一时间的omega
%% 划分网格
L=20; N=128;
x=L/N*(-N/2:N/2-1);y=x;
kx=(2*pi/L)*[0:N/2-1 -N/2:-1];
kx(1)=1e-6;ky=kx;  %防止分母为零
[X,Y]=meshgrid(x,y);
[kX,kY]=meshgrid(kx,ky);
K2=kX.^2+kY.^2;
%% 构造谱求导矩阵
%间隔
h=2*pi/N;
%1阶谱求导矩阵
col=[0 0.5*(-1).^(1:N-1).*cot((1:N-1)*h/2)]';
D=(2*pi/L)*toeplitz(col,col([1 N:-1:2]));   
%2阶谱求导矩阵
col=[-pi^2/(3*h^2)-1/6 -0.5*(-1).^(1:N-1)./sin(h*(1:N-1)/2).^2];
D2=(2*pi/L)^2*toeplitz(col);
%% 初始条件
w=sech((X+2).^2+Y.^2/20)+sech((X-2).^2+Y.^2/20);
%% 数值求解
v=0.001;t=0:10:30;
addpath(genpath(pwd));
[t,wsol]=ode45('advection_diffusion',t,w(:),[],N,D,D2,K2,v);
%% 画图
figure(2)
for n=1:4
    subplot(2,2,n)
    gca=pcolor(reshape(wsol(n,:),N,N));axis off
    set(gca,'LineStyle','none'), shading interp
    title(['t=' num2str(t(n))]), axis square
end
%% 注释
%Toeplitz矩阵（diagonal-constant matrix），指矩阵中每条自左上至右下的斜线上的元素相同
%若直接对矩阵求逆，运算量较大，故先进行傅里叶变换

