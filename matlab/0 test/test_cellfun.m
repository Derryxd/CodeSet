
tic
    tmp = txt(2:end,4);                                               % ��������Ϊcell
    idx = cellfun(@(x)strfind(x,'2/29'),tmp,'UniformOutput', false);  % �ҳ�2/29����������Ϊcell
    idy = cellfun(@(x)isequal(x,6),idx,'UniformOutput', false);       % ����Ҫ���ֵΪ6��������Ϊ��([])
    idz = cell2mat(idy);  ii  = find(idz==1);                         % ת��Ϊ�߼����󲢲���ֵΪ1���к�
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



% ���������Եĺ���������cellfun�İ����ĵ����ҵ�(doc cellfun),������˵����Input Arguments>>func>>Backward Compatibility 
% cellfun accepts function name strings for function func, rather than a function handle, for these function names: isempty, islogical, isreal, length, ndims, prodofsize, size, isclass. Enclose the function name in single quotes.
% 
% �������prodofsize��Ӧnumel֮��,����������ͬ����,Ҳ��������������
% 
% ����������Ե�ԭ��Ӧ����cellfun����֮��mathworks����⼸���������й��Ż�,�����ڵ���������ú�����������ļ����İ汾,�⼸�����Ż��ĺ�������Backward Compatibility�ķ�ʽ��������

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

