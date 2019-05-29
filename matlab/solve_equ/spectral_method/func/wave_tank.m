function duv=wave_tank(t,uv,dummy,Nx,Ny,D2x,D2y,BCy)
%引入v=(Dt)u，将高阶方程转为为一阶方程组
%并处理(Dy)u为(Dt(Dy))u，交换顺序后则为(Dy)v
u=reshape(uv(1:end/2),Ny+1,Nx);
v=reshape(uv(end/2+1:end),Ny+1,Nx);
v([1 Ny+1],:)=BCy*v(2:Ny,:);
duv=[v(:); reshape(u*D2x'+D2y*u,Nx*(Ny+1),1)];