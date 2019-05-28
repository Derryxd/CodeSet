!M      整型变量， 输入参数，x轴上的分点个数 
!N      整型变量， 输入参数，y轴上的分点个数 
!X1A    M个元素的一维实型数组，输入参数，存放x轴上的M个分点 
!X2A    N个元素的一维实型数组，输入参数，存放y轴上的N个分点 
!X1     实型变量， 输入参数，插值变量的第一个分量 
!X2     实型变量， 输入参数，插值变量的第二个分量 
!YA     M*N个元素的二维实型数组，输入参数，函数在插值节点上的函数值 
!Y      实型变量， 输出参数，插值结果 
!DY     实型变量， 输出参数，精度估计 

SUBROUTINE polin2(x1a,x2a,ya,m,n,x1,x2,y,dy) 
INTEGER m,n,NMAX,MMAX 
REAL dy,x1,x2,y,x1a(m),x2a(n),ya(m,n) 
PARAMETER (NMAX=20,MMAX=20) 
!USES polint 
INTEGER j,k 
REAL ymtmp(MMAX),yntmp(NMAX) 
do j=1,m 
 do k=1,n 
   yntmp(k)=ya(j,k) 
 end do 
 call polint(x2a,yntmp,n,x2,ymtmp(j),dy) 
end do 
call polint(x1a,ymtmp,m,x1,y,dy) 
END SUBROUTINE polin2 


SUBROUTINE polint(xa,ya,n,x,y,dy) 
INTEGER n,NMAX 
REAL dy,x,y,xa(n),ya(n) 
PARAMETER (NMAX=10) 
INTEGER i,m,ns 
REAL den,dif,dift,ho,hp,w,c(NMAX),d(NMAX) 
ns=1 
dif=abs(x-xa(1)) 
do i=1,n 
 dift=abs(x-xa(i)) 
 if (dift<dif) then 
   ns=i 
   dif=dift 
 endif 
 c(i)=ya(i) 
 d(i)=ya(i) 
end do 
y=ya(ns) 
ns=ns-1 
do m=1,n-1 
 do i=1,n-m 
   ho=xa(i)-x 
   hp=xa(i+m)-x 
   w=c(i+1)-d(i) 
   den=ho-hp 
   if(den==0.) pause 'failure in polint' 
   den=w/den 
   d(i)=hp*den 
   c(i)=ho*den 
 end do 
 if (2*ns<n-m) then 
   dy=c(ns+1) 
 else 
   dy=d(ns) 
   ns=ns-1 
 endif 
 y=y+dy 
end do 
END SUBROUTINE polint 