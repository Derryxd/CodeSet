%% 读取文件及参数设置
clear;clc;
tic
info=geotiffinfo('MOD17A3_Science_GPP_2000.tif');     % 查看信息
A=geotiffread('MOD17A3_Science_GPP_2000.tif');
toc
% %Elapsed time is 10.132633 seconds.
lon=(1:360)*(2*pi/360);     %弧度表示
lat=(-59:80)*(pi/180);    
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
D=uint16(C);
toc
%Elapsed time is 4.254600 seconds.
%% 生成相应nc文件
toc
nccreate('2000_gpp.nc','gpp','Datatype','uint16', ...                %数据类型
                          'Dimensions',{'lat',140,'lon',360},...     %维数设置
                          'Format','netcdf4')                %文件类型
ncwrite('2000_gpp.nc','gpp',D);
nccreate('2000_gpp.nc','lat','Datatype','double', ...                %数据类型
                          'Dimensions',{'lat',140})                  %文件类型
ncwrite('2000_gpp.nc','lat',-59:80);
ncwriteatt('2000_gpp.nc','lat','units','degrees_north');
nccreate('2000_gpp.nc','lon','Datatype','double', ...                %数据类型
                          'Dimensions',{'lon',360})                  %文件类型
ncwrite('2000_gpp.nc','lon',-179:180);
ncwriteatt('2000_gpp.nc','lon','units','degrees_east');
tic
%Elapsed time is 4.253834 seconds.
%总共花时间约20s
%% 画图
% figure
% imshow(A)
% figure
% imshow(D)


