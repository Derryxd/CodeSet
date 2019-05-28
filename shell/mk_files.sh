#!/bin/sh
for((i=1;i<21;i++))
do
dir=File${i}
mkdir $dir
for x in `seq 1 20`;do
touch ${dir}/${x}text
done
for y in `seq 1 3`;do
touch ${dir}/text${y}
done
done