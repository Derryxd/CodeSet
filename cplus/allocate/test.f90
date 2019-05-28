program main

use mod 

integer::i

!call arrmoc()
!call arr2d()

allocate(at(3,2))
at = 1
write(*,*),"at=",at

write(*,*),"call findaddr"
call findaddr(at)
write(*,*),"at_f=",at

write(*,*),"call usearr_1p"
call use1p
write(*,*),"at_1p=",at

!write(*,*),"call usearr_2p"
!call use2p
!write(*,*),"at_2p=",at

write(*,*),"call usearr_arrp"
call usearrp
write(*,*),"at_arrp=",at

!write(*,*),"at(2,1)=",at(2,1)
!write(*,*),"at(2,2)=",at(2,2)

write(*,*),"call sub_fortran"
call sub
write(*,*),"at=",at

write(*,*),"call deallocate"
deallocate(at)
write(*,*),"at=",at

end program
