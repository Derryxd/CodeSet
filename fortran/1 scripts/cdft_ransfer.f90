!This fortran module transfer one distribution to another using cdf mapping method.

module cdftransfer

use NRTYPE
use NR, only : sort
implicit none
private

public :: transfer,&
        get_F_from_data_normal,&
        get_F_from_data_weibul,&
        get_F_from_data_EVI,&
        get_data_from_F_normal,&
        get_data_from_F_weibul,&
        get_data_from_F_EVI
        
contains

subroutine transfer(src, src_cdf_ref, quan, desti_cdf_ref, desti, extype,tag)
!This is a general transfer function to transfer value (src) in one reference
!set (src_cdf_ref) to a value (desti) in another referecne set(desti_cdf_ref). 
!The query is src, quan is the quantile value used in the transfer
!desti is the output
!extype is the type of distribution used if the value falls outside of the reference set
use NRTYPE
use NR,only : sort, moment
implicit none

real(SP) :: src
real(SP),dimension(:) :: src_cdf_ref
real(SP),dimension(:) :: desti_cdf_ref
real(SP),dimension(:),pointer :: quan1
real(SP),dimension(:),pointer :: quan2
real(SP) :: quan
real(SP) :: desti
real(SP) :: X
real(SP) :: src_mean, src_sd, src_skew
real(SP) :: desti_mean, desti_sd, desti_skew
real(SP) :: dummy_adev, dummy_var, dummy_curt
character(len=4) :: extype
character(len=*),optional:: tag
character(len=12)::mytag
integer :: n1,n2
integer :: i
integer :: ihigh, ilow

!real(SP) :: mean, sd

!write(*,*) "cdftransfer()"
if(present(tag)) then
    mytag=tag
else
    mytag='mytag'
endif

!
!get the array size
!

n1=size(src_cdf_ref)
n2=size(desti_cdf_ref)

!
!allocate space
!
allocate(quan1(n1))
allocate(quan2(n2))

!
!sort the src_cdf_ref and desti_cdf_ref
!

call sort(src_cdf_ref)
call sort(desti_cdf_ref)

!
!calculate mean and standard deviations
!
!    print*,'INSIDE TRANSFER'
!    print*,src_cdf_ref
    call moment(src_cdf_ref,src_mean,dummy_adev,src_sd,dummy_var,src_skew,dummy_curt)
!    print*,desti_cdf_ref
    call moment(desti_cdf_ref,desti_mean,dummy_adev,desti_sd,dummy_var,desti_skew,dummy_curt)

!
!initialize percentile vectors using Gringorten plotting position
!Gringorton gives exceedance probability, so 1-gringorton
!

do i = 1, n1
      quan1(i) = 1.-real(n1+1-i-0.44)/real(n1+0.12)
end do

do i = 1, n2
      quan2(i) = 1.-real(n2+1-i-0.44)/real(n2+0.12)
end do

!
!===============================================================
!find the quantile first
!

!
!if src is smaller than the smallest value in the reference
!
if(src < src_cdf_ref(1))then
!print*, 'finding quantile case 1', src, src_cdf_ref(1)

    if(extype .eq. 'norm')then
        quan = get_f_from_data_normal(src_mean,src_sd,src)
    else
        print*,'-----------------',trim(mytag),'-------------------------'
        print*, 'using get_f_from_data_weibul ', src, src_cdf_ref(1),src_mean,src_sd,src_skew
        write(100,*),'-----------------',trim(mytag),'-------------------------' !change for screen output to dat
        write(100,*), 'using get_f_from_data_weibul ', src, src_cdf_ref(1),src_mean,src_sd,src_skew !change for screen output to dat
        
        quan = get_f_from_data_weibul(src_mean,src_sd,src_skew,src)
    endif

