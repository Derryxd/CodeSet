% clear all;
tic
%Ѱ�Ҷ�����ڵ�����ֵ����������ǰ������Сʱ��ֵ�浽�����С�
%Ŀ�ģ�����Դ����ʱ�õġ��ҵ���������A�����ߵ�ʱ�̣����ҳ�ǰ��ʱ��λ����١�������ʱ��ͼ�ͷ���frequencyõ��ͼ��
%% read data
data = importdata('4502#20170429-20171107-May-10min.txt');
time = data.textdata(10:end);
speed_10m = data.data(:,37);        %10m�߶ȵķ���
len = length(speed_10m);
%% find index 
% index_gt_0p8 = find(speed_10m>0.8); %find the indices of wind which are greater than 0.8m/s
index_gt_5p0 = find(speed_10m>0.8); %for test: ���ٴ���5m/s���±�
index_bgn = index_gt_5p0-18;        %�����±�3Сʱǰ����ʼ�±�
index_end = index_gt_5p0+18;        %�����±�3Сʱ���ĩ���±�
tmp = arrayfun(@(x,y) x:y,index_bgn,index_end,'UniformOutput',false);  
                                    %(���ɵĽ���μ������index_cell)
index_mat = cell2mat(tmp);          %���������ɷ��ٴ���5m/s��ʱ��ε��±����
[x,y] = size(index_mat);
tmp = reshape(index_mat,[x*y 1]);   %���þ����ų�һ��
index_unique = unique(tmp);         %ȥ�أ�ȡ�±��Ψһֵ
index_period = index_unique(index_unique>0&index_unique<=len);
                                    %���±�С����ͳ������е�ȥ��
%% choose
% time_gt_5p0 = time(index_period);   %10m�߶ȷ��ٴ���5m/s��ʱ��
% speed_10m_gt_5p0 = speed_10m(index_period);
%����Щ���ݷֳ�����������ʱ���(����ɼ�ͼƬ��С����)
index_period_new = [index_period(2:end);index_period(end)];
                                    %ȡԭ����2��end�����Ϊԭ�������һ����
discont = find(index_period_new-index_period>1); 
                                    %�ҳ�����1���±꣬���������ĵط����Ӷ��ֶ�
period_bgn = [index_period(1);index_period_new(discont)];
period_end = [index_period(discont);index_period(end)];
                                    %���ɲ�ͬʱ��ε���ʼ�±��ĩ���±�
index_cell = arrayfun(@(x,y) x:y,period_bgn,period_end,'UniformOutput',false); 
                                    %��cell���治ͬʱ��ε��±�����
%% 
ind=1:length(index_cell);ind=ind';
speed_10m_gt_5p0 = arrayfun(@(ind) speed_10m(index_cell{ind}),ind,'UniformOutput',false); 
time_gt_5p0 = arrayfun(@(ind) time(index_cell{ind}),ind,'UniformOutput',false);    %10m�߶ȷ��ٴ���5m/s��ʱ��                                  
toc                                    
%Elapsed time is 0.283227 seconds.                            
