clc;
clear all;
 
maindir = 'E:\360data\重要数据\桌面\data\生成nc';
subdir =  dir( maindir );   % 先确定子文件夹
 
for i = 1 : length( subdir )
    if( isequal( subdir( i ).name, '.' ) || ...
        isequal( subdir( i ).name, '..' ) || ...
        ~subdir( i ).isdir )   % 如果不是目录跳过
        continue;
    end
     
    subdirpath = fullfile( maindir, subdir( i ).name, '*.jpg' );
    images = dir( subdirpath );   % 在这个子文件夹下找后缀为jpg的文件
     
    % 遍历每张图片
    for j = 1 : length( images )
        imagepath = fullfile( maindir, subdir( i ).name, images( j ).name  );
          imgdata = imread( imagepath );   % 这里进行你的读取操作
    end
end