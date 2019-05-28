C=zeros(nlat,nlon);
A=mat2gray(A);                                                                 %归一化
A(A==1)=nan;                                                                   %把值为1的地方定义为缺失
for xi=1:nlat
    for yi=1:nlon
        B=A(num*xi-num+1:num*xi, num*yi-num+1:num*yi);                         %截取低分辨粗网格相应的高分辨矩阵
        nan_matrix=~isnan(B);
        arc_lat=lat(xi):delta:lat(xi+1);
        area=10^5.*(180/x).*(360/y).*cos((arc_lat(1:end-1)+arc_lat(2:end))/2); %根据经纬度生成格点面积的公式
        area_weight=repmat(area',[1 num]).*nan_matrix;
        area_sum=nansum(nansum(area_weight));
        C(xi,yi)=nansum(nansum(B.*area_weight))/area_sum;
    end
end
D=C;D(isnan(D))=1;   