%������λ
clear;clc;
num=10;
len_format=4; %��λ����
str=repmat('a',num,len_format);
for ii=1:num
  str(ii,:)=num2str(ii,['%0' num2str(len_format) 'i']);
  %�൱��'%04d'or'%04i'
end