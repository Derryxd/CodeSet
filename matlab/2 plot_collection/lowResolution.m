%% ���ɵͷֱ�ͼ
%���������Ȩ�����߷ֱ��ͼת��Ϊ�ͷֱ��ͼ
% Code by Derry Liu, 6 Apr 2017
lon=(0:720)*(2*pi/720);
lat=(-180:180)*(pi/360);
deta=pi/21600;
temp_num=1:60;
[x,y]=size(DATA(1).A);
for i=1:num
    %% ���ͷֱ���
    %��һ��21600*43200��ͼ��ֳ�360*720��ͼ���
    %��ÿһ�麬��60*60�����ݣ�����ʱ�������һ����
    %     area=1;
    %     tic
    %     A=DATA(i).A*area;                                           %���
    %     n=360;m=720;
    %     [x,y]=size(A);
    %     block_n=x/n*ones(1,n);%block_n=[360,360,...,360];
    %     block_m=y/m*ones(1,m);
    %     B=mat2cell(A,block_n,block_m);
    %     D=cellfun(@sum,cellfun(@sum,B,'UniformOutput',false));       %MATLAB�Դ����㺯��
    %     toc
    %Elapsed time is 20.248076 seconds.
    %%�õڶ��ּ��㷽�����ٶ�����
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
    %%����
    % isequal(C,D)
    % % ans=1, C==D
    % imshow(D,[0 255])
    %% ������Ӧnc�ļ���tifͼ
    ncfilename(i,:) = strcat(num2str(k(i)),'_re.nc');          %�贴��nc�ļ�������
    tiffilename(i,:) = strcat(num2str(k(i)),'_re.tif');        %�贴��tifͼ������
    mode = 'NC_NOCLOBBER';
    ncid = netcdf.create(ncfilename(i,:), mode);               %����nc�ļ�
    %����Dimension��dimids��
    dimidy = netcdf.defDim(ncid,'lat',size(C,1));
    dimidx = netcdf.defDim(ncid,'lon',size(C,2));
    %����Varible��varname��
    varname = 'NDVI';
    xtype = 'NC_FLOAT';
    varid = netcdf.defVar(ncid,varname,xtype,[dimidy dimidx]);  %nc�ļ����⵽�ڴ���
    netcdf.endDef(ncid);                                        %���netCDF�ļ�����ģʽ
    %��������ļ�
    netcdf.putVar(ncid,varid,C);
    netcdf.close(ncid);                                         %�ر��ļ�
    imshow(C,[0 255])                                           %��ͼƬ
    print(gcf,'-dtiffn',tiffilename)                            %����tifͼ
    close all                                                   %�ر�ͼƬ
end