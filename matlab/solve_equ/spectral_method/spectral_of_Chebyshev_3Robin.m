%�����ڱ߽�������
%% ������߽�������Du|(�߽�)+u|(�߽�)=g
%���˼·��ڶ������ƣ��Զ�ά�ȴ�������Ϊ��
clear all;close all;addpath(genpath(pwd));
%% Ԥ����
%ʹ��odes����ʱ����Ҫ��u�ı߽�����תΪ���(Dt)u�ı߽�����
%             ������Ҫ���׻��ƫ��(D2tx)u�����ɽ�����˳��
%��߽����������(Dx)u=0|(x=+-1)�ȼ�Ϊ(Dt(Dx))u=0���ٽ���˳��Ϊ(Dx(Dt))u=0
%�ô��������func�е�heat2D.m
%% ��ά�ȴ�������
% (D2t)u=(D2x+D2y)u ,   -1<x,y<1
% (u+a*(Dx)u)=0|(x=1)
% (Dx)u|(x=-1)=(Dy)u|(|y|=1)=0
% u=(1+cos(pi*x))*(1+cos(pi*y));
L=2;N=20;a=0.1;
%�����б�ѩ���󵼾���
h=L/2;
[D,x]=cheb(N);
D=D/h;D2=D^2;
x=h*x;y=x;
%�ޱ��߽�������������(Dy)u
BCx=-(a*D([1 N+1],[1 N+1])+[1 0;0 0])\(a*D([1 N+1],2:N));
BCy=-D([1 N+1],[1 N+1])\D([1 N+1],2:N);
%��ʼ����
[X,Y]=meshgrid(x,y);
u=(1+cos(pi*X)).*(1+cos(pi*Y));
%���
t=[0 0.05 0.2 4];
[t,usol]=ode45('heat2D',t,u(:),[],N,D2,BCx,BCy);
%��ͼ
figure(1)
for n=1:4
    subplot(2,2,n)
    uu=reshape(usol(n,:),N+1,N+1);
    surfl(x,y,uu),shading interp
    title(['t=' num2str(t(n))])
    axis([-1 1 -1 1 0 4]),view(15,15)
    xlabel x, ylabel y ,zlabel u
    %���
    E=h*u*D'+u;max(abs(E(:,1)))
end
