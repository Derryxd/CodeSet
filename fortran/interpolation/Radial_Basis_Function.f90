program rbf
!
!*******************************************************************************
!
!! RBF implements the radial basis function method.
!
!
!  mq1dlsc - a multi-quadric radial basis function method
!            with least squares method.
!
!  version "c" - the alfa-coefficients and c_j are to be found
!
!           test 1: 1d function interpolation
!           test 2: 1d elliptic equation
!
!
  integer, parameter :: nmax = 501

  integer, parameter :: lwa = ( nmax * ( 3 * nmax + 13 ) / 2 + 1 )
  integer, parameter :: nxtm = 1001
!
  real a(nmax,nmax)
  real aaa(nmax,nmax)
  real adfdx
  real anal
  real asa(nmax,nmax)
  real b(nmax)
  real c(nmax)
  real ck
  real cmax
  real cmin
  character ( len = 30 ) comnd
  real cond
  real d2fdx2
  real d2fundx
  real dfdx
  real dfundx
  real dsdx
  real dx
  real dxfun
  real dxt
  real err
  real errdf
  real f(nmax)
  real ffun
  real fun
  real fvec(nmax)
  real g
  real gx
  real g2x
  real hxt
  integer i
  integer ifun
  integer in
  integer info
  integer io
  integer io2
  integer ios
  integer ipvt(nmax)
  integer j
  integer k
  integer m
  integer mode
  integer n
  integer nn
  integer nnxt
  integer npmx
  integer nqq
  integer nxt
  character ( len = 10 ) par
  real radc
  real rcur
  real sol
  real tol
  real uxx
  real w(nmax)
  real wa(lwa)
  real xk(nmax)
  real x1
  real x2
  real xdx
  real xfun
  real xt(nxtm)
  real xt1
  real xt2
  real xxf
  real y(nmax)
  real z
!
  external hlsrec
!
  common /i_common/ ifun, m, mode, nn, nqq, nxt
  common /r_common/ aaa, asa, b, hxt, xk, xt
!
!  declaration operator-functions
!
  fun(z) = ffun(ifun,z)
  dfdx(z) = dfundx(ifun,z)
  d2fdx2(z) = d2fundx(ifun,z)
!
  g(j,z) = sqrt ( ( z - xk(j) )**2 + c(j)**2 )

  gx(j,z) = ( z - xk(j) ) / sqrt ( ( z - xk(j) )**2 + c(j)**2 )

  g2x(j,z) = 1.0 / sqrt ( ( z - xk(j) )**2 + c(j)**2 ) &
     - ( z - xk(j) )**2 / sqrt ( ( ( z - xk(j) )**2 + c(j)**2 )**3 )
!
!  Read the solver parameters.
!
  ifun = 1
  in = 5
  io = 9
  io2 = 10
  open ( io, file='mqle.dat', status = 'unknown' )

  mode = 2

  write ( *, * ) ' '
  write ( *, * ) 'Choose the function:'
  write ( *, * ) '  1 = x**2'
  write ( *, * ) '  2 = x*(x-1)**2'
  write ( *, * ) '  3 = sin(2*pi*x)'
  write ( *, * ) '  4 = exp(-x)'
  write ( *, * ) '  5 = abs(x-0.5)'
  write ( *, * ) '  6 = atan(10*(x-0.5)): '
  read ( *, * ) ifun

  write ( *, * ) ' '
  write ( *, * ) 'Enter N:'
  read ( *, * ) n

  write ( *, * ) ' '
  write ( *, * ) 'Enter NNXT'
  read ( *, * ) nnxt

  nxt = abs ( nnxt )
  nxt = ( nxt - 1 ) / 2 * 2 + 1
  m = n

  write ( *, * ) ' '
  write ( *, * ) 'Enter K, CMIN, CMAX:'
  write ( *, * ) ' '
  write ( *, * ) '  K=1: C(J)=cmin*(j/n)^(3/4);'
  write ( *, * ) '  K=2: C(J)=cmin*((cmax/cmin)^((j-1)/(n-1)))'
  read ( *, * ) k, cmin, cmax
!
!  Generate CJ
!
  do j = 1, n
    if ( k == 1 ) then
      if ( cmax > 0.0 ) then
        c(j) = cmax * ( real ( j ) / real ( n ) )**0.75
      else
        c(j) = abs(cmax)
      end if
    else
      c(j) = cmin * ( cmax / cmin )**( float ( j - 1 ) / float ( n - 1 ) )	
    end if
  end do

  write ( *, * ) ' '
  write ( *, * ) 'Shape parameters C(1:N):'
  write ( *, * ) ' '
  write ( *, '(i3,g12.4)' ) ( i, c(i), i = 1, n )
!
!  Set integration points
!
  xt1 = 0.0
  xt2 = 1.0
  xt(1) = xt1
  dxt = ( xt2 - xt1 ) / real ( nxt - 1 )
  hxt = dxt
  do i = 2, nxt
    xt(i) = xt(i-1) + dxt
  end do

  write ( *, * ) ' '
  write ( *, * ) 'Integration points XT(1:NXT):'
  write ( *, * ) ' '
  write ( *, '(i3,g12.4)' ) ( i, xt(i), i = 1, nxt )
!
!  Set xj points - function knots
!
  x1 = 0
  x2 = 1
  xk(1) = x1
  dx = ( x2 - x1 ) / real ( n - 1 )
  do i = 2, n
    xk(i) = xk(i-1) + dx
  end do

  write ( *, * ) ' '
  write ( *, * ) 'Function points XK(1:N):'
  write ( *, * ) ' '
  write ( *, '(i3,g12.4)' ) ( i, xk(i), i = 1, n )
!
!  form a matrix
!
610  continue

  nn = n

  a(1:nn,1:nn) = 0.0

  do j = 1, n
    do i = 1, n
      a(i,j) = g(j,xk(i))
    end do
  end do
!
!  Form a right hand side.
!
  do i = 1, n
    b(i) = fun ( xk(i) )
  end do
!
!   stiff b.c. (function at the boundary)
!
  if ( nnxt < 0 ) then
!
!   set b.c.
!
    i = 1
    do j = 1, n
      a(i,j) = g(j,xk(i))
      asa(i,j) = a(i,j)
    end do
    b(i) = fun ( xk(i) )

    i = n
    do j = 1, n
      a(i,j) = g(j,xk(i))
      asa(i,j) = a(i,j)
    end do
    b(i) = fun ( xk(i) )

  end if
!
!  Decompose the system matrix.
!
  call decomp ( nmax, n, a, cond, ipvt, w )

  write ( *, * ) ' '
  write ( *, * ) '  Number of knots = ', n
  write ( *, * ) '  Number of points = ', nxt
  write ( *, * ) '  Condition number = ', cond
!
!  solve by hmin/hybrid
!
  y(1:n) = b(1:n)

  call solve ( nmax, n, a, y, ipvt )

  write ( *, * ) ' '
  write ( *, * ) 'Preliminary ALFA(1:N)'
  write ( *, * ) ' '
  write ( *, '(i3,e14.3)' ) ( i, y(i), i = 1, n )
  tol = 1.d-12
  info = 0
  y(1:n) = c(1:n)

  call hybrd1 ( hlsrec, nn, y, fvec, tol, info, wa, lwa )

  write(*,2000) tol, info
2000  format(' solved o.k.',' tol req =',1pe12.3,' info =',i5)

  if ( info == 0 ) then
    write ( *, * ) 'improper input parameters.'
  else if ( info == 1 ) then
    write ( *, * ) 'relative error between x and the solution is at most tol.'
  else if ( info == 2 ) then
    write ( *, * ) 'number of calls to fcn has reached or exceeded 200*(n+1).'
  else if ( info == 3 ) then
    write ( *, * ) 'tol is too small.'
    write ( *, * ) 'no further improvement in the solution x is possible.'
  else if ( info == 4 ) then
    write ( *, * ) 'iteration is not making good progress.'
  end if

  write ( *, * ) ' '
  write ( *, * ) 'Distance L(1:N):'
  write ( *, * ) ' '
  write ( *, '(i3,e14.3)' ) ( i, y(i), i = 1, n )
  read ( *, * )

  c(1:n) = y(1:n)
!
!  Solve again using new c
!
  do j = 1, n
    do i = 1, n
      a(i,j) = g(j,xk(i))
      asa(i,j) = a(i,j)
    end do
  end do

  do i = 1, n
    b(i) = fun ( xk(i) )
  end do

  call decomp ( nmax, n, a, cond, ipvt, w )

  write ( *, * ) ' '
  write ( *, * ) '  Number of knots = ', n
  write ( *, * ) '  Number of points = ', nxt
  write ( *, * ) '  Condition number = ', cond

  y(1:n) = b(1:n)

  call solve ( nmax, n, a, y, ipvt )

  write ( *, * ) ' '
  write ( *, * ) 'Final ALFA(1:N)'
  write ( *, * ) ' '
  write ( *, '(i3,e14.3)' ) ( i, y(i), i = 1, n )
  read ( *, * ) 
!
!  print solution at the nodes
!
!cc  write (*,3000)n

  rewind io
  write ( *, 3000 ) n, cond
3000  format('# solution ',i5,' points, cond=',1pe12.2)

  write ( *, * ) '#    i       x               numer          anal', &
    '          err          ux (numer and anal)          d/dxerr'

  npmx = 201
  xfun = 0.0
  dxfun = 0.0
  xxf = 0.0
  xdx = 0.0
  do k = 1, npmx
    z = x1 + ( x2 - x1 ) * real ( k - 1 ) / real ( npmx - 1 )
    sol = 0.0
    dsdx = 0.0
    do j = 1, n
      sol = sol + y(j) * g(j,z)
      dsdx = dsdx + y(j) * gx(j,z)
    end do

    anal = fun(z)
    err = anal - sol

    adfdx = dfdx(z)
    errdf = adfdx - dsdx

    if ( abs ( err ) > abs ( xfun ) ) then
      xfun = err
      xxf = z
    end if

    if ( abs ( errdf ) > abs ( dxfun ) ) then
      dxfun = errdf
      xdx = z
    end if
!
!  write (*,3100)k,z,sol,anal,err,dsdx,adfdx,errdf
  write ( io, 3100 ) k,z,sol,anal,err,dsdx,adfdx,errdf
3100  format(i5,1p7e15.5)
  end do

  rewind io

  write (*,3150)xfun,xxf
3150  format(' max. func. error ',1pe15.5,' at ',1pe15.5)
  write ( *,3151)dxfun,xdx
3151  format (' max. df/dx error ',1pe15.5,' at ',1pe15.5)
!
!  write solution at the nodes
!
  open ( io2, file = 'mqle2.dat', status = 'unknown' )
  rewind io2

  write (io2,3060)n,cond
3060  format('# solution ',i5,' points, cond=',1pe12.2)

  write ( *, * ) ' max f,fx error=',xfun, xxf
  write (io2  ,3061)
3061  format('#',4x,'i',7x,'x',15x,'numer',10x,'anal',10x,'err',10x, &
     'ux (numer and anal)',10x,'d/dxerr' &
     ,10x,'c[j]',10x,'curv',10x,'rad',12x,'uxx')

  xfun = 0.0
  dxfun = 0.0
  xxf = 0.0
  xdx = 0.0
  do k = 1, n
    z = xk(k)
    sol = 0.0
    dsdx = 0.0
    do j = 1, n
      sol = sol + y(j) * g(j,xk(k))
      dsdx = dsdx + y(j) * gx(j,xk(k))
    end do

    anal = fun(xk(k))
    err = anal - sol

    adfdx = dfdx(xk(k))
    errdf = adfdx - dsdx

    if ( abs ( err ) > abs ( xfun ) ) then
      xfun = err
      xxf = xk(k)
    end if

    if ( abs ( errdf ) > abs ( dxfun ) ) then
      dxfun = errdf
      xdx = xk(k)
    end if

    ck = abs ( c(k) / y(k) )
    uxx = d2fdx2 ( xk(k) )
    rcur = uxx / ( sqrt ( 1.0 + adfdx**2 ) )**3
    radc = 300.0

    if ( abs ( rcur ) > 1.0 / radc ) then
      radc = 1.0 / abs ( rcur )
    end if

    write (io2 ,3250)k,xk(k),sol,anal,err,dsdx,adfdx,errdf,ck,rcur,radc,uxx
3250  format(i5,1p11e15.5)

  end do

  rewind io2
  close(io2)
!
!   test points
!
  20  continue

  write ( *, * ) ' '
  write ( *, * ) 'Next command?'
  write ( *, * ) ' '
  write ( *, * ) '  Q = quit'
  write ( *, * ) '  G = gnuplot'
  write ( *, * ) '  S = save to a file'
  write ( *, * ) '  X = enter a point X.'

  read ( *, '(a)' ) par

  if ( par(1:1) == 'Q' ) then
    stop
  else if ( par(1:1) == 'S' )then
    write ( *, * ) ' '
    write ( *, * ) 'Enter file name:'
    read ( *, '(a)' ) par
    comnd='cp -p mqle2.dat '// par
    write(*,'(a,a)')' comnd = ', comnd
    call system ( comnd )
    go to 20
  else if ( par(1:1) == 'G' )then
    call gnuplot
    go to 20
  else if ( par(1:1) == 'X' ) then
    read ( par, * ) z
  else
    stop
  end if
!
!  Find the numerical solution at the point Z.
!
   sol = 0.0
   dsdx = 0.0
   do j = 1, n
     sol = sol + y(j) * g(j,z)
     dsdx = dsdx + y(j) * gx(j,z)
   end do

  anal = fun(z)
  err = anal - sol
  adfdx = dfdx(z)
  errdf = adfdx - dsdx

  write ( *,3800)
3800  format(7x,'x',9x,'numer',8x,'anal',9x,'err', &
  10x,'du/dx (numer and anal)')
  write ( *,'(1p6e13.5)')z,sol,anal,err,dsdx,adfdx

  go to 20

end
function ffun ( i, x )
!
!*******************************************************************************
!
!! FFUN returns the value of one of six different functions of X.
!
!
!  Discussion:
!
!    The user chooses the function by specifying an input argument.
!
  real ffun
  integer i
  real x
!
  if ( i == 1 ) then
    ffun = x**2
  else if ( i == 2 ) then
    ffun = x * ( x - 1.0 )**2
  else if ( i == 3 ) then
    ffun = sin ( 2.0 * 3.14159265358979323844 * x )
  else if ( i == 4 ) then
    ffun = exp ( - x )
  else if ( i == 5 ) then
    ffun = abs ( x - 0.5 )
  else if ( i == 6 ) then
    ffun = atan ( 10.0 * ( x - 0.5 ) )
  else
    ffun = 0.0E+00
  end if

  return
end
function dfundx(i,x)
!
!*******************************************************************************
!
!! DFUNDX returns the derivative of one of six different functions of X.
!
!
  real del
  real dfun
  real dfundx
  integer i
  real pi
  real pi2
  real x
!
  if ( i == 1 ) then
    dfundx=2*x
  else if ( i == 2 ) then
    dfundx=(x-1)**2 + x*2*(x-1)
  else if ( i == 3 ) then
    pi=3.14159265358979323844
    pi2=2.0*pi
    dfundx=pi2*cos(pi2*x)
  else if ( i == 4 ) then
    dfundx=-exp(-x)
  else if ( i == 5 ) then
    dfundx=-1
    if(x.ge.0.5)dfundx=1
  else if ( i == 6 ) then
    del=0.001
    dfun=atan(10.0*(x+del-0.5))-atan(10.0*(x-del-0.5))
    dfundx=dfun/(2.0*del)
  else
    dfundx = 0.0E+00
  end if

  return
end
function d2fundx(i,x)
!
!*******************************************************************************
!
!! D2FUNDX returns the second derivative of one of six different functions of X.
!
!
  real d2
  real d2fundx
  real del
  integer i
  real, parameter :: pi = 3.1415926535897932384
  real pi2
  real x
!
  if ( i == 1 ) then
    d2fundx=2
  else if ( i == 2 ) then
    d2fundx=2*(x-1) + 2*(x-1) + x*2
  else if ( i == 3 ) then
    pi2=2.0*pi
    d2fundx=-pi2**2*sin(pi2*x)
  else if ( i == 4 ) then
    d2fundx=exp(-x)
  else if ( i == 5 ) then
    d2fundx=0.0
    if(x.eq.0.5)d2fundx=1e6
  else if ( i == 6 ) then
    del=0.001
    d2  =atan(10.0*(x+del-0.5))-2*atan(10.0*(x-0.5))+atan(10.0*(x-del-0.5))
    d2fundx=d2/del**2
  else
    d2fundx = 0.0
  end if

  return
end
subroutine gnuplot
!
!*******************************************************************************
!
!! GNUPLOT writes out a file of commands to the GNUPLOT graphics package.
!
  integer lgp
