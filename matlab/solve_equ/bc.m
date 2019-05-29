function bcv=bc(ua,ub)
%% boundary condition
%例子说明
%ua(1)、ua(2)为函数在左边界的取值和一阶导数，ua(1)-1代表u1(0)=1
%ub(1)、ub(2)为函数在右边界的取值和一阶导数,ub(1)+1-pi/exp(pi)代表u1(pi)=pi/exp(pi)-1
%the code:
bcv=[ ua(1)-1 ; ub(1)+1-pi/exp(pi) ] ;
