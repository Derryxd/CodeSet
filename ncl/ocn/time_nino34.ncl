;************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;************************************************
begin
;************************************************
; read in netCDF file
;************************************************
a1 = addfile("/public/home/jinjb/jinjb_plot/data/controlts.nc","r")
a2 = addfile("/public/home/jinjb/jinjb_plot/data/ts2.nc","r")
;a3 = addfile("/public/home/jinjb/jinjb_plot/data/su0.5ts.nc","r")
 a3 = addfile("/public/home/jinjb/jinjb_plot/data/ts0.5.nc","r")
;;;;;;;;;;;;;
;ts1cas = a1->ts
;printVarSummary(ts1cas)
;exit
ts1cas = a1->ts(108:827,0,{-5:5},{190:240})    ;nino3.4 {190:240}
ts1lat = ts1cas&lat
ts1lon = ts1cas&lon
ts2cas = a2->ts(108:827,0,{-5:5},{190:240})     ;;;;;;; 90 years (11-50)
ts2lat = ts2cas&lat
ts2lon = ts2cas&lon
;ts3cas = a3->ts(12:731,0,{-5:5},{190:240})     ;;;;;;; 90 years (11-50)
ts3cas = a3->ts(108:827,0,{-5:5},{190:240})
ts3lat = ts3cas&lat
ts3lon = ts3cas&lon


nlatts1 = dimsizes(ts1lat)
nlatts2 = dimsizes(ts2lat)
nlatts3 = dimsizes(ts3lat)

;;;;;area average with weight;;;;;;;;;;
  rad    = 4.0*atan(1.0)/180.0
  re     = 6371220.0
  rr     = re*rad

;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;area average with weight;;;;;;;;;;

  dlonts1   = abs(ts1lon(2)-ts1lon(1))*rr
  dxts1     = dlonts1*cos(ts1lat*rad)
  dyts1     = new ( nlatts1, typeof(dxts1))
  dyts1(0)  = abs(ts1lat(2)-ts1lat(1))*rr
  dyts1(1:nlatts1-2)  = abs(ts1lat(2:nlatts1-1)-ts1lat(0:nlatts1-3))*rr*0.5
  dyts1(nlatts1-1)    = abs(ts1lat(nlatts1-1)-ts1lat(nlatts1-2))*rr
  areats1   = dxts1*dyts1           ; cell area ftsnction of latittsde only

  dlonts2   = abs(ts2lon(2)-ts2lon(1))*rr
  dxts2     = dlonts2*cos(ts2lat*rad)
  dyts2     = new ( nlatts2, typeof(dxts2))
  dyts2(0)  = abs(ts2lat(2)-ts2lat(1))*rr
  dyts2(1:nlatts2-2)  = abs(ts2lat(2:nlatts2-1)-ts2lat(0:nlatts2-3))*rr*0.5
  dyts2(nlatts2-1)    = abs(ts2lat(nlatts2-1)-ts2lat(nlatts2-2))*rr
  areats2   = dxts2*dyts2           ; cell area ftsnction of latittsde only

  dlonts3   = abs(ts3lon(2)-ts3lon(1))*rr
  dxts3     = dlonts3*cos(ts3lat*rad)
  dyts3     = new ( nlatts3, typeof(dxts3))
  dyts3(0)  = abs(ts3lat(2)-ts3lat(1))*rr
  dyts3(1:nlatts3-2)  = abs(ts3lat(2:nlatts3-1)-ts3lat(0:nlatts3-3))*rr*0.5
  dyts3(nlatts3-1)    = abs(ts3lat(nlatts3-1)-ts3lat(nlatts3-2))*rr
  areats3   = dxts3*dyts3                               ; cell area ftsnction of latittsde only

 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ts1cas_clm=clmMonTLL(ts1cas)
ts1cas_ano=calcMonAnomTLL(ts1cas,ts1cas_clm)
ts1cas_time=wgt_areaave(ts1cas_ano,areats1,1.0,0)

