#!/bin/bash
#set -x
#NCARG_ROOT="/n/home05/packard/sw/ncl-6.4.0"
NCL_SOURCE="${NCARG_ROOT}/source-6.4.0/"  # https://www.earthsystemgrid.org/dataset/ncl.640.src/file/ncl_ncarg-6.4.0.tar.gz

grep -rin "undef(\"$1\")" "${NCARG_ROOT}/lib/ncarg/nclscripts/"

wrka=$1
nl=0
while [ -n "$wrka" ] && [ $nl -lt 5 ]; do
  wrkz=$wrka
#  wrkb=`grep -l ${wrka} "${NCARG_ROOT}"/lib/*`
#  wrkb=`nm -A --defined-only "${NCARG_ROOT}"/lib/*.a |grep -i "T ${wrka}[_$]"`
  wrkb=`nm -A --defined-only "${NCARG_ROOT}"/lib/*.a |grep -Ei "T ${wrka}_(W)?$"`
  echo $wrkb
#  wrkc=`sed 's?^.*lib\([^/]*\)\.a?\1?' <<< "$wrkb"`
  wrkc=`sed 's?^[^:]*lib\([^/]*\)\.a:.*$?\1?' <<< "$wrkb"`
  echo $wrkc
  wrkd=`find "${NCL_SOURCE}" -name "$wrkc" -type d`
  echo $wrkd
#  grep -l ${wrka}_W ${wrkd}/*W.c  # only nfp
  grep -il ${wrka} ${wrkd}/*
  #sed -sn "/${wrka}_W/,/NhlErrorTypes/p" ${wrkd}/*W.c |grep NGCALLF
#  wrka=`sed -sn "/${wrka}_W/,/NhlErrorTypes/s/^\s*NGCALLF(\([a-zA-Z]*\>\).*$/\1/p" ${wrkd}/*W.c`
  wrka=`sed -sn "/${wrka}_W/,/NhlErrorTypes/s/^\s*NGCALLF(\([a-zA-Z]*\>\).*$/\1/p" ${wrkd}/*`
  echo $wrka
  nl=$((nl+1))
done
grep -in $wrkz ${wrkd}/*

# \grep '^syn keyword nclBUILTIN' ~/.vim/syntax/ncl.vim
#grep "$1" ~/.vim/syntax/ncl.vim | awk '{print $3}'

