%% 读取文件及参数设置
clear;clc;clf;
for i=2000:2000
tic
info=geotiffinfo(['MOD17A3_Science_GPP_' num2str(i) '.tif']);     % 查看信息
A=geotiffread(['MOD17A3_Science_GPP_' num2str(i) '.tif']);
lon=(0:360)*(2*pi/360);     %弧度表示
lat=(-60:80)*(pi/180);    
delta=pi/21600;             %原图分辨率（180度含有的格点数）
num= 120; temp_num=1:120;
nlat=140; nlon=360;
[x,y]=size(A);
%% 降低分辨率
%将一幅16800*43200的图像分成140*360的图像块
%即每一块含有120*120个数据
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
%% 生成相应nc文件
ncFilename=['gpp_' num2str(i) '.nc'];    %需创建nc文件的全路径
delete(ncFilename);                      %删除已存在文件，以免重复写入
%write
mode = 'NOCLOBBER';
ncid = netcdf.create(ncFilename, mode);  %创建nc文件
%定义Dimension（dimids）
nlat=length(lat(2:end));
nlon=length(lon(2:end));
dimidx = netcdf.defDim(ncid,'lat',nlat);
dimidy = netcdf.defDim(ncid,'lon',nlon);
%定义Varible（VariNameOut）
xtype = 'NC_DOUBLE';
varid1 = netcdf.defVar(ncid,'gpp',xtype,[dimidy dimidx]);  %ncl和matlab的顺序是反的
varid2 = netcdf.defVar(ncid,'lat',xtype,dimidx);
varid3 = netcdf.defVar(ncid,'lon',xtype,dimidy);
netcdf.endDef(ncid);                     %完成netCDF文件定义模式
%把数据写到netcdf的文件中：netcdf.putVar(ncid,varid,start,count,stride,data) 
% netcdf.putVar(ncid,varid1,rot90(D,-1));  %顺时针旋转90°
netcdf.putVar(ncid,varid1,D');
netcdf.putVar(ncid,varid2,80:-1:-59);    %纬度为80:-59
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
time=toc;
disp(['Elapsed time for ' num2str(i) 'year file is ' num2str(time) ' seconds.'])
%Elapsed time for (i)year file is 14.1468 seconds.
end
%% 画图
imshow(A)
figure
imshow(D)
%%

% C=zeros(nlat,nlon);
% A=mat2gray(A);                                                                 %归一化
% A(A==1)=nan;                                                                   %把值为1的地方定义为缺失
% for xi=1:nlat
%     for yi=1:nlon
%         B=A(num*xi-num+1:num*xi, num*yi-num+1:num*yi);                         %截取低分辨粗网格相应的高分辨矩阵
%         nan_matrix=~isnan(B);
%         arc_lat=lat(xi):delta:lat(xi+1);
%         area=10^5.*(180/x).*(360/y).*cos((arc_lat(1:end-1)+arc_lat(2:end))/2); %根据经纬度生成格点面积的公式
%         area_weight=repmat(area',[1 num]).*nan_matrix;
%         area_sum=nansum(nansum(area_weight));
%         C(xi,yi)=nansum(nansum(B.*area_weight))/area_sum;
%     end
% end
% D=C;D(isnan(D))=1;   