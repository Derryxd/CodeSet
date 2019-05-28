
clear;clf;clc;
tic
lat=linspace(-90,90,181);
lon=linspace(0,360,361);
llat=repmat(lat',[1 361]);  % 'Ϊת�õ���˼
llon=repmat(lon ,[181 1]);
%% shp
cnmap=shaperead('ALL.shp'); %��ά�ṹ��
%taiwan����һά�ṹ������
alon=cnmap(1,1).X;
alat=cnmap(1,1).Y;
%all���ڶ�λ�ṹ������
blon=cnmap(2,1).X;
blat=cnmap(2,1).Y;
%% deal
[in,on] = inpolygon(llon,llat,blon,blat);
%[in,on] = inpolygon(xq,yq,xv,yv);
[x,y]=find(in==1);    % find location of points inside
mg=zeros(4,size(x,1));
mg(1,:)=x;        %nlat
mg(2,:)=y;        %nlon
mg(3,:)=lat(x);   %lat
mg(4,:)=lon(y);   %lon
%% plot
figure(1)
shp_map=geoshow('ALL.shp');
figure(2)
taiwan=geoshow(alat,alon);
figure(3)
all=geoshow(blat,blon);
figure(4)
judge_map=plot(llon(in),llat(in),'r+'); 
%plot(xq(in),yq(in),'r+') % points inside
toc
%Elapsed time is 29.210647 seconds.
%% outcome to nc file
%name_for_output
ncFilename='mg.nc';                      %�贴��nc�ļ���ȫ·��
delete(ncFilename);                      %ɾ���Ѵ����ļ��������ظ�д��
mode = 'NC_SHARE';
ncid = netcdf.create(ncFilename, mode);  %����nc�ļ�
%����Dimension��dimids��
dimid0 = netcdf.defDim(ncid,'id'   ,size(mg,1));
dimid1 = netcdf.defDim(ncid,'value',size(mg,2));
dimidlat = netcdf.defDim(ncid,'lat',length(lat));
dimidlon = netcdf.defDim(ncid,'lon',length(lon));
%����Varible��VariNameOut��
xtype = 'NC_DOUBLE';
varid1 = netcdf.defVar(ncid,'mg' ,'NC_FLOAT',[dimid1 dimid0]);  %matlab��ncl��˳���෴
varid2 = netcdf.defVar(ncid,'lat',xtype,dimidlat);
varid3 = netcdf.defVar(ncid,'lon',xtype,dimidlon);
netcdf.endDef(ncid);                    %���netCDF�ļ�����ģʽ
%������д��netcdf���ļ��У�netcdf.putVar(ncid,varid,start,count,stride,data) 
netcdf.putVar(ncid,varid1,mg');         %��Ϊ˳���෴������Ҫת��
netcdf.putVar(ncid,varid2,lat);
netcdf.putVar(ncid,varid3,lon);
%close
netcdf.close(ncid); 
