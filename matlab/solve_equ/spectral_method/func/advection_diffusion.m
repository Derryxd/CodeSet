function dw=advection_diffusion(t,w,dummy,N,D,D2,K2,v)
w=reshape(w,N,N);wt=fft2(w);
psi=ifft2(wt./(-K2));
dw=reshape(v*(D2*w+w*D2')-(psi*D').*(D*w)+(D*psi).*(w*D'),N^2,1);







