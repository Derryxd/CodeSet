function u_exact=solu(x,u0,problem,temp)
%pΪ��һ�����⣬���ɴ˾�����ȡ���ֽⷨ
if nargin<3
    error(message('solu:TooFewInputs'));
end
p=problem;
%% �����н��ͽ⣬���ֶ���д�ýű�
if strcmp(p,'exact')
    %example
    %Du=-3u+6x+5=fx
    %solu:2*exp(-3*x)+2*x+1
    %the code :
    u_exact=2*exp(-3*x)+2*x+1;
end
%% ��MATLAB�Դ���ode����Ϊ���ͽ⣬�������������Դ�Ϊʾ��
if strcmp(p,'ivp')
    if nargin==3
        isstiff=0;
    elseif nargin==4
        isstiff=temp;
    end
    %  ode45���Ǹ��Է���
    if isstiff==0
        [~,u_exact]=ode45(@fx,x,u0);
        %�ȼ�����������
        %[x,u_ode45]=ode45(@(x,u)[-3*u+6*x+5],0:0.05:1,3);
        %[x,u_ode45]=ode45('fx',0:0.05:1,3);
    end
    % ode23s�����Է���
    if isstiff
        [~,u_exact]=ode23s(@fx,x,u0);
    end
end
%% ��MATLAB�Դ���bvp����Ϊ���ͽ⣬�������������Դ�Ϊʾ��
if strcmp(p,'bvp')
    %guessΪ��ֵ�²�ֵ����Ӱ���Ľ�����������ʶ�����Ψһ
    guess=u0;
    solinit=bvpinit(x,guess);   %���ɽṹ�壬��bvp����ʹ��
    sol=bvp4c(@fx,@bc,solinit);
    u_exact=deval(sol,x);             %�ӽṹ����ȡ�����ֵ
end




