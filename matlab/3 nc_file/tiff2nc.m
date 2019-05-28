%% tif图转化为nc文件
% 说明：
% 可读取某文件下所有tif图片并以结构体DATA储存(具体为NDVI年最大值，并以此为变量名)
% 其中，结构体中的矩阵A为格点数据；若有地理信息，则以矩阵R储存
% 随后新建文件夹nc，并创立nc文件，把矩阵A的数据写入其中
% 注意：
% 使用该脚本需改动路径与创建的nc文件名，并修改nc文件相应变量
% Code by Derry Liu, 5 Apr 2017
% Modified on 6 Apr 2017（adding the test module）
%% 读取tif文件
tic
% cd E:\360data\重要数据\桌面\data\生成nc                   %到该路径下
getfilename = ls('*.tif') ;                              %读取路径下所有的tif文件名
filename = cellstr(getfilename);                         %将字符型数组转换为cell型数组
num = length(filename);                                  %得到所有tif文件的个数
for i=1:num
    [DATA(i).A, DATA(i).R] = geotiffread(filename{i});   %得到文件的像元值矩阵A和地理信息R
end
toc
clearvars getfilename ;
%Elapsed time is 31.899923 seconds.                      %运行时间
%% 写入nc文件
mkdir nc
cd nc
tic
k = 2001:2001+num-1;
for i=1:num
   ncfilename(i,:) = strcat(num2str(k(i)),'.nc');        %需创建nc文件的名称
   mode = 'NC_NOCLOBBER';
   ncid = netcdf.create(ncfilename(i,:), mode);          %创建nc文件
% mode选项如下：
%  'NC_NOCLOBBER'： Prevent overwriting of existing file with the same name.
%  'NC_SHARE'： Allow synchronous file updates.
%  'NC_64BIT_OFFSET'： Allow easier creation of files and variables which are larger than two gigabytes.
   %定义Dimension（dimids）
   dimidx = netcdf.defDim(ncid,'lat',size(DATA(i).A,1));   
   dimidy = netcdf.defDim(ncid,'lon',size(DATA(i).A,2));  
   %定义Varible（varname）
   varname = 'NDVI';
   xtype = 'NC_BYTE';
   varid = netcdf.defVar(ncid,varname,xtype,[dimidx dimidy]);  %nc文件从外到内储存
% xtype选项如下：
%  'NC_BYTE'	int8 or uint8[a]
%  'NC_CHAR'	char
%  'NC_SHORT'	int16
%  'NC_INT'	    int32
%  'NC_FLOAT'	single
%  'NC_DOUBLE'	double
   netcdf.endDef(ncid);                                  %完成netCDF文件定义模式
   %把数据写到netcdf的文件中
   netcdf.putVar(ncid,varid,DATA(i).A);
   netcdf.close(ncid);                                   %关闭文件
end
toc
%Elapsed time is 29.155819 seconds.
%% MATLAB生成nc文件的其他例子
%%一、
% srcFile = fullfile(matlabroot,'toolbox','matlab','demos','example.nc');
% copyfile(srcFile,'myfile.nc');
% fileattrib('myfile.nc','+w');
% ncid = netcdf.open('myfile.nc','WRITE');
% varid = netcdf.inqVarID(ncid,'temperature');
% data = [100:109];
% netcdf.putVar(ncid,varid,0,10,data);
% netcdf.close(ncid);
%%二、
% a=rand(10,11);
% ncfilename = 'test1.nc';                               %需创建nc文件的名称
% mode = 'NC_NOCLOBBER';
% ncid1 = netcdf.create(ncfilename, mode);               %创建nc文件
% %定义Dimension
% dimidx = netcdf.defDim(ncid1,'lon',11);
% dimidy = netcdf.defDim(ncid1,'lat',10);
% %定义变量
% varid1 = netcdf.defVar(ncid1,'test','double',[dimidx dimidy]);
% netcdf.endDef(ncid1);                                  %完成netCDF文件定义模式
% %把数据写到netcdf的文件中
% netcdf.putVar(ncid1,varid1,a);
% netcdf.close(ncid1);                                   %关闭文件
%% 检验
%若setTest非零，则进行检验
%具体检验那个文件需手动修改
setTest=1;
tic
if setTest
    ncfile=cellstr(ncfilename(1,:));
    B=ncread(ncfile{1},varname);
    val_setTest=isequal(B,DATA(1).A);
    if val_setTest==1
        ok='成功';
    else
        ok='不成功';
    end
    display(strcat('tif转化nc文件',ok));
end
toc
%tif转化nc文件成功
%Elapsed time is 30.750304 seconds.
%% 查看nc文件命令
%ncdisp 2001.nc
%ncinfo 2001.nc







