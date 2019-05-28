
!1 用NCEP  2.5分辨率逐日资料西太副高的5个特征指数，一天一个指数
!2 GM 面积指数，GQ 面积指数，GJ 西脊点指数，GX 脊线指数，GB 北界点指数
program fg_zhishu
implicit none
	integer,Parameter::x=145,y=73,yr=？,mo=365
	integer,Parameter::lon1=37,lon2=73,lat10=41,lat80=69  ! lat10--北纬10度，lat80--北纬80度，LON1--东经90，LON2--东经180 
	integer i,j,t,m,tem,tt,n,s,kr,kkr
	real h(x,y,mo,yr),fgm(x,y,mo,yr),fg(x,y,mo,yr),n588(x,mo,yr),s588(x,mo,yr
	real gm1(mo,yr),gq2(mo,yr),gj3(mo,yr),gx4(mo,yr),gb5(mo,yr)

	real a,b,c,d,e,f,nn,ch,du
!读取多个文件
	character(len=4) :: year
	character(len=1) :: index

	open(10,file='XXXXX\XX.grd',form='binary')
		read(10) ((((h(i,j,m,t),i=1,x),j=1,y),m=1,mo),t=1,yr)
	close(10)

!!!!!!!!!!!!!!!!!!!!!!!  判断副高的范围 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	do t=1,yr
		do m=1,mo
		!588线南界
			do i=lon1,lon2
				s588(i,m,t)=0.0
				do j=lat10,lat80
					if((h(i,j,m,t)/10.0>=588.0) .and. (h(i,j+1,m,t)/10.0>=588.0))then
						s588(i,m,t)=j		
						exit
					end if
				end do
			end do
		!588线北界
			do i=lon1,lon2
				n588(i,m,t)=0.0
				do j=lat80,lat10,-1
					if((h(i,j,m,t)/10.0>=588.0) .and. (h(i,j-1,m,t)/10.0>=588.0))then
						n588(i,m,t)=j
						exit
					end if
				end do
			end do
			do i=lon1,lon2
		!副高分布	
				if(s588(i,m,t)/=0)then
					do j=s588(i,m,t),lat80
						fgm(i,j,m,t)=0.0;fg(i,j,m,t)=0.0
						if(h(i,j,m,t)/10.0>=588.0)then					
							fgm(i,j,m,t)=1
							fg(i,j,m,t)=h(i,j,m,t)
						end if				
					end do
				end if
			end do
		end do
	end do

!!!!!!!!!!!!!!!!!!!!!!!! 1面积指数 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	do t=1,yr
		do m=1,mo
			gm1(m,t)=0.0
			do i=lon1,lon2
				if(s588(i,m,t)/=0)then
					do j=s588(i,m,t),n588(i,m,t)
						if((h(i,j,m,t)/10.0>=588.0))then
							gm1(m,t)=gm1(m,t)+1
						end if
					end do
				end if
			end do
		end do
	end do
	print*, 'ok gm1'	

!!!!!!!!!!!!!!!!!!!!!!!! 2强度指数 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	do t=1,yr
		do m=1,mo
			gq2(m,t)=0.0
			do i=lon1,lon2
				if(s588(i,m,t)/=0)then
					do j=s588(i,m,t),n588(i,m,t)
						if((h(i,j,m,t)/10.0>=588.0))then
							gq2(m,t)=gq2(m,t)+(h(i,j,m,t)/10.0-587.0)
						end if
					end do
				end if
			end do
		end do
	end do
	print*, 'ok gq2'
!!!!!!!!!!!!!!!!!!!!!!!!3 西脊点指数!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	do t=1,yr
		do m=1,mo     
			gj3(m,t)=0.0;tt=0
			do i=lon1,lon2
				do j=lat10,lat80
					if(h(i,j,m,t)/10.0>=588 .and. h(i+1,j,m,t)/10.0>=588)then
						tt=i
						exit			
					end if
				end do
				if(tt/=0)then
					exit
				end if	
			end do
			gj3(m,t)=(tt-1)*2.5
			if(gj3(m,t)<=0)then
				gj3(m,t)=180
			end if
		end do
	end do
	print*, 'ok gj3'
!!!!!!!!!!!!!!!!!!!!!!!! 4 脊线位置指数 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	do t=1,yr
		do m=1,mo
			gx4(m,t)=0.0;tt=0
			do i=lon1,lon2
				if(n588(i,m,t)/=0 .and. s588(i,m,t)/=0)then
					tt=tt+1
					gx4(m,t)=gx4(m,t)+(n588(i,m,t)+s588(i,m,t))/2.0
				end if
			end do
			if(gx4(m,t)/=0)then
				gx4(m,t)=(gx4(m,t)-1)/float(tt)*2.5-90.0
			end if
		end do	
	end do
	print*, 'ok gx4'
!!!!!!!!!!!!!!!!!!!!!!!! 5 北界位置指数 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!	
	do t=1,yr
		do m=1,mo
			gb5(m,t)=0.0;tt=0
			do i=lon1,lon2
				if(n588(i,m,t)/=0.0)then
					tt=tt+1
					gb5(m,t)=gb5(m,t)+n588(i,m,t)			
				end if		
			end do
			if(gb5(m,t)/=0)then
				gb5(m,t)=(gb5(m,t)-1)/float(tt)*2.5-90.0
			end if
		end do
	end do
	print*, 'ok gb5'

!!!!!!!!!!!!!!!!!!!!!!!! 输出结果 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!循环输出文件    可根据需要输出数据
	do t =1,yr
		write( year,'(i4)' ) t+1977                !change 1977为其实年份-1
		write(*,*) t+1977,year                     !!change
		open (9,file='D:\study\wpsh\data\ind\'//trim(adjustl(year))//'.1.grd',form='binary',status='replace')
			do m=1,mo
				write(9) gm1(m,t)
			end do
		close(9)
		open (9,file='D:\study\wpsh\data\ind\'//trim(adjustl(year))//'.2.grd',form='binary',status='replace')
			do m=1,mo		
				write(9) gq2(m,t)
			end do
		close(9)
		open (9,file='D:\study\wpsh\data\ind\'//trim(adjustl(year))//'.3.grd',form='binary',status='replace')
			do m=1,mo
				write(9) gj3(m,t)
			end do
		close(9)
		open (9,file='D:\study\wpsh\data\ind\'//trim(adjustl(year))//'.4.grd',form='binary',status='replace')
			do m=1,mo
				write(9) gx4(m,t)
			end do
		close(9)
		open (9,file='D:\study\wpsh\data\ind\'//trim(adjustl(year))//'.5.grd',form='binary',status='replace')
			do m=1,mo
				write(9) gb5(m,t)
			end do
		close(9)

	end do



end program