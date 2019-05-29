function [D,x]=cheb(N)
if N==0,D=0;x=1;return,end
%计算Dij，而在c中的2为D0、Dn
x=cos(pi*(0:N)/N)';             %契比雪夫点的坐标是由大到小排列的，如-1~1，则x(N)=-1
c=[2;ones(N-1,1);2].*(-1).^(0:N)';
X=repmat(x,1,N+1);
dX=X-X';                        %等于xi-xj
%契比雪夫求导矩阵
D=(c*(1./c)')./(dX+(eye(N+1))); %防止分母为0
D=D-diag(sum(D'));              %sum(A):对A的每一列求和
%该脚本的求导矩阵并非严格按照公式计算，对角线上的元素是由对角线以外的元素所得：
%D每行之和为0