function [u,u_exact,err]=solve_bvp_odes(xspan,u0,method)
%% ode��ֵ����ⷨ(��з�shoot)
%basic usage  ��[u,u_exact,err]=solve_bvp_odes(0:0.05:pi,2,'linear');
%or simply    : [u,u_exact,err]=solve_bvp_odes(0:0.05:pi,2);
%or simpliest : u=solve_bvp_odes(0:0.05:pi,2);
% 
%input:
% dx=0.05; %time step
% x0=0;    %initial time
% xt=1;    %termial time
% xspan    %meshing
% u0;      %��ʼ�²�ֵ
% model    %��ȡ���ַ��������²�ֵ
%
%output:
% u        %numerical solution
% err      %error between u and exact solution
%
% Code by Derry Liu, 21 Feb 2017
tic
if nargin<2
    error(message('solve_1st_ode:TooFewInputs'));
elseif nargin==2
    method_name='linear';
elseif nargin==3
    method_name=method;
end
x=xspan;        %�������ŷ������
%����Ϊ�򵥱�ֵ���
%u(a)=alpha
%u(b)=beta0
alpha=1;beta0=pi/exp(pi)-1;
n=0;m(1)=u0;
%% ��з�(shoot)
while n==0||abs(Beta(n)-beta0)>=1e-6
    n=n+1;
    [~,u] = ode45(@fx,x,[alpha m(n)]);
    Beta(n)=u(end,1);
    if strcmp(method_name,'linear')
        if n==1
            m(2)=m(1)-0.1;
        else
            m(n+1)=m(n-1)+(m(n)-m(n-1))*(beta0-Beta(n-1))/(Beta(n)-Beta(n-1));
        end
    end
end
%% ���н��ͽ⣬�ɽ���������
if nargout==2
    u_exact=solu(x,u0,'bvp');
elseif nargout>=2
    % ������
    u_exact=solu(x,u0,'bvp');
    err=abs(u(:,1)-u_exact(:,1));
end
        

    









