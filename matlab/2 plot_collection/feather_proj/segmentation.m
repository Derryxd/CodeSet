function index_cell = segmentation(index_period)
%��������index_period���밴�������� index_period=[2 3 4 7 8 11 12]'
    index_period_new = [index_period(2:end);index_period(end)];
                                        %ȡԭ����2��end�����Ϊԭ�������һ����
    discont = find(index_period_new-index_period>1); 
                                        %�ҳ�����1���±꣬���������ĵط����Ӷ��ֶ�
    period_bgn = [index_period(1);index_period_new(discont)];
    period_end = [index_period(discont);index_period(end)];
                                        %���ɲ�ͬʱ��ε���ʼ�±��ĩ���±�
    index_cell = arrayfun(@(x,y) x:y,period_bgn,period_end,'UniformOutput',false); 
                                        %��cell���治ͬʱ��ε��±�����

