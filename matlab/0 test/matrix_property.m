a=diag([3,2,4])+randn(3);
% a=a-mean(a,2);
[u,s,v]=svd(a);
[iv,ig]=eig(a);
[aa1,bb1]=eig(a*a');
[aa2,bb2]=eig(a*a);
% s==sqrt(bb1)
% ig==sqrt(bb2)