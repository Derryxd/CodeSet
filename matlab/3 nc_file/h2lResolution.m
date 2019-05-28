%% 读取文件及参数设置
clear;clc;clf;
tic
info=geotiffinfo('MOD17A3_Science_GPP_2000.tif');     % 查看信息
A=geotiffread('MOD17A3_Science_GPP_2000.tif');
toc
% %Elapsed time is 10.132633 seconds.
lon=(0:360)*(2*pi/360);     %弧度表示
lat=(-60:80)*(pi/180);    
delta=pi/21600;             %原图分辨率（180度含有的格点数）
num= 120; temp_num=1:120;
nlat=140; nlon=360;
[x,y]=size(A);
%% 降低分辨率
%将一幅16800*43200的图像分成140*360的图像块
%即每一块含有120*120个数据
tic
C=zeros(nlat,nlon);
for xi=1:nlat
    for yi=1:nlon
        B=A(num*xi-num+1:num*xi, num*yi-num+1:num*yi);                         %截取低分辨粗网格相应的高分辨矩阵
        arc_lat=lat(xi):delta:lat(xi+1);
        area=10^5.*(180/x).*(360/y).*cos((arc_lat(1:end-1)+arc_lat(2:end))/2); %根据经纬度生成格点面积的公式
        area_weight=repmat(area',[1 num]);
        area_sum=sum(sum(area_weight));
        C(xi,yi)=sum(sum(double(B).*area_weight))/area_sum;
    end
end
D=mat2gray(uint16(C));
% D=uint16(C);
toc
%Elapsed time is 4.254600 seconds.
%% 生成相应nc文件
toc
ncFilename='gpp2_2000.nc';                %需创建nc文件的全路径
delete(ncFilename);                      %删除已存在文件，以免重复写入
%write
% mode = 'NOCLOBBER';
mode = 'NETCDF4';
ncid = netcdf.create(ncFilename, mode);  %创建nc文件
%定义Dimension（dimids）
nlat=length(lat(2:end));
nlon=length(lon(2:end));
dimidx = netcdf.defDim(ncid,'lat',nlat);
dimidy = netcdf.defDim(ncid,'lon',nlon);
%定义Varible（VariNameOut）
xtype = 'NC_DOUBLE';
% varid1 = netcdf.defVar(ncid,'gpp',xtype,[dimidy dimidx]);  %ncl和matla的顺序是反的
varid1 = netcdf.defVar(ncid,'gpp','NC_USHORT',[dimidy dimidx]);  %ncl和matla的顺序是反的
varid2 = netcdf.defVar(ncid,'lat',xtype,dimidx);
varid3 = netcdf.defVar(ncid,'lon',xtype,dimidy);
netcdf.endDef(ncid);                     %完成netCDF文件定义模式
%把数据写到netcdf的文件中：netcdf.putVar(ncid,varid,start,count,stride,data) 
netcdf.putVar(ncid,varid1,D');           %转置后保存
netcdf.putVar(ncid,varid2,-59:80);       %纬度为-59:80
netcdf.putVar(ncid,varid3,-179:180);     %经度为-179:180
% Re-enter define mode.
netcdf.reDef(ncid);
%定义Attribute(attr)：
%lat
netcdf.putAtt(ncid,varid2,'units','degrees_north');
netcdf.putAtt(ncid,varid2,'long_name','lat');
%lon
netcdf.putAtt(ncid,varid3,'units','degrees_east');
netcdf.putAtt(ncid,varid3,'long_name','lon');
%close
netcdf.close(ncid);
tic
%Elapsed time is 4.253834 seconds.
%总共花时间约20s
%% 画图
figure
imshow(A)
figure
imshow(D)


