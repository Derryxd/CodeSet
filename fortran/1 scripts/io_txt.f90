	program main
	!statement section	
		implicit none
		integer*2,parameter :: n=3  !声明常数
		real*4,allocatable :: y(:)  !声明可变大小一维数组，y(:,:)为二维
		real*4 :: x(n,2),z(2)       !固定大小数组只能用常数声明，等价于x（3）
		integer :: i,j,k,fid
		character*2 :: num
!       data num/'09','10','11'/
    !executable section
 		do i=9,9
 			write(num,'(i2.2)') i 	!i2.2意为两个字符长度，并保留两位有效数字
 			open(fid,file=trim(adjustl(num))//'.txt') 
 			!adjustl的作用是将字符串里的内容左对齐，空格置于右端。trim的作用是将字符串末尾(即右端)的空格删掉
 			do j=1,1             !跳过第一行
 				read(fid,*)      !一次read只读取文件一行，不读进变量里
 			end do
 			read(fid,*)((x(j,k),k=1,2),j=1,3)                 !！！！！更简洁，work~
! 			do j=1,3
! 				read(fid,*) x(j,:)  !空格、tab、英文的逗号均可以作为txt文件的间隔符
! 			end do
			print *, 'i=',i
 			print *,'num=',num
 			print *,'x=',x(1,1)
!  			print *,'z=',z
 		end do
 		print *, 'i=',i
 		allocate(y(1:i))       !配置数组维数大小
 		y(i)=1
 		print *,y(i)
 		if(allocated(y)) then  !确认变量是否已被配置空间
 			deallocate(y)      !释放空间
 			print *,2
 		end if 
 		do i=1,3
 			write(*,100) x(i,2),x(i,1)**2  !**为幂，下一行为format的具体设置
 			100 format (T10,f6.2,f7.2)     !Tn代表在第n列输出
 		end do
 		close(fid)
	end

