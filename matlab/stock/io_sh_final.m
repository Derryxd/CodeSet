
%%
%个股输入
tic
% cd E:\360data\重要数据\桌面\data\sh                       %到该路径下
getfilename=ls('E:\360data\重要数据\桌面\data\stock\sh\*.csv') ;%读取所有的csv文件名
filename = cellstr(getfilename);                         %将字符型数组转换为cell型数组
num = length(filename);                                  %得到所有csv文件的个数
for i=1:num
    [~,~,untitled] = xlsread(filename{i});               %读取资料并保存为cell型数组
    data_single(i).stock = untitled(2:end,1);            %股票名称
    data_single(i).date = untitled(2:end,3);             %交易日期
    data_single(i).raw(:,1)=datenum(data_single(i).date);%将日期转化为数字
    temp=untitled(2:end,13);
    data_single(i).raw(:,2)=cell2mat(temp);              %涨跌幅，将cell型数组转换为矩阵，类别为双精度
    data_single(i).raw = sortrows(data_single(i).raw,1); %日期排序，并同时更改涨跌幅的顺序
    data_single(i).date=cellstr(datestr(data_single(i).raw(:,1),26));%将数字转化回日期,采用第26种日期格式，类别为元胞
    clearvars temp untitled;                             %清除临时变量
end
toc
clearvars getfilename ;
%Elapsed time is 515.443060 seconds.                     %运行时间

tic
for i=1:num
    %a(:,1)=linspace(1,length(data(1).raw(:,1)),length(data(1).raw(:,1))); %慢，弃用
    data_single(i).order(:,1)=(1:1:size(data_single(i).raw,1));
end
toc
%Elapsed time is 0.004259 seconds.
tic

%%
%大盘指数输入
tic
[~,~,untitled] = xlsread('E:\360data\重要数据\桌面\data\stock\sh000001.csv');
data_market.stock = untitled(2:end,1);
data_market.date = untitled(2:end,2);                        %交易日期
data_market.raw(:,1)=datenum(data_market.date);
temp=untitled(2:length(untitled(:,1)),9);
data_market.raw(:,2)=cell2mat(temp);                         %大盘指数，将cell型数组转换为矩阵，类别为双精度
data_market.raw = sortrows(data_market.raw,1);
data_market.date=cellstr(datestr(data_market.raw(:,1),26));
data_market.index=data_market.raw(:,2);
clearvars temp untitled;
toc
%Elapsed time is 3.653382 seconds.               

%%
%将对应交易日期的大盘指数跟个股匹配
tic
for i=1:num
    [C,IA,IB] = intersect(data_single(i).date,data_market.date); 
    data_single(i).raw(:,3)= data_market.index(IB);
    clearvars IA IB C;
end
toc
%Elapsed time is 4.146959 seconds.

%%
%输出
tic
cd E:\360data\重要数据\桌面\data
mkdir sh_re                                      %建立sh_re文件夹
cd E:\360data\重要数据\桌面\data\sh_re
a_vari={'个股名称', '交易日期', '个股涨跌幅', '指数涨跌幅','第几个交易日'};
for i=1:num
    %输出标题
    xlswrite([filename{i}],a_vari,1,'A1');
    %输出字符型数据
    xlswrite([filename{i}],[data_single(i).stock data_single(i).date],1,'A2');
    %输出双精度数据
    xlswrite([filename{i}],[data_single(i).raw(:,2) data_single(i).raw(:,3) data_single(i).order],1,'C2');
end
toc
%Elapsed time is 3517.977483 seconds.

