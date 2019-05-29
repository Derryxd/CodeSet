function icfft=ic(icname,x,N,X,Y)
%% initial condition
%应用于谱方法中，故需做傅里叶变换fft
%% 一维波动方程
if strcmp(icname,'wave1Dic')
    u=2*sech(x) ;ut=fft(u);
    v=zeros(1,N);vt=fft(v);
    icfft=[ut vt];         %所有数据排成一列
end
%% 二维波动方程
if strcmp(icname,'wave2Dic')
    u=exp(-20*((X-0.4).^2+(Y+0.4).^2))+exp(-20*((X+0.4).^2+(Y-0.4).^2));
    ut=fft2(u);vt=zeros(N);
    icfft=[ut(:);vt(:)];   %所有数据也是排成一列
end
%% 一维非线性薛定谔方程
if strcmp(icname,'NLSEic')
    u=2*sech(x);
    icfft=fft(u);
end
%% 一维KdV方程
if strcmp(icname,'KdVic')
    u=2*sech(x).^2;
    icfft=fft(u);
end
%% 二维浅水方程
if strcmp(icname,'shallow_wateric')
    e=0.1*exp(X.^2/10+Y.^2/10)+0.1;
    et=fft2(e);ut=zeros(N.^2,1);vt=zeros(N.^2,1);
    icfft=[et(:);ut;vt];
end
%% 二维粘性Burgers方程
if strcmp(icname,'burgersic')
    u=sech(4*X.^2+4*Y.^2);
    icfft=fft2(u);
end
%% 二维Schnakenberg方程
if strcmp(icname,'sbic')
    u=zeros(N);u(N/2,N/2)=1;v=ones(N);
    ut=fft2(u);vt=fft2(v);
    icfft=[ut;vt];
end








