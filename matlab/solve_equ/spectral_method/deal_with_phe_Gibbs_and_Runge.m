clear all;close all;
%% Gibbs phenomenon
%周期边界插值时，若存在间断，会发生吉布斯现象，即有震荡。
L=2*pi;N=64;h=2*pi/N;
x=L/N*(-N/2:N/2-1);y=exp(x);
figure(1)
subplot(2,1,1)
plot(x-L,y,'k',x,y,'k',x+L,y,'k')
axis([-10 10 -5 25]) ,xlabel x , ylabel y
subplot(2,1,2)
x2=-3/2*L:0.01:3/2*L;
interpolant=0;
for n=1:length(x)
    interpolant=interpolant+ ...
        y(n)*sin(pi*(x2-x(n))/h)./((2*pi/h)*tan((x2-x(n))/2));
end
plot(x2,interpolant,'k')
axis([-10 10 -5 25]) ,xlabel x , ylabel y

%% Runge's phenomenon
%对区间内函数使用多项式插值，边界出会震荡，为龙格现象
L=2;
figure(2)
for m=1:2
    N=16*m;
    for n=1:2
        if n==1
            x=L/N*(-N/2:N/2);
        else
            x=L/2*cos(pi*(0:N)/N);
        end
        y=1./(1+25*x.^2);
        x2=-L/2:0.01:L/2;
        y2=polyval(polyfit(x,y,N),x2);
        error=max(abs(y2-1./(1+23*x2.^2)));
        subplot(2,2,n+2*(m-1))
        plot(x2,y2,'k',x,y,'.r','MarkerSize',15,'LineWidth',1.1)
        axis([-1.1 1.1 -0.1 1.1]) ,xlabel x , ylabel y
        title(['N=' num2str(N) ',Error_{max}=' num2str(error)])
    end
end
