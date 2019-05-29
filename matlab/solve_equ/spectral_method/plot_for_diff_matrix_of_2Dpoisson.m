clear all;close all;
% -(D2x+D2y)u=(pi^2-1)exp(x)sin(pi*y)   , 0<x<2
% u(0,y)=sin(pi*y); u(2,y)=e^2*sin(pi*y), 0<=y<=1
% u(x,0)=0;         u(x,1)=0            , 0<x<2
%% 有限差分
%生成网格上的坐标
h=0.1;x=(0:h:2)';y=(0:h:1)';
N=length(x)-1;M=length(y)-1;
[X,Y]=meshgrid(x,y);
%解释解
u_analytical=exp(X).*sin(pi*Y);
X=X(2:M,2:N);Y=Y(2:M,2:N);
%生成f的矩阵,注意：f的首尾包含x的边界条件
f=(pi^2-1)*exp(X).*sin(pi*Y);
f(:,1)=f(:,1)+sin(pi*y(2:M))/h^2;            %！！注意
f(:,end)=f(:,end)+exp(2)*sin(pi*y(2:M))/h^2; %！！注意
%构造矩阵
e=ones(N-1,1);
C=1/h^2*spdiags([-e 4*e -e],[-1 0 1],N-1,N-1);
D=-1/h^2*eye(N-1);
A=kron(eye(M-1),C)+kron(spdiags([e,e],[-1 1],M-1,M-1),D);
%左除求解
f=f';u=zeros(M+1,N+1);
u(2:M,2:N)=reshape(A\f(:),N-1,M-1)';
u(:,1)=sin(pi*y);
u(:,end)=exp(2)*sin(pi*y);
%画图
figure(1),spy(A,'k',16)
figure(2),subplot(1,2,1),mesh(x,y,u)
xlabel x, ylabel y ,zlabel u
subplot(1,2,2),mesh(x,y,u-u_analytical)
axis([0 2 0 1 0 0.04])
xlabel x, ylabel y ,zlabel Error


clear all;
% -(D2x+D2y)u=(pi^2-1)exp(x)sin(pi*y)   , 0<x<2
% u(0,y)=sin(pi*y); u(2,y)=e^2*sin(pi*y), 0<=y<=1
% u(x,0)=0;         u(x,1)=0            , 0<x<2
%% 求导矩阵：第一类边界条件
L=2;N=10;figure(3)
%构造拉普拉斯算符矩阵
h=L/2;[D,x]=cheb(N);D=D/h;D2=D^2;
I=eye(N+1);LA=kron(I,D2)+kron(D2,I);
x=h*x;y=x;[x ,y]=meshgrid(x,y);
X=x(:);Y=y(:);
subplot(2,3,1), spy(LA,'k',8)
title('kron(I_{N+1},D^2_N)+kron(D^2_N,I_{N+1})')
%修改矩阵，对于第一类边界条件，将D2矩阵首尾行分别修改为1 0 0 0...和 ... 0 0 0 1
bound=find(abs(X)==L/2|abs(Y)==L/2);
LA(bound,:)=0;
subplot(2,3,2), spy(LA,'k',8)
title('L(bound,:)=0')
LA(bound,bound)=eye(4*N);
subplot(2,3,3), spy(LA,'k',8)
title('L(bound,bound)=eye(4*N)')
subplot(2,3,4), spy(kron(I,D2),'k',8)
title('kron(I_{N+1},D^2_N)')
subplot(2,3,5), spy(kron(D2,I),'k',8)
title('kron(D^2_N,I_{N+1})')
%给f加入边界条件
f=6*(X+1).*(Y+0.1).^3;
f(bound)=(Y(bound)==L/2).*sinc(4*X(bound))/2+ ...
    (X(bound)==L/2).*max(0,(0.5-abs(Y(bound))));
