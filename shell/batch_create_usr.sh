
#!/bin/bash
set -x
#>user
stime=`date +%Y%m%d-%H:%M:%S`
#echo $stime >>user
for i in `cat name`
  do
  useradd -d /home/20181212/$i -m $i >> user
  echo "iap123456" | passwd --stdin $i
  echo "密码写入成功" 
  done
echo $etime >>user
