function [u,u_exact,err]=solve_ivp_odes(xspan,u0,model,isstiff)
%% ode初值问题解法
%basic usage  ：[u,u_exact,err]=solve_ivp_odes(0:0.05:1,3,'Euler');
%or simply    : [u,u_exact,err]=solve_ivp_odes(0:0.05:1,3);
%or simpliest : u=solve_ivp_odes(0:0.05:1,3);
% 
%input:
% dx=0.05; %time step
% x0=0;    %initial time
% xt=1;    %termial time
% xspan    %meshing
% u(1)=u0; %initial value
% model    %解ode的方法，有:Euler 2ndEuler Backward Trapzd 2ndRK  4ndRK_C  Gill
% isstiff  %方程是否刚性，0为非刚性，非0为刚性
%
%output:
% u        %numerical solution
% err      %error between u and exact solution
%
% Code by Derry Liu, 16 Feb 2017
tic
if nargin<2
    error(message('solve_1st_ode:TooFewInputs'));
elseif nargin==2
    model_name='Euler';
    isstiff=0;
elseif nargin==3
    model_name=model;
    isstiff=0;
elseif nargin==4
    model_name=model;
    isstiff=1;
end
x=xspan;        %后面用着方便而用
n=length(x);    %number of time steps.
i=1:n-1;
dx=x(i+1)-x(i);
u=zeros(n,length(u0));   
u(1,:)=u0;
%% 欧拉(Euler)
if strcmp(model_name,'Euler')
    for i = 1 : n-1
        u(i+1,:)=u(i,:)+dx(i)*( fx(x(i),u(i,:)) )';  % '为矩阵转置，使加减对面的维数一致
    end
end
%% 二阶欧拉(2ndEuler)
if strcmp(model_name,'2ndEuler')
    u(2,:)=u(1,:)+dx(1)*( fx(x(1),u(1,:)) )';
    for i = 2 : n-1
        u(i+1,:)=u(i-1,:)+2*dx(i)*( fx(x(i),u(i,:)) )';
    end
end
%% 隐式欧拉（Backward）
if strcmp(model_name,'Backward')
    for i = 1 : n-1
        ut = u(i,:) + dx(i) * (feval ( @fx, x(i), u(i,:)) )';
        done = 0;
        while  ~done
            u(i+1,:) = u(i,:) + dx(i) * (feval ( @fx, x(i), ut))' ;
            done = ( abs(u(i+1,:) - ut) < 1e-6 );
            ut = u(i+1,:);
        end
    end
end
%% 梯形欧拉（Trapezoidal ）
if strcmp(model_name,'Trapzd')
    for i = 1 : n-1
        ut = u(i,:) + dx(i) * (feval( @fx, x(i), u(i,:)) )';
        done = 0;
        while  ~done
            u(i+1,:) = u(i,:) + 0.5 * dx(i) *( ut + (feval(@fx, x(i), ut ))' );
            done = ( abs ( u(i+1,:) - ut ) < 1e-6 );
            ut = u(i+1,:);
        end
    end
end
%% 二阶龙格-库塔法(2ndRK)
if strcmp(model_name,'2ndRK')
    for i=1:n-1
        k1=dx(i)*( fx(x(i),u(i,:)) )';
        k2=dx(i)*( fx(x(i)+dx(i),u(i,:)+k1) )';
        u(i+1,:)=u(i,:)+(k1+k2)/2;
    end
end
%% 经典四阶阶龙格-库塔法(4stRK_C)
if strcmp(model_name,'4stRK_C')
    for i=1:n-1
        k1=dx(i)*(fx(x(i),u(i,:)))';
        k2=dx(i)*(fx(x(i)+dx(i)/2,u(i,:)+k1/2))';
        k3=dx(i)*(fx(x(i)+dx(i)/2,u(i,:)+k2/2))';
        k4=dx(i)*(fx(x(i)+dx(i),u(i,:)+k3))';
        u(i+1,:)=u(i,:)+(k1+2*k2+2*k3+k4)/6;
    end
end
%% Gill法：其中一种四阶阶龙格-库塔法(Gill)
if strcmp(model_name,'Gill')
    for i=1:n-1
        k1=dx(i)*(fx(x(i),u(i,:)))';
        k2=dx(i)*(fx( x(i)+dx(i)/2, u(i,:)+k1/2 ))';
        k3=dx(i)*(fx( x(i)+dx(i)/2, u(i,:)+(sqrt(2)-1)*k1/2+(2-sqrt(2))*k2/2 ))';
        k4=dx(i)*(fx( x(i)+dx(i),u(i,:)-sqrt(2)*k2/2+(2+sqrt(2))*k3/2 ))';
        u(i+1,:)=u(i,:)+(k1+(2-sqrt(2))*k2+(2+sqrt(2))*k3+k4)/6;
    end
end
%% 若有解释解，可进行误差分析
if nargout==2
    u_exact=solu(x,u0,'ivp',isstiff);
elseif nargout>=2
    % 误差分析
    u_exact=solu(x,u0,'ivp',isstiff);
    err=abs(u(:,1)-u_exact(:,1));
end
%% 画图
MS=8;	%标识符大小
LW=1;   %线宽
%o：圆圈  x:交叉  +：正号 ； 默认为直线
%k为黑色，相应颜色字母可上网查找
figure(1)
plot(x,u(:,1),'+k','MarkerSize',MS);
if nargout>=2
    hold on
    plot(x,u_exact(:,1),'k','LineWidth',LW);
end
if nargout==3
    figure(2)
    plot(x,err,'k','LineWidth',LW)
end
t=toc;
disp(strcat('计算时间',num2str(t),'秒'))
%计算时间0.47872秒






