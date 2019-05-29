function duvt=wave2D(t,uvt,dummy,N,K2,a)
ut=uvt(1:N^2);
vt=uvt(N^2+[1:N^2]);
duvt=[vt;-a^2*K2.*ut];
