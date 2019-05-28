Subroutine read_rain_nc(rfile,lat,lon,RAIN)
implicit none
include 'netcdf.inc'            ！这里用到了netcdf库
integer,parameter :: nx=720,ny=361,nt=4
integer ncid,ierr,varidx,varidy,varid,err
character(len=50) rfile
real*4 lat(ny),lon(nx),RAIN(nx,ny,nt)

ierr=NF_OPEN(trim(rfile),NF_NOWRITE,ncid)
ierr=NF_INQ_VARID(ncid,'longitude',varidx)
ierr=NF_INQ_VARID(ncid,'latitude',varidy)
ierr=NF_GET_VAR_REAL(ncid,varidx,lon)
ierr=NF_GET_VAR_REAL(ncid,varidy,lat)
ierr=NF_INQ_VARID(ncid,'APCP_surface',varid)
ierr=NF_GET_VAR_REAL(ncid,varid,RAIN)
! print *,RAIN(1,1,1),RAIN(720,361,4)
err=NF_CLOSE(ncid)
end subroutine read_rain_nc