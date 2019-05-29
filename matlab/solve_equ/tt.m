clear;
fil1=fopen('I:\desti_63_stand.bin','rb');
a=fread(fil1,'float32');
fil2=fopen('i:\obs_1981_2010_sta.bin','rb');
a2=fread(fil2,'float32');

b=reshape(a,1000,63,3);
b2=reshape(a2,3,92,30);

c=b(:,3,1); %1000
c2=squeeze(mean(b2(1,1:31,:),2)); %30
cc2=squeeze(mean(b2(:,1:31,1),2)); %30


s1=[3,5,7,4,6];
s2=[1.1,5.4,8,9];

ss1(5,1)=0;
ss2(5,1)=0;


