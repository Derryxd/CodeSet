
clear;clc;
% geotiffinfo('MOD17A3_Science_GPP_2000.tif')
a=geotiffread('MOD17A3_Science_GPP_2000.tif');
nccreate('test.nc','MGFC','Datatype','uint16', ...                   %��������
                          'Dimensions',{'lat',16800,'lon',43200},... %ά������
                          'Format','netcdf4')                        %�ļ�����
ncwrite('test.nc','MGFC',a);

% b=single(mat2gray(a));                         %��һ������ֵΪ0~1֮��
% ncwrite('test.nc','MGFC',b);  datatype:single

% %����
% c=ncread('test.nc','MGFC');
% isequal(b,c)
% %ans=1֤��һ��

%%  ����
% format:
% 'classic'	NetCDF 3
% '64bit'	NetCDF 3, with 64-bit offsets
% 'netcdf4_classic'	NetCDF 4 classic model
% 'netcdf4'	NetCDF 4 model (Use this format to enable group hierarchy)

% Datatype
% 'double'	NC_DOUBLE
% 'single'	NC_FLOAT
% 'int64'	NC_INT64*
% 'uint64'	NC_UINT64*
% 'int32'	NC_INT
% 'uint32'	NC_UINT*
% 'int16'	NC_SHORT
% 'uint16'	NC_USHORT*
% 'int8'	NC_BYTE
% 'uint8'	NC_UBYTE*
% 'char'	NC_CHAR


