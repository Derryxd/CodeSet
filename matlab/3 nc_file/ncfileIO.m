clc,clear;
%% input
%name_for_input
name='gpp';      %需要改的东西
ncfileNameIn=['LPJ-GUESS-BLAZE_SF1_' name '.nc'];
VariNameIn=[name '.monthly'];
%open
ncidIn = netcdf.open(ncfileNameIn,'NOWRITE');  %打开nc文件
info=ncinfo(ncfileNameIn);                   %以结构体的数据类型存储nc文件的信息
%read
VariData  = ncread(ncfileNameIn,VariNameIn); %读入变量gpp
LonData  = ncread(ncfileNameIn,'lon');       %读入变量lon
LatData  = ncread(ncfileNameIn,'lat');       %读入变量lat
TimeData  = ncread(ncfileNameIn,'time');     %读入变量time
%% output
%name_for_output
outputFile='modified';                   %存放文档名
mkdir(outputFile);
filePath=[pwd '\' outputFile];           %当前路径+存放输出文件的文档
ncfileNameOut=['LPJ-GUESS-BLAZE_SF1_' name '_re.nc'];
VariNameOut=[name '_monthly'];
ncFilename=[filePath '\' ncfileNameOut]; %需创建nc文件的全路径
delete(ncFilename);                      %删除已存在文件，以免重复写入
%write
mode = 'NC_SHARE';
ncid = netcdf.create(ncFilename, mode);  %创建nc文件
    % mode选项如下：
    %  'NC_NOCLOBBER'： Prevent overwriting of existing file with the same name.
    %  'NC_SHARE'： Allow synchronous file updates.
    %  'NC_64BIT_OFFSET'： Allow easier creation of files and variables which are larger than two gigabytes.
%定义Dimension（dimids）
ntime=length(TimeData);
nlat=length(LatData);
nlon=length(LonData);
dimidx = netcdf.defDim(ncid,'time',netcdf.getConstant('NC_UNLIMITED'));    %unlimited
dimidy = netcdf.defDim(ncid,'lat',nlat);
dimidz = netcdf.defDim(ncid,'lon',nlon);
%定义Varible（VariNameOut）
xtype = 'NC_DOUBLE';
varid1 = netcdf.defVar(ncid,VariNameOut,'NC_FLOAT',[dimidz dimidy dimidx]);  %nc和matla的顺序是反的
varid2 = netcdf.defVar(ncid,'time',xtype,dimidx);
varid3 = netcdf.defVar(ncid,'lat',xtype,dimidy);
varid4 = netcdf.defVar(ncid,'lon',xtype,dimidz);
    % xtype选项如下：
    %  'NC_BYTE'	int8 or uint8[a]
    %  'NC_CHAR'	char
    %  'NC_SHORT'	int16
    %  'NC_INT'	    int32
    %  'NC_FLOAT'	single
    %  'NC_DOUBLE'	double
netcdf.endDef(ncid);                     %完成netCDF文件定义模式
%把数据写到netcdf的文件中：netcdf.putVar(ncid,varid,start,count,stride,data) (stride可以不设)
netcdf.putVar(ncid,varid1,[0 0 0],[nlon nlat ntime],VariData); %从第一个数（0）开始存储，共nlon*nlat*ntime个
netcdf.putVar(ncid,varid2,0,length(TimeData),TimeData);        %因为变量中有一维是unlimited
% netcdf.putVar(ncid,varid1,VariData);
% netcdf.putVar(ncid,varid2,TimeData);
netcdf.putVar(ncid,varid3,LatData);
netcdf.putVar(ncid,varid4,LonData);
% Re-enter define mode.
netcdf.reDef(ncid);
%定义Attribute(attr)：需要在putVar后面（尝试copy和put两种用法）
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
netcdf.close(ncidIn);                        %关闭nc文件
%% 检验
%若setTest非零，则进行检验
%具体检验那个文件需手动修改
setTest=1;
if setTest
    val_setTest=exist(ncFilename, 'file'); %文件是否存在
    if val_setTest==2 
        nc_content=dir(ncFilename);            %文件大小不为0
        if nc_content.bytes~=0
            ok='成功';
        else
            ok='失败';
        end
    else
        ok='失败';
    end
    display(strcat(name,'文件生成',ok));
end

