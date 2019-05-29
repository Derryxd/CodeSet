function dut=burgers(t,ut,dummy,N,kX,kY,K2,v)
ut=reshape(ut,N,N);
u=iff2(ut);
dut=reshape(-v*K2.*ut-fft2(u.*ifft2(i*(kX+kY).*ut)),N^2,1);
