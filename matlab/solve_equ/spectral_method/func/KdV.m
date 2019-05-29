function dut=KdV(t,ut,dummy,k)
u=ifft(ut);
du=(i*k).*ut-12*fft(u.*ifft(i*k.*ut))-(i*k).^3.*ut;
