
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin
nrun=4
a=(/(/1,2/),(/3,4/),(/5,6/)/)
b=(/2.0,2.0,2.0,2.0/)
c=conform_dims((/1,nrun/),2.0,0)
print(a)

d=ispan(0,-300,20)
print(d)

    ; d=dim_avg_n(a,0)
    ; print(d)
    ; e=a-conform_dims(dimsizes(a),d,1)
    ; print(e)                  
 
      
; aa=(/1,2,3,4/)
; bb=(/4,3,2,1/)
; aa!0="time"
; aa&time=bb
; cc=aa({3:2})
; dd=aa({2:3})
; print(cc)
; print(dd)

end