%求解
u=reshape(LA\f,N+1,N+1);
%画图
figure(4)
x2=-L/2:0.04:L/2;y2=x2;  
%or : [x2,y2]=meshgrid(-L/2:0.04:L/2,-L/2:0.04:L/2);
u2=interp2(x,y,u,x2,y2','cubic');
mesh(x2,y2,u2)
view(-60,30),axis([-1 1 -1 1 -0.25 0.5])
xlabel x, ylabel y ,zlabel u
%% 注释：
%1、bound=find(abs(X)==L/2|abs(Y)==L/2)表示为：
%找到矩阵L中所有对应于边界的行的序号，之后将这些行的所有元素替代为0
%2、LA(bound,bound)=eye(4*N)表示为：
%将这些行的第i个元素设置为1，其中二维边界的个数为(N+1)*2+(N-1)*2=4*N个
%3、kron是矩阵的乘法:C=kron (A,B)    %A为m×n矩阵，B为p×q矩阵，则C为mp×nq矩阵。


clear all;
% -(D2x+D2y)u=-sin[(x+2)^2*(y+1)]          , -2<x,y<2
% (Dx)u|(x=2) = (Dy)u|(y=2) = u|(y=-2) = 0 ,
% u=sin(pi*y)/10                           , x=-2
%% 求导矩阵：第二类边界条件
L=4;N=50;
%构造拉普拉斯算符矩阵
h=L/2;[D,x]=cheb(N);D=D/h;D2=D^2;
I=eye(N+1);LA=kron(I,D2)+kron(D2,I);
x=h*x;y=x;[x ,y]=meshgrid(x,y);
X=x(:);Y=y(:);
%修改矩阵，对于第二类边界条件，可以把D2的行列替代为D的行列，一类同上
Hx=kron(D,I);Hy=kron(I,D);
bound1=find(X==-L/2|Y==-L/2);
bound2=find(X==L/2|Y==L/2);
LA(bound1,:)=0;LA(bound1,bound1)=eye(2*N+1);
LA(bound2,:)=repmat(X(bound2)==L/2,1,(N+1)^2).*Hx(bound2,:)...
    +repmat(Y(bound2)==L/2,1,(N+1)^2).*Hy(bound2,:);  %逻辑为1的矩阵.*边界处的D
figure(5)
spy(LA,'k',8)
%给f加入边界条件
f=-sin((X+2).^2.*(Y+1));
f([bound1;bound2])=0;
f(bound1)=(X(bound1)==-L/2).*sin(pi*Y(bound1))/10;
%求解
u=LA\f;u=reshape(u,N+1,N+1);
%画图
figure(6)
x2=-L/2:0.05:L/2;y2=x2;  
%or : [x2,y2]=meshgrid(-L/2:0.04:L/2,-L/2:0.04:L/2);
u2=interp2(x,y,u,x2,y2','cubic');
mesh(x2,y2,u2), view(-25,45)
axis([-2 2 -2 2 -0.1 0.2])
xlabel x, ylabel y ,zlabel u


clear all;
% (D2x+D2y)u=-sin[(x+5)*(y+2)]             , -2<x,y<2
% (u+(Dx)u/10)|(|x|=2)=(u+(Dy)u/10)|(|y|=2)=1
%% 求导矩阵：第三类边界条件（u+a*Du=g）
L=4;N=40;a=0.1;
%构造拉普拉斯算符矩阵
h=L/2;[D,x]=cheb(N);D=D/h;D2=D^2;
I=eye(N+1);LA=kron(I,D2)+kron(D2,I);
x=h*x;y=x;[x ,y]=meshgrid(x,y);
X=x(:);Y=y(:);
%修改矩阵，对于第三类边界条件，可以把D2的行列替代为与D的线性组合
%如一维，取出a*Du的首(尾)行，并在上(下)行加上[1 0..0]([0..0 1])，然后替换D2的首(尾)行
%修改后的D2与u相乘的首尾行等于u0+a*Du0、un+a*Dun
Hx=kron(D,I);Hy=kron(I,D);
bound1=find(X==L/2|X==-L/2);
bound2=find(Y==L/2|Y==-L/2);
I=eye((N+1)^2);
LA(bound1,:)=I(bound1,:)+a*Hx(bound1,:);
LA(bound2,:)=I(bound2,:)+a*Hy(bound2,:);
figure(7)
spy(LA,'k',8)
%给f加入边界条件
f=sin((X+5).*(Y+2));
f([bound1;bound2])=1;
%求解
u=LA\f;u=reshape(u,N+1,N+1);
%画图
figure(8)
x2=-L/2:0.05:L/2;y2=x2;  
%or : [x2,y2]=meshgrid(-L/2:0.04:L/2,-L/2:0.04:L/2);
u2=interp2(x,y,u,x2,y2','cubic');
mesh(x2,y2,u2), view(-25,45)
xlabel x, ylabel y ,zlabel u
%边界误差
Ex=u(:)+a*Hx*u(:)-1;max(abs(Ex(bound1)))
Ey=u(:)+a*Hy*u(:)-1;max(abs(Ey(bound2)))

