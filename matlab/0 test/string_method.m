% �ַ������� 
a='  a';b='b  b';c='cccc';m='' 
% ��ȡ�ַ������� 
length(a)     
% ���������ַ���,ÿ���ַ������ұߵĿո񱻲��� 
d=strcat(a,c)  
length(d) 
% ���Ӷ����ַ���,ÿ�г��ȿɲ��ȣ��Զ��ѷ���ַ������ұ߲��ո� 
% ʹ����ַ�����ȣ�����Կ��ַ��� 
e=strvcat(a,b,m) 
size(e) 
% char���ӣ����ַ����ᱻ�ո����� 
f=char(a,b,m) 
size(f)

% strcmp    �Ƚ������ַ����Ƿ���ȫ��ȣ��ǣ������棬���򣬷��ؼ� 
% strncmp    �Ƚ������ַ���ǰn���ַ��Ƿ���ȣ��ǣ������棬���򣬷��ؼ� 
% strcmpi    �Ƚ������ַ����Ƿ���ȫ��ȣ�������ĸ��Сд 
% strncmpi   �Ƚ������ַ���ǰn���ַ��Ƿ���ȣ�������ĸ��Сд

% isletter  ����ַ�����ÿ���ַ�ʱ������Ӣ����ĸ 
% isspace    ����ַ�����ÿ���ַ��Ƿ����ڸ�ʽ�ַ����ո񣬻س����Ʊ����з��ȣ� 
% isstrprop  ����ַ�ÿһ���ַ��Ƿ�����ָ���ķ�Χ 
a='d sdsdsd 15#'; 
b=isletter(a) 
c=isspace(a)

% �ַ����滻�Ͳ���   
% strrep �����ַ����滻�����ִ�Сд 
%   strrep(str1,str2,str3) 
%      ����str1�����е�str2�ִ���str3���滻

% strfind(str,patten)  ����str���Ƿ���pattern�����س���λ�ã�û�г��ַ��ؿ����� 
% findstr(str1,str2)   ����str1��str2�У��϶��ַ����ڽϳ��ַ����г��ֵ�λ�ã�û�г��ַ��ؿ����� 
% strmatch(patten,str) ���patten�Ƿ��str����ಿ��һ�� 
% strtok(str,char)     ����str����charָ�����ַ���ǰ�Ĳ��ֺ�֮��Ĳ��֣� 
mm='youqwelcome'; 
[mm1,mm2]=strtok(mm,'q')

% blanks(n)             ������n���ո���ɵ��ַ��� 
% deblank(str)          �����ַ�����β���ո� 
% strtrim(str)          �����ַ����Ŀ�ͷ��β���Ŀո��Ʊ��س���

% lower(str)            ���ַ����е���ĸת����Сд 
% upper(str)            ���ַ����е���ĸת���ɴ�д  
% sort(str)             �����ַ���ASCIIֵ���ַ�������

% num2str          ������ת��Ϊ�����ַ��� 
% str2num          �������ַ���ת��Ϊ���� 
% mat2str          ������ת�����ַ��� 
% int2str          ����ֵ����ת��Ϊ����������ɵ��ַ�����

%% CELL�����е��ַ����Ƚϣ�

c=cell(2,1); 
c(1,1)=cellstr('xxx'); 
c(2,1)=cellstr('yyyyyyy'); 
strcmp(c{1,1},c{2,1})

% isequal   Test arrays for equality, �������Ƚ������ַ������Ƿ���ͬ��

%%

d=1:40;
arrayfun(@(x) ['bottom-n' num2str(x)],d,'un',0)