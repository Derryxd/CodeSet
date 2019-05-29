clear all;
clc;
% ��Ϊ�����мȰ������֣��ְ������֣����Ի�ȡ��cell�У��ڽ��д���;
% [~,~,rawdata] = xlsread('Training_data',1,'A2:F16');  %sheet1�е�����
[~,~,rawdata] = xlsread('Training_data',2,'B2:F15');  %sheet2�е�����
Training_data = inf(size(rawdata));  %һ������ڴ洢����Ҫ�õ�ѵ������
judge = cell(1,size(rawdata,2)); %���ڴ洢�����Ƿ�Ϊ���֣�һ����Ѳ������ֵ�ת��������
for i = 1:size(rawdata,2)
    judge{1,i} = rawdata{1,i};        
end
judge_num_ornot = cellfun(@(x)isnumeric(x),judge);%��ʱ1�����Ӧ����һ������Ϊ����   0�����Ӧ����һ������Ϊ����
numer_index = find(judge_num_ornot == 1); %�ҵ���ֵ���Զ�Ӧ���е�����
Text_index = find(judge_num_ornot == 0);%�ҵ��������Զ�Ӧ���е�����
for i = 1:length(numer_index)
    trans_before = cell2mat(rawdata(:,numer_index(i)));
    Training_data(:,numer_index(i)) = trans_before; %��ֵ���Բ��ô���ֱ�Ӵ浽���յ�Training_data�оͿ�����
end
% native2unicode([186 186])
%��ʵ���������ԵĴ��������⣬����ͨ��cell2mat�������ֻ�ܻ�ȡÿ������ֵ�ĵ�һ�����ֻ��ַ������涼��ȡ����
% for i = 1:length(Text_index)
%     text_length = inf(1,size(rawdata,1));  %����һ�����ÿ������ֵ�������ж೤�����һ�������е�����ֵ��һ���������ô���
%     tmp = rawdata(:,Text_index(i));
%     for v = 1:length(tmp)
%         text_length(v) = length(tmp{v});  %��¼��ǰ���Ե�ÿ������ֵ�ĳ���
%     end
%     if length(unique(text_length)) == 1     %���һ�������е�����ֵһ�������Ϳ�����cell2mat�������
%          trans_before = cell2mat(tmp);
%     else   %���һ�������е�����ֵ��һ���������磬���� ������ ��ʱ��Ҫ������ַ���Ϊ��׼����ȫ�̵��ַ���
%         max_length = max(text_length);
% %         add_num=repmat(max_length,[1,length(tmp)])-text_length; %������Ҫ����Ŀ��ַ��ĸ���
%         deal_index = find(text_length ~= max_length);
%         for u = 1:length(deal_index)
%             add_num = max_length - text_length(deal_index(u));
%             tmp(deal_index(u)) = cellfun(@strcat, tmp(deal_index(u)), cellstr(repmat('a',[1,add_num])),'Unif',0);
%         end
%         trans_before = cell2mat(tmp);    
%     end
%     trans_after = inf(size(rawdata,1),1);
%     a_num = unique(trans_before(:,Text_index(i)),'rows');
%     for j = 1:length(a_num)
%         index = find(rawdata(:,Text_index(i)) == a_num{j});
%         trans_after(index) = mark;     
%         fprintf('����%d�е�����ֵ"%s"��%d��ʾ\n',Text_index(i),a_num(j),mark);
%         mark = mark+1;
%     end
%     Training_data(:,Text_index(i)) = trans_after;
% end
%�����������ڶԶ����������������Ϊ��Щ���������֣�Ҫת���ɲ�ͬ������
for i = 1:length(Text_index)
    trans_after = inf(size(rawdata,1),1);
    a_num = unique(rawdata(:,Text_index(i)));
%     a_num = unique(trans_before,'rows'); %�õ�������ԵĲ��ظ�������ֵ  ��������һ�㶼����ɢ����
    mark = 1:length(a_num);
    for j = 1:length(a_num)
        for v = 1:size(rawdata,1)
            if strcmp(rawdata{v,Text_index(i)},a_num{j}) %�����ַ����Ƚ�ֻ����strcmp��������==
                trans_after(v) = mark(j);
            end
        end
        fprintf('����%d�е�����ֵ"%s"��%d��ʾ\n',Text_index(i),a_num{j},mark(j));
    end
    Training_data(:,Text_index(i)) = trans_after;
end



 train_patterns=Training_data(:,1:(size(Training_data,2)-1));  %�õ�ѵ������
 train_targets=Training_data(:,size(Training_data,2))';   %�õ�ѵ�������ı�ǩ   1��ѵ��������Ŀ
 test_patterns=[];
 test_targets_predict = Use_C4_5(train_patterns', train_targets, test_patterns', 5, 5);  
 