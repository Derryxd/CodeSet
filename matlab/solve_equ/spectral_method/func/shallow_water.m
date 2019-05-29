function deuvt=shallow_water(t,euvt,dummy,kX,kY,N,g)
et=euvt(1:N^2);
ut=euvt(N^2+[1:N^2]);
vt=euvt(2*N^2+[1:N^2]);
et=reshape(et,N,N);ut=reshape(ut,N,N);vt=reshape(vt,N,N);
e=ifft2(et);u=ifft2(ut);v=ifft2(vt);
deuvt=[reshape(-1i*kX.*fft2(e.*u)-1i*kY.*fft2(e.*v),N^2,1);
    reshape(-fft2(v.*ifft2(1i*kY.*ut)+u.*ifft2(1i*kX.*ut))-g*1i*kX.*et,N^2,1);
    reshape(-fft2(v.*ifft2(1i*kX.*vt)+u.*ifft2(1i*kY.*vt))-g*1i*kY.*et,N^2,1)];
