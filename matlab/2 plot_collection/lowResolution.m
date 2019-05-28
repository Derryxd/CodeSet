%% 生成低分辨图
%根据面积加权，将高分辨的图转化为低分辨的图
% Code by Derry Liu, 6 Apr 2017
lon=(0:720)*(2*pi/720);
lat=(-180:180)*(pi/360);
deta=pi/21600;
temp_num=1:60;
[x,y]=size(DATA(1).A);
for i=1:num
    %% 降低分辨率
    %将一幅21600*43200的图像分成360*720的图像块
    %即每一块含有60*60个数据（试验时假设面积一样）
    %     area=1;
    %     tic
    %     A=DATA(i).A*area;                                           %点乘
    %     n=360;m=720;
    %     [x,y]=size(A);
    %     block_n=x/n*ones(1,n);%block_n=[360,360,...,360];
    %     block_m=y/m*ones(1,m);
    %     B=mat2cell(A,block_n,block_m);
    %     D=cellfun(@sum,cellfun(@sum,B,'UniformOutput',false));       %MATLAB自带运算函数
    %     toc
    %Elapsed time is 20.248076 seconds.
    %%用第二种计算方法，速度略慢
    tic
    for xi=1:360
        for yi=1:720
            B=DATA(i).A(60*xi-60+1:60*xi,60*yi-60+1:60*yi);
            arc_lat=lat(xi):deta:lat(xi+1);
            area=10^5.*(180/x).*(360/y).*cos((arc_lat(1:end-1)+arc_lat(2:end))/2);
            area_weight=repmat(area',[1 60]);
            area_sum=sum(sum(area_weight));
            C(xi,yi)=sum(sum(double(B).*area_weight))/area_sum;
        end
    end
    toc
    % %Elapsed time is 25.828347 seconds.
    %%检验
    % isequal(C,D)
    % % ans=1, C==D
    % imshow(D,[0 255])
    %% 生成相应nc文件和tif图
    ncfilename(i,:) = strcat(num2str(k(i)),'_re.nc');          %需创建nc文件的名称
    tiffilename(i,:) = strcat(num2str(k(i)),'_re.tif');        %需创建tif图的名称
    mode = 'NC_NOCLOBBER';
    ncid = netcdf.create(ncfilename(i,:), mode);               %创建nc文件
    %定义Dimension（dimids）
    dimidy = netcdf.defDim(ncid,'lat',size(C,1));
    dimidx = netcdf.defDim(ncid,'lon',size(C,2));
    %定义Varible（varname）
    varname = 'NDVI';
    xtype = 'NC_FLOAT';
    varid = netcdf.defVar(ncid,varname,xtype,[dimidy dimidx]);  %nc文件从外到内储存
    netcdf.endDef(ncid);                                        %完成netCDF文件定义模式
    %生成相关文件
    netcdf.putVar(ncid,varid,C);
    netcdf.close(ncid);                                         %关闭文件
    imshow(C,[0 255])                                           %打开图片
    print(gcf,'-dtiffn',tiffilename)                            %生成tif图
    close all                                                   %关闭图片
end