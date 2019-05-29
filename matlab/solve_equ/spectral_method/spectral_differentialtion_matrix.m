%% bounded and periodic
clear all;close all;
%% 划分网格
L=2; N=50;
x=L/N*(-N/2:N/2-1)'; 
%% 构造谱求导矩阵
%间隔
h=2*pi/N;
%1阶谱求导矩阵
col=[0 0.5*(-1).^(1:N-1).*cot((1:N-1)*h/2)]';
D=(2*pi/L)*toeplitz(col,col([1 N:-1:2]));
%2阶谱求导矩阵
col=[-pi^2/(3*h^2)-1/6 -0.5*(-1).^(1:N-1)./sin(h*(1:N-1)/2).^2];
D2=(2*pi/L)^2*toeplitz(col);
%3阶谱求导矩阵
col=[0 (-1).^(1:N-1).*cot((1:N-1)*h/2).*(...
    -pi^2/(2*h^2)+3/4*csc((1:N-1)*h/2).^2)]';
D3=(2*pi/L)^3*toeplitz(col,col([1 N:-1:2]));
%% 导数精确解
u=exp(sin(pi*x));
du_exact(:,1)=pi*cos(pi*x).*u;
du_exact(:,2)=pi^2*(cos(pi*x).^2-sin(pi*x)).*u;
du_exact(:,3)=pi^3*cos(pi*x).*(cos(pi*x).^2-3*sin(pi*x)-1).*u;
%% 谱方法求导
du_Fourier(:,1)=D*u;
du_Fourier(:,2)=D2*u;
du_Fourier(:,3)=D3*u;
error=max(abs(du_exact-du_Fourier));
%% 画图
figure(1)
labels={'u''(x)','u''''(x)','u''''''(x)'};
for n=1:4
    subplot(2,2,n)
    if n==1
        plot(x,u,'k')
        xlabel x, ylabel u(x), title('u(x)=e^{sin(\pix)}')
    else
        plot(x,du_exact(:,n-1),'k',x,du_Fourier(:,n-1),'.r')
        title(['Error_{max}=' num2str(error(n-1))])
            xlabel x , ylabel(labels(n-1))
    end
end


%% bounded and nonperiodic
clear all;
L=2; N=32;
%% 构造切比雪夫求导矩阵
%[-1 1]长度的倍数
h=L/2;
%1阶求导矩阵
[D,x]=cheb(N);D=D/h;
%2阶求导矩阵, 非精确表达式，直接求平方
D2=D^2;
%缩放
x=h*x;
%% 导数精确解&切谱方法求导
% 导数精确解
for m=1:2
    if m==1
        u=sech(x);
        du_exact(:,1)=-u.*tanh(x);
        du_exact(:,2)=u-2*u.^3;
    else
        u=exp(sin(2*x));
        du_exact(:,1)=2*cos(2*x).*u;
        du_exact(:,2)=4*u.*(cos(2*x).^2-sin(2*x));
    end
    % 切谱方法求导
    du_Cheb(:,1)=D*u;
    du_Cheb(:,2)=D2*u;
    error=max(abs(du_exact-du_Cheb));
    %% 画图'
    titles={'u(x)=sech(x)','u(x)=e^{sin(2x)}'};
    labels={'u''(x)','u''''(x)'};
    figure(2)
    subplot(3,2,m)
    plot(x,u,'k',x,u,'.r','MarkerSize',15,'LineWidth',1.1)
    title(titles(m)),xlabel x,ylabel u(x)
    for n=1:2
        subplot(3,2,2*n+m)
        plot(x,du_exact(:,n),'k',x,du_Cheb(:,n),'.r')
        title(['Error_{max}=' num2str(error(n))])
        xlabel x , ylabel(labels(n))
    end
end




