 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin
print(systemfunc("date"))

; ;var 
; nrun= 1
; nyrs= 1
; nmon= 12
; nlev= 30
; var = (/"ts","ss"/)  
; ;for res 2 / 0.5 / 0.25 / 0.125
; nres = (/"2","5","114","216"/)
; nlat = (/115,446, 940,1892/)
; nlon = (/182,722,1442,2882/)
; ;build month string
;     nl = str_get_nl()
;     d = new((/nmon,1/),string)
;     do i = 1, nmon
;         d(i-1,0)= sprinti("%0.2i", i)
;     end do
;     print("built d array for months")
;     print(nl + "-------------------------------------" + nl + "  ")
    diri= "/public/home/jinjb/liudezhi/"
    filesTmp= systemfunc ("ls " + diri + "ersst.v5.1854-2007.nc")
    fiTmp= addfile(filesTmp, "r")
    time=fiTmp->time
    lat= fiTmp->lat
    lon= fiTmp->lon
    tmpsst =fiTmp->sst  
    tmpssta=fiTmp->ssta
    
    sst = tmpsst(66*12:1848-1,{-5:5},{190:240})    ;1920~2007:88yrs
    ssta=tmpssta(66*12:1848-1,{-5:5},{190:240}) 
    nino=dim_avg_n(dim_avg_n(ssta,2),1)

    nsize=dimsizes(sst)
    sst_re =reshape(sst, (/88,12,nsize(1),nsize(2)/))
    clim=dim_avg_n(sst_re,0)
    ssta_re=sst_re-conform_dims(dimsizes(sst_re),clim,(/1,2,3/))
    areaAvg=dim_avg_n(dim_avg_n(ssta_re,3),2)
    nino3=reshape(areaAvg,dimsizes(nino))
      
    x=fspan(1,1056,1056)
    b=regCoef(x,nino3)
    y=x*b-b*dim_avg(x)+dim_avg(nino3)
    data=new((/2,1056/),float)
    data(0,:)=nino3
    data(1,:)=y
    a=b*1056
    printVarSummary(nino)

;write files
    diro="/public/home/jinjb/liudezhi/"
    foname= "nino_indice_ERSST88yrs.nc"
    system ("rm "+ diro + foname)
    fo = addfile(diro + foname, "c")
    fo->nino3=nino3
    fo->nino= nino
    fo->lat = lat
    fo->lon = lon
    fo->time= time

; plot parameters
  wks           = gsn_open_wks ("ps","nino") ; send graphics to PNG file
  res           = True                   ; plot mods desired
  res@gsnDraw   = False                  ; don't draw plot
  res@gsnFrame  = False                  ; don't advance frame
  res@gsnFrame  = False                  ; don't advance frame yet      
  res@vpHeightF = 0.4                    ; change aspect ratio of plot
  res@vpWidthF  = 0.8                  
  res@trYMinF   = -3.0                   ; min value on y-axis
  res@trYMaxF   =  3.0                   ; max value on y-axis
  res@trXMinF   =  0
  res@trXMaxF   =  1056-1
  res@tmXBMode  = "Explicit"
  res@tmXBValues=  fspan(0, 960, 5)      ; Y : res@tmYLValues
  res@tmXBLabels= (/"1920","1940","1960","1980","2000"/)
  res@vpXF      =  0.1                   ; start plot at x ndc coord 
  res@gsnLeftString    = "ERSST"        
  res@gsnRightString   = sprintf("%3.2f",a)+"C 88yr~S~-1~N~"    ; ~B~...~N~ 下标   
  fontheight = 0.015
  res@gsnRightStringFontHeightF=fontheight
  res@gsnLeftStringFontHeightF =fontheight
  res@gsnCenterString  = "Nino3.4 Index" ; title
  res@gsnXYAboveFillColors = "red"
  res@gsnXYBelowFillColors = "blue"
  res@xyLineColors         = "white"
  res@gsnYRefLine           = 0.
  res@gsnYRefLineDashPattern= 1
  res@gsnYRefLineColor      = "grey"

  ; res@gsnYRefLine          =  0 ; create a horizontal reference line  
  ; res@gsnAboveYRefLineColor= "red"              ; above ref line fill red
  ; res@gsnBelowYRefLineColor= "blue"             ; below ref line fill blue
  ; polyres                  = True
  ; polyres@gsLineThicknessF = 3.0

  plot = gsn_csm_xy (wks,x,data,res)           ; create plot
  ; gsn_polyline(wks,plo/t,x,(/nino3/),polyres)    ; add polyline
  draw(plot)
  frame(wks)                                    ; now advance frame


print(systemfunc("date"))
end