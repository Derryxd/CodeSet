function duvt=wave1D(t,uvt,dummy,N,k,a)
ut=uvt(1:N);
vt=uvt(N+[1:N]);
b=k.^2;
duvt=[vt;(ut.*b)];
%-a^2*
