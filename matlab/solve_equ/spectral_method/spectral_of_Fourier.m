%周期边界条件下
%% 网格：根据相应方程及维数设置
L=4; N=64;
D=2;                                      %处理D维波动方程
icname=strcat('wave',num2str(D),'Dic');   %初值条件
%一维
if D==1
    x=L/N*(-N/2:N/2-1);            %时域坐标
    k=2*pi/L*[0:N/2-1 -N/2:-1];    %频域坐标,对应MATLAB自带fft命令生成的坐标
    X=[];Y=[];
end
%二维D=1;
if D==2
    x=L/N*(-N/2:N/2-1);y=x;
    kx=(2*pi/L)*[0:N/2-1 -N/2:-1];ky=kx;
    [X,Y]=meshgrid(x,y);
    [kX,kY]=meshgrid(kx,ky);
    K2=kX.^2+kY.^2;
end
%% 初始条件,并已进行傅里叶变换
icfft=ic(icname,x,N,X,Y);
%% 求解
%注意修改ode中的相关参数
t=0:0.25:1 ; a=1;
addpath(genpath(pwd));
% [t,usol]=ode45('wave1D',t,icfft,[],N,k,a);
[t,usol]=ode45('wave2D',t,icfft,[],N,K2(:),a);
% usol=ifft(uvt(:,1:N),[],2);
%% 画图
if D==1
    p=[1 11 21 41];
    for n=1:4
        subplot(5,2,n)
        plot(x,usol(p(n),:));
    end
    subplot(5,2,5:10)
    waterfall(x,t,usol),view(10,45)
    xlabel x, ylabel t ,zlabel u, axis([-L/2 L/2 0 t(end) 0 1])
end
if D==2
    for n=1:4
        subplot(2,2,n)
        mesh(x,y,ifft2(reshape(usol(n+1,1:N^2),N,N))),view(10,45)
        title(['t=' num2str(t(n+1))]),axis([-L/2 L/2 -L/2 L/2 0 1])
        xlabel x, ylabel y ,zlabel u
    end
end













