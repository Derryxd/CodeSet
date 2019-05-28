C=zeros(nlat,nlon);
A=mat2gray(A);                                                                 %��һ��
A(A==1)=nan;                                                                   %��ֵΪ1�ĵط�����Ϊȱʧ
for xi=1:nlat
    for yi=1:nlon
        B=A(num*xi-num+1:num*xi, num*yi-num+1:num*yi);                         %��ȡ�ͷֱ��������Ӧ�ĸ߷ֱ����
        nan_matrix=~isnan(B);
        arc_lat=lat(xi):delta:lat(xi+1);
        area=10^5.*(180/x).*(360/y).*cos((arc_lat(1:end-1)+arc_lat(2:end))/2); %���ݾ�γ�����ɸ������Ĺ�ʽ
        area_weight=repmat(area',[1 num]).*nan_matrix;
        area_sum=nansum(nansum(area_weight));
        C(xi,yi)=nansum(nansum(B.*area_weight))/area_sum;
    end
end
D=C;D(isnan(D))=1;   