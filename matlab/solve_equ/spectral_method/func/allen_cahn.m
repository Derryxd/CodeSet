function du=allen_cahn(t,u,dummy,D2,epsilon)
du=epsilon*D2*u+u-u.^3;
du([1 end])=0;
