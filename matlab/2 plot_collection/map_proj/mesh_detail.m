x=-8:.5:8;y=-7:0.5:8;
[a,b]=meshgrid(x,y);    %������һ������
c=sqrt(a.^2+b.^2)+eps;
z=sin(c)./c;
mesh(a,b,z)
xlabel('a')
% axis square
ss=size(z)