!
  lgp = 12

  open ( unit = lgp, file = 'rbf_gnu_commands.txt', status = 'replace' ) 

  write ( lgp, * ) 'set title "mq-lsh method interpolation errors"'
  write ( lgp, * ) 'set xlabel "x"'
  write ( lgp, * ) 'set ylabel "f, df/dx error"'
  write ( lgp, * ) 'plot "mqle.dat" u 2:5 w l 1,"mqle.dat" u 2:8 w l -1'
  write ( lgp, * ) 'pause -1'
  write ( lgp, * ) 'set title "mq-ls : f - original and interpolated function"'
  write ( lgp, * ) 'set ylabel "f"'
  write ( lgp, * ) 'plot "mqle.dat" u 2:3 w l 1,"mqle.dat" u 2:4 w l 3,\\'
  write ( lgp, * ) '"mqle2.dat" u 2:3 w p 3'
  write ( lgp, * ) 'pause -1'
  write ( lgp, * ) 'set title "mq-ls : df/dx - original and interpolated function"'
  write ( lgp, * ) 'set ylabel "df/dx"'
  write ( lgp, * ) 'plot "mqle.dat" u 2:6 w l 1,"mqle.dat" u 2:7 w l 5,\\'
  write ( lgp, * ) '"mqle2.dat" u 2:6 w p 3'
  write ( lgp, * ) 'pause -1'
  write ( lgp, * ) 'q'

  close ( unit = lgp )

  write ( *, * ) 'starting gnuplot. hit return for new figure'

  call system ( 'gnuplot rbf_gnu_commands.txt' )

  return
end
subroutine hlsrec ( na, x, fvec, iflag )
!
!*******************************************************************************
!
!! HLSREC calculates the functions at X.
!
!
  integer, parameter :: nmax = 501
  integer, parameter :: nxtm = 1001
!
  integer na
!
  real aaa(nmax,nmax)
  real asa(nmax,nmax)
  real b(nmax)
  real c(nmax)
  real cond
  real d2fdx2
  real d2fundx
  real dfdx
  real dfundx
  real ffun
  real fun
  real fvec(na)
  real g
  real gx
  real gxc
  real g2x
  real hxt
  integer i
  integer iflag
  integer ifun
  integer ipr
  integer iprec
  integer ipvt(nmax)
  integer j
  integer k
  integer m
  integer mode
  integer n
  integer, save :: nit = 0
  integer nn
  integer nqq
  integer nxt
  real resid
  real uxk
  real w(nmax)
  real x(na)
  real xk(nmax)
  real xt(nxtm)
  real xx2
  real y(nmax)
  real z
!
  common /i_common/ ifun, m, mode, nn, nqq, nxt
  common /r_common/ aaa, asa, b, hxt, xk, xt
!
!  These BLANKING STATEMENT FUNCTIONS SHOULD NEVER NEVER BE USED!
!
! declaration operator-functions
!
  fun(z)    = ffun(ifun,z)
  dfdx(z)   = dfundx(ifun,z)
  d2fdx2(z) = d2fundx(ifun,z)

  g(j,z)  = sqrt((z-xk(j))**2+c(j)**2)

  gx(j,z)  = (z-xk(j))/sqrt((z-xk(j))**2+c(j)**2)
!
! gxc(j,z)  = -c(j)*(z-xk(j))/sqrt(((z-xk(j))**2+c(j)**2)**3)
!
  gxc(j,z)  = (z-xk(j))/sqrt(((z-xk(j))**2+c(j)**2)**3)

  g2x(j,z) =      1.0/sqrt((z-xk(j))**2+c(j)**2) &
     - (z-xk(j))**2/sqrt(((z-xk(j))**2+c(j)**2)**3)


  iprec = 1
  ipr = 0
  n = m
  nn = n
  nit = nit+1
!
!  Form a matrix using the current x = [x,c]
!
  c(1:n) = x(1:n)

  do j = 1, n
    do i = 1, n
      aaa(i,j) = g(j,xk(i))
    end do
  end do

  do i = 1, n
    y(i) = fun ( xk(i) )
  end do
!
!  Preconditioning
!
  if ( iprec /= 0 )then

    do i = 1, n
      b(i) = aaa(i,i)
    end do

    do j = 1, n
      do i = 1, n
        aaa(i,j) = aaa(i,j) / b(i)
      end do
    end do

    y(1:n) = y(1:n) / b(1:n)

  end if

  call decomp ( nmax, n, aaa, cond, ipvt, w )

! if ( nit<=20) then
!   write(45,1300) n,nxt,cond
! end if

