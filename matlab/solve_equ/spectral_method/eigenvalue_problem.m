clear all;close all;
%通式：
% (Dnt)u=L*u+N(u);  L:linear; N:nonlinear
%例子：
%（-D2x-D2y+x^2+y^2)u=lamda*u;
%解释解：
%  lamda_{m,n}=lamda_{m}+lamda_{m};
%% 二维线性谐振子的定态薛定谔方程
%划分网格
L=10;N=32;
x=L/N*(-N/2:N/2-1);y=x;
%构造谱求导矩阵
h=2*pi/N;
col=[-pi^2/(3*h^2)-1/6 -0.5*(-1).^(1:N-1)./sin(h*(1:N-1)/2).^2];
D2=(2*pi/L)^2*toeplitz(col);
%求特征值和特征函数
I=eye(N);
L=kron(D2,I)+kron(I,D2);
x2=kron(diag(x.^2),I);y2=kron(I,diag(y.^2));
[V,D]=eig(-L+x2+y2);eigenvalues=diag(D);
%画图
[py,px]=meshgrid(0.75:-0.25:0,0:0.25:0.75);
figure(1)
for n=1:16
    subplot('position',[px(n)+0.04 py(n)+0.04 0.17 0.17])
    mesh(x,y,reshape(V(:,n),N,N))
    axis([-4 4 -4 4 -0.1 0.1]),title(num2str(eigenvalues(n)))
end
figure(2)
for n=1:16
    subplot('position',[px(n)+0.04 py(n)+0.04 0.17 0.17])
    contour(x,y,reshape(V(:,n),N,N),[-0.03 0.03])
    axis([-4 4 -4 4 ]),axis square ,title(num2str(eigenvalues(n)))
end

clear all;
%例子：
%（-D2x-D2y)u=lamda*u; -1<x,y<1
% u|(x=1)=u|(y=1)=0
%解释解：
%  lamda_{n1,n2}=-pi^2/4*(n1^2+n2^2);
%  u_{n1,n2}=sin(n1*pi/2*(x+1))*sin(n2*pi/2*(y+1));
%% 二维无限深方势井的定态薛定谔方程
%构造谱求导矩阵
L=2;N=20;
%[-1 1]长度的倍数
h=L/2;
%1阶求导矩阵
[E,x]=cheb(N);E=E/h;
%2阶求导矩阵, 非精确表达式，直接求平方
D2=E^2;
%修改L算子矩阵
D2=D2(2:N,2:N);
%网格缩放
x=h*x;y=x;
%求特征值和特征函数
I=eye(N-1);
LA=kron(D2,I)+kron(I,D2);
[V,E]=eig(LA);E=diag(E);
[eigenvalues,i]=sort(real(E),'descend');
V=V(:,i);
%画图
x2=-L/2:0.08:L/2;y2=x2;
[py,px]=meshgrid(0.75:-0.25:0,0:0.25:0.75);
figure(3)
for n=1:16
    subplot('position',[px(n)+0.04 py(n)+0.04 0.17 0.22])
    v=zeros(N+1);v(2:N,2:N)=reshape(V(:,n),N-1,N-1);
    v2=interp2(x,y,v,x2,y2','cubic');
    mesh(x2,y2,v2),hold on,view(35,20),axis off
    axis([-1.1 1.1 -1.1 1.1 -0.2 0.13])
    contour3(x2,y2,v2-0.2,[-0.2-eps -0.2+eps])
    m=-eigenvalues(n)*4/pi^2;
    title(['-' num2str(m) 'pi^2/4']);
end

clear all;
%例子：
%（D4x+2*D2xD2y+D4y)u=lamda*u; -1<x,y<1
% u|(x=1)=u|(y=1)=0
% (Dx)u|(x=1)=(Dy)u|(y=1)=0
%化简复杂边界条件的方法：（以一维为例）
%  因为+-1处的条件，可设u的插值函数为p=(1-x^2)q;
%  对p求四次导，得(D4x)p=[(1-x^2)*D4-8*x*D3-12*D2]/(1-x^2)*p
%% 二维双调和算符的特征值问题
%构造谱求导矩阵
L=2;N=25;
%二维调和算符矩阵
h=L/2;
[D,x]=cheb(N);x=h*x;y=x;
D=D/h;D2=D^2;D2=D2(2:N,2:N);
D4=(diag(1-x.^2)*D^4-diag(8*x)*D^3-12*D^2)*diag((1./(1-x.^2)));
D4=D4(2:N,2:N);I=eye(N-1);
LA2=kron(D4,I)+2*kron(D2,I)+kron(I,D4);
%求特征值和特征函数
[V,D]=eig(LA2);D=diag(real(D));
[eigenvalues,i]=sort(D);
V=real(V(:,i));
%画图
x2=-1.08:0.08:1.08;y2=x2;
[py,px]=meshgrid(0.8:-0.2:0,0:0.2:0.8);
figure(4)
for n=1:25
    subplot('position',[px(n)+0.02 py(n)+0.01 0.15 0.2])
    v=zeros(N+1);v(2:N,2:N)=reshape(V(:,n),N-1,N-1);
    v2=interp2(x,y,v,x2,y2','cubic');
    mesh(x2,y2,v2),hold on,axis off
    axis([-1 1 -1 1 -0.25 0.1])
    contour3(x2,y2,v2-0.25,[-0.25-eps -0.25+eps])
    text(0.7,0,0.13,sprintf('%.1f',eigenvalues(n)))
end


clear all;
%标准形式：
% Au=lamda*u
%广义形式：
% Au=lamda*B*u
%其中B未必可逆，求解需用QZ法，MATLAB中的调用形式为eig（A,B）
%例子：
% D2u=lamda*x*u , -2<x<2,u(+-2)=0
%% 广义特征值问题
%构造谱求导矩阵
L=4;N=40;
%构造切比雪夫求导矩阵
h=L/2;
[D,x]=cheb(N);x=h*x;
D=D/h;D2=D^2;D2=D2(2:N,2:N);
%求解
[V,E]=eig(D2,diag(x(2:N)));E=diag(E);
i=find(E>0);E=E(i);V=V(:,i);
[eigenvalues,i]=sort(E);V=V(:,i);
%画图
x2=-2:0.01:2;
figure(5)
for n=1:9
    subplot(3,3,n)
    plot(x2,polyval(polyfit(x,[0;V(:,n);0],N),x2));
    title(num2str(eigenvalues(n)));
    axis([-2 2 -1.1 1.1]),xlabel x, ylabel u
end