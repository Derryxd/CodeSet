load "/disk1/soft/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "/disk1/soft/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "/disk1/soft/lib/ncarg/nclscripts/csm/contributed.ncl"
load "/disk1/soft/lib/ncarg/nclscripts/csm/shea_util.ncl"
    
begin   

    a=1
    b=2
    c=3
    bb=new((/1,1,1/),float)
    bb=1
    printVarSummary(bb)
    aa=(/"a","b","c"/)
;     i=1
; bb!i=aa(0)
; bb&$aa(0)$=2

    do i=0,2
        bb!i=aa(i)
        bb&$aa(i)$=$aa(i)$
    end do 


    printVarSummary(bb)
   end 