1300  format(' hsolvc mqls: knots',i5,' points',i5, ' cond  = ',1pe15.5)

  call solve ( nmax, n, aaa, y, ipvt )
!
!  c_j related matrix block
!
  do i = 1, n

    fvec(i) = 0.0

    do k = 1, n
      uxk = 0.0
      do j = 1, n
        uxk = uxk + y(j) * gx(j,xk(k))
      end do

      fvec(i) = fvec(i) + y(i) * gxc(i,xk(k)) * (uxk-dfdx(xk(k)))

    end do

  end do

  resid = 0.0

  xx2 = sqrt ( sum ( x(1:n)**2 ) )
  resid = sqrt ( sum ( fvec(1:n)**2 ) )

  if ( nit <= 10 .or. mod ( nit, 10 ) == 0 ) then
    write(6,100)nit,na,m,xx2,resid,cond
  end if

100   format('hlsrec: nit,nn,m = ',3i4,' |x| =',1pe11.3,' resid=',1pe10.2 &
       ,' cond = ',1pe10.2)

  return
end
subroutine decomp ( ndim, n, a, cond, ipvt, work )
!
!*******************************************************************************
!
!! DECOMP computes a PLU decomposition of a matrix.
!
!
  integer ndim
  integer n
!
  real a(ndim,n)
  real anorm
  real cond
  real ek
  integer i
  integer ipvt(n)
  integer j
  integer k
  integer kb
  integer m
  real t
  real work(n)
  real ynorm
  real znorm
!
  ipvt(n) = 1

  if ( n == 1 ) then
    if ( a(1,1) /= 0.0 ) then
      cond = 1.0
    else
      cond = huge ( cond )
    end if
    return
  end if

  anorm = 0.0
  do j = 1, n
    t = sum ( abs ( a(1:n,j) ) )
    anorm = max ( anorm, t )
  end do

  do k = 1, n-1

    m = k
    do i = k+1,n
      if(abs(a(i,k)) > abs(a(m,k)))m = i
    end do

    ipvt(k) = m
    if ( m /= k ) ipvt(n) = -ipvt(n)

    call r_swap ( a(m,k), a(k,k) )

    if ( a(k,k) /= 0.0 ) then

      do i = k+1,n
        a(i,k) = -a(i,k) / a(k,k)
      end do

      do j = k+1,n

        call r_swap ( a(m,j), a(k,j) )

        if ( a(k,j) /= 0.0 ) then
          do i = k+1, n
            a(i,j) = a(i,j) + a(i,k) * a(k,j)
          end do
        end if

     end do

    end if

  end do

  do k = 1,n

    t = 0.0
    do i = 1, k-1
      t = t + a(i,k) * work(i)
    end do

    ek = 1.0
    if ( t < 0.0 ) ek = -1.0

    if ( a(k,k) == 0.0 ) then
      cond = huge ( cond )
      return
    end if

    work(k) = -(ek+t) / a(k,k)
  end do

  do k = n-1, 1, -1

    t = 0.0
    do i = k+1, n
      t = t + a(i,k) * work(k)
    end do

    work(k) = t
    m = ipvt(k)

    if ( m /= k ) then
      call r_swap ( work(m), work(k) )
    end if

  end do

  ynorm = sum ( abs ( work(1:n) ) )

  call solve ( ndim, n, a, work, ipvt )

  znorm = sum ( abs ( work(1:n) ) )

  cond = anorm*znorm/ynorm

  cond = max ( cond, 1.0 )

  return
end
subroutine solve ( ndim, n, a, b, ipvt )
!
!*******************************************************************************
!
!! SOLVE solves a linear system whose matrix has been decomposed by DECOMP.
!
!
  integer ndim
  integer n
!
  real a(ndim,n)
  real b(n)
  integer i
  integer ipvt(n)
  integer k
  integer m
!
  if ( n == 1 ) then
    b(1) = b(1) / a(1,1)
    return
  end if

  do k = 1, n-1
    m = ipvt(k)
    call r_swap ( b(m), b(k) )
    do i = k+1, n
      b(i) = b(i) + a(i,k) * b(k)
    end do
  end do

  do k = n, 2, -1

    b(k) = b(k) / a(k,k)

    do i = 1, k-1
      b(i) = b(i) - a(i,k) * b(k)
    end do

  end do

  b(1) = b(1) / a(1,1)

  return
end

