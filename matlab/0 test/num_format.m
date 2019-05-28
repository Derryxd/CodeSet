%数字左补位
clear;clc;
num=10;
len_format=4; %补位长度
str=repmat('a',num,len_format);
for ii=1:num
  str(ii,:)=num2str(ii,['%0' num2str(len_format) 'i']);
  %相当于'%04d'or'%04i'
end