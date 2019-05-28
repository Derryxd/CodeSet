#! /bin/csh -fx


#set start_time = "2015032900" 

set start_time =  $1

set operationtop = "/home/disk5/Grib2-EDFF"

set timedir = "/home/ranlk/newwrf/WRFDA/var/da"

set up_dir = "${operationtop}/GFS"

set work_dir = "${operationtop}/GFS/$start_time"

if(-d ${work_dir} ) then
else
mkdir -p ${work_dir}
endif

set end_time = 0

set time_inc = 900 

set time = 0

set counter = 0

set counter0 = 0

set counter1 = 0

set counter2 = 1

set delta_time = 0

set delta_time0 = 0

set delta_time1 = 0

@ delta_time = $counter * $time_inc / 60

set initial_time = `$timedir/da_advance_time.exe ${start_time} ${delta_time}m -f ccyy-mm-dd.hh:nn:ss`
echo 'rlk0 '$initial_time''

set dirmonth =	`$timedir/da_advance_time.exe ${start_time} ${delta_time}m -f ccyymm`
set dirdate =	`$timedir/da_advance_time.exe ${start_time} ${delta_time}m -f ccyymmdd`

set dirtime =	`$timedir/da_advance_time.exe ${start_time} ${delta_time}m -f ccyymmddhh`
set hr =	`$timedir/da_advance_time.exe ${start_time} ${delta_time}m -f hh`
echo 'rlk1 '$dirtime''

set timestring = `$timedir/da_advance_time.exe ${start_time} ${delta_time}m -f ccyymmddhh_nn`

@ delta_time0 = $delta_time + 480
set timestring0 = `$timedir/da_advance_time.exe ${start_time} ${delta_time0}m -f ccyymmddhh`

set hour_time_arps = `$timedir/da_advance_time.exe ${start_time} ${delta_time}m -f ccyymmddhh`

set timestring1 = `$refdir/gradscntl_time.exe gfs.${hour_time_arps}f00`

set hour_time_sst = `$timedir/da_advance_time.exe ${start_time} ${delta_time}m -f ccyymmdd`
set hour_time_sst1 = `$timedir/da_advance_time.exe ${start_time} -1440m -f ccyymmdd`

echo 'rlk0_1 '$timestring''
if ( $time < 1000000 ) set timelength = $time
if ( $time < 100000 ) set timelength = 0$time
if ( $time < 10000 ) set timelength = 00$time
if ( $time < 1000 ) set timelength = 000$time
if ( $time < 100 ) set timelength = 0000$time
if ( $time < 10 ) set timelength = 00000$time

if ( $counter1 < 1000 ) set timenum = $counter1

if ( $counter1 < 100 ) set timenum = 0$counter1

if ( $counter1 < 10 )  set timenum = 00$counter1

set htmldir = "/home/disk5/Grib2-EDFF/NCEP/${timestring0}"

if(-d $htmldir/China ) then
else
mkdir -p $htmldir/China
endif

if(-d $htmldir/Southwest ) then
else
mkdir -p $htmldir/Southwest
endif

if(-d $htmldir/Southeast ) then
else
mkdir -p $htmldir/Southeast
endif

if(-d $htmldir/Northwest ) then
else
mkdir -p $htmldir/Northwest
endif

if(-d $htmldir/Northeast ) then
else
mkdir -p $htmldir/Northeast
endif

if(-d $htmldir/Beijing ) then
else
mkdir -p $htmldir/Beijing
endif

if(-d $htmldir/China ) then
else
mkdir -p ${$htmldir/China}
endif
############################ The first six-hour forecast #########################################

#cat >! sed_pro << EOF
#s|spawn.*|spawn scp -r lacs@159.226.234.19:/usr/home/lacs/rlk_GFS_0p5/$start_time $up_dir |g
#EOF
#rm -rf up_download_GFS0p5_${start_time}.exp
#sed -f  sed_pro /home/rlk/Grib2-EDFF/download_GFS0p5_reference.exp > up_download_GFS0p5_${start_time}.exp
#chmod 577 up_download_GFS0p5_${start_time}.exp
#/usr/bin/expect up_download_GFS0p5_${start_time}.exp 
 
if(-d ${work_dir}/sst_data ) then
else
mkdir -p ${work_dir}/sst_data
endif
cd ${work_dir}/sst_data

