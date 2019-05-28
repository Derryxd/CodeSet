
Folder = 'C:\Users\lt\Desktop\2014年04月VOA常速英语听力音频打包下载';
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

% 作者：李腾
% 链接：https://www.zhihu.com/question/27780598/answer/61510874
% 来源：知乎
% 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。