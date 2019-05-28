	!---Longitude(����),Latitude(γ��)
	program main
		implicit none	
		integer*4, parameter	::	lats=73, lons=144			!γ����,������
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
	
	!�ж�����
	function is_leap_year(year)
		logical*4	::	is_leap_year
		integer*4	::	year
	
		is_leap_year = .false.
		if((mod(year,400)==0).or.((mod(year,4)==0).and.(mod(year,100)/=0))) then
			is_leap_year = .true.
		end if
	end function
	
	!��ȡÿ�������
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
		!---��ȡĳһ��߶ȳ�����
		include		'netcdf.inc'
		
		real*4, parameter		::	add_offset=117965.0, scale_factor=1.0				!ƫ����,�Ŵ�ϵ��
		integer*4, parameter	::	missing_value=32766, lats=73, lons=144, levs=17			!ȱ��ֵ,γ����,������,�߶ȳ�����           
		integer*4				::	ncid,status,slp
		character*4				::	year_str
		character*200			::	in_file_str
		character*200			::	out_file_str
		integer*4				::	year,days
		integer*4				::	i,j,l		!---
		real*4,allocatable		::	tmp(:,:,:)	!��̬���飬��δ����ؼ�,ʵ���ݵ��������ӳ���ռ䣬��һ������
		integer*4				::	get_days_of_year
		
		days = get_days_of_year(year)
		allocate(tmp(lons,lats,days))  !����̬�������ؼ���lon:0~357.5;lat:90~-90;lev:1~17;day:1~365
		
	
		!������Ҫ��ȡ��nc�ļ����ļ���
		write(year_str,'(i4)')year
		in_file_str = 'e:\work\data\slp\slp.'//year_str//'.nc'		
			
		!----------��netcdf����------------------------------------------------
		status=nf_open(trim(in_file_str),nf_nowrite,ncid)   !��nc
		if(status/=nf_noerr) call handle_nc_err(status)
		
		status=nf_inq_varid(ncid,'slp',slp)	!��ȡ������Ϣ
		if(status/=nf_noerr) call handle_nc_err(status)
		
		status = nf_get_var_real(ncid,slp,tmp) !---��ȡ����
		if(status/=nf_noerr) call handle_nc_err(status)
		
		status=nf_close(ncid)   ! �ر�nc
		if(status/=nf_noerr) call handle_nc_err(status)

		!-------------------------------------------------------------------------
		!�������ݵ�����
		do l = 1,days !---������ѭ��
			do j = 1,lats !---��γ�ȸ���ѭ��
				do i = 1,lons !---�Ծ��ȸ���ѭ��
					tmp(i,j,l)=tmp(i,j,l)*scale_factor+add_offset				
				enddo
			enddo
		enddo
		
	end subroutine

!------------------netcdf��������-------------------------------------------
	subroutine handle_nc_err(status)
		integer status
		write(*,*)'Netcdf Process Error!'
	end subroutine