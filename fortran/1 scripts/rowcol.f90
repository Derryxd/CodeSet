

parameter(m=1440,n=480) 
real*4 x(m,n),y(m,n)
real*4 aa(8)
integer i,j
!列行
open(3,file="cr.dat", form="unformatted", &
           access="direct",recl=m*n)
open(2,file="tmax_sum_LST.dat", form="unformatted", &
           access="direct",recl=m*n)
READ(2,rec=1)((x(i,j),i=1,m),j=1,n)  
write(3,rec=1)((x(i,j),i=1,m),j=1,n)
print *,'x=',x(1,1:8)
print *,'xx=',x(6,480)
CLOSE(2)   
!行列
open(4,file="rc.dat", form="unformatted", &
           access="direct",recl=m*n)
open(22,file="tmax_sum_LST.dat", form="unformatted", &
           access="direct",recl=m*n)
READ(22,rec=1)((y(i,j),j=1,n),i=1,m) 
write(4,rec=1)((y(i,j),j=1,n),i=1,m)
print *,'y=',y(1,1:8)
print *,'yy=',y(6,480)


open(5,file="final.dat", form="unformatted", &
           access="direct",recl=8)
open(222,file="tmax_sum_LST.dat", form="unformatted", &
           access="direct",recl=8)
READ(222,rec=1)aa
write(5,rec=1)aa
print *,'aa=',aa
CLOSE(222) 

close(3)
close(4)
close(5)
end


! !列行
! parameter(m=4,n=3) 
! real x(m,n)
! integer i,j
! OPEN(2,FILE='33.txt')
! ! 	do i=1,m
! ! 		read(2,*) x(i,:)
! ! 	end do

! READ(2,*)((x(i,j),i=1,m),j=1,n)
! ! write(*,100)((x(i,j),j=1,n),i=1,m)
! write(*,100)((x(i,j),i=1,m),j=1,n)
! 100 FORMAT(3F9.2)

! write(*,101)(x(i,1),i=1,m)
! CLOSE(2)   
! 101 FORMAT(F9.2)

! print *,x(2,2)
! end

! !行列
! parameter(m=4,n=3) 
! real x(m,n)
! OPEN(2,FILE='33.txt')
! READ(2,*)((x(i,j),j=1,n),i=1,m)  
! write(*,100)((x(i,j),j=1,n),i=1,m)
! 100 FORMAT(3F9.2)

! write(*,101)(x(i,1),i=1,m)
! CLOSE(2)   
! 101 FORMAT(F9.2)

! print *,x(2,2)
! end