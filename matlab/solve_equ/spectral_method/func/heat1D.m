function du=heat1D(t,u,dummy,N,D2,BC)
%(Dx)u=0|(x=+-1)等价为(Dt(Dx))u=0|(x=+-1)和(Dx)u=0|(x=+-1、t=0)
%因为偏导连续，再交换顺序为(Dx(Dt))u=0|(x=+-1)
du=D2*u;
du([1 N+1])=BC*du(2:N);   %(Dx(Dt))u=0|(x=+-1)