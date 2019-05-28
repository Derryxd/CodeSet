%% ��ȡ�ļ�����������
clear;clc;
tic
info=geotiffinfo('MOD17A3_Science_GPP_2000.tif');     % �鿴��Ϣ
A=geotiffread('MOD17A3_Science_GPP_2000.tif');
toc
% %Elapsed time is 10.132633 seconds.
lon=(1:360)*(2*pi/360);     %���ȱ�ʾ
lat=(-59:80)*(pi/180);    
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
D=uint16(C);
toc
%Elapsed time is 4.254600 seconds.
%% ������Ӧnc�ļ�
toc
nccreate('2000_gpp.nc','gpp','Datatype','uint16', ...                %��������
                          'Dimensions',{'lat',140,'lon',360},...     %ά������
                          'Format','netcdf4')                %�ļ�����
ncwrite('2000_gpp.nc','gpp',D);
nccreate('2000_gpp.nc','lat','Datatype','double', ...                %��������
                          'Dimensions',{'lat',140})                  %�ļ�����
ncwrite('2000_gpp.nc','lat',-59:80);
ncwriteatt('2000_gpp.nc','lat','units','degrees_north');
nccreate('2000_gpp.nc','lon','Datatype','double', ...                %��������
                          'Dimensions',{'lon',360})                  %�ļ�����
ncwrite('2000_gpp.nc','lon',-179:180);
ncwriteatt('2000_gpp.nc','lon','units','degrees_east');
tic
%Elapsed time is 4.253834 seconds.
%�ܹ���ʱ��Լ20s
%% ��ͼ
% figure
% imshow(A)
% figure
% imshow(D)


