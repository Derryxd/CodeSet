	!---Longitude(经度),Latitude(纬度)
	program main
		implicit none	
		integer*4, parameter	::	lats=73, lons=144			!纬度数,经度数
		integer*4, parameter	::	start_year=1948, end_year=2009, years=62	
		integer*4				::	iyear
		integer*4				::	get_days_of_year, days
		
		external is_leap_year
		external get_days_of_year
		do iyear=start_year,end_year
			call read_data(iyear)
			write(*,*) iyear," OK!"
		enddo			
		print *,"Success!"				
		pause
	end program main
	
	!判断闰年
	function is_leap_year(year)
		logical*4	::	is_leap_year
		integer*4	::	year
	
		is_leap_year = .false.
		if((mod(year,400)==0).or.((mod(year,4)==0).and.(mod(year,100)/=0))) then
			is_leap_year = .true.
		end if
	end function
	
	!求取每年的天数
	function get_days_of_year(year)
		integer*4	::	get_days_of_year
		logical*4	::	is_leap_year
		if(is_leap_year(year)) then
			get_days_of_year = 366
		else
			get_days_of_year = 365
		end if
	end function
	
	subroutine read_data(year) 
		implicit none
		!---读取某一层高度场数据
		include		'netcdf.inc'
		
		real*4, parameter		::	add_offset=117965.0, scale_factor=1.0				!偏移量,放大系数
		integer*4, parameter	::	missing_value=32766, lats=73, lons=144, levs=17			!缺测值,纬度数,经度数,高度场层数           
		integer*4				::	ncid,status,slp
		character*4				::	year_str
		character*200			::	in_file_str
		character*200			::	out_file_str
		integer*4				::	year,days
		integer*4				::	i,j,l		!---
		real*4,allocatable		::	tmp(:,:,:)	!动态数组，尚未分配控件,实传递到读数据子程序空间，读一年数据
		integer*4				::	get_days_of_year
		
		days = get_days_of_year(year)
		allocate(tmp(lons,lats,days))  !给动态数组分配控件，lon:0~357.5;lat:90~-90;lev:1~17;day:1~365
		
	
		!生成所要读取的nc文件的文件名
		write(year_str,'(i4)')year
		in_file_str = 'e:\work\data\slp\slp.'//year_str//'.nc'		
			
		!----------读netcdf数据------------------------------------------------
		status=nf_open(trim(in_file_str),nf_nowrite,ncid)   !打开nc
		if(status/=nf_noerr) call handle_nc_err(status)
		
		status=nf_inq_varid(ncid,'slp',slp)	!获取变量信息
		if(status/=nf_noerr) call handle_nc_err(status)
		
		status = nf_get_var_real(ncid,slp,tmp) !---读取变量
		if(status/=nf_noerr) call handle_nc_err(status)
		
		status=nf_close(ncid)   ! 关闭nc
		if(status/=nf_noerr) call handle_nc_err(status)

		!-------------------------------------------------------------------------
		!生成数据到数组
		do l = 1,days !---对天数循环
			do j = 1,lats !---对纬度格数循环
				do i = 1,lons !---对经度格数循环
					tmp(i,j,l)=tmp(i,j,l)*scale_factor+add_offset				
				enddo
			enddo
		enddo
		
	end subroutine

!------------------netcdf错误处理函数-------------------------------------------
	subroutine handle_nc_err(status)
		integer status
		write(*,*)'Netcdf Process Error!'
	end subroutine