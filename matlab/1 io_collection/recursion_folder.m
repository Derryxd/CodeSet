function folders = recursion_folder(main_dir,folders)
%main
% %function record = recursion_folder(mainDir, format, fileExt, ignoreSize, collectData)
% % main_dir = 'E:\360data\��Ҫ����\����\data';
if nargin == 1
    folders = {};
end
dir_name = main_dir;
folder_struct = dir(main_dir);
for i = 1:numel(folder_struct)
    fname = folder_struct(i).name;
    if( isequal( fname, '.' ) || ...     %������ǰ�ļ���
        isequal( fname, '..' ) || ...    %    ��һ���ļ���
        ~folder_struct(i).isdir )        %    ��Ŀ¼�ļ�
        %   'You know nothing';          %������ 
    else                                 %�����ļ���
        %�ݹ�������ļ����µ������ļ����������ļ���������ݹ�
        main_dir = [dir_name '\' fname]; 
        folders{end+1,1} = main_dir;       %�򣺼�¼�ļ�������  
        folders = recursion_folder(main_dir,folders);  
    end
end

