%% I/O Binary
% 说明：以nine.bin为例子，先运行一下程序，具体见脚本：tt.m
%  fileID = fopen('nine.bin','w');
%  fwrite(fileID,magic(5),'integer*4');
%  fclose(fileID);
% Code by Derry Liu, 14 Apr 2017
%% 注意&参数
%注意：
%1、By default, fread reads a file 1 byte at a time, interprets each byte 
%   as an 8-bit unsigned integer (uint8), and returns a double array.
%   --具体参考MATLAB数据类型表格（见图）
%2、Read in column order.
%   --比如向[3,3]中读取4个数，则读第一列和第二列第一个数。
%3、To preserve NaN and Inf values, read and write data of class 'double' or 'single'.
%参数：
%下面fseek、fread和fwrite模块均有具体参数需要修改
read_specific=1;              %是否从特定位置读取数据
multiDir=0;                   %从单一文件夹读取数据(0)还是从多个文件夹(非0)读取数据
singleFile=1;                 %是否只读取一个文件(非0为单一文件)
                              %multiDir和singleFile不能同时为1，否则只执行multiDir
fileName='nine';              %若只读取单一文件，则修改此处（不带后缀）
suffix='.bin';                %文件后缀名称
mainDir = '';                 %确定主文件夹路径
%% 文件位置
if multiDir
    temp=0;
    subDir =  dir( mainDir ); %确定各子文件夹
    num_dir = length(subDir); %子文件夹个数
    for i = 1:num_dir
        if( isequal( subDir(i).name, '.' ) || ...       %当前文件夹
                isequal( subDir(i).name, '..' ) || ...  %上一级文件夹
                ~subDir(i).isdir )                      %如果不是目录跳过
            continue;
        end
        %fullfile('dir1', 'dir2', ..., 'filename')
        subDirPath = fullfile( mainDir, subDir(i).name, ['*' suffix] );
        files = dir( subDirPath );            %在这个子文件夹下找特定后缀的文件
        num = length(files);                  %得到所有文件的个数
        if num
        for j = 1:num
            temp=temp+1;
            getFilename = fullfile(mainDir,subDir(i).name,files(j).name);
            filePath{temp} = cellstr(getFilename);
        end
        end
    end
    num = temp;                                %得到所有文件的个数
elseif ~singleFile
    cd(mainDir)
    getFilename=ls( [mainDir '\*' suffix] );   %读取所有特定后缀文件的名称
    filePath = cellstr(getFilename);           %将字符型数组转换为cell型数组
    num = length(filePath);                    %得到所有文件的个数
else
    getFilename=ls( [mainDir '\' fileName suffix] );
    filePath = cellstr(getFilename);
    num=1;
end
clearvars files getfilename num_dir multidir subdir subdirpath suffix temp 
%读取文件
for i=1:num
    %r:read only ; w:write ; a:write onto the end ; +:read first then write
    fidR=fopen(filePath{i},'r+');
%% fseek & ftell
%格式：
%fseek(fileID, offset, origin)
%status = fseek(fileID, offset, origin)
%position = ftell(fileID)
%说明：
% offset: Number of bytes to move from origin. Can be positive, negative, or zero. 
%         The n bytes of a given file are in positions 0 through n-1.
% origin: Starting location in the file, specified as a character vector, string scalar or a scalar number:
%   'bof' or -1   :  Beginning of file
%   'cof' or 0    :  Current position in file
%   'eof' or 1    :  End of file
    if read_specific
        n=1;         %如n=9，则移动到第10个字节
        offset=n;
        origin='bof';
        fseek(fidR,offset,origin);
        ftell(fidR)
    end
%       frewind(fid);     把当前文件指针移动到文件开始
%% fread
%格式：
%A = fread(fileID,sizeA,precision,skip,machinefmt)
%[A,count] = fread(___)
%说明：
% fileID:用fopen打开文件句柄
% sizeA :[]代表向量或矩阵形式；数字n代表读取(向下去整)n个数
% precision :使用哪种数据类型读取数据，具体类型参见word或图片
%   source : 如'int16'，以int16读取数据，最终数据为double
%   source=>output : 如'int8=>char'，读取数据最终为char
%   *source : 如'*int18',相当于'ubit18=>uint32'，则以int18读取数据，最终数据为int32
%   N*source or N*source=>output ： 一次性读source型的数据
% skip :循环因子，周期性跳过n个字节，n为标量
% machinefmt :大小端（windows这种用intel的是小端，UINX之类的一般是大端）
%   'n'or'native'  ： Your system byte ordering (default)
%   'b'or'ieee-be' ： Big-endian ordering
%   'l'or'ieee-le' ： Little-endian ordering
%   's'or'ieee-be.l64' ： Big-endian ordering, 64-bit long data type
%   'a'or'ieee-le.l64' ： Little-endian ordering, 64-bit long data type
    sizeA=[3,2];
    precision='double';
    A(i).data=fread(fidR,sizeA,precision);  %A(i).data可针对特定需要做修改
    fclose(fidR);
end
%% fwrite
%格式：
%fwrite(fileID,A,precision,skip,machinefmt)
%count = fwrite(___)
for i=1:num
    %以下参数参照上面模块的设置
    outDir='';
    outSuffix='.txt';
    outFile=strcat('out',num2str(i),outSuffix);
    outPath=[outDir '\' outFile];
    fidW=fopen(outPath,'w+');
    precision='double';
    fwrite(fidW,A(i).data,precision);
    fclose(fidW);
end
%% fscan & fprintf（文本io，跟c语言一样）
%格式：
%A = fscanf(fileID,formatSpec,sizeA)
%fprintf(fileID,formatSpec,A1,...,An)，fprintf(formatSpec,A1,...,An)
%[A,count] = fscanf(___)；nbytes = fprintf(___)
%例子：文件大小存疑
%一、
% A = magic(4);
% fileID = fopen('myfile.txt','w');
% nbytes = fprintf(fileID,'%2.1f%2.1f%2.1f%2.1f\r\n',A)
% fclose(fileID);
%二、
% str = '78°C 72°C 64°C 66°C 49°C';
% fileID = fopen('temperature.dat','w');
% fprintf(fileID,'%s',str);
% fclose(fileID);
% fileID = fopen('temperature.dat','r');
% degrees = char(176);  %The extended ASCII code 176 represents the degree sign.
% [A,count] = fscanf(fileID, ['%d' degrees 'C'])
% fclose(fileID);