!if query falls above maximum value in referecne set
elseif(src > src_cdf_ref(n1))then
!print*, 'find quantile case 2', src, src_cdf_ref(n1)
    if(extype .eq. 'norm')then
        quan = get_F_from_data_normal(src_mean,src_sd,src)
    else
        quan = get_F_from_data_EVI(src_mean,src_sd,src)
    endif
else
!print*, 'finding quantile regular case'
    do i=1,n1
        if(src .le. src_cdf_ref(i))then
            ihigh=i
            exit
        endif
        ihigh=n1
    end do
    
    do i=n1,1,-1
        if(src .ge. src_cdf_ref(i))then
            ilow=i
            exit
        endif
        ilow=1
    end do
    
    if(src_cdf_ref(ihigh) .ne. src_cdf_ref(ilow))then
    X=(src_cdf_ref(ihigh)-src)/(src_cdf_ref(ihigh)-src_cdf_ref(ilow))
    quan = (1.-X)*quan1(ihigh)+X*quan1(ilow)
    else
    quan = (quan1(ihigh)+quan1(ilow))/2.
    endif
endif
!print*,'Value is:',src,' Quantile is: ',quan

!=============================================================================================
!after the quantile is obtained, we now need to find the values in desti_cdf_ref

if(quan < quan2(1))then
!print*, 'finding value case 1',quan, quan2(1)
    if(extype .eq. 'norm')then
        desti = get_data_from_F_normal(desti_mean,desti_sd,quan)
    else
        desti = get_data_from_F_weibul(desti_mean,desti_sd,desti_skew,quan)
    endif
elseif(quan > quan2(n2))then
!print*, 'finding value case 2',quan, quan2(n2)    
    if(extype .eq. 'norm')then
        desti = get_data_from_F_normal(desti_mean,desti_sd,quan)
    else
        desti = get_data_from_F_EVI(desti_mean,desti_sd,quan)
    endif
else
!print*,'finding value regular case'
    do i=1,n2
        if(quan .le. quan2(i))then
            ihigh=i
            exit
        endif
        ihigh=n2
    end do
    
    do i=n2,1,-1
        if(quan .ge. quan2(i))then
            ilow=i
            exit
        endif
        ilow=1
    end do

    if(ihigh .ne. ilow)then
    X=(quan2(ihigh)-quan)/(quan2(ihigh)-quan2(ilow))
    desti = (1.-X)*desti_cdf_ref(ihigh)+X*desti_cdf_ref(ilow)
    else
    desti = desti_cdf_ref(ihigh)
    endif
endif
!print*,'Quantile is:',quan,' Value is: ',desti

deallocate(quan1)
deallocate(quan2)
!write(*,*) "cdftransfer done()"
end subroutine


!#######################################################################################
!
!     function get_F_from_data_normal(mean, sd, x)
!
!########################################################################################

function get_F_from_data_normal(mean, sd, x)
! uses approximation from Handbook of Hydrology eq. 18.2.2 
use NRTYPE
implicit none

integer :: sign
real(SP) :: mean, sd, x
real(SP) :: z, F, get_F_from_data_normal

sign=1
z = (x-mean)/sd
if(z < 0.) then
    sign=-1
    z=sign*z
endif
  F = 1-0.5*exp(-1.*((83.*z+351.)*z+562.)/(165.+703./z))
!

if(F>1.0 .or. F<0.0)then
    print*,'Error in get_F_from_data_normal'
    print*,'Bad quantile: data=',x,' mean=',mean,' sd=',sd,' quant=',F
    stop
!    if(F>=1.0) F=0.99999
!    if(F<=0.0) F=0.00001
else
    if(sign == -1) F = 1-F
endif
get_F_from_data_normal  = F
end function get_F_from_data_normal


!#######################################################################################
!
!  function get_data_from_F_normal(mean,sd,F)
!
!########################################################################################

