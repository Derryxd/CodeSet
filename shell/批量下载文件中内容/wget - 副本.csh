#!/bin/csh -f

set dir = https://www.giss.nasa.gov/tools/panoply/colorbars/gsfc

set file 
foreach file (`cat infile | xargs`)

   echo 
   echo " + Downloading ... " $file
   echo

   wget $dir/$file .
end
