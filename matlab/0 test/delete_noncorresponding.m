
Folder = 'C:\Users\lt\Desktop\2014��04��VOA����Ӣ��������Ƶ�������';
dirOutput=dir(fullfile(Folder,'*.lrc'));
fileNames={dirOutput.name};
shortMatch = cell2mat(fileNames);
dirOutput=dir(fullfile(Folder, '*.mp3'));
fileNames={dirOutput.name}';
for n = 1:length(fileNames)
    fileNames{n,1} = strrep(fileNames{n,1}, '.mp3','');
    if isempty(strfind(shortMatch, fileNames{n,1}))
       delete(strcat(Folder,'\', fileNames{n,1},'.mp3')); 
    end
end

% ���ߣ�����
% ���ӣ�https://www.zhihu.com/question/27780598/answer/61510874
% ��Դ��֪��
% ����Ȩ���������С���ҵת������ϵ���߻����Ȩ������ҵת����ע��������