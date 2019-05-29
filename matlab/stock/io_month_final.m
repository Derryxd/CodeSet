% %%
% % %注意num不一样，所以先读取对应的mat文件
% % tic
% % for i=1:1
% %     data_month(i).stock = data_month_re(i).one(:,2);               %股票名称
% %     data_month(i).date  = data_month_re(i).one(:,1);               %交易日期
% %     data_month(i).raw(:,1)=datenum(data_month(i).date);            %将日期转化为数字
% %     data_month(i).raw(:,2)=data_month_re(i).two(:,5);              %月线涨跌幅
% %     data_month(i).raw = sortrows(data_month(i).raw,1);             %日期排序，并同时更改涨跌幅的顺序
% %     data_month(i).date=cellstr(datestr(data_month(i).raw(:,1),26));%将数字转化回日期,采用第26种日期格式，类别为元胞
% %     data_month(i).order(:,1)=(1:1:size(data_month(i).raw,1));      %第几个交易日
% % end
% % % clearvars data_month_re;   
% % toc
% % %Elapsed time is 160.448768 seconds.
% 
% %%
% %将对应交易日期的大盘指数跟月线匹配
% %大部分股票的月线多了2017/1/20的数据，而大盘指数没有
% tic
% for i=1:num
%     [C,IA,IB] = intersect(data_month(i).date,data_market.date); 
%     len=size(C,1);
% %   data_month(i).raw(len,:)=[];
%     data_month(i).raw(1:len,3)= data_market.index(IB);
%     data_month(i).raw(end,3)=-9999*(len<size(data_month(i).raw,1))+data_month(i).raw(end,3)*(len==size(data_month(i).raw,1));
%     data_month(i).raw(data_month(i).raw==-9999)=nan;
%     clearvars IA IB C temp len;
% end
% toc
% %Elapsed time is 32.815836 seconds.

%%
%输出
tic
cd E:\360data\重要数据\桌面\data
mkdir month_re                                      
cd E:\360data\重要数据\桌面\data\month_re
a_vari={'个股名称', '交易日期', '个股涨跌幅', '指数涨跌幅','第几个交易日'};
for i=1:num
    temp=unique(data_month(i).stock);
    %输出标题
    xlswrite([temp{1} '.csv'],a_vari,1,'A1');
    %输出字符型数据
    xlswrite([temp{1} '.csv'],[data_month(i).stock data_month(i).date],1,'A2');
    %输出双精度数据
    xlswrite([temp{1} '.csv'],[data_month(i).raw(:,2) data_month(i).raw(:,3) data_month(i).order],1,'C2');
    clearvars temp;
end
toc
%Elapsed time is 3.851542 seconds.


%Elapsed time is 3517.977483 seconds.