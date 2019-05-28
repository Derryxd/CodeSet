
PROGRAM test_simul
	IMPLICIT NONE 
	INTEGER, PARAMETER :: MAX_SIZE=10
	REAL, DIMENSION(MAX_SIZE,MAX_SIZE) :: a 
	REAL, DIMENSION(MAX_SIZE) :: b
	REAL :: line
	INTEGER :: error
	CHARACTER(len=20) :: file_name
	INTEGER :: i,j,n 							!n<Max_size
	INTEGER :: istat							! I/O status
	!get the file name
	WRITE(*,"('Enter the file name containing the eqns:')")
	READ (*,'(A20)') file_name
	!open file
 	OPEN(10,FILE=file_name,STATUS='OLD',IOSTAT=istat)
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
 	REWIND(10,IOSTAT=istat)
		!read the eqns
		size_ok: IF (n<=MAX_SIZE) THEN
			DO i=1,n
				READ(10,*)(a(i,j),j=1,n),b(i)
			END DO
			!display coeff
			WRITE(*,"(/,1X,'Coeff before call:')")
			DO i=1,n
				WRITE(*,"(1X,7F11.4)") (a(i,j),j=1,n),b(i)
			END DO
			!solve eqns
			CALL simul(a,b,MAX_SIZE,n,error)
			!check for error
			error_check: IF (error/=0) THEN
			WRITE(*,1010)
 		1010 FORMAT (/1X,'zero pivot encontered!',&
			//1X,'There is no unique solu to this system.')
			ELSE error_check
				!no error,show coff
				WRITE(*,"(/,1X,'Coeff after call:')")
				DO i=1,n
					WRITE(*,"(1X,7F11.4)")(a(i,j),j=1,n),b(i)
				END DO
				!final answer
				WRITE(*,"(/,1X,'The solu are: ')")
				Do i=1,n
					WRITE(*,"(3X,'X(',I1,')=',F16.6)") i,b(i)
				END DO
			END IF error_check
		END IF size_ok
	ELSE fileopen
		!open file
		WRITE(*,1020) istat
 	1020 FORMAT (1X,'file open failed--status=',I6)
	END IF fileopen
	CLOSE(10)
END PROGRAM test_simul

SUBROUTINE simul (a,b,ndim,n,error)
	IMPLICIT NONE
	INTEGER, INTENT(IN) :: ndim
	REAL, INTENT(INOUT), DIMENSION(ndim,ndim) :: a  	!array nxn of coeff
	REAL, INTENT(INOUT), DIMENSION(ndim) :: b			!in:rhs of eqs; out:solu vector
	INTEGER, INTENT(IN) :: n 							!num of eqs
	INTEGER, INTENT(OUT) :: error						!if 1, then singular
	REAL, PARAMETER :: EPSILON=1.0e-6
	REAL :: factor
	INTEGER :: i,j
	INTEGER :: irow, jrow, kcol
	INTEGER :: ipeak 									!pivot value
	REAL :: temp
	! process n 
	mainloop: DO irow=1,n
		!find pivot for column irow in rows
		ipeak=irow
		max_pivot: DO jrow=irow+1,n
			IF ( ABS(a(jrow,irow)) > ABS(a(ipeak,irow)) ) THEN 
				ipeak=jrow
			END IF 
		END DO max_pivot
		!check singular
		singular: IF ( ABS(a(ipeak,irow)) < EPSILON ) THEN 
			error=1
			PRINT *, 'a(i,i)=',a(ipeak,irow)
			PRINT *,'err=',error
			RETURN
		END IF singular
		!swap irow and ipeak
		swap_eqn: IF ( ipeak/=irow ) THEN 
			DO kcol=1,n
				temp=a(ipeak,kcol)	
				a(ipeak,kcol)=a(irow,kcol)
				a(irow,kcol)=temp
			END DO
			temp=b(ipeak)
			b(ipeak)=b(irow)
			b(irow)=temp
		END IF swap_eqn
		!multiply coeff: -a(jrow,irow)/a(irow,irow)
		eliminate: DO jrow=1,n
			IF ( jrow/=irow ) THEN
				factor=-a(jrow,irow)/a(irow,irow)
				DO kcol=1,n
					a(jrow,kcol)=a(irow,kcol)*factor+a(jrow,kcol)
				END DO
				b(jrow)=b(irow)*factor+b(jrow)
			END IF
		END DO eliminate
		PRINT *, 'irow=',irow,'   a(i,i)=',a(irow,irow)
	END DO mainloop
	!deal with diagonal
	divide: DO irow=1,n
		b(irow)=b(irow)/a(irow,irow)
		a(irow,irow)=1.
	END DO divide
	!set error
	error=0
	PRINT *,'err=',error
END SUBROUTINE simul



