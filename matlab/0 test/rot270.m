%% ˳ʱ����ת90��
n=10;
a=magic(n);
b=rot90(rot90(rot90(a)));%rot90��ʱ����ת
c=fliplr(a');
d=rot90(a,-1);
%b==c==d