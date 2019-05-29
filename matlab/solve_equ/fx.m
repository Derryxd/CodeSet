function f=fx(x,u)
%% example：非刚性方程
%Du=-3u+6x+5=fx;
%u(0)=3;
%the code : 
% f=-3*u+6*x+5;

%% van der Pol方程：刚性方程
%Du1=u2;
%Du2=1000(1-u1^2)*u2-u1;
%u1(0)=2;u2(0)=0;
%the code:
% f=[u(2);1000*(1-u(1)^2)*u(2)-u(1)];

%% 阻尼震荡问题
%Du1=u2;
%Du2=-2*beta*u2-omega^2*u1
%u1(0)=1;u2(0)=0;
%the code:
% Beta=1;Omega=10;
% f=[ u(2) ; -2*Beta*u(2)-Omega^2*u(1) ];  %matlab自带解法ode命令要实用column，所以要用;号形成行矩阵。

%% 边值问题
%Du1=u2;
%Du2=-u1+2(x-1)*exp(-x)
%u1(0)=1;u1(pi)=pi/exp(pi)-1;
%the code:
% f = [u(2) ; -u(1)+2*(x-1)*exp(-x)];

%% 
f=[u(2);-u(2)+3];














