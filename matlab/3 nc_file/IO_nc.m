clc,clear;
%% input
%name_for_input
name='gpp';      %��Ҫ�ĵĶ���
ncfileNameIn=['LPJ-GUESS-BLAZE_SF1_' name '.nc'];
VariNameIn=[name '.monthly'];
%open
ncidIn = netcdf.open(ncfileNameIn,'NOWRITE');  %��nc�ļ�
info=ncinfo(ncfileNameIn);                   %�Խṹ����������ʹ洢nc�ļ�����Ϣ
%read
VariData  = ncread(ncfileNameIn,VariNameIn); %�������gpp
LonData  = ncread(ncfileNameIn,'lon');       %�������lon
LatData  = ncread(ncfileNameIn,'lat');       %�������lat
TimeData  = ncread(ncfileNameIn,'time');     %�������time
%% output
%name_for_output
outputFile='modified';                   %����ĵ���
mkdir(outputFile);
filePath=[pwd '\' outputFile];           %��ǰ·��+�������ļ����ĵ�
ncfileNameOut=['LPJ-GUESS-BLAZE_SF1_' name '_re.nc'];
VariNameOut=[name '_monthly'];
ncFilename=[filePath '\' ncfileNameOut]; %�贴��nc�ļ���ȫ·��
delete(ncFilename);                      %ɾ���Ѵ����ļ��������ظ�д��
%write
mode = 'NC_SHARE';
ncid = netcdf.create(ncFilename, mode);  %����nc�ļ�
    % modeѡ�����£�
    %  'NOCLOBBER'	  Prevent overwriting of existing file with the same name.
    % 'CLOBBER'	      Overwrite any existing file with the same name.
    % 'SHARE'	      Allow synchronous file updates.
    % '64BIT_OFFSET'  Allow easier creation of files and variables which are larger than two gigabytes.
    % 'NETCDF4'	      Create a NetCDF-4/HDF5 file
    % 'CLASSIC_MODEL' Enforce the classic model; has no effect unless used in a bitwise-or with NETCDF4er creation of files and variables which are larger than two gigabytes.
%����Dimension��dimids��
ntime=length(TimeData);
nlat=length(LatData);
nlon=length(LonData);
dimidx = netcdf.defDim(ncid,'time',netcdf.getConstant('NC_UNLIMITED'));    %unlimited
dimidy = netcdf.defDim(ncid,'lat',nlat);
dimidz = netcdf.defDim(ncid,'lon',nlon);
%����Varible��VariNameOut��
xtype = 'NC_DOUBLE';
varid1 = netcdf.defVar(ncid,VariNameOut,'NC_FLOAT',[dimidz dimidy dimidx]);%nc��matla��˳���Ƿ��ģ�����ȡ��ͼƬ����˳ʱ����ת90��
varid2 = netcdf.defVar(ncid,'time',xtype,dimidx);
varid3 = netcdf.defVar(ncid,'lat',xtype,dimidy);
varid4 = netcdf.defVar(ncid,'lon',xtype,dimidz);
    % xtypeѡ�����£�
    %  'NC_BYTE'	int8 or uint8[a]
    %  'NC_CHAR'	char
    %  'NC_SHORT'	int16
    %  'NC_INT'	    int32
    %  'NC_INT64'   int64
    %  'NC_FLOAT'	single
    %  'NC_DOUBLE'	double
    %  'NC_UBYTE'   uint8
    %  'NC_USHORT'  uint16
    %  'NC_UINT'    uint32
    %  'NC_UINT64'  uint64
netcdf.endDef(ncid);                     %���netCDF�ļ�����ģʽ
%������д��netcdf���ļ��У�netcdf.putVar(ncid,varid,start,count,stride,data) (stride���Բ���)
netcdf.putVar(ncid,varid1,[0 0 0],[nlon nlat ntime],rot90(VariData,-1));   %�ӵ�һ������0����ʼ�洢����nlon*nlat*ntime��
netcdf.putVar(ncid,varid2,0,length(TimeData),TimeData);                    %��Ϊ��������һά��unlimited
% netcdf.putVar(ncid,varid1,VariData);
% netcdf.putVar(ncid,varid2,TimeData);
netcdf.putVar(ncid,varid3,LatData);
netcdf.putVar(ncid,varid4,LonData);
% Re-enter define mode.
netcdf.reDef(ncid);
%����Attribute(attr)����Ҫ��putVar���棨����copy��put�����÷���
    %vari
    varid = netcdf.inqVarID(ncidIn,VariNameIn);
    netcdf.copyAtt(ncidIn,varid,'units',ncid,varid1);
    netcdf.copyAtt(ncidIn,varid,'_FillValue',ncid,varid1);
    netcdf.copyAtt(ncidIn,varid,'long_name',ncid,varid1);
    %time
    netcdf.putAtt(ncid,varid2,'units','months since 1950-01-01');
    netcdf.putAtt(ncid,varid2,'long_name','time');
    %lat
    netcdf.putAtt(ncid,varid3,'units','degrees_north');
    netcdf.putAtt(ncid,varid3,'long_name','lat');
    %lon
    netcdf.putAtt(ncid,varid4,'units','degrees_east');
    netcdf.putAtt(ncid,varid4,'long_name','lon');
%close
netcdf.close(ncid); 
netcdf.close(ncidIn);                        %�ر�nc�ļ�
%% ����
%��setTest���㣬����м���
%��������Ǹ��ļ����ֶ��޸�
setTest=1;
if setTest
    val_setTest=exist(ncFilename, 'file'); %�ļ��Ƿ����
    if val_setTest==2 
        nc_content=dir(ncFilename);            %�ļ���С��Ϊ0
        if nc_content.bytes~=0
            ok='�ɹ�';
        else
            ok='ʧ��';
        end
    else
        ok='ʧ��';
    end
    display(strcat(name,'�ļ�����',ok));
end

