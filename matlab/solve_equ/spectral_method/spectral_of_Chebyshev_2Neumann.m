%�����ڱ߽�������
%% �ڶ���߽�������Du|(�߽�)=g
%���˼·��
%��ŵ�����߽�����ת��Ϊһ���������������߽紦��ֵ
%����Du(1)=(D00 ... D0n)*(u0 ... un)'=D00*u0 + (D01 ... D0n)*(u1 ... un)
%��Du(1)=0,��u0=-inv(D00)*(D01 ... D0n)*(u1 ... un)=-D00\(D01 ... D0n)*(u1 ... un)
%��һά�ȴ������̡���ά�������̡���άBarkleyģ��Ϊ��
clear all;close all;addpath(genpath(pwd));
%% Ԥ����
%ʹ��odes����ʱ����Ҫ��u�ı߽�����תΪ���(Dt)u�ı߽�����
%             ������Ҫ���׻��ƫ��(D2tx)u�����ɽ�����˳��
%��߽����������(Dx)u=0|(x=+-1)�ȼ�Ϊ(Dt(Dx))u=0���ٽ���˳��Ϊ(Dx(Dt))u=0
%�ô��������func�е�heat1D.m��wave_tank.m�ļ�
%Ϊ������һ���㣬��ʹ��ŷ����������(Dt)u������������άBarkleyģ�ͳ���
%% һά�ȴ�������
%��Dt)u=(D2x+D2y)u
% (Dx)u=0;            x=+-1
% u=1+cos(pi*x)       x=+-1
L=2;N=20;
%�����б�ѩ���󵼾���
h=L/2;
[D,x]=cheb(N);
D=D/h;D2=D^2;
x=h*x;
%��ʼ����
u=1+cos(pi*x);
%ŵ�����߽�����
BC=-D([1 N+1],[1 N+1])\D([1 N+1],2:N);    %��ΪDu=0
%���
t=0:0.01:0.4;
[t,usol]=ode45('heat1D',t,u,[],N,D2,BC);
%��ͼ
figure(1)
X=L/2:-0.05:-L/2;
u=interp2(x,t,usol,X,t,'cubic');
waterfall(X,t,u)
axis([-1 1 0 0.4 0 2])
xlabel x, ylabel t ,zlabel u
title('���˾���������һά�ȴ������̵Ľ�');

clear all;
%�������ڱ߽������ͷ����ڱ߽�
%% ��ά��������
% (D2t)u=(D2x+D2y)u ,   -3<x<3, -1<y<1
% (Dy)u=0|(|y|=1)   ;   u|(x=-3)=u|(x=-3)
% u=exp(-8*((x+1.5)^2+u^2))|(t=0)
% (Dt)u|(t=0)=-(Dx)u|(t=0)
%x����
Lx=6; Nx=50;
x=Lx/Nx*(-Nx/2:Nx/2-1)';
h=2*pi/Nx;
col=[0 0.5*(-1).^(1:Nx-1).*cot((1:Nx-1)*h/2)]';
Dx=(2*pi/Lx)*toeplitz(col,col([1 Nx:-1:2]));
col=[-pi^2/(3*h^2)-1/6 -0.5*(-1).^(1:Nx-1)./sin(h*(1:Nx-1)/2).^2];
D2x=(2*pi/Lx)^2*toeplitz(col);
%y����
Ly=2; Ny=20;
[Dy,y]=cheb(Ny);
Dy=Dy/(Ly/2);D2y=Dy^2;y=Ly/2*y;
%ŵ�����߽�������������(Dy)u
BCy=-Dy([1 Ny+1],[1 Ny+1])\Dy([1 Ny+1],2:Ny);
%��ʼ����������v=(Dt)u�����߽׷���תΪΪһ�׷�����
%�޸ĺ����£�
% (Dt)u=v           ,   -3<x<3, -1<y<1
% (Dt)v=(D2x+D2y)u 
% (Dy)v=0|(|y|=1)   ;   u|(x=-3)=u|(x=-3)
% u=exp(-8*((x+1.5)^2+u^2))|(t=0)
% v|(t=0)=-(Dx)u|(t=0)
[X,Y]=meshgrid(x,y);
u=exp(-8*((X+1.5).^2+Y.^2));
v=-u*Dx';
uv=[u(:);v(:)];
%���
t=0:2:4;
[t,uvsol]=ode45('wave_tank',t,uv,[],Nx,Ny,D2x,D2y,BCy);
%��ͼ
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
%�����ڱ߽磬ʹ��ŷ����
%% ��άBarkleyģ��(��Ӧ-��ɢϵͳ)
% (Dt)u=d*(D2x+D2y)u+u(1-u)/epsilon*(u-(b+v)/a)
% (Dt)v=u-v          ,  -60<x,y<60
% (Dn)u=(Dn)v=0      ,  �߽��޻�ѧ���ʽ���
%���У�
%u��vΪ�����໥ת���Ļ�ѧ����Ũ�ȣ�dΪ��ɢϵ����a��b��eΪϵͳ����
L=120;N=90;
%�����б�ѩ���󵼾���
h=L/2;
[D,x]=cheb(N);
D=D/h;D2=D^2;
x=h*x;y=x;
%�߽�����
BCx=-(D([1 N+1],2:N)')/(D([1 N+1],[1 N+1])');  %u��x��������Ϊ���У�����ת��
BCy=-D([1 N+1],[1 N+1])\D([1 N+1],2:N);
%��ʼ����
u_old=zeros(N+1,N+1);v_old=u_old;
u_old(N/2,1:N/2)=0.5;v_old(N/2,1:N/2)=0.5;
u_old(N/2-1,1:N/2)=1;v_old(N/2+1,1:N/2)=1;
usol(:,:,1)=u_old;vsol(:,:,1)=v_old;
%���,����(D2*u')'=u*D2'
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
%��ͼ
figure(3)
for n=1:4
    subplot(2,2,n)
    gca=pcolor(x,y,usol(:,:,n));
    set(gca,'LineStyle','none'),axis off
    shading interp ,axis square
end
text(-2*N,-N,'�����������Ĺ���');
 