ts2cas_clm=clmMonTLL(ts2cas)
ts2cas_ano=calcMonAnomTLL(ts2cas,ts2cas_clm)
ts2cas_time=wgt_areaave(ts2cas_ano,areats2,1.0,0)

ts3cas_clm=clmMonTLL(ts3cas)
ts3cas_ano=calcMonAnomTLL(ts3cas,ts3cas_clm)
ts3cas_time=wgt_areaave(ts3cas_ano,areats3,1.0,0)


;;;;;;; Normalized
data = new((/3,720/),float)
data(0,:) = ts1cas_time
data(1,:) = ts2cas_time
data(2,:) = ts3cas_time

;;;;; Correlation
;ccr = escorc(tscas_time,ucas_time)
;print(ccr)

;;;;;;;;plot;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
wks = gsn_open_wks("eps","time-nino34-exp12345")
plot = new(3,graphic)
gsn_define_colormap(wks,"BlWhRe")   
res = True
res@gsnDraw = False
res@gsnFrame = False
;res@gsnYRefLine = 0
res@vpXF = 0.2
res@vpYF = 0.8
res@vpWidthF = 0.95
res@vpHeightF = 0.3
;res@tiYAxisString  = " "
;res@trXMinF            = -2
;res@trXMaxF            = 2
res@trYMinF            = -5.0
res@trYMaxF            = 5.0
;res@xyLineColors   = (/"black","blue","green","red","purple"/)   ; choose line colors
;res@xyLineThicknessF      = 3
;res@xyDashPatterns = (/0,0/)
res@tmXBLabelFontHeightF = 0.02
res@tmYLLabelFontHeightF = 0.02
res@gsnLeftStringFontHeightF = .02
res@gsnCenterStringFontHeightF = .03

res@tmYLLabelFontThicknessF = 0.6
res@tmXBLabelFontThicknessF = 0.6

res@tmXBAutoPrecision = False
res@tmYLAutoPrecision = False
;res@tmXBPrecision = 2
;res@tmYLPrecision = 1


;;;;;;;;;;;;;;;;;;;;; Xlabel
 yrStrt1  = 1948         ; manually specify for convenience
 yrLast1  = 2007
 yyyymm1 = yyyymm_time(yrStrt1,yrLast1,"integer")    ; yyyymm(*)
 yrfrac1 = yyyymm_to_yyyyfrac(yyyymm1, 0.0)         ; yrfrac(*)
 yyyy1   = yyyymm1/100
 month1  = yyyymm1 - (yyyy1*100)
 yrfrac1&time = yyyymm1

 res@gsnYRefLine           = 0.0     ; create a reference line   
 res@gsnAboveYRefLineColor = "red"
 res@gsnBelowYRefLineColor = "blue"

res@xyMonoDashPattern   = True      ; Define line pattern.
res@xyLineThicknessF    = 2.0       ; default is 1.0     

res@gsnCenterString = "Nino3.4"
res@gsnLeftString = "(a) Control"
plot(0) = gsn_csm_xy(wks,yrfrac1,data(0,:),res)
;gres=True
;gres@gsnYRefLine           = -0.5   ; create a reference line   
;gres@gsnAboveYRefLineColor = "transparent"
;gres@gsnBelowYRefLineColor = "blue"
;plot1 = gsn_csm_xy(wks,yrfrac1,data(0,:),gres)
;overlay(plot(0),plot1)
;delete([/plot1/])

res@gsnCenterString = ""
res@gsnLeftString = "(b) sux2"
plot(1) = gsn_csm_xy(wks,yrfrac1,data(1,:),res)

res@gsnCenterString = ""
res@gsnLeftString = "(c) sux05"
plot(2) = gsn_csm_xy(wks,yrfrac1,data(2,:),res)

rest = True
  
gsn_panel(wks,plot,(/3,1/),rest)     ; now draw as one plot


end
