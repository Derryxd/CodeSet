%���ڱ߽�������
%% ��άƽ��-��ɢ����
%��ʽ��
% (Dt)omega=v*(D2x+D2y)omega+(Dx)omega*(Dy)psi-(Dy)omega*(Dx)psi
% (D2x+D2y)psi=omega
%˵����
% psi:������(stream func)
% omega:����(vorticity
% v:constant value
% һʽ�ұߣ���һ����Ϊ��ɢ���֣��ڶ�����Ϊƽ������
% �������ɿ���������һ������������֪��ʼomega������psi�����������㣬����һʱ���omega
%% ��������
L=20; N=128;
x=L/N*(-N/2:N/2-1);y=x;
kx=(2*pi/L)*[0:N/2-1 -N/2:-1];
kx(1)=1e-6;ky=kx;  %��ֹ��ĸΪ��
[X,Y]=meshgrid(x,y);
[kX,kY]=meshgrid(kx,ky);
K2=kX.^2+kY.^2;
%% �������󵼾���
%���
h=2*pi/N;
%1�����󵼾���
col=[0 0.5*(-1).^(1:N-1).*cot((1:N-1)*h/2)]';
D=(2*pi/L)*toeplitz(col,col([1 N:-1:2]));   
%2�����󵼾���
col=[-pi^2/(3*h^2)-1/6 -0.5*(-1).^(1:N-1)./sin(h*(1:N-1)/2).^2];
D2=(2*pi/L)^2*toeplitz(col);
%% ��ʼ����
w=sech((X+2).^2+Y.^2/20)+sech((X-2).^2+Y.^2/20);
%% ��ֵ���
v=0.001;t=0:10:30;
addpath(genpath(pwd));
[t,wsol]=ode45('advection_diffusion',t,w(:),[],N,D,D2,K2,v);
%% ��ͼ
figure(2)
for n=1:4
    subplot(2,2,n)
    gca=pcolor(reshape(wsol(n,:),N,N));axis off
    set(gca,'LineStyle','none'), shading interp
    title(['t=' num2str(t(n))]), axis square
end
%% ע��
%Toeplitz����diagonal-constant matrix����ָ������ÿ�������������µ�б���ϵ�Ԫ����ͬ
%��ֱ�ӶԾ������棬�������ϴ󣬹��Ƚ��и���Ҷ�任