if(-f rtg_sst_grb_0.5.${hour_time_sst} ) then
else
wget -c  ftp://polar.ncep.noaa.gov/pub/history/sst/rtg_sst_grb_0.5.${hour_time_sst} 
endif 
if(-f rtg_sst_grb_0.5.${hour_time_sst1} ) then
else
wget -c  ftp://polar.ncep.noaa.gov/pub/history/sst/rtg_sst_grb_0.5.${hour_time_sst1} 
endif 

cd ${work_dir}       
foreach fore_hour ( 00 03 06 09 12 15 18 21 24 27 30 33 36 39 42 45 48 51 54 57 60 63 66 69 72 75 78 81 84 87 90 93 96 )
#foreach fore_hour ( 00 03 )
set filename = "gfs_4_${dirdate}_${hr}00_0${fore_hour}.grb2"
#set filename = "gfs.t${hr}z.pgrb2.0p50.f0${fore_hour}"
set filename1 = "${filename}f${fore_hour}"
set filename_arps = "gfs.${hour_time_arps}f${fore_hour}"
if(-f $filename || -f $filename_arps ) then
else
#  /usr/bin/proz -r -f -k=8 http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.${dirtime}/$filename > gettingdata.out 
#  wget -c http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.${dirtime}/$filename > gettingdata.out
  /usr/bin/proz -r -f -k=8  http://nomads.ncdc.noaa.gov/data/gfs4/${dirmonth}/${dirdate}/$filename > gettingdata.out
         
  mv $filename $filename_arps
endif  

end 



cd /home/rlk/Grib2-EDFF


cat >! sed_pro << EOF
s|spawn.*|spawn scp -o "StrictHostKeyChecking no" -r $work_dir ranlk@172.16.0.173:/public/home/ranlk/model/GFS0p5|g
EOF
rm -rf download_GFS0p5_${start_time}_lacs.exp
sed -f  sed_pro /home/rlk/Grib2-EDFF/download_GFS0p5_reference_lacs.exp > download_GFS0p5_${start_time}_lacs.exp
chmod 577 download_GFS0p5_${start_time}_lacs.exp
/usr/bin/expect /home/rlk/Grib2-EDFF/download_GFS0p5_${start_time}_lacs.exp


#cat >! sed_pro << EOF
#s|spawn.*|spawn scp -r $work_dir/rtg_sst_grb_0.5.${hour_time_sst} ranlk@172.16.0.173:/public/home/ranlk/model/SST_data|g
#EOF
#rm -rf download_SST_${start_time}_lacs.exp
#sed -f  sed_pro /home/rlk/Grib2-EDFF/download_GFS0p5_reference_lacs.exp > download_SST_${start_time}_lacs.exp
#chmod 577 download_SST_${start_time}_lacs.exp
#/usr/bin/expect /home/rlk/Grib2-EDFF/download_SST_${start_time}_lacs.exp

################# for LvLiang model ##############################################################################
cat >! sed_pro << EOF
s|spawn.*|spawn scp -o "StrictHostKeyChecking no"  -P 7032 -r $work_dir iap-rlk@59.48.248.2:/nfs5/home/iap-rlk/GFS|g
EOF
rm -rf download_GFS0p5_${start_time}_LL.exp
sed -f  sed_pro /home/rlk/Grib2-EDFF/download_GFS0p5_reference_LL.exp > download_GFS0p5_${start_time}_LL.exp
chmod 577 download_GFS0p5_${start_time}_LL.exp
/usr/bin/expect /home/rlk/Grib2-EDFF/download_GFS0p5_${start_time}_LL.exp

#cat >! sed_pro << EOF
#s|spawn.*|spawn scp -P 7032 -r $work_dir/rtg_sst_grb_0.5.${hour_time_sst} iap-rlk@59.48.248.2:/nfs5/home/iap-rlk/SST_data|g
#EOF
#rm -rf download_SST_${start_time}_LL.exp
#sed -f  sed_pro /home/rlk/Grib2-EDFF/download_GFS0p5_reference_LL.exp > download_SST_${start_time}_LL.exp
#chmod 577 download_SST_${start_time}_LL.exp
#/usr/bin/expect /home/rlk/Grib2-EDFF/download_SST_${start_time}_LL.exp











