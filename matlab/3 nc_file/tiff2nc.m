%% tifͼת��Ϊnc�ļ�
% ˵����
% �ɶ�ȡĳ�ļ�������tifͼƬ���Խṹ��DATA����(����ΪNDVI�����ֵ�����Դ�Ϊ������)
% ���У��ṹ���еľ���AΪ������ݣ����е�����Ϣ�����Ծ���R����
% ����½��ļ���nc��������nc�ļ����Ѿ���A������д������
% ע�⣺
% ʹ�øýű���Ķ�·���봴����nc�ļ��������޸�nc�ļ���Ӧ����
% Code by Derry Liu, 5 Apr 2017
% Modified on 6 Apr 2017��adding the test module��
%% ��ȡtif�ļ�
tic
% cd E:\360data\��Ҫ����\����\data\����nc                   %����·����
getfilename = ls('*.tif') ;                              %��ȡ·�������е�tif�ļ���
filename = cellstr(getfilename);                         %���ַ�������ת��Ϊcell������
num = length(filename);                                  %�õ�����tif�ļ��ĸ���
for i=1:num
    [DATA(i).A, DATA(i).R] = geotiffread(filename{i});   %�õ��ļ�����Ԫֵ����A�͵�����ϢR
end
toc
clearvars getfilename ;
%Elapsed time is 31.899923 seconds.                      %����ʱ��
%% д��nc�ļ�
mkdir nc
cd nc
tic
k = 2001:2001+num-1;
for i=1:num
   ncfilename(i,:) = strcat(num2str(k(i)),'.nc');        %�贴��nc�ļ�������
   mode = 'NC_NOCLOBBER';
   ncid = netcdf.create(ncfilename(i,:), mode);          %����nc�ļ�
% modeѡ�����£�
%  'NC_NOCLOBBER'�� Prevent overwriting of existing file with the same name.
%  'NC_SHARE'�� Allow synchronous file updates.
%  'NC_64BIT_OFFSET'�� Allow easier creation of files and variables which are larger than two gigabytes.
   %����Dimension��dimids��
   dimidx = netcdf.defDim(ncid,'lat',size(DATA(i).A,1));   
   dimidy = netcdf.defDim(ncid,'lon',size(DATA(i).A,2));  
   %����Varible��varname��
   varname = 'NDVI';
   xtype = 'NC_BYTE';
   varid = netcdf.defVar(ncid,varname,xtype,[dimidx dimidy]);  %nc�ļ����⵽�ڴ���
% xtypeѡ�����£�
%  'NC_BYTE'	int8 or uint8[a]
%  'NC_CHAR'	char
%  'NC_SHORT'	int16
%  'NC_INT'	    int32
%  'NC_FLOAT'	single
%  'NC_DOUBLE'	double
   netcdf.endDef(ncid);                                  %���netCDF�ļ�����ģʽ
   %������д��netcdf���ļ���
   netcdf.putVar(ncid,varid,DATA(i).A);
   netcdf.close(ncid);                                   %�ر��ļ�
end
toc
%Elapsed time is 29.155819 seconds.
%% MATLAB����nc�ļ�����������
%%һ��
% srcFile = fullfile(matlabroot,'toolbox','matlab','demos','example.nc');
% copyfile(srcFile,'myfile.nc');
% fileattrib('myfile.nc','+w');
% ncid = netcdf.open('myfile.nc','WRITE');
% varid = netcdf.inqVarID(ncid,'temperature');
% data = [100:109];
% netcdf.putVar(ncid,varid,0,10,data);
% netcdf.close(ncid);
%%����
% a=rand(10,11);
% ncfilename = 'test1.nc';                               %�贴��nc�ļ�������
% mode = 'NC_NOCLOBBER';
% ncid1 = netcdf.create(ncfilename, mode);               %����nc�ļ�
% %����Dimension
% dimidx = netcdf.defDim(ncid1,'lon',11);
% dimidy = netcdf.defDim(ncid1,'lat',10);
% %�������
% varid1 = netcdf.defVar(ncid1,'test','double',[dimidx dimidy]);
% netcdf.endDef(ncid1);                                  %���netCDF�ļ�����ģʽ
% %������д��netcdf���ļ���
% netcdf.putVar(ncid1,varid1,a);
% netcdf.close(ncid1);                                   %�ر��ļ�
%% ����
%��setTest���㣬����м���
%��������Ǹ��ļ����ֶ��޸�
setTest=1;
tic
if setTest
    ncfile=cellstr(ncfilename(1,:));
    B=ncread(ncfile{1},varname);
    val_setTest=isequal(B,DATA(1).A);
    if val_setTest==1
        ok='�ɹ�';
    else
        ok='���ɹ�';
    end
    display(strcat('tifת��nc�ļ�',ok));
end
toc
%tifת��nc�ļ��ɹ�
%Elapsed time is 30.750304 seconds.
%% �鿴nc�ļ�����
%ncdisp 2001.nc
%ncinfo 2001.nc







