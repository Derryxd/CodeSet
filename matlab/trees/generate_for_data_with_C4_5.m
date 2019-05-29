clear all;
clc;
% 因为数据中既包含数字，又包含文字，所以获取到cell中，在进行处理;
% [~,~,rawdata] = xlsread('Training_data',1,'A2:F16');  %sheet1中的样本
[~,~,rawdata] = xlsread('Training_data',2,'B2:F15');  %sheet2中的样本
Training_data = inf(size(rawdata));  %一会儿用于存储最终要用的训练样本
judge = cell(1,size(rawdata,2)); %用于存储数据是否为数字，一会儿把不是文字的转换成数字
for i = 1:size(rawdata,2)
    judge{1,i} = rawdata{1,i};        
end
judge_num_ornot = cellfun(@(x)isnumeric(x),judge);%此时1代表对应的那一列属性为数字   0代表对应的那一列属性为文字
numer_index = find(judge_num_ornot == 1); %找到数值属性对应的列的索引
Text_index = find(judge_num_ornot == 0);%找到文字属性对应的列的索引
for i = 1:length(numer_index)
    trans_before = cell2mat(rawdata(:,numer_index(i)));
    Training_data(:,numer_index(i)) = trans_before; %数值属性不用处理，直接存到最终的Training_data中就可以了
end
% native2unicode([186 186])
%其实对文字属性的处理有问题，就是通过cell2mat这个函数只能获取每个属性值的第一个汉字或字符，后面都获取不到
% for i = 1:length(Text_index)
%     text_length = inf(1,size(rawdata,1));  %用于一会儿放每个属性值的文字有多长，如果一个属性中的属性值不一样长，还得处理
%     tmp = rawdata(:,Text_index(i));
%     for v = 1:length(tmp)
%         text_length(v) = length(tmp{v});  %记录当前属性的每个属性值的长度
%     end
%     if length(unique(text_length)) == 1     %如果一个属性中的属性值一样长，就可以用cell2mat这个函数
%          trans_before = cell2mat(tmp);
%     else   %如果一个属性中的属性值不一样长，比如，‘买’ ‘不买’ 这时需要以最长的字符串为标准，补全短的字符串
%         max_length = max(text_length);
% %         add_num=repmat(max_length,[1,length(tmp)])-text_length; %计算需要补充的空字符的个数
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
%         fprintf('属性%d中的属性值"%s"用%d表示\n',Text_index(i),a_num(j),mark);
%         mark = mark+1;
%     end
%     Training_data(:,Text_index(i)) = trans_after;
% end
%以上内容是在对读入的数据作处理，因为有些属性是文字，要转换成不同的数字
for i = 1:length(Text_index)
    trans_after = inf(size(rawdata,1),1);
    a_num = unique(rawdata(:,Text_index(i)));
%     a_num = unique(trans_before,'rows'); %得到这个属性的不重复的属性值  文字属性一般都是离散属性
    mark = 1:length(a_num);
    for j = 1:length(a_num)
        for v = 1:size(rawdata,1)
            if strcmp(rawdata{v,Text_index(i)},a_num{j}) %两个字符串比较只能用strcmp，不能用==
                trans_after(v) = mark(j);
            end
        end
        fprintf('属性%d中的属性值"%s"用%d表示\n',Text_index(i),a_num{j},mark(j));
    end
    Training_data(:,Text_index(i)) = trans_after;
end



 train_patterns=Training_data(:,1:(size(Training_data,2)-1));  %得到训练样本
 train_targets=Training_data(:,size(Training_data,2))';   %得到训练样本的标签   1×训练样本数目
 test_patterns=[];
 test_targets_predict = Use_C4_5(train_patterns', train_targets, test_patterns', 5, 5);  
 