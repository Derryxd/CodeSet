function du=heat2(t,u,dummy,N,D2)
%(Dt)u=0                 |x|=1,|y|=1
%u=1-sqrt((x-1)^2+y^2);  (x-1)^2+y^2<=1,t=0
%u=0;                    (x-1)^2+y^2>1 ,t=0
u=reshape(u,N+1,N+1);
du=D2*u+u*D2';
du([1 N+1],:)=0;du(:,[1 N+1])=0;
du=du(:);