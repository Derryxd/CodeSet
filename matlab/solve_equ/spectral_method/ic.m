function icfft=ic(icname,x,N,X,Y)
%% initial condition
%Ӧ�����׷����У�����������Ҷ�任fft
%% һά��������
if strcmp(icname,'wave1Dic')
    u=2*sech(x) ;ut=fft(u);
    v=zeros(1,N);vt=fft(v);
    icfft=[ut vt];         %���������ų�һ��
end
%% ��ά��������
if strcmp(icname,'wave2Dic')
    u=exp(-20*((X-0.4).^2+(Y+0.4).^2))+exp(-20*((X+0.4).^2+(Y-0.4).^2));
    ut=fft2(u);vt=zeros(N);
    icfft=[ut(:);vt(:)];   %��������Ҳ���ų�һ��
end
%% һά������Ѧ���̷���
if strcmp(icname,'NLSEic')
    u=2*sech(x);
    icfft=fft(u);
end
%% һάKdV����
if strcmp(icname,'KdVic')
    u=2*sech(x).^2;
    icfft=fft(u);
end
%% ��άǳˮ����
if strcmp(icname,'shallow_wateric')
    e=0.1*exp(X.^2/10+Y.^2/10)+0.1;
    et=fft2(e);ut=zeros(N.^2,1);vt=zeros(N.^2,1);
    icfft=[et(:);ut;vt];
end
%% ��άճ��Burgers����
if strcmp(icname,'burgersic')
    u=sech(4*X.^2+4*Y.^2);
    icfft=fft2(u);
end
%% ��άSchnakenberg����
if strcmp(icname,'sbic')
    u=zeros(N);u(N/2,N/2)=1;v=ones(N);
    ut=fft2(u);vt=fft2(v);
    icfft=[ut;vt];
end








