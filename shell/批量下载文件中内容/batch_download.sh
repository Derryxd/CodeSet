#!/bin/bash 
#  
# Decription:  
#  A Shell script used to download the imges from Internet. 
# Author: 
#  Long Luo 
# Date: 
#  2014-09-11 00:16:59 
#   
BASE_URL="https://s.yimg.com/zz/combo?a/i/us/nws/weather/gr/" 
 # declare STIRNG variable
 STRING="Beginning Image download..."  
 #print var on screen  
 echo $STRING   
 sleep 1 
 echo "...."  
 BIG_PNG="ds.png"
 PNG=".png"  
 echo "url="${BASE_URL} 
 echo "big png="${BIG_PNG}   
 for ((i=0; i<49;i++)); do 
 echo IMG_URL=${BASE_URL}${i}${BIG_PNG}  
 echo "final url="${IMG_URL}    
 curl ${BASE_URL}${i}${BIG_PNG} -o small/${i}${PNG}  
 sleep 1   
done 

