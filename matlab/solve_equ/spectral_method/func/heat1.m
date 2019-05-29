function du=heat1(t,u,dummy,N,D2)
u=reshape(u,N-1,N-1);
du=reshape(D2*u+u*D2',(N-1)^2,1);
