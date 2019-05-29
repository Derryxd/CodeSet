 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
    
begin   
;var 

    nlat=446
    nlon=722
    ; nlat=115
    ; nlon=182
    nlev=30
    diri = "/public/home/jinjb/liudezhi/test"
    f=addfile(diri + "/" + "Res5Yrs50.nc", "r")
    lat=f->lat
    lon=f->lon
    lev=f->lev
    lev1=f->lev1
    T=f->ts

;workstation
    wks = gsn_open_wks("pdf","test3_T")
    contour = new(5,graphic)                          ; create a plot array
;colormap
    gsn_define_colormap(wks,"BlAqGrYeOrRevi200")
;resources
    res                                            = True
    res@gsnAddCyclic = False  ;默认为经度范围0~360，而模式结果为0~362，故设置false
;map
    ; res@mpProjection                = "Mercator" 
    res@mpGridAndLimbOn     = False 
    res@mpPerimOn           = False 
    res@mpGridLatSpacingF   = 20.               
    res@mpGridLonSpacingF   = 30.
    res@mpFillOn            = False
;contour
    res@cnFillOn          = True
    res@cnLineLabelsOn    = False 
    res@cnLevelSelectionMode =  "ManualLevels"   
    res@cnMinLevelValF       =  0.
    res@cnMaxLevelValF       = 28.
    res@cnLevelSpacingF      =  2. 
    res@mpMinLonF            = 0
   res@mpMaxLonF            =360  
   res@mpCenterLonF         = 180
; ;viewport
;   res@vpXF            = 0.1                 
;   res@vpYF            = 0.9         
;   res@vpWidthF        = 0.8
;   res@vpHeightF       = 0.8
;plot contour
    do i=0,4
        contour(i) = gsn_csm_contour_map(wks,T(5+i,0,:,:),res)
    end do   
;panel
    resP                    = True                 ; modify the panel plot
;colorbar and label
    resP@gsnSpreadColors     = True 
    ; resP@gsnSpreadColorStart = 5 
    ; resP@gsnSpreadColorEnd   = -5 
    resP@lbLabelFontHeightF  = 0.015 
;title
;   res@tiMainString       = "annual mean of SST"
;   res@tiMainFontHeightF  = .018   
    resP@gsnPanelMainString = "annual mean of SST"     ; new resource added in NCL V6.4.0
    ; resP@txString           = "A common title"     ; use this for NCL V6.3.0 and earlier

    gsn_panel(wks,contour,(/5,1/),False)             ; now draw as one plot
end