function get_data_from_F_normal(mean,sd,F)
use NRTYPE
implicit none
real(SP), intent(in) :: mean, sd, F
real(SP) :: get_data_from_F_normal, x,z
! /* uses approximation from Handbook of Hydrology eq. 18.2.3a */
  if(F > 1.0 .or. F < 0.0)then
    print*,'Error in get_data_from_F_normal'
    print*,'Bad quantile: mean=',mean,' sd=',sd,' quant=',F
    write(100,*),'Error in get_data_from_F_normal'  !change for screen output to dat
    write(100,*),'Bad quantile: mean=',mean,' sd=',sd,' quant=',F  !change for screen output to dat

    
    stop
  endif
  
! /*  z = ((F**0.135)-((1-F)**0.135))/0.1975;*/
  z = ((F**0.135)-((1.-F)**0.135))/0.1975;
  if(z > 5)then
    print*,'Pushing upper limit of applicability of equation'
    print*,'in get_data_from_F_normal best range is 0<z<5. z= ',z
    write(100,*),'Pushing upper limit of applicability of equation' !change for screen output to dat
    write(100,*),'in get_data_from_F_normal best range is 0<z<5. z= ',z !change for screen output to dat
  endif
  x = z*sd+mean
  get_data_from_F_normal=x
end function get_data_from_F_normal


!#######################################################################################
!
!  function get_F_from_data_EVI(mean, sd, x)
!
!########################################################################################

function get_F_from_data_EVI(mean, sd, x)
use NRTYPE
implicit none
!  Gumbel (EV Type I distribution) for maxima 
real(SP), intent(in) :: mean, sd, x
real(SP) :: a, b, F, get_F_from_data_EVI

 b = 3.14159/(sd*sqrt(6.))
 a = mean-0.5772/b
 F = exp(-1.*exp(-b*(x-a)))

!  added following adjustment so that outlier ensembles don't */
!  get totally booted out AWW-020903 */
if(F == 1.0) then
   F = F-.00238  !to adjust quantile if it is out of bounds 
   print*, 'Invoked TINY in get_F_from_data_EVI: data=',x,' mean=',mean,' sd=',sd,' quant=',F
   write(100,*), 'Invoked TINY in get_F_from_data_EVI: data=',x,' mean=',mean,' sd=',sd,' quant=',F !change for screen output to dat
elseif( F == 0.0) then
   F = F +.00238  !to adjust quantile if it is out of bounds 
   print*, 'Invoked TINY in get_F_from_data_EVI: data=',x,' mean=',mean,' sd=',sd,' quant=',F
   write(100,*), 'Invoked TINY in get_F_from_data_EVI: data=',x,' mean=',mean,' sd=',sd,' quant=',F
endif

if(F>=1.0 .or. F<=0.0)then
   print*,'Error in get_F_from_data_EVI'
   print*,'Bad quantile: data=',x,' mean=',mean,' sd=',sd,' quant=',F
   write(100,*),'Error in get_F_from_data_EVI'  !change for screen output to dat
   write(100,*),'Bad quantile: data=',x,' mean=',mean,' sd=',sd,' quant=',F   !change for screen output to dat 
   stop
endif
get_F_from_data_EVI =F
end function  get_F_from_data_EVI

!#######################################################################################
!
!   function get_data_from_F_EVI(mean, sd, F)
!
!########################################################################################

function get_data_from_F_EVI(mean, sd, F)
use NRTYPE
implicit none
!   Gumbel (EV Type I distribution) for maxima */
real(SP), intent(in) :: mean, sd, F
real(SP) :: x, get_data_from_F_EVI
real(SP) :: a, b

  if(F>=1.0 .or. F<=0.0)then
    print*,'Error in get_data_from_F_EVI'
    print*,'Bad quantile: mean=',mean,' sd=',sd,' quant=',F
    write(100,*),'Error in get_data_from_F_EVI'  !change for screen output to dat
    write(100,*),'Bad quantile: mean=',mean,' sd=',sd,' quant=',F  !change for screen output to dat
    stop
  endif
  
  b = 3.14159/(sd*sqrt(6.))
  a = mean-0.5772/b
  x = a-(1/b)*(log(-log(F)))
  get_data_from_F_EVI = x
