clc;
clear all;
 
maindir = 'E:\360data\��Ҫ����\����\data\����nc';
subdir =  dir( maindir );   % ��ȷ�����ļ���
 
for i = 1 : length( subdir )
    if( isequal( subdir( i ).name, '.' ) || ...
        isequal( subdir( i ).name, '..' ) || ...
        ~subdir( i ).isdir )   % �������Ŀ¼����
        continue;
    end
     
    subdirpath = fullfile( maindir, subdir( i ).name, '*.jpg' );
    images = dir( subdirpath );   % ��������ļ������Һ�׺Ϊjpg���ļ�
     
    % ����ÿ��ͼƬ
    for j = 1 : length( images )
        imagepath = fullfile( maindir, subdir( i ).name, images( j ).name  );
          imgdata = imread( imagepath );   % ���������Ķ�ȡ����
    end
end