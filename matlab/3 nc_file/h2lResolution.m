%% ��ȡ�ļ�����������
clear;clc;clf;
tic
info=geotiffinfo('MOD17A3_Science_GPP_2000.tif');     % �鿴��Ϣ
A=geotiffread('MOD17A3_Science_GPP_2000.tif');
toc
% %Elapsed time is 10.132633 seconds.
lon=(0:360)*(2*pi/360);     %���ȱ�ʾ
lat=(-60:80)*(pi/180);    
delta=pi/21600;             %ԭͼ�ֱ��ʣ�180�Ⱥ��еĸ������
num= 120; temp_num=1:120;
nlat=140; nlon=360;
[x,y]=size(A);
%% ���ͷֱ���
%��һ��16800*43200��ͼ��ֳ�140*360��ͼ���
%��ÿһ�麬��120*120������
tic
C=zeros(nlat,nlon);
for xi=1:nlat
    for yi=1:nlon
        B=A(num*xi-num+1:num*xi, num*yi-num+1:num*yi);                         %��ȡ�ͷֱ��������Ӧ�ĸ߷ֱ����
        arc_lat=lat(xi):delta:lat(xi+1);
        area=10^5.*(180/x).*(360/y).*cos((arc_lat(1:end-1)+arc_lat(2:end))/2); %���ݾ�γ�����ɸ������Ĺ�ʽ
        area_weight=repmat(area',[1 num]);
        area_sum=sum(sum(area_weight));
        C(xi,yi)=sum(sum(double(B).*area_weight))/area_sum;
    end
end
D=mat2gray(uint16(C));
% D=uint16(C);
toc
%Elapsed time is 4.254600 seconds.
%% ������Ӧnc�ļ�
toc
ncFilename='gpp2_2000.nc';                %�贴��nc�ļ���ȫ·��
delete(ncFilename);                      %ɾ���Ѵ����ļ��������ظ�д��
%write
% mode = 'NOCLOBBER';
mode = 'NETCDF4';
ncid = netcdf.create(ncFilename, mode);  %����nc�ļ�
%����Dimension��dimids��
nlat=length(lat(2:end));
nlon=length(lon(2:end));
dimidx = netcdf.defDim(ncid,'lat',nlat);
dimidy = netcdf.defDim(ncid,'lon',nlon);
%����Varible��VariNameOut��
xtype = 'NC_DOUBLE';
% varid1 = netcdf.defVar(ncid,'gpp',xtype,[dimidy dimidx]);  %ncl��matla��˳���Ƿ���
varid1 = netcdf.defVar(ncid,'gpp','NC_USHORT',[dimidy dimidx]);  %ncl��matla��˳���Ƿ���
varid2 = netcdf.defVar(ncid,'lat',xtype,dimidx);
varid3 = netcdf.defVar(ncid,'lon',xtype,dimidy);
netcdf.endDef(ncid);                     %���netCDF�ļ�����ģʽ
%������д��netcdf���ļ��У�netcdf.putVar(ncid,varid,start,count,stride,data) 
netcdf.putVar(ncid,varid1,D');           %ת�ú󱣴�
netcdf.putVar(ncid,varid2,-59:80);       %γ��Ϊ-59:80
netcdf.putVar(ncid,varid3,-179:180);     %����Ϊ-179:180
% Re-enter define mode.
netcdf.reDef(ncid);
%����Attribute(attr)��
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
%�ܹ���ʱ��Լ20s
%% ��ͼ
figure
imshow(A)
figure
imshow(D)


