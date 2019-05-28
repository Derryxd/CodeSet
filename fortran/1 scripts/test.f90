 	implicit none
    integer, allocatable :: array(:)!动态数组
    integer :: n
    real :: line
    integer :: i,istat
 OPEN(10,FILE="inputs1.txt",STATUS='OLD',IOSTAT=istat)
	PRINT *, 2333
	!test open 
	fileopen: IF ( istat==0 ) THEN
		!figure out n
		n=0 
		PRINT *, n
		countrow: DO WHILE (.true.)
			READ(10,*,end=100) line
			n=n+1
			PRINT*,n
		END DO countrow
     100 continue
 	END IF fileopen
 	PRINT *, n
 END