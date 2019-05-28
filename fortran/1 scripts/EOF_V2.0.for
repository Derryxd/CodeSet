cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c                                                                      c
c            EMPIRICAL ORTHOGONAL FUNCTIONS (EOF's)                    c
c                                                                      c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Last updated by YONGJIE HUANG, Mar 2, 2012.
c
c-----*----------------------------------------------------6---------7--
c     The parameters you need to change:  
c       datefname - Name of input data file;  
c	  n         - Length of time series, viz. sample size;
c       mx        - Grids in row;
c       my        - Grids in column; 
c       mnl       - Min(m,n)
c       undef     - Missing value; 
c       mg1 & mg2 - The efficient grids (output on screen) and cancel the 
c                    "stop" in line 96, try again.
c       ks        - Contral parameter:
c                     ks=-1: self, i.e., for the raw time series; 
c                     ks=0: departure, i.e., for the anomaly time series from climatological mean;
c                     ks=1: normalized departure, i.e., for the normalized time series; 
c       km        - Contral parameter:
c                     km=1: monthly or daily data.
c                     km=0: data without annual cycle.
c       nd        - The number of the months or days in a year.
c     ------------------------------------------------------------------
c     Output:
c       er.txt    - Ascii file with EOF eigenvalues, accumulated eigenvalues, 
c                   explained variances and accumulated explained variances.
c       egvt.dat  - Binary file with eigenvactors matrix of EOF.
c       ecof.dat  - Binary file with time coefficients matrix of EOF.
c       egvt.ctl  - Control file for 'egvt.dat'.
c       ecof.ctl  - Control file for 'ecof.dat'.
c    
c-----*----------------------------------------------------6---------7--
      program main
	character*80,parameter :: datafname='precip.dec.mean.dat'
	parameter(n=31,mx=8,my=11,m=mx*my,mnl=n)
	parameter(undef=-9.99e+08,mg1=mx*my,mg2=mx*my)
      parameter(ks=0,km=0,nd=1,std=1e-6)
!-----input array
      dimension f0(n,m)
!-----work arrays
      dimension f1(n,mg1),f2(n,mg1),g(mg1),h1(mg1,n),h2(mg1,n)
	dimension f(mg2,n),gvt(mg2,mnl),cof(mnl,n)	
!-----output arrays
      dimension er(mnl,4),egvt(m,mnl),ecof(mnl,n)

c-----Read data.
      open(20,file=datafname,form='unformatted',
     &	access='direct',recl=m)
 	do j=1,n
	  read(20,rec=j)(f0(j,i),i=1,m) 
 	end do
	close(20)
	write(*,*)'Read data OK!'
c-----Remove the terrain or missing value.
      l1=0
	do j=1,m
	  if(f0(1,j).ne.undef)then
          l1=l1+1
	    do k=1,n
            f1(k,l1)=f0(k,j)
	    enddo
	  endif
	enddo
      write(*,*)'Grids without terrain:'
	write(*,*)'mg1=',l1
c-----Remove annual cycle.
      if(km.eq.1)then
	  ny=n/nd	  
	  do i=1,l1
	    call initial(nd,ny,n,f1(1,i),f2(1,i))
	  end do 	
	  do i=1,l1
	    do k=1,n
	      f1(k,i)=f2(k,i)
	    end do
	  end do
	end if
c-----Remove the grids whose variance equal to zero.
	l2=0
	do i=1,l1
	  call meanvar(n,f1(1,i),ax,g(i),vx)	
	  if(g(i).gt.std)then
          l2=l2+1
	    do k=1,n
            f(l2,k)=f1(k,i)
	    enddo
	  endif
	end do
	write(*,*)'Grids without terrain and constant value:'
	write(*,*)'mg2=',l2
     
c     stop

c-----Call the subroutine.
      write(*,*)'!!!!'
      call eof(l2,n,mnl,f(1:l2,:),ks,er,gvt(1:l2,:),ecof)
	write(*,*)'EOF ok and transform to the original form in the next!'
c-----Add the grids whose variance equal to zero.      
	l3=0
	do i=1,mg2
	  if(g(i).gt.std)then
	    l3=l3+1
	    do k=1,mnl
	      h1(i,k)=gvt(l3,k) 
	    end do	
	  else
	    do k=1,mnl
	      h1(i,k)=undef
	    end do
	  endif
	enddo
c-----Add the terrain or missing value.
	l4=0
	do i=1,m
	  if(f0(1,i).ne.undef)then
	    l4=l4+1
	    do k=1,mnl
	      egvt(i,k)=h1(l4,k)
	    end do
	  else
	    do k=1,mnl
	      egvt(i,k)=undef
	    end do
	  endif
	enddo
c-----output the result.        
c-----output the error.
      write(*,*)'Output the results:'
	open(10,file='er.txt',form='formatted')
c
      write(10,*)'EOF lamda (eigenvalues) from big to small'
	write(10,*)(er(i,1),i=1,mnl)
	write(*,*)' OK: EOF lamda (eigenvalues) from big to small!'
c
	write(10,*)'EOF accumulated eigenvalues from big to small'
	write(10,*)(er(i,2),i=1,mnl)
	write(*,*)' OK: accumulated eigenvalues from big to small!'
c
	write(10,*)'EOF explained variances'
	write(10,*)(er(i,3),i=1,mnl)
	write(*,*)' OK: EOF explained variances!'
c
	write(10,*)'EOF accumulated explained variances'
	write(10,*)(er(i,4),i=1,mnl)
	write(*,*)' OK: EOF accumulated explained variances!'
c
	close(10)
c-----output eigenvactors matrix of EOF.
      open(11,file='egvt.dat',status='unknown'
     &,form='unformatted',access='direct',recl=mx*my)	
	do j=1,mnl
	  write(11,rec=j)(egvt(i,j),i=1,m)
	end do
      write(*,*)' OK: output eigenvactors matrix of EOF!'
	close(11)
c-----output time coefficients matrix of EOF.
      open(12,file='ecof.dat',status='unknown'
     &,form='unformatted',access='direct',recl=mnl)
      do i=1,n
	  write(12,rec=i)(ecof(j,i),j=1,mnl)
	end do
      write(*,*)' OK: output time coefficients matrix of EOF!'
	close(12)
      write(*,*)'EOF all OK!' 	
c-----create control files(.ctl) for 'egvt.dat' and 'ecof.dat'
      write(*,*) 'Create ''.ctl'' files for ''.dat'' files: '
      open(13,file='egvt.ctl',form='formatted')
	write(13,*) 'dset ^egvt.dat'
	write(13,*) 'undef ',undef
	write(13,*) 'xdef ',mx,' linear  88.75 2.5'
	write(13,*) 'ydef ',my,' linear  3.75 2.5'
	write(13,*) 'zdef 1 linear 0 1'
	write(13,*) 'tdef ',mnl,' linear DEC1979 1yr'
	write(13,*) 'vars 1'
	write(13,*) 'egvt  0  99  eigenvactors matrix of EOF'
	write(13,*) 'endvars'
	close(13)
	write(*,*) ' OK: ''egvt.ctl'' is created!'
c
      open(14,file='ecof.ctl',form='formatted')
	write(14,*) 'dset ^ecof.dat'
	write(14,*) 'undef ',undef
	write(14,*) 'xdef ',mnl,' linear 0 1'
	write(14,*) 'ydef 1 linear 0 1'
	write(14,*) 'zdef 1 linear 0 1'
	write(14,*) 'tdef ',n,' linear DEC1979 1yr'
	write(14,*) 'vars 1'
	write(14,*) 'ecof  0  99  eigenvactors matrix of EOF'
	write(14,*) 'endvars'
	close(14)
	write(*,*) ' OK: ''ecof.ctl'' is created!'
c	
	write(*,*) 'All are finished successfully!'	
		     
	stop
c-----
	end

c=======================================================================
c
c=======================================================================

c-----------------------------------------------------------------------
c                      eof(m,n,mnl,f,ks,er,egvt,ecof)
c                  --------------------------------------
c                  经验正交函数(EOF)-特征向量场及时间系数
c-----*----------------------------------------------------6---------7--
C     EMPIRICAL ORTHOGONAL FUNCTIONS (EOF's)
c     This subroutine applies the EOF approach to analysis time series 
c       of meteorological field f(m,n).
c     input: m,n,mnl,f(m,n),ks
c       m: number of grid-points
c       n: lenth of time series
c       mnl=min(m,n)
c       f(m,n): the raw spatial-temporal seires
c       ks: contral parameter
c           ks=-1: self, i.e., for the raw time series; 
c           ks=0: departure, i.e., for the anomaly time series from climatological mean;
c           ks=1: normalized departure, i.e., for the normalized time series; 
c     output: egvt,ecof,er
c       egvt(m,mnl): array of eigenvactors
c       ecof(mnl,n): array of time coefficients for the respective eigenvectors
c       er(mnl,1): lamda (eigenvalues), its sequence is from big to small.
c       er(mnl,2): accumulated eigenvalues from big to small
c       er(mnl,3): explained variances (lamda/total explain) from big to small
c       er(mnl,4): accumulated explaned variances from big to small
c     work variables:

c     Last updated by Yongjie HUANG on January 4, 2012
c     Dr. Jianping Li on October 20, 2005.

c     Citation: Li, J., 2005: EOF subroutine, http://web.lasg.ac.cn/staff/ljp/subroutine/EOF.f.

c-----
      subroutine eof(m,n,mnl,f,ks,er,egvt,ecof)
      dimension f(m,n),er(mnl,4),egvt(m,mnl),ecof(mnl,n)
      dimension cov(mnl,mnl),s(mnl,mnl),d(mnl),v(mnl) !work array
c---- Preprocessing data
      call transf(m,n,f,ks)
c---- Crossed product matrix of the data f(m,n)
      call crossproduct(m,n,mnl,f,cov)
c---- Eigenvalues and eigenvectors by the Jacobi method 
      call jacobi(mnl,cov,s,d,0.00001)
c---- Specified eigenvalues 
      call arrang(mnl,d,s,er)
c---- Normalized eignvectors and their time coefficients 
      call tcoeff(m,n,mnl,f,s,er,egvt,ecof)
      return
      end
c-----------------------------------------------------------------------
c
c-----------------------------------------------------------------------	  

c-----------------------------------------------------------------------
c                           transf(m,n,f,ks)
c                    ------------------------------
c                    处理资料为距平、标准方差或不变      	  
c-----*----------------------------------------------------6---------7--
c     Preprocessing data to provide a field by ks.
c     input: m,n,f
c       m: number of grid-points
c       n: lenth of time series
c       f(m,n): the raw spatial-temporal seires
c       ks: contral parameter
c           ks=-1: self, i.e., for the raw time series; 
c           ks=0: departure, i.e., for the anomaly time series from climatological mean;
c           ks=1: normalized departure, i.e., for the normalized time series; 
c     output: f
c       f(m,n): output field based on the control parameter ks.
c     work variables: fw(n)
      subroutine transf(m,n,f,ks)
      dimension f(m,n)
      dimension fw(n),wn(m)           !work array
c
	i0=0
	do i=1,m
	  do j=1,n
          fw(j)=f(i,j)
        enddo
	  call meanvar(n,fw,af,sf,vf)
	  if(sf.eq.0.)then
	    i0=i0+1
	    wn(i0)=i
	  endif
	enddo
c
	if(i0.ne.0)then
	  write(*,*)'****  FAULT  ****'
	  write(*,*)' The program cannot go on because 
     *the original field has invalid data.'
	  write(*,*)' There are totally ',i0,
     *    '  gridpionts with invalid data.'
     	  write(*,*)' These invalid data are those whose standard variance 
     *equal zero.'
     	  write(*,*)' The array WN stores the positions of those invalid 
     *grid-points. You must pick off those invalid data from the orignal
     *field and then reinput a new field to calculate its EOFs.'   
	  write(*,*)'****  FAULT  ****'
	  stop
	endif	    
c
c
      if(ks.eq.-1)return
c
      if(ks.eq.0)then                !anomaly of f
        do i=1,m
          do j=1,n
            fw(j)=f(i,j)
          enddo
          call meanvar(n,fw,af,sf,vf)
          do j=1,n
            f(i,j)=f(i,j)-af
          enddo
        enddo
        return
      endif
c
      if(ks.eq.1)then                 !normalizing f
        do i=1,m
          do j=1,n
            fw(j)=f(i,j)
          enddo
          call meanvar(n,fw,af,sf,vf)
          do j=1,n
            f(i,j)=(f(i,j)-af)/sf
          enddo
        enddo
      endif
      return
      end
c-----------------------------------------------------------------------
c
c-----------------------------------------------------------------------


c-----------------------------------------------------------------------
c                      crossproduct(m,n,mnl,f,cov)
c                      ---------------------------
c                              计算交叉矩阵
c-----*----------------------------------------------------6---------7--
c     Crossed product martix of the data. It is n times of 
c       covariance matrix of the data if ks=0 (i.e. for anomaly). 
c     input: m,n,mnl,f
c       m: number of grid-points
c       n: lenth of time series
c       mnl=min(m,n)
c       f(m,n): the raw spatial-temporal seires
c     output: cov(mnl,mnl)  
c       cov(m,n)=f*f' or f'f dependes on m and n.
c         It is a mnl*mnl real symmetric matrix.
      subroutine crossproduct(m,n,mnl,f,cov)
      dimension f(m,n),cov(mnl,mnl)

	if(n-m<0) then
        do i=1,mnl
		do j=i,mnl
		  cov(i,j)=0.0
            do is=1,m
			 cov(i,j)=cov(i,j)+f(is,i)*f(is,j)
            enddo
          cov(j,i)=cov(i,j)
	    end do
	  end do
        return
	else
        do i=1,mnl
		 do j=i,mnl
             cov(i,j)=0.0
		   do js=1,n
			  cov(i,j)=cov(i,j)+f(i,js)*f(j,js)
             enddo
           cov(j,i)=cov(i,j)
		 end do
	  end do
        return
	end if
      end
c-----------------------------------------------------------------------
c
c-----------------------------------------------------------------------


c-----------------------------------------------------------------------
c                           jacobi(m,a,s,d,eps)
c                ------------------------------------------         
c                使用雅克比过关法计算矩阵的特征向量和特征值
c-----*----------------------------------------------------6---------7--
c     Computing eigenvalues and eigenvectors of a real symmetric matrix
c       a(m,m) by the Jacobi method.
c     input: m,a,s,d,eps 
c       m: order of matrix
c       a(m,m): the covariance matrix
c       eps: given precision
c     output: s,d 
c       s(m,m): eigenvectors
c       d(m): eigenvalues
      subroutine jacobi(m,a,s,d,eps)
      dimension a(m,m),s(m,m),d(m)

c-----使s(m,m)为单位矩阵E
      do i=1,m
       do j=1,i
        if(i-j==0) then
	     s(i,j)=1.
	  else
		 s(i,j)=0.
		 s(j,i)=0.
	  end if
	 end do
	end do
c-----计算m阶实对称矩阵a(m,m)的所有非对角线元素平方之和的平方根
      g=0.
      do i=2,m
        i1=i-1
        do j=1,i1
          g=g+2.*a(i,j)*a(i,j)
	  end do
	end do
      s1=sqrt(g)
c-----设置关口s3
      s2=eps/float(m)*s1
      s3=s1
      l=0
  50  s3=s3/float(m)
c-----在非对角线元素中逐行扫描选取第一个绝对值大于或等于s3的元素a(ip,iq),
c-----进行平面旋转变换，直到所有非对角线元素的绝对值都小于s3为止.
  60  do 130 iq=2,m
        do 130 ip=1,iq-1
		  if(abs(a(ip,iq)).lt.s3) goto 130
		  l=1
		  v1=a(ip,ip)
		  v2=a(ip,iq)
		  v3=a(iq,iq)
		  u=0.5*(v1-v3)
		  if(u.eq.0.0) g=1.
		  if(abs(u).ge.1e-10) g=-sign(1.,u)*v2/sqrt(v2*v2+u*u)
		  st=g/sqrt(2.*(1.+sqrt(1.-g*g)))
		  ct=sqrt(1.-st*st)

		  do i=1,m
			g=a(i,ip)*ct-a(i,iq)*st
		    a(i,iq)=a(i,ip)*st+a(i,iq)*ct
	     	a(i,ip)=g

			g=s(i,ip)*ct-s(i,iq)*st
			s(i,iq)=s(i,ip)*st+s(i,iq)*ct
			s(i,ip)=g
		  end do

		  do i=1,m
			 a(ip,i)=a(i,ip)
			 a(iq,i)=a(i,iq)
		  end do

		  g=2.*v2*st*ct
		  a(ip,ip)=v1*ct*ct+v3*st*st-g
		  a(iq,iq)=v1*st*st+v3*ct*ct+g
            a(ip,iq)=(v1-v3)*st*ct+v2*(ct*ct-st*st)
            a(iq,ip)=a(ip,iq)
  130 continue
c-----平面旋转变换，直到所有非对角线元素的绝对值都小于s3为止.	
      if(l-1==0) then
        l=0
        go to 60
	else
	  if(s3.gt.s2) goto 50 !再设置下一关口
	end if
c
      do i=1,m
        d(i)=a(i,i)
	end do

      return
      end
c-----------------------------------------------------------------------
c
c-----------------------------------------------------------------------


c-----------------------------------------------------------------------
c                            arrang(mnl,d,s,er)
c   ----------------------------------------------------------------
c   重新由大到小排列及计算特征值、累积特征值、解释方差及累积解释方差
c-----*----------------------------------------------------6---------7--
c     Provides a series of eigenvalues from maximuim to minimuim.
c     input: mnl,d,s
c       d(mnl): eigenvalues 
c       s(mnl,mnl): eigenvectors
c     output: er
c       er(mnl,1): lamda (eigenvalues), its equence is from big to small.
c       er(mnl,2): accumulated eigenvalues from big to small
c       er(mnl,3): explained variances (lamda/total explain) from big to small
c       er(mnl,4): accumulated explaned variances from big to small
      subroutine arrang(mnl,d,s,er)
      dimension d(mnl),s(mnl,mnl),er(mnl,4)
c
      tr=0.0
      do i=1,mnl
        tr=tr+d(i)
        er(i,1)=d(i)
      end do
c-----由大到小排列特征值及将对应的特征向量做相应的移动
      mnl1=mnl-1
      do k1=mnl1,1,-1
       do k2=k1,mnl1
        if(er(k2,1).lt.er(k2+1,1)) then
          c=er(k2+1,1)
          er(k2+1,1)=er(k2,1)
          er(k2,1)=c
          do i=1,mnl
            c=s(i,k2+1)
            s(i,k2+1)=s(i,k2)
            s(i,k2)=c
		end do
        endif
	 end do
	end do
c-----计算累积特征值
      er(1,2)=er(1,1)
      do i=2,mnl
        er(i,2)=er(i-1,2)+er(i,1)
      end do
c-----计算解释方差及累积解释方差
      do i=1,mnl
        er(i,3)=er(i,1)/tr
        er(i,4)=er(i,2)/tr
	end do
c
      return
      end
c-----------------------------------------------------------------------
c
c-----------------------------------------------------------------------

c-----------------------------------------------------------------------
c                   tcoeff(m,n,mnl,f,s,er,egvt,ecof)
c                   --------------------------------
c                       归一化特征向量和时间系数
c-----*----------------------------------------------------6---------7--
c     Provides standard eigenvectors and their time coefficients
c     input: m,n,mnl,f,s,er
c       m: number of grid-points
c       n: lenth of time series
c       mnl=min(m,n)
c       f(m,n): the raw spatial-temporal seires
c       s(mnl,mnl): eigenvectors
c       er(mnl,1): lamda (eigenvalues), its equence is from big to small.
c       er(mnl,2): accumulated eigenvalues from big to small
c       er(mnl,3): explained variances (lamda/total explain) from big to small
c       er(mnl,4): accumulated explaned variances from big to small
c     output: egvt,ecof
c       egvt(m,mnl): normalized eigenvectors
c       ecof(mnl,n): time coefficients of egvt 
      subroutine tcoeff(m,n,mnl,f,s,er,egvt,ecof)
      dimension f(m,n),s(mnl,mnl),er(mnl,4),egvt(m,mnl),ecof(mnl,n)
      dimension v(mnl)  !work array
c
      do j=1,mnl
        do i=1,m
          egvt(i,j)=0.
        enddo
        do i=1,n
          ecof(j,i)=0.
        enddo
      enddo
c-----Normalizing the input eignvectors s
      do j=1,mnl
        c=0.
        do i=1,mnl
          c=c+s(i,j)*s(i,j)
        enddo
        c=sqrt(c)
        do i=1,mnl
          s(i,j)=s(i,j)/c
        enddo
      enddo
c-----
      if(m.le.n) then

        do js=1,mnl
		do i=1,m
		 egvt(i,js)=s(i,js)
		enddo
        enddo

        do j=1,n
          do i=1,m
            v(i)=f(i,j)
          enddo

          do is=1,mnl
		 do i=1,m
		   ecof(is,j)=ecof(is,j)+v(i)*s(i,is)
		 enddo
          enddo
	  enddo

      else
c-----这里使用了时空转换，时间系数得乘以sqrt(abs(er(js,1))，特征向量除以sqrt(abs(er(js,1))
        do i=1,m
          do j=1,n
            v(j)=f(i,j)
          enddo
          do js=1,mnl
		 do j=1,n
            egvt(i,js)=egvt(i,js)+v(j)*s(j,js)
		 enddo
          enddo
	  enddo

        do js=1,mnl
          do j=1,n
            ecof(js,j)=s(j,js)*sqrt(abs(er(js,1)))
          enddo
          do i=1,m
            egvt(i,js)=egvt(i,js)/sqrt(abs(er(js,1)))
          enddo
	  enddo

      endif

      return
      end
c-----------------------------------------------------------------------
c
c-----------------------------------------------------------------------
	  
c-----------------------------------------------------------------------
c	                     meanvar(n,x,ax,sx,vx)
c                      -------------------------------
c                       计算矩阵的平均值、标准差和方差
c-----*----------------------------------------------------6---------7--
c     Computing the mean ax, standard deviation sx
c       and variance vx of a series x(i) (i=1,...,n).
c     input: n and x(n)
c       n: number of raw series
c       x(n): raw series
c     output: ax, sx and vx
c       ax: the mean value of x(n)
c       sx: the standard deviation of x(n)
c       vx: the variance of x(n)
c     By Dr. LI Jianping, May 6, 1998.
      subroutine meanvar(n,x,ax,sx,vx)
      dimension x(n)
      ax=0.
      vx=0.
      sx=0.
c     calculate the mean value of x(n): ax
      do i=1,n
        ax=ax+x(i)
	end do
      ax=ax/float(n)
c     calculate the standard deviation of x(n): sx
      do i=1,n
        vx=vx+(x(i)-ax)**2
	end do
      vx=vx/float(n)
c     calculate	the variance of x(n): vx  
      sx=sqrt(vx)
      return
      end
c-------------------------------------------------------------------------
c
c-------------------------------------------------------------------------
c-----*----------------------------------------------------6---------7--
c     This subroutine is for removing annual cycle (Monthly of daily data)
c     
c     input:
c       nd: number of days or monthes in a year. 
c       ny: number of year
c       ndy=nd*ny
c       f(ndy): the daily of monthly data.
c
c     output:
c       af(ndy): the daily of monthly data without annual cycle
c
c     by Dr Jianping Li,  
c     recomplied by Dong Xiao on May 7, 2007
c-----
      subroutine initial(nd,ny,ndy,f,af)
!-----input array
	real f(ndy)
!-----work arrays
	real fave(nd),fstd(nd)
!-----output array
	real af(ndy)
c-----
	do i=1,nd
	  fave(i)=0.
	  do j=1,ny
	    fave(i)=fave(i)+f(i+(j-1)*nd)
	  enddo
	  fave(i)=fave(i)/ny
	  fstd(i)=0.0
	  do j=1,ny
	    fstd(i)=fstd(i)+(f(i+(j-1)*nd)-fave(i))**2
	  enddo
	  fstd(i)=sqrt(fstd(i)/float(ny))
	  do j=1,ny
	    ij=i+(j-1)*nd
c-----standard departure
c	    af(ij)=(f(ij)-fave(i))/fstd(i)
c-----departure
	af(ij)=(f(ij)-fave(i))
	  enddo
	enddo
c-----
	return
	end
c-----*----------------------------------------------------6---------7--
c
c-----------------------------------------------------------------------