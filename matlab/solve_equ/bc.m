function bcv=bc(ua,ub)
%% boundary condition
%����˵��
%ua(1)��ua(2)Ϊ��������߽��ȡֵ��һ�׵�����ua(1)-1����u1(0)=1
%ub(1)��ub(2)Ϊ�������ұ߽��ȡֵ��һ�׵���,ub(1)+1-pi/exp(pi)����u1(pi)=pi/exp(pi)-1
%the code:
bcv=[ ua(1)-1 ; ub(1)+1-pi/exp(pi) ] ;
