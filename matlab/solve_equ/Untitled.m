count=input('input the count:');%����ģ��������
sigmaedata=[28370,13845,6908,2555,1223,2602,1925,905.3,479.7,164.5,74.24,23.86,66.60,36.62,22.29,9.978,5.298,1.668,0.7378,0.2361,0.1099,0.06211,0.03939,0.02030];
sigmacdata=[0.0220,0.0393,0.0568,0.0904,0.1209,0.1479,0.1722,0.2136,0.2480,0.3092,0.3486,0.3932,0.4153,0.4268,0.4319,0.4291,0.4215,0.3969,0.3691,0.3269,0.2944,0.2709,0.2512,0.2209];
Edata=[1,1.5,2,3,4,5,6,8,10,15,20,30,40,50,60,80,100,150,200,300,400,500,600,800];%��������
channel=zeros(1,ceil(662/5)+10);%�������
nget=0;%̽�⵽���ܼ���
ntotal=0;%����̽�������ܼ���
for ii=1:count%count������ѭ��
collidetime=0;%��ǰ������ײ����
%����״̬��ʼ��
E0=622;
E=E0;
z=-2;
r=0;
theta=2*pi*rand(1);% Դ������z,r,theta����
miu=2*rand(1)-1;
fai=2*pi*rand(1);%����ǳ���
 if miu<cos(pi/4) %�Ƿ��ܽ���̽����
    continue; 
 else
    z=0;
    r=2*sqrt(1-miu^2)/miu;
    theta=fai;
 end
while E>1%һ����������˸���е����˹���
sigmae=interp1(Edata,sigmaedata,E,'linear');
sigmac=interp1(Edata,sigmacdata,E,'linear');
sigmat=sigmae+sigmac;%���Բ�ֵ�õ���������
L=-log(rand(1))/sigmat;%�´���ײ�ľ���
%�����´���ײλ������
rnew=sqrt(r^2+L^2*(1-miu^2)+2*r*L*sqrt(1-miu^2)*cos(fai-theta));
z=z+L*miu;
cdth=(rnew^2+r^2-L^2*(1-miu^2))/2/r/rnew;
sdth=L*sqrt(1-miu^2)*sin(fai-theta)/rnew;
dtheta=asin(sdth);
    if cdth<0
        dtheta=pi-dtheta;
    end
theta=theta+dtheta;
r=rnew;
    if(r>2)|(z>=4)|(z<0)%�ж��Ƿ�����˸����
        break;
    else
        collidetime=collidetime+1;
    end
if rand(1)<(sigmae/sigmat) %���ЧӦ
  E=0; 
else%���ն�ɢ��
    alpha=E/511;
    flag=0;
    while flag==0
        if rand(1)<=27/(4*alpha+29)
            x=(1+2*alpha)/(1+2*alpha*rand(1));
                if rand(1)<=0.5*((alpha+1-x/alpha)^2+1)
                    flag=1;
                end
        else
            x=1+2*alpha*rand(1);
            if rand(1)<=27/4*((x-1)^2)/x^3
                flag=1;
            end            
        end
    end  
    E=E/x;
    alphat=alpha/x;
    miuL=1-1/alphat+1/alpha;%ɢ���ķ���
    a=miuL;
    b=sqrt(1-a^2);
    randangle=2*pi*rand(1);
    miunew=a*miu+b*sqrt(1-miu^2)*cos(randangle);
    sdf=b*sin(randangle)/sqrt(1-miunew^2);
    cdf=(a-miu*miunew)/sqrt(1-miu^2)/sqrt(1-miunew^2);
    sfn=sdf*cos(fai)+cdf*sin(fai);
    cfn=cdf*cos(fai)-sdf*sin(fai);
    fainew=asin(sfn);
    if(cfn<0)
        fainew=pi-fainew;
    end
    fai=fainew;
    miu=miunew;
end%conputon/electtron
%��¼���
end%while
ntotal=ntotal+1;%����̽�������ܼ���
if collidetime>0
nget=nget+1;%̽�⵽�ļ���
Edown=E0-E;%��������
FWHM=0.01+0.05*sqrt(Edown+0.4*Edown^2);
delta=0.4247*FWHM;
Eget=Edown+delta*randn(1);%��¼����
num=ceil(Eget/5); %Ѱ��ַ
    if num~=0
        channel(num)=channel(num)+1;
    end
end
end%for count
plot(channel);
fprintf(1,'̽��Ч��Ϊ%1.5f',nget/ntotal);