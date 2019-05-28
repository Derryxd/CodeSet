function folders = recursion_folder(main_dir,folders)
%main
% %function record = recursion_folder(mainDir, format, fileExt, ignoreSize, collectData)
% % main_dir = 'E:\360data\重要数据\桌面\data';
if nargin == 1
    folders = {};
end
dir_name = main_dir;
folder_struct = dir(main_dir);
for i = 1:numel(folder_struct)
    fname = folder_struct(i).name;
    if( isequal( fname, '.' ) || ...     %若：当前文件夹
        isequal( fname, '..' ) || ...    %    上一级文件夹
        ~folder_struct(i).isdir )        %    非目录文件
        %   'You know nothing';          %则：跳过 
    else                                 %若：文件夹
        %递归遍历该文件夹下的所有文件，遇到子文件夹则继续递归
        main_dir = [dir_name '\' fname]; 
        folders{end+1,1} = main_dir;       %则：记录文件夹名字  
        folders = recursion_folder(main_dir,folders);  
    end
end

