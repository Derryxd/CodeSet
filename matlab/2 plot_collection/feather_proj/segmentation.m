function index_cell = segmentation(index_period)
%输入序列index_period必须按列排序，如 index_period=[2 3 4 7 8 11 12]'
    index_period_new = [index_period(2:end);index_period(end)];
                                        %取原序列2：end，最后为原序列最后一个数
    discont = find(index_period_new-index_period>1); 
                                        %找出大于1的下标，即不连续的地方，从而分段
    period_bgn = [index_period(1);index_period_new(discont)];
    period_end = [index_period(discont);index_period(end)];
                                        %生成不同时间段的起始下标和末端下标
    index_cell = arrayfun(@(x,y) x:y,period_bgn,period_end,'UniformOutput',false); 
                                        %以cell保存不同时间段的下标数组

