% clc;
% clear;
% for i = 2007:2015
%     fid=fopen([num2str(i) '.txt'],'a');
%     fclose(fid);
% end

for i=1:5
    folder = sprintf('%s%s','stat_', a_time{i}); % �����ļ�������
    mkdir(folder); % �����ļ���
end