clear all;close all;
% -(D2x+D2y)u=(pi^2-1)exp(x)sin(pi*y)   , 0<x<2
% u(0,y)=sin(pi*y); u(2,y)=e^2*sin(pi*y), 0<=y<=1
% u(x,0)=0;         u(x,1)=0            , 0<x<2
%% ���޲��
%���������ϵ�����
h=0.1;x=(0:h:2)';y=(0:h:1)';
N=length(x)-1;M=length(y)-1;
[X,Y]=meshgrid(x,y);
%���ͽ�
u_analytical=exp(X).*sin(pi*Y);
X=X(2:M,2:N);Y=Y(2:M,2:N);
%����f�ľ���,ע�⣺f����β����x�ı߽�����
f=(pi^2-1)*exp(X).*sin(pi*Y);
f(:,1)=f(:,1)+sin(pi*y(2:M))/h^2;            %����ע��
f(:,end)=f(:,end)+exp(2)*sin(pi*y(2:M))/h^2; %����ע��
%�������
e=ones(N-1,1);
C=1/h^2*spdiags([-e 4*e -e],[-1 0 1],N-1,N-1);
D=-1/h^2*eye(N-1);
A=kron(eye(M-1),C)+kron(spdiags([e,e],[-1 1],M-1,M-1),D);
%������
f=f';u=zeros(M+1,N+1);
u(2:M,2:N)=reshape(A\f(:),N-1,M-1)';
u(:,1)=sin(pi*y);
u(:,end)=exp(2)*sin(pi*y);
%��ͼ
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
%% �󵼾��󣺵�һ��߽�����
L=2;N=10;figure(3)
%����������˹�������
h=L/2;[D,x]=cheb(N);D=D/h;D2=D^2;
I=eye(N+1);LA=kron(I,D2)+kron(D2,I);
x=h*x;y=x;[x ,y]=meshgrid(x,y);
X=x(:);Y=y(:);
subplot(2,3,1), spy(LA,'k',8)
title('kron(I_{N+1},D^2_N)+kron(D^2_N,I_{N+1})')
%�޸ľ��󣬶��ڵ�һ��߽���������D2������β�зֱ��޸�Ϊ1 0 0 0...�� ... 0 0 0 1
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
%��f����߽�����
f=6*(X+1).*(Y+0.1).^3;
f(bound)=(Y(bound)==L/2).*sinc(4*X(bound))/2+ ...
    (X(bound)==L/2).*max(0,(0.5-abs(Y(bound))));
%���
u=reshape(LA\f,N+1,N+1);
%��ͼ
figure(4)
x2=-L/2:0.04:L/2;y2=x2;  
%or : [x2,y2]=meshgrid(-L/2:0.04:L/2,-L/2:0.04:L/2);
u2=interp2(x,y,u,x2,y2','cubic');
mesh(x2,y2,u2)
view(-60,30),axis([-1 1 -1 1 -0.25 0.5])
xlabel x, ylabel y ,zlabel u
%% ע�ͣ�
%1��bound=find(abs(X)==L/2|abs(Y)==L/2)��ʾΪ��
%�ҵ�����L�����ж�Ӧ�ڱ߽���е���ţ�֮����Щ�е�����Ԫ�����Ϊ0
%2��LA(bound,bound)=eye(4*N)��ʾΪ��
%����Щ�еĵ�i��Ԫ������Ϊ1�����ж�ά�߽�ĸ���Ϊ(N+1)*2+(N-1)*2=4*N��
%3��kron�Ǿ���ĳ˷�:C=kron (A,B)    %AΪm��n����BΪp��q������CΪmp��nq����


clear all;
% -(D2x+D2y)u=-sin[(x+2)^2*(y+1)]          , -2<x,y<2
% (Dx)u|(x=2) = (Dy)u|(y=2) = u|(y=-2) = 0 ,
% u=sin(pi*y)/10                           , x=-2
%% �󵼾��󣺵ڶ���߽�����
L=4;N=50;
%����������˹�������
h=L/2;[D,x]=cheb(N);D=D/h;D2=D^2;
I=eye(N+1);LA=kron(I,D2)+kron(D2,I);
x=h*x;y=x;[x ,y]=meshgrid(x,y);
X=x(:);Y=y(:);
%�޸ľ��󣬶��ڵڶ���߽����������԰�D2���������ΪD�����У�һ��ͬ��
Hx=kron(D,I);Hy=kron(I,D);
bound1=find(X==-L/2|Y==-L/2);
bound2=find(X==L/2|Y==L/2);
LA(bound1,:)=0;LA(bound1,bound1)=eye(2*N+1);
LA(bound2,:)=repmat(X(bound2)==L/2,1,(N+1)^2).*Hx(bound2,:)...
    +repmat(Y(bound2)==L/2,1,(N+1)^2).*Hy(bound2,:);  %�߼�Ϊ1�ľ���.*�߽紦��D
figure(5)
spy(LA,'k',8)
%��f����߽�����
f=-sin((X+2).^2.*(Y+1));
f([bound1;bound2])=0;
f(bound1)=(X(bound1)==-L/2).*sin(pi*Y(bound1))/10;
%���
u=LA\f;u=reshape(u,N+1,N+1);
%��ͼ
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
%% �󵼾��󣺵�����߽�������u+a*Du=g��
L=4;N=40;a=0.1;
%����������˹�������
h=L/2;[D,x]=cheb(N);D=D/h;D2=D^2;
I=eye(N+1);LA=kron(I,D2)+kron(D2,I);
x=h*x;y=x;[x ,y]=meshgrid(x,y);
X=x(:);Y=y(:);
%�޸ľ��󣬶��ڵ�����߽����������԰�D2���������Ϊ��D���������
%��һά��ȡ��a*Du����(β)�У�������(��)�м���[1 0..0]([0..0 1])��Ȼ���滻D2����(β)��
%�޸ĺ��D2��u��˵���β�е���u0+a*Du0��un+a*Dun
Hx=kron(D,I);Hy=kron(I,D);
bound1=find(X==L/2|X==-L/2);
bound2=find(Y==L/2|Y==-L/2);
I=eye((N+1)^2);
LA(bound1,:)=I(bound1,:)+a*Hx(bound1,:);
LA(bound2,:)=I(bound2,:)+a*Hy(bound2,:);
figure(7)
spy(LA,'k',8)
%��f����߽�����
f=sin((X+5).*(Y+2));
f([bound1;bound2])=1;
%���
u=LA\f;u=reshape(u,N+1,N+1);
%��ͼ
figure(8)
x2=-L/2:0.05:L/2;y2=x2;  
%or : [x2,y2]=meshgrid(-L/2:0.04:L/2,-L/2:0.04:L/2);
u2=interp2(x,y,u,x2,y2','cubic');
mesh(x2,y2,u2), view(-25,45)
xlabel x, ylabel y ,zlabel u
%�߽����
Ex=u(:)+a*Hx*u(:)-1;max(abs(Ex(bound1)))
Ey=u(:)+a*Hy*u(:)-1;max(abs(Ey(bound2)))

