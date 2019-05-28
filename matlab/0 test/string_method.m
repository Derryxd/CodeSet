% 字符串处理 
a='  a';b='b  b';c='cccc';m='' 
% 获取字符串长度 
length(a)     
% 连接两个字符串,每个字符串最右边的空格被裁切 
d=strcat(a,c)  
length(d) 
% 连接多行字符串,每行长度可不等，自动把非最长字符串最右边补空格 
% 使与最长字符串相等，会忽略空字符串 
e=strvcat(a,b,m) 
size(e) 
% char连接，空字符串会被空格填满 
f=char(a,b,m) 
size(f)

% strcmp    比较两个字符串是否完全相等，是，返回真，否则，返回假 
% strncmp    比较两个字符串前n个字符是否相等，是，返回真，否则，返回假 
% strcmpi    比较两个字符串是否完全相等，忽略字母大小写 
% strncmpi   比较两个字符串前n个字符是否相等，忽略字母大小写

% isletter  检测字符串中每个字符时否属于英文字母 
% isspace    检测字符串中每个字符是否属于格式字符（空格，回车，制表，换行符等） 
% isstrprop  检测字符每一个字符是否属于指定的范围 
a='d sdsdsd 15#'; 
b=isletter(a) 
c=isspace(a)

% 字符串替换和查找   
% strrep 进行字符串替换，区分大小写 
%   strrep(str1,str2,str3) 
%      它把str1中所有的str2字串用str3来替换

% strfind(str,patten)  查找str中是否有pattern，返回出现位置，没有出现返回空数组 
% findstr(str1,str2)   查找str1和str2中，较短字符串在较长字符串中出现的位置，没有出现返回空数组 
% strmatch(patten,str) 检查patten是否和str最左侧部分一致 
% strtok(str,char)     返回str中由char指定的字符串前的部分和之后的部分， 
mm='youqwelcome'; 
[mm1,mm2]=strtok(mm,'q')

% blanks(n)             创建有n个空格组成的字符串 
% deblank(str)          裁切字符串的尾部空格 
% strtrim(str)          裁切字符串的开头和尾部的空格，制表，回车符

% lower(str)            将字符串中的字母转换成小写 
% upper(str)            将字符串中的字母转换成大写  
% sort(str)             按照字符的ASCII值对字符串排序

% num2str          将数字转换为数字字符串 
% str2num          将数字字符串转换为数字 
% mat2str          将数组转换成字符串 
% int2str          把数值数组转换为整数数字组成的字符数组

%% CELL数组中的字符串比较：

c=cell(2,1); 
c(1,1)=cellstr('xxx'); 
c(2,1)=cellstr('yyyyyyy'); 
strcmp(c{1,1},c{2,1})

% isequal   Test arrays for equality, 可用来比较两个字符数组是否相同。

%%

d=1:40;
arrayfun(@(x) ['bottom-n' num2str(x)],d,'un',0)