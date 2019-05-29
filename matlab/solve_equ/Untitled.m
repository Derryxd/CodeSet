count=input('input the count:');%输入模拟粒子数
sigmaedata=[28370,13845,6908,2555,1223,2602,1925,905.3,479.7,164.5,74.24,23.86,66.60,36.62,22.29,9.978,5.298,1.668,0.7378,0.2361,0.1099,0.06211,0.03939,0.02030];
sigmacdata=[0.0220,0.0393,0.0568,0.0904,0.1209,0.1479,0.1722,0.2136,0.2480,0.3092,0.3486,0.3932,0.4153,0.4268,0.4319,0.4291,0.4215,0.3969,0.3691,0.3269,0.2944,0.2709,0.2512,0.2209];
Edata=[1,1.5,2,3,4,5,6,8,10,15,20,30,40,50,60,80,100,150,200,300,400,500,600,800];%截面数据
channel=zeros(1,ceil(662/5)+10);%多道数组
nget=0;%探测到的总计数
ntotal=0;%进入探测器的总计数
for ii=1:count%count个粒子循环
collidetime=0;%当前粒子碰撞次数
%粒子状态初始化
E0=622;
E=E0;
z=-2;
r=0;
theta=2*pi*rand(1);% 源抽样，z,r,theta坐标
miu=2*rand(1)-1;
fai=2*pi*rand(1);%方向角抽样
 if miu<cos(pi/4) %是否能进入探测器
    continue; 
 else
    z=0;
    r=2*sqrt(1-miu^2)/miu;
    theta=fai;
 end
while E>1%一个粒子在闪烁体中的输运过程
sigmae=interp1(Edata,sigmaedata,E,'linear');
sigmac=interp1(Edata,sigmacdata,E,'linear');
sigmat=sigmae+sigmac;%线性插值得到截面数据
L=-log(rand(1))/sigmat;%下次碰撞的距离
%计算下次碰撞位置坐标
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
    if(r>2)|(z>=4)|(z<0)%判断是否在闪烁体内
        break;
    else
        collidetime=collidetime+1;
    end
if rand(1)<(sigmae/sigmat) %光电效应
  E=0; 
else%康普顿散射
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
    miuL=1-1/alphat+1/alpha;%散射后的方向
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
%记录结果
end%while
ntotal=ntotal+1;%进入探测器的总计数
if collidetime>0
nget=nget+1;%探测到的计数
Edown=E0-E;%沉积能量
FWHM=0.01+0.05*sqrt(Edown+0.4*Edown^2);
delta=0.4247*FWHM;
Eget=Edown+delta*randn(1);%记录能量
num=ceil(Eget/5); %寻道址
    if num~=0
        channel(num)=channel(num)+1;
    end
end
end%for count
plot(channel);
fprintf(1,'探测效率为%1.5f',nget/ntotal);