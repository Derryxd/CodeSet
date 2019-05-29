function u_exact=solu(x,u0,problem,temp)
%p为哪一类问题，并由此决定采取何种解法
if nargin<3
    error(message('solu:TooFewInputs'));
end
p=problem;
%% 若真有解释解，需手动改写该脚本
if strcmp(p,'exact')
    %example
    %Du=-3u+6x+5=fx
    %solu:2*exp(-3*x)+2*x+1
    %the code :
    u_exact=2*exp(-3*x)+2*x+1;
end
%% 用MATLAB自带解ode函数为解释解，做误差分析，并以此为示例
if strcmp(p,'ivp')
    if nargin==3
        isstiff=0;
    elseif nargin==4
        isstiff=temp;
    end
    %  ode45：非刚性方程
    if isstiff==0
        [~,u_exact]=ode45(@fx,x,u0);
        %等价于以下两种
        %[x,u_ode45]=ode45(@(x,u)[-3*u+6*x+5],0:0.05:1,3);
        %[x,u_ode45]=ode45('fx',0:0.05:1,3);
    end
    % ode23s：刚性方程
    if isstiff
        [~,u_exact]=ode23s(@fx,x,u0);
    end
end
%% 用MATLAB自带解bvp函数为解释解，做误差分析，并以此为示例
if strcmp(p,'bvp')
    %guess为初值猜测值，会影响解的结果，若问题适定，解唯一
    guess=u0;
    solinit=bvpinit(x,guess);   %生成结构体，供bvp命令使用
    sol=bvp4c(@fx,@bc,solinit);
    u_exact=deval(sol,x);             %从结构体中取出解的值
end




