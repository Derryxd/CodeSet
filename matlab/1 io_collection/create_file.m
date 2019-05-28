% clc;
% clear;
% for i = 2007:2015
%     fid=fopen([num2str(i) '.txt'],'a');
%     fclose(fid);
% end

for i=1:5
    folder = sprintf('%s%s','stat_', a_time{i}); % 构造文件夹名称
    mkdir(folder); % 创建文件夹
end