end function get_data_from_F_EVI

!#######################################################################################
!
!  function get_F_from_data_weibul(mean, sd, skew, x)
!
!########################################################################################

function get_F_from_data_weibul(mean, sd, skew, x)
use NRTYPE
implicit none
real(SP),intent(in) :: mean, sd, skew, x
!   Weibull (EV Type III distribution) for minima, bounded at zero 
!   approximation for a (alpha) is eq. 11-32 from Kite (1977) 

real(SP) :: a,b,AA,BB,bound
real(SP) :: get_F_from_data_weibul, F

  print*
  print*
  print*,'begin get_f_from_data_weibul'
  print*,'INSIDE get_F_from_data_weibul, mean sd skew x',mean,sd,skew,x
  write(100,*),'begin get_f_from_data_weibul' !change for screen output to dat
  write(100,*),'INSIDE get_F_from_data_weibul, mean sd skew x',mean,sd,skew,x !change for screen output to dat

  if(skew .gt. 8.214 .or. skew .lt. -1.)then
    print*,'Outside limit for table in get_F_from_data_weibul'
    print*,'best range is -1<skew<8.2 skew=',skew
    write(100,*),'Outside limit for table in get_F_from_data_weibul' !change for screen output to dat
    write(100,*),'best range is -1<skew<8.2 skew=',skew !change for screen output to dat
  endif

  call weibul_params(skew,a,AA,BB)
  b = AA*sd+mean;
  bound = b-BB*sd;

! lower bound minimum of zero, but allow larger minima if data say so */
  if(bound < 0.) bound=0.
  if(bound > x ) bound=0.
  F =1.-exp(-1.* ((x-bound)/(b-bound))**a)
  

!  if(F >= 1.0 .or.  F <= 0.0) then
! based on AWW-042001: altered as follows to allow for 0 precip pass through
  if(F >= 1.0 .or.  F <= 0.0 ) then
    print*, 'Error in get_F_from_data_weibul'
    print*, 'Bad quantile: data=',x, ' mean=',mean, ' sd=',sd,' skew=',skew,' quant=',F
    print*, 'a = ',a,' AA=',aa,' bb=',bb,' b=',b,' bound=',bound
    print*
    print*
    write(100,*), 'Error in get_F_from_data_weibul' !change for screen output to dat
    write(100,*), 'Bad quantile: data=',x, ' mean=',mean, ' sd=',sd,' skew=',skew,' quant=',F !change for screen output to dat
    write(100,*), 'a = ',a,' AA=',aa,' bb=',bb,' b=',b,' bound=',bound !change for screen output to dat

   F=0.00001
   endif
   get_F_from_data_weibul = F
   print*,'INSIDE get_F_from_data_weibul, F=',get_F_from_data_weibul
   print*,'finish get_f_from_data_weibul'
   write(100,*),'INSIDE get_F_from_data_weibul, F=',get_F_from_data_weibul !change for screen output to dat
   write(100,*),'finish get_f_from_data_weibul' !change for screen output to dat
   print*
   print*
end function get_F_from_data_weibul


!#######################################################################################
!
!   function get_data_from_F_weibul(mean,sd,skew,F)
!
!########################################################################################

function get_data_from_F_weibul(mean,sd,skew,F)
!  /* Weibull (EV Type III distribution) for minima, bounded at zero */
!  /* approximation for a (alpha) is eq. 11-32 from Kite (1977) */
use NRTYPE
implicit none
real(SP), intent(in) :: mean, sd, skew, F
real(SP) :: a, b, AA, BB, bound, x, get_data_from_F_weibul
  if(F >= 1.0 .or. F <= 0.0)then
    print*,'Error entering get_data_from_F_weibul'
    print*,'Bad quantile: mean=',mean,' sd=',sd,' skew=',skew,' quant=',F
    write(100,*),'Error entering get_data_from_F_weibul' !change for screen output to dat
    write(100,*),'Bad quantile: mean=',mean,' sd=',sd,' skew=',skew,' quant=',F !change for screen output to dat
    stop
  endif
  
  if(skew>8.2 .or. skew<-1)then
    print*,'Outside limit for table in get_data_from_F_weibul'
    print*,'best range is -1<skew<8.2 skew=',skew
    write(100,*),'Outside limit for table in get_data_from_F_weibul' !change for screen output to dat
    write(100,*),'best range is -1<skew<8.2 skew=',skew !change for screen output to dat
  endif
  
