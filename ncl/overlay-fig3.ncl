;*********************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
;************************************************

begin
;************************************************
 c   =addfile("/public/home/jinjb/mius111/exe/MMEAN0001-01.nc","r")
   lat =c->lat
   lev =c->lev
   lev1=c->lev1
   lon =c->lon  
  
  
   
   b3=addfile("/public/home/jinjb/mius111/exe/MMEAN0010-01.nc","r")
   us31  =b3->us(0,1,:,:)
   vs31  =b3->vs(0,1,:,:)
   
    b0=addfile("/public/home/jinjb/mius114/exe/MMEAN0010-01.nc","r")
    vs0  =b0->vs(0,1,:,:)
    us0  =b0->us(0,1,:,:)
    lat0 =b0->lat
    lon0 =b0->lon
  vs00=vs0
  us00=us0
  ;vs00  =dim_avg_n(vs0(:,:,:),0)
  ;us00  =dim_avg_n(us0(:,:,:),0)
  
;  vs3  =dim_avg_n(vs31(26:30,:,:),0)
;  us3  =dim_avg_n(us31(26:30,:,:),0)
 vs3=vs31
 us3=us31 
  printVarSummary(vs00)
  vs00 !0  ="lat"
  vs00 !1  ="lon"
  vs00 &lat=lat0
  vs00 &lon=lon0
  
  us00 !0  ="lat"
  us00 !1  ="lon"
  us00 &lat=lat0
  us00 &lon=lon0 
  
  vs11  =vs3
  us11  =us3
  
  
  
  ws11=vs11
  ws11=(vs11^2+us11^2)^0.5
  
  ws00=vs00
  ws00=(vs00^2+us00^2)^0.5
  ws00 !0  ="lat"
  ws00 !1  ="lon"
  ws00 &lat=lat0
  ws00 &lon=lon0


  vs11 !0  ="lat"
  vs11 !1  ="lon"
  vs11 &lat=lat
  vs11 &lon=lon
  
  us11 !0  ="lat"
  us11 !1  ="lon"
  us11 &lat=lat
  us11 &lon=lon 

  ws11 !0  ="lat"
  ws11 !1  ="lon"
  ws11 &lat=lat
  ws11 &lon=lon

print(us11&lat)
print(us00&lat)
  ;exit
  fontheight = 0.015
;************************************************
; create plot
;************************************************
  wks = gsn_open_wks("eps" ,"nanfai")
gsn_define_colormap(wks,"BlueDarkRed18")
;gsn_define_colormap(wks,"BlAqGrYeOrRevi200")
plot = new(2,graphic)

vcres        =True
vcres@gsnDraw = False
vcres@gsnFrame = False
vcres@mpFillOn = False
vcres@mpOutlineOn           = True
vcres@mpGeophysicalLineThicknessF    = 2
vcres@cnFillOpacityF = 0.7

vcres@tmXBLabelFontHeightF = 0.025
vcres@tmYLLabelFontHeightF = 0.025
vcres@tmYLLabelFontThicknessF = 0.8
vcres@tmXBLabelFontThicknessF = 0.8
vcres@tmYLLabelStride = 0
vcres@tmXBLabelFont = 25
vcres@tmYLLabelFont = 25
vcres@cnLineLabelsOn = False

vcres@gsnContourNegLineDashPattern = 2

vcres@gsnScalarContour = True
vcres@gsnMaximize = True                         ;copy the full plot
vcres@gsnPaperOrientation = "portrait"
vcres@mpCenterLonF = 180

vcres@cnFillOn            = True
vcres@cnLevelSelectionMode = "ExplicitLevels"
;vcres@cnLevels = fspan(20,30,11)


vcres@gsnSpreadColors= True
;vcres@gsnSpreadColorEnd = 18
;vcres@gsnSpreadColorStart = 3


vcres@lbLabelBarOn = True
vcres@lbOrientation = "vertical"
vcres@cnLinesOn = False

vcres@mpLimitMode = "LatLon"
;latS      = 25    ;wanliu  range to zoom in on  
;latN      = 50.
;lonL      = 280.
;lonR      =  310.


;latS      = 25  ;heichao range to zoom in on
;latN      = 50.
;lonL      = 125.
;lonR      =  155.

latS      = -50; range to zoom in on
latN      = -20.
lonL      = 10
lonR      =  65.



vcres@mpMinLatF = latS
vcres@mpMaxLatF = latN
vcres@mpMinLonF = lonL
vcres@mpMaxLonF = lonR

vcres@cnFillDrawOrder = "Predraw"
vcres@mpShapeMode = "FreeAspect"
;vcres@vpXF = 0.3                ;set the propotion of the plot
;vcres@vpYF = 0.8
vcres@vpWidthF = 1.2          ;1.6
vcres@vpHeightF = 0.8          ;0.6
vcres@gsnAddCyclic = False

vcres@vcRefAnnoOrthogonalPosF = -1.0             ; move ref vector up
vcres@vcRefLengthF            = 0.06            ; define length of vec ref
vcres@vcGlyphStyle            = "CurlyVector"    ; turn on curly vectors

vcres@vcMinDistanceF          = 0.02
vcres@vcLineArrowThicknessF = 1.2

;vcres@gsnRightString = "JJA(0)"
vcres@gsnStringFont = "times-roman"
vcres@gsnStringFontHeightF = 0.04
;vcres@vcRefMagnitudeF         = vc(ii)            ; define vector ref mag

vcres@lbLabelBarWidthF = 0.85
vcres@lbLabelBarHeightF = 0.85


vcres@cnLevels = fspan(-.3,.3,11)
vcres@vcRefMagnitudeF = .1
;vcres@gsnLeftString = "(a)"
;vcres@gsnRightString = "SODA"



;vcres@cnLevels = fspan(-.05,.05,11)
;vcres@vcRefMagnitudeF = .08
vcres@gsnLeftString = "(a)"
vcres@gsnRightString = "LOW"
plot(0) = gsn_csm_vector_scalar_map_ce(wks,us11({latS:latN},{lonL:lonR}),vs11({latS:latN},{lonL:lonR}),ws11({latS:latN},{lonL:lonR}),vcres)



vcres@gsnLeftString = "(b)"
vcres@gsnRightString = "HIGH"
plot(1) = gsn_csm_vector_scalar_map_ce(wks,us00({latS:latN},{lonL:lonR}),vs00({latS:latN},{lonL:lonR}),ws00({latS:latN},{lonL:lonR}),vcres)


rest = True
;rest@gsnPanelYWhiteSpacePercent = 1.0
rest@gsnPanelLabelBar = False
;rest@txString = "UV850 & OMEGA500"
rest@txFontHeightF = 0.024
rest@txFont = "times-bold"
rest@lbLabelStride = 1
rest@lbLabelFontHeightF = 0.015

rest@lbLabelFont = 25
rest@pmLabelBarWidthF = 0.85
rest@pmLabelBarParallelPosF = 0.015


rest@lbBoxMinorExtentF = .15
;rest@lbBoxMajorExtentF = .9
rest@lbLabelFontHeightF = .015
;rest@lbLeftMarginF = -.3
rest@lbRightMarginF = -2.5

gsn_panel(wks,plot,(/2,1/),rest)

end
