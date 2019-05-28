% clear all;
tic
%寻找多个日期的索引值，并返回其前后三个小时的值存到数组中。
%目的：风资源分析时用的。找到湍流大于A类曲线的时刻，并找出前后时间段画风速、湍流的时序图和风速frequency玫瑰图。
%% read data
data = importdata('4502#20170429-20171107-May-10min.txt');
time = data.textdata(10:end);
speed_10m = data.data(:,37);        %10m高度的风速
len = length(speed_10m);
%% find index 
% index_gt_0p8 = find(speed_10m>0.8); %find the indices of wind which are greater than 0.8m/s
index_gt_5p0 = find(speed_10m>0.8); %for test: 风速大于5m/s的下标
index_bgn = index_gt_5p0-18;        %上述下标3小时前的起始下标
index_end = index_gt_5p0+18;        %上述下标3小时后的末端下标
tmp = arrayfun(@(x,y) x:y,index_bgn,index_end,'UniformOutput',false);  
                                    %(生成的结果参加下面的index_cell)
index_mat = cell2mat(tmp);          %这两句生成风速大于5m/s的时间段的下标矩阵
[x,y] = size(index_mat);
tmp = reshape(index_mat,[x*y 1]);   %将该矩阵排成一行
index_unique = unique(tmp);         %去重，取下标的唯一值
index_period = index_unique(index_unique>0&index_unique<=len);
                                    %将下标小于零和超过序列的去掉
%% choose
% time_gt_5p0 = time(index_period);   %10m高度风速大于5m/s的时刻
% speed_10m_gt_5p0 = speed_10m(index_period);
%将这些数据分成若干连续的时间段(具体可见图片的小例子)
index_period_new = [index_period(2:end);index_period(end)];
                                    %取原序列2：end，最后为原序列最后一个数
discont = find(index_period_new-index_period>1); 
                                    %找出大于1的下标，即不连续的地方，从而分段
period_bgn = [index_period(1);index_period_new(discont)];
period_end = [index_period(discont);index_period(end)];
                                    %生成不同时间段的起始下标和末端下标
index_cell = arrayfun(@(x,y) x:y,period_bgn,period_end,'UniformOutput',false); 
                                    %以cell保存不同时间段的下标数组
%% 
ind=1:length(index_cell);ind=ind';
speed_10m_gt_5p0 = arrayfun(@(ind) speed_10m(index_cell{ind}),ind,'UniformOutput',false); 
time_gt_5p0 = arrayfun(@(ind) time(index_cell{ind}),ind,'UniformOutput',false);    %10m高度风速大于5m/s的时刻                                  
toc                                    
%Elapsed time is 0.283227 seconds.                            
