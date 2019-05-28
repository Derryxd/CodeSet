program step_by_step_regress
implicit none
integer,parameter ::m=3
integer,parameter ::n=21
integer,parameter ::ncycle=2
real,parameter ::f0=4.0
integer ::ki(m)
real ::x_0(n,m-1)
real ::y(n)

real ::x(n,m)
real ::ave_x(m),s(m)
real ::cov
real ::r(m,m),r2(m,m),sxx(m,m)
integer ::numb=0
integer ::flag1,kint,kout
real ::b0,b(m-1)
real ::syy,sy,rxy
integer ::i,j,t

open(1,file='data.dat')
do t=1,n
read(1,*) (x_0(t,j),j=1,m-1),y(t)
enddo
close(1)
x(:,1:m-1)=x_0
x(:,m)=y
s=0

do j=1,m
ave_x(j)=sum(x(:,j))/n
do t=1,n
s(j)=s(j)+(x(t,j)-ave_x(j))**2
enddo
s(j)=sqrt(s(j))
enddo

do i=1,m-1
do j=1,m-1
!r(i,j)=cov(x(:,i),x(:,j),n)/(s(i)*s(j))
sxx(i,j)=cov(x(:,i),x(:,j),n)
enddo
enddo
do i=1,m-1
sxx(i,m)=cov(x(:,i),y(:),n)
sxx(m,i)=cov(x(:,i),y(:),n)
sxx(m,m)=cov(y,y,n)
enddo

ki=0
do i=1,ncycle
!call input(r,m,n,kint,numb,ki,f0)
call input(sxx,m,n,kint,numb,ki,f0)
ki(i)=kint
if (kint.ne.0) then
print*,'第',i,'步变换后的系数矩阵'
!call transform(r,m,ki(i))
call transform(sxx,m,ki(i))
endif
if (numb.gt.2)then
flag1=2
do while(flag1.eq.0)
!call output(r,m,n,ki,numb,flag1,kout,f0)
call output(sxx,m,n,ki,numb,flag1,kout,f0)
if (flag1.eq.0) then
!call transform(r,m,kout)
call transform(sxx,m,kout)
ki(numb)=0
numb=numb-1
endif
enddo
endif
enddo
print*,'回归方程的各因子系数为'
b0=ave_x(m)
do i=1,numb
!b(i)=s(m)/s(ki(i))*r(ki(i),m)
b(i)=sxx(ki(i),m)
write(*,'(1x,A1,I1,F9. 3)')'x',ki(i),b(i)
b0=b0-b(i)*ave_x(ki(i))
enddo
print *,'b0',b0
syy=s(m)**2
!sy=syy*sqrt(r(m,m)/(n-numb-1))/n
!rxy=sqrt(1-r(m,m))
!sy=syy*sqrt(sxx(m,m)/(n-numb-1))/n
!rxy=sqrt(1-sxx(m,m))
!print *,'回归方程的负相关系数和剩余标准差'
!print *,'Sy',sy
!print *,'Syy',syy
!print *,'Rxy',rxy
end program step_by_step_regress


!subroutine input (r,m,n,kint,numb,ki,f0)
subroutine input (sxx,m,n,kint,numb,ki,f0)
implicit none
integer ::m,n
!real ::r(m,m)
real ::sxx(m,m)
real ::v(m)
integer ::ki(m),kint
integer ::flag0
real ::max_v
real ::f,f0
integer ::numb,i,j
f=0
max_v=0
flag0=1
do i=1,m-1
!v(i)=r(i,m)**2/r(i,i)
v(i)=sxx(i,m)**2/sxx(i,i)
print *,'v',i,'=',v(i)
do j=1,numb
if(i.eq.ki(j)) flag0=0
enddo
if (flag0.eq.0) then
flag0=1
cycle
endif
if (v(i).gt.max_v) then
max_v=v(i)
kint=i
!f=v(kint)/(r(m,m)-v(kint))*(n-2)
f=v(kint)/(sxx(m,m)-v(kint))*(n-2)
print *,'f=',f
endif
enddo
if(f.gt.f0) then
numb=numb+1
print *,'第',numb,'个选中的因子是第',kint,'个因子'
else
print *,'没有可以引入的因子'
kint=0
endif
end subroutine input


!subroutine transform(r,m,kint)
subroutine transform(sxx,m,kint)
implicit none
integer ::m
!real ::r(m,m),r2(m,m)
real ::sxx(m,m),r2(m,m)
integer ::kint
integer ::i,j
do i=1,m
do j=1,m
if (i==kint.and.j==kint) then
!r2(i,j)=1/r(kint,kint)
r2(i,j)=1/sxx(kint,kint)
elseif (i==kint) then
!r2(i,j)=r(i,j)/r(kint,kint)
r2(i,j)=sxx(i,j)/sxx(kint,kint)
elseif (j==kint) then
!r2(i,j)=-r(i,j)/r(kint,kint)
r2(i,j)=-sxx(i,j)/sxx(kint,kint)
elseif(i.ne.kint.and.j.ne.kint) then
!r2(i,j)=r(i,j)-(r(i,kint)*r(kint,j))/r(kint,kint)
r2(i,j)=sxx(i,j)-(sxx(i,kint)*sxx(kint,j))/sxx(kint,kint)
endif
enddo
enddo
do i=1,m
print *,(r2(i,j),j=1,m)
enddo
!r=r2
sxx=r2
end subroutine transform


!subroutine output(r,m,n,ki,numb,flag1,kout,f0)
subroutine output(sxx,m,n,ki,numb,flag1,kout,f0)
implicit none
integer ::m,n
!real ::r(m,m)
real ::sxx(m,m)
real ::v(m)
integer ::ki(m)
real ::f,f0
real ::min_v
integer ::kout,flag1
integer ::i,numb
min_v=1000000.0
do i=1,numb
!v(ki(i))=r(ki(i),m)**2/r(ki(i),ki(i))
v(ki(i))=sxx(ki(i),m)**2/sxx(ki(i),ki(i))
if (v(ki(i)).lt.min_v) then
min_v=v(ki(i))
kout=ki(i)
endif
enddo
!f=v(kout)/r(m,m)*(n-numb-1)
f=v(kout)/sxx(m,m)*(n-numb-1)
if (f.gt.f0) then
flag1=1
print *,'因子全部通过检验，没有剔除'
else
flag1=0
print *,'没有通过检验的是第',kout,'个因子'
endif
end subroutine output

real function cov(x,y,n)
integer ::n
real ::x(n),y(n)
real ::ave_x,ave_y
real ::k
ave_x=sum(x)/n
ave_y=sum(y)/n
cov=0
do k=1,n
cov=cov+(x(k)-ave_x)*(y(k)-ave_y)
enddo
end function cov