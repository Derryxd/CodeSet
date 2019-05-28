
tic
    tmp = txt(2:end,4);                                               % 数据类型为cell
    idx = cellfun(@(x)strfind(x,'2/29'),tmp,'UniformOutput', false);  % 找出2/29，数据类型为cell
    idy = cellfun(@(x)isequal(x,6),idx,'UniformOutput', false);       % 符合要求的值为6，不符合为空([])
    idz = cell2mat(idy);  ii  = find(idz==1);                         % 转化为逻辑矩阵并查找值为1的行号
toc
clearvars idx idy idz tmp ii
%Elapsed time is 0.459655 seconds.
tic
tmp=txt(:,4);
for i=1:61488
    idx(i)=strfind(tmp(i),'2/29');
    idy(i)=isequal(idx,6);
end
    ii = find(idy==1); 
toc
clearvars idx idy tmp ii
%Elapsed time is 0.358461 seconds.

tic
tmp=txt(:,4);
idx=cell(61488,1);
idy=zeros(61488,1);
for i=1:61488
    idx(i)=strfind(tmp(i),'2/29');
    idy(i)=isequal(idx,6);
end
    ii = find(idy==1); 
toc
clearvars idx idy idz tmp ii
%Elapsed time is 0.323952 seconds.



% 有这种特性的函数可以在cellfun的帮助文档中找到(doc cellfun),具体来说是在Input Arguments>>func>>Backward Compatibility 
% cellfun accepts function name strings for function func, rather than a function handle, for these function names: isempty, islogical, isreal, length, ndims, prodofsize, size, isclass. Enclose the function name in single quotes.
% 
% 这里除了prodofsize对应numel之外,其他几个都同名的,也都具有这种特性
% 
% 造成这种特性的原因应该是cellfun出现之初mathworks针对这几个函数进行过优化,以至于到今天可以用函数句柄代替文件名的版本,这几个被优化的函数仍以Backward Compatibility的方式留存下来

clear all
clc

A = {'abcd' 'qw'
    'dasd' 'ssss'};
A = repmat(A,1e2,1e2);

tic;
N1 = cellfun(@(x)numel(x),A);
toc;

tic;
N2 = cellfun(@numel,A);
toc;

tic;
N3 = cellfun('prodofsize',A);
toc;

tic
N4=zeros(200,200);
for i=1:200
    for j=1:200
        N4(i,j)=numel(A{i,j});
    end
end
toc

% Elapsed time is 0.095503 seconds.
% Elapsed time is 0.022696 seconds.
% Elapsed time is 0.000329 seconds.
% Elapsed time is 0.007445 seconds.

