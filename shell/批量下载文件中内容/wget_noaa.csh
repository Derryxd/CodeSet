#!/bin/csh -f

mkdir download_noaa
cd download_noaa


set dir = ftp://ftpprd.ncep.noaa.gov/pub/data/nccf/com/gfs/para
mkdir para
set file 
foreach file (`cat para | xargs`)

   echo 
   echo " + Downloading ... " $file
   echo
   mkdir $file
   wget -P ./para/$file/ $dir/$file/"*" 
end
