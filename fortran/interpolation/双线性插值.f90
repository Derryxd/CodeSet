!������˼���Ա����Ƭ�ϣ������ο��� 
!ע����1����һ�ε���ʱ����first=.true.���Ժ������ÿ��ܻ��Լһ�����ʱ�� 
!    ��2��������NCEP�ٷ������ϵ�����ǣ�0E,45N��δȡȫ��Χ��������Լ����� 
!         �����޸ġ� 
!=============================================================== 
!interp routine for the NCEP REANALYSIS data to 
!a new grid 
!=============================================================== 
! 
!Bilinearly Interpolate from one grid to the other 
!     !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
!     !!!!!!!!!! for NCEP REANALYSIS only(144X73) !!!! 
!     !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
!interpolate the internal grids from original(F=>T) 
!                     F----+-------------F 
!                     |    |             | wn F=from 
!                     +----T-------------+ 
!                     |    |             | ws T=to 
!                     F----+-------------F 
!                       ww        we 
!   
!Note: vector intepolate should be rotated first 
!           some variable are 192X94 should be treated in other files 
subroutine daily_interp( 
    &xf,yf,xt,yt, 
    &lonf,latf,varf, 
    &latt,lont,vart, 
    &isw,ise,inw,ine, 
    &jsw,jse,jnw,jne, 
    &ww,we,ws,wn, 
    &first) 
implicit none 
integer xf,yf,xt,yt 
real,dimension(xf,yf):: varf 
real,dimension(xt,yt):: latt,lont,vart 
real,dimension(xf):: lonf 
real,dimension(yf):: latf 
integer,dimension(xt,yt):: isw,ise,inw,ine 
integer,dimension(xt,yt):: jsw,jse,jnw,jne 
real,dimension(xt,yt):: ww,we 
real,dimension(xt,yt):: ws,wn 
logical first 
integer i,j,k,ie,iw,jn,js 
if(first) then 
! 
!find the weight & indexes 
! 
do j=1,yt 
do i=1,xt 
! 
!x direction 
! 
iw=int(lont(i,j)/2.5)+1 !***���ȴ�0��ʼ**** 
ie=iw+1 
if(ie.gt.xf) then 
ww(i,j)=(360.-lont(i,j))/2.5 
we(i,j)=1-ww(i,j) 
ie=1 
else 
ww(i,j)=(lonf(ie)-lont(i,j))/2.5 
we(i,j)=1-ww(i,j) 
endif 
ise(i,j)=ie 
ine(i,j)=ie 
isw(i,j)=iw 
inw(i,j)=iw 
enddo 
enddo 
! 
!y direction 
! 
do j=1,yt 
do i=1,xt 
js=int((latt(i,j)-45)/2.5)+1 !***γ�ȴ�45��ʼ**** 
if(js.eq.yf) js=js-1 
jn=js+1 
ws(i,j)=(latf(jn)-latt(i,j))/(latf(jn)-latf(js)) 
wn(i,j)=1-ws(i,j) 
jnw(i,j)=jn 
jne(i,j)=jn 
jsw(i,j)=js 
jse(i,j)=js 
enddo 
enddo 
first=.false. 
endif !first 
! 
!interpolate bilinearly 
! 
! 
do j=1,yt 
do i=1,xt 
vart(i,j)= ww(i,j)*wn(i,j)*varf(inw(i,j),jnw(i,j)) 
    &          +ww(i,j)*ws(i,j)*varf(isw(i,j),jsw(i,j)) 
    &          +we(i,j)*ws(i,j)*varf(ise(i,j),jse(i,j)) 
    &          +we(i,j)*wn(i,j)*varf(ine(i,j),jne(i,j)) 
enddo 
enddo 
return 
end subroutine daily_interp 
