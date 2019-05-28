%% I/O Binary
% ˵������nine.binΪ���ӣ�������һ�³��򣬾�����ű���tt.m
%  fileID = fopen('nine.bin','w');
%  fwrite(fileID,magic(5),'integer*4');
%  fclose(fileID);
% Code by Derry Liu, 14 Apr 2017
%% ע��&����
%ע�⣺
%1��By default, fread reads a file 1 byte at a time, interprets each byte 
%   as an 8-bit unsigned integer (uint8), and returns a double array.
%   --����ο�MATLAB�������ͱ�񣨼�ͼ��
%2��Read in column order.
%   --������[3,3]�ж�ȡ4�����������һ�к͵ڶ��е�һ������
%3��To preserve NaN and Inf values, read and write data of class 'double' or 'single'.
%������
%����fseek��fread��fwriteģ����о��������Ҫ�޸�
read_specific=1;              %�Ƿ���ض�λ�ö�ȡ����
multiDir=0;                   %�ӵ�һ�ļ��ж�ȡ����(0)���ǴӶ���ļ���(��0)��ȡ����
singleFile=1;                 %�Ƿ�ֻ��ȡһ���ļ�(��0Ϊ��һ�ļ�)
                              %multiDir��singleFile����ͬʱΪ1������ִֻ��multiDir
fileName='nine';              %��ֻ��ȡ��һ�ļ������޸Ĵ˴���������׺��
suffix='.bin';                %�ļ���׺����
mainDir = '';                 %ȷ�����ļ���·��
%% �ļ�λ��
if multiDir
    temp=0;
    subDir =  dir( mainDir ); %ȷ�������ļ���
    num_dir = length(subDir); %���ļ��и���
    for i = 1:num_dir
        if( isequal( subDir(i).name, '.' ) || ...       %��ǰ�ļ���
                isequal( subDir(i).name, '..' ) || ...  %��һ���ļ���
                ~subDir(i).isdir )                      %�������Ŀ¼����
            continue;
        end
        %fullfile('dir1', 'dir2', ..., 'filename')
        subDirPath = fullfile( mainDir, subDir(i).name, ['*' suffix] );
        files = dir( subDirPath );            %��������ļ��������ض���׺���ļ�
        num = length(files);                  %�õ������ļ��ĸ���
        if num
        for j = 1:num
            temp=temp+1;
            getFilename = fullfile(mainDir,subDir(i).name,files(j).name);
            filePath{temp} = cellstr(getFilename);
        end
        end
    end
    num = temp;                                %�õ������ļ��ĸ���
elseif ~singleFile
    cd(mainDir)
    getFilename=ls( [mainDir '\*' suffix] );   %��ȡ�����ض���׺�ļ�������
    filePath = cellstr(getFilename);           %���ַ�������ת��Ϊcell������
    num = length(filePath);                    %�õ������ļ��ĸ���
else
    getFilename=ls( [mainDir '\' fileName suffix] );
    filePath = cellstr(getFilename);
    num=1;
end
clearvars files getfilename num_dir multidir subdir subdirpath suffix temp 
%��ȡ�ļ�
for i=1:num
    %r:read only ; w:write ; a:write onto the end ; +:read first then write
    fidR=fopen(filePath{i},'r+');
%% fseek & ftell
%��ʽ��
%fseek(fileID, offset, origin)
%status = fseek(fileID, offset, origin)
%position = ftell(fileID)
%˵����
% offset: Number of bytes to move from origin. Can be positive, negative, or zero. 
%         The n bytes of a given file are in positions 0 through n-1.
% origin: Starting location in the file, specified as a character vector, string scalar or a scalar number:
%   'bof' or -1   :  Beginning of file
%   'cof' or 0    :  Current position in file
%   'eof' or 1    :  End of file
    if read_specific
        n=1;         %��n=9�����ƶ�����10���ֽ�
        offset=n;
        origin='bof';
        fseek(fidR,offset,origin);
        ftell(fidR)
    end
%       frewind(fid);     �ѵ�ǰ�ļ�ָ���ƶ����ļ���ʼ
%% fread
%��ʽ��
%A = fread(fileID,sizeA,precision,skip,machinefmt)
%[A,count] = fread(___)
%˵����
% fileID:��fopen���ļ����
% sizeA :[]���������������ʽ������n�����ȡ(����ȥ��)n����
% precision :ʹ�������������Ͷ�ȡ���ݣ��������Ͳμ�word��ͼƬ
%   source : ��'int16'����int16��ȡ���ݣ���������Ϊdouble
%   source=>output : ��'int8=>char'����ȡ��������Ϊchar
%   *source : ��'*int18',�൱��'ubit18=>uint32'������int18��ȡ���ݣ���������Ϊint32
%   N*source or N*source=>output �� һ���Զ�source�͵�����
% skip :ѭ�����ӣ�����������n���ֽڣ�nΪ����
% machinefmt :��С�ˣ�windows������intel����С�ˣ�UINX֮���һ���Ǵ�ˣ�
%   'n'or'native'  �� Your system byte ordering (default)
%   'b'or'ieee-be' �� Big-endian ordering
%   'l'or'ieee-le' �� Little-endian ordering
%   's'or'ieee-be.l64' �� Big-endian ordering, 64-bit long data type
%   'a'or'ieee-le.l64' �� Little-endian ordering, 64-bit long data type
    sizeA=[3,2];
    precision='double';
    A(i).data=fread(fidR,sizeA,precision);  %A(i).data������ض���Ҫ���޸�
    fclose(fidR);
end
%% fwrite
%��ʽ��
%fwrite(fileID,A,precision,skip,machinefmt)
%count = fwrite(___)
for i=1:num
    %���²�����������ģ�������
    outDir='';
    outSuffix='.txt';
    outFile=strcat('out',num2str(i),outSuffix);
    outPath=[outDir '\' outFile];
    fidW=fopen(outPath,'w+');
    precision='double';
    fwrite(fidW,A(i).data,precision);
    fclose(fidW);
end
%% fscan & fprintf���ı�io����c����һ����
%��ʽ��
%A = fscanf(fileID,formatSpec,sizeA)
%fprintf(fileID,formatSpec,A1,...,An)��fprintf(formatSpec,A1,...,An)
%[A,count] = fscanf(___)��nbytes = fprintf(___)
%���ӣ��ļ���С����
%һ��
% A = magic(4);
% fileID = fopen('myfile.txt','w');
% nbytes = fprintf(fileID,'%2.1f%2.1f%2.1f%2.1f\r\n',A)
% fclose(fileID);
%����
% str = '78��C 72��C 64��C 66��C 49��C';
% fileID = fopen('temperature.dat','w');
% fprintf(fileID,'%s',str);
% fclose(fileID);
% fileID = fopen('temperature.dat','r');
% degrees = char(176);  %The extended ASCII code 176 represents the degree sign.
% [A,count] = fscanf(fileID, ['%d' degrees 'C'])
% fclose(fileID);










