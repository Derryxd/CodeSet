
%%
%��������
tic
% cd E:\360data\��Ҫ����\����\data\sh                       %����·����
getfilename=ls('E:\360data\��Ҫ����\����\data\stock\sh\*.csv') ;%��ȡ���е�csv�ļ���
filename = cellstr(getfilename);                         %���ַ�������ת��Ϊcell������
num = length(filename);                                  %�õ�����csv�ļ��ĸ���
for i=1:num
    [~,~,untitled] = xlsread(filename{i});               %��ȡ���ϲ�����Ϊcell������
    data_single(i).stock = untitled(2:end,1);            %��Ʊ����
    data_single(i).date = untitled(2:end,3);             %��������
    data_single(i).raw(:,1)=datenum(data_single(i).date);%������ת��Ϊ����
    temp=untitled(2:end,13);
    data_single(i).raw(:,2)=cell2mat(temp);              %�ǵ�������cell������ת��Ϊ�������Ϊ˫����
    data_single(i).raw = sortrows(data_single(i).raw,1); %�������򣬲�ͬʱ�����ǵ�����˳��
    data_single(i).date=cellstr(datestr(data_single(i).raw(:,1),26));%������ת��������,���õ�26�����ڸ�ʽ�����ΪԪ��
    clearvars temp untitled;                             %�����ʱ����
end
toc
clearvars getfilename ;
%Elapsed time is 515.443060 seconds.                     %����ʱ��

tic
for i=1:num
    %a(:,1)=linspace(1,length(data(1).raw(:,1)),length(data(1).raw(:,1))); %��������
    data_single(i).order(:,1)=(1:1:size(data_single(i).raw,1));
end
toc
%Elapsed time is 0.004259 seconds.
tic

%%
%����ָ������
tic
[~,~,untitled] = xlsread('E:\360data\��Ҫ����\����\data\stock\sh000001.csv');
data_market.stock = untitled(2:end,1);
data_market.date = untitled(2:end,2);                        %��������
data_market.raw(:,1)=datenum(data_market.date);
temp=untitled(2:length(untitled(:,1)),9);
data_market.raw(:,2)=cell2mat(temp);                         %����ָ������cell������ת��Ϊ�������Ϊ˫����
data_market.raw = sortrows(data_market.raw,1);
data_market.date=cellstr(datestr(data_market.raw(:,1),26));
data_market.index=data_market.raw(:,2);
clearvars temp untitled;
toc
%Elapsed time is 3.653382 seconds.               

%%
%����Ӧ�������ڵĴ���ָ��������ƥ��
tic
for i=1:num
    [C,IA,IB] = intersect(data_single(i).date,data_market.date); 
    data_single(i).raw(:,3)= data_market.index(IB);
    clearvars IA IB C;
end
toc
%Elapsed time is 4.146959 seconds.

%%
%���
tic
cd E:\360data\��Ҫ����\����\data
mkdir sh_re                                      %����sh_re�ļ���
cd E:\360data\��Ҫ����\����\data\sh_re
a_vari={'��������', '��������', '�����ǵ���', 'ָ���ǵ���','�ڼ���������'};
for i=1:num
    %�������
    xlswrite([filename{i}],a_vari,1,'A1');
    %����ַ�������
    xlswrite([filename{i}],[data_single(i).stock data_single(i).date],1,'A2');
    %���˫��������
    xlswrite([filename{i}],[data_single(i).raw(:,2) data_single(i).raw(:,3) data_single(i).order],1,'C2');
end
toc
%Elapsed time is 3517.977483 seconds.

