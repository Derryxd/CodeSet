load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"  
begin
;**********************************************************
  fs = addfile("/public/home/jinjb/mius116/exe/LICOM0001-09-04.nc","r")
 ;fs = addfile("/public/home/jinjb/mius116/exe/MMEAN0001-01.nc","r") 
 ; var=fs->ts(0,0,:,:)
 var =fs->ts(0,0,:,:)
  ;var = fs->z0(0,:,:)
;  print(var({0},{60}))
  ;print(var)
;exit
;  print(var&lat)
  printMinMax(var,True)
  printVarSummary(var)
;exit

;*******************************************************
  wks  = gsn_open_wks("ps","ts")
  gsn_define_colormap(wks,"BlAqGrYeOrRevi200")        ; choose colormap

  res                 = True                     ; plot mods desired
  res@gsnDraw             = True           ; don't draw
  res@gsnFrame            = True         ; don't advance frame
;  res@gsnMaximize           = True
  res@mpCenterLonF    = 180.
  res@mpMinLatF              =  -90.
  res@mpMaxLatF              =  90.
  res@mpMinLonF              = 0.
  res@mpMaxLonF              = 360.
 ;res@cnLevelSelectionMode ="ManualLevels"
 ;res@cnMinLevelValF       =-2.2
 ;res@cnMaxLevelValF       =1.2
 ;res@cnLevelSpacingF      =0.2

  res@cnInfoLabelOn       = False          ; turn off cn info label
  res@cnFillOn        = True                     ; turn on color
  res@cnLinesOn       = False                   ; turn off contour lines
  res@gsnSpreadColors = True
;  res@cnFillPalette   = "BlWhRe"
; res@cnLevelSelectionMode  = "ExplicitLevels"
 ;res@cnLevels = (/28,29,30,32,32.5,33,33.5,34,34.5,35,36/)
;  res@cnLevels = (/-30,-27,-24,-21,-18,-15,-12,-9,-6,-3,0,3,6,9,12,15,18,21,24,27,30/)
  res@gsnCenterString  = "u_cp"
  res@tiMainString   = ""
  res@gsnLeftString  = ""
  res@gsnRightString = ""
  res@cnLineLabelsOn = False
  res@lbLabelBarOn   = True
  res@pmLabelBarOrthogonalPosF = 0.15
  res@cnLineLabelDensityF = 1 
  res@cnLineLabelFontHeightF = 0.008
  res@cnLabelMasking = True
  res@cnLineLabelBackgroundColor = "white"
 ; res@cnLabelDrawOrder = "PreDraw"
;  res@cnLineLabelInterval = 1
  res@tmXBLabelFontHeightF = 0.02
  res@tmYLLabelFontHeightF = 0.02

;  resc = True
;  resc@gsnDraw = False
;  resc@gsnFrame = False
;  resc@cnFillOn = False
;  resc@cnLinesOn = True
;  resc@gsnLeftString = ""
;  resc@cnInfoLabelOn = False

  resd  = True
  resd@cnFillOn        = False                   ; turn on color
  resd@cnLinesOn       = True                    ; turn off contour lines
  resd@cnLevelSelectionMode  = "ExplicitLevels"
  resd@cnLevels = (/3000./)
  resd@cnLineColor = "black"
   resd@cnLineThicknessF = 1.5
   resd@cnLineLabelsOn   = False
   resd@cnInfoLabelOn  = False
  
  plot = new(8,graphic)

  plot(0) = gsn_csm_contour_map(wks,var(:,:),res)
  draw(plot(0))
exit
  delete(res@gsnCenterString)
  res@gsnCenterString = "u_3x3"
  plot(1) = gsn_csm_contour_map(wks,up(3,49,:,:),res)
  plot(2) = gsn_csm_contour_map(wks,u(5,45,:,:),res)
  plot(3) = gsn_csm_contour_map(wks,up(5,45,:,:),res)
  delete(res@gsnCenterString)
  res@gsnCenterString = "v"
  plot(4) = gsn_csm_contour_map(wks,v(6,49,:,:),res)
  delete(res@gsnCenterString)
  res@gsnCenterString = "v_3x3"
  plot(5) = gsn_csm_contour_map(wks,vp(6,49,:,:),res)
  plot(6) = gsn_csm_contour_map(wks,v(7,40,:,:),res)
  plot(7) = gsn_csm_contour_map(wks,vp(7,40,:,:),res)

 Pres = True
 
 gsn_panel(wks,plot,(/4,2/),Pres)
  
;  draw(plot)
end