!  a = 1/(0.2777757913+0.3132617714*skew+0.0575670910*pow(skew,2)-
!      0.0013038566*pow(skew,3)-0.0081523408*pow(skew,4)); 
  call weibul_params(skew,a,AA,BB)
  b = AA*sd+mean
  bound = b-BB*sd
!  /*  lower bound minimum of zero, but allow larger minima if data say so */
  if(bound<0) bound=0
  x = ((-log(1-F))**(1/a))*(b-bound) + bound
  get_data_from_F_weibul = x
end function get_data_from_F_weibul


!#######################################################################################
!
!   subroutine weibul_params(skew,a,aa,bb)
!
!########################################################################################

subroutine weibul_params(skew,a,aa,bb)
use NRTYPE
implicit none
!   returns alpha, Aalpha, and Balpha for the Weibull distrubution 
!   table taken from Statistical Methods in Hydrology, Haan, shown below 
real(SP) :: skew
real(SP), intent(out)  :: a
real(SP), intent(out)  :: aa
real(SP), intent(out)  :: bb

integer:: i
real(SP) :: X

real(SP),dimension(26) :: sk = (/-1.000, -0.971, -0.917, -0.867, -0.638, -0.254, 0.069, 0.359,&
		 0.631,  0.896,  1.160,  1.430,  1.708,  2.000, 2.309, 2.640, &
                 2.996,  3.382,  3.802,  4.262,  4.767,  5.323, 5.938, 6.619, &
 		 7.374,  8.214 /)
real(SP),dimension(26) :: inva = (/0.020, 0.030, 0.040, 0.050, 0.100, 0.200, 0.300, 0.400, 0.500, &
	          0.600, 0.700, 0.800, 0.900, 1.000, 1.100, 1.200, 1.300, 1.400, &
	          1.500, 1.600, 1.700, 1.800, 1.900, 2.000, 2.100, 2.200 /)
real(SP),dimension(26) :: Avec = (/0.446,  0.444,  0.442,  0.439,  0.425,  0.389,  0.346,  0.297, &
                  0.246,  0.193,  0.142,  0.092,  0.044,  0.000, -0.040, -0.077, &
                 -0.109, -0.136, -0.160, -0.180, -0.196, -0.208, -0.217, -0.224,&
		 -0.227, -0.229 /)
real(SP),dimension(26) :: Bvec = (/40.005, 26.987, 20.481, 16.576, 8.737, 4.755, 3.370, 2.634,&
		   2.159,  1.815,  1.549,  1.334, 1.154, 1.000, 0.867, 0.752, &
                   0.652,  0.563,  0.486,  0.418, 0.359, 0.308, 0.263, 0.224, &
		   0.190, 0.161 /)

if(skew>sk(26)) then
   skew=sk(26)
else if (skew<sk(1)) then
   skew=sk(1)
endif

do i=1,25
      if(skew <= sk(i+1) .and. skew >= sk(i))then
            if((sk(i+1)-sk(i)) == 0.) then
            X=1.
            else
            X=(sk(i+1)-skew)/(sk(i+1)-sk(i))
            a=1./(X*inva(i)+(1.-X)*inva(i+1))
            aa= X*Avec(i)+(1.-X)*Avec(i+1)
            bb= X*Bvec(i)+(1.-X)*Bvec(i+1)
            endif
      endif
end do
end subroutine  weibul_params   

end module
