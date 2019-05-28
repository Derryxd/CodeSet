!By topmad
implicit none
real line
integer i
open(10,file='09.txt',status='old')
do i=1,1            !跳过第一行
	read(10,*)      !什么都不读
end do
i=0  !清风提醒，特加此行
do while (.true.)
read(10,*,end=100) line
i=i+1
print*,i
enddo
100 continue
print*,i
print*,line
end