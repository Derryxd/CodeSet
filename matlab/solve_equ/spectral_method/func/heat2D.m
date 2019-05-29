function du=heat2D(t,u,dummy,N,D2,BCx,BCy)
% (u+a*(Dx)u)=0|(x=1)
% (Dx)u|(x=-1)=(Dy)u|(|y|=1)=0
%等价条件并交换偏导顺序，有
% ((Dt)u+a*(Dt(Dx))u)=0|(x=1)
% (Dx(Dt))u|(x=-1)=(Dy(Dt))u|(|y|=1)=0
u=reshape(u,N+1,N+1);
du=D2*u+u*D2';
du([1 N+1],:)=BCy*du(2:N,:);
du(:,[1 N+1])=du(:,2:N)*BCx';
du=du(:);