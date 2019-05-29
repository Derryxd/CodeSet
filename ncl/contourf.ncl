load "/disk1/soft/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "/disk1/soft/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "/disk1/soft/lib/ncarg/nclscripts/csm/contributed.ncl"
load "/disk1/soft/lib/ncarg/nclscripts/csm/shea_util.ncl"
	
begin	
;var : for res 2
	nyrs=2
	nlat=115
	nlon=182
	nlev=30
	avgT_yr=new((/nyrs,nlev,nlat,nlon/),float,1e+35)
;build year string
	nl = str_get_nl()
 	c = new((/50,1/),string)
    do i = 0, nyrs
        c(i,0)=sprinti("%0.2i", i+1)
    end do
    print("built c array for years")
    print(nl + "-------------------------------------" + nl + "  ")
;read files
    wgt = (/0.08493151, 0.076712325, 0.08493151, 0.08219178 \  ; same size as dimension "time"
           ,0.08493151, 0.08219178 , 0.08493151, 0.08493151 \
       	   ,0.08219178, 0.08493151 , 0.08219178, 0.08493151 /)
    diri = "/disk7/liudezhi/licom/res2/"
    ; files = systemfunc ("ls " + diri + "MMEAN00" + "[01-50]*-" + c(0,0) + ".nc")

;statistic	
    do i=1,nyrs
	    files = systemfunc ("ls " + diri + "MMEAN00"+c(i-1,0)+"-*.nc")
	    print(files)
	    F=addfiles(files,"r")
		T = F[:]->ts	
		tmp=dim_avg_wgt_n_Wrap(T,wgt,0,0)
		avgT_yr(i-1,:,:,:)=tmp
	end do
	; copy_VarCoords(T(0:1,:,:,:),avgT_yr)
	printVarSummary(avgT_yr)
    printVarSummary(avgT_yr&lat)

;workstation
	wks = gsn_open_wks("ps","SST_mean_yrs")
	contour = new(2,graphic)                          ; create a plot array
;colormap
	gsn_define_colormap(wks,"gui_default")
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
; ;viewport
; 	res@vpXF            = 0.1                 
; 	res@vpYF            = 0.9         
; 	res@vpWidthF        = 0.8
; 	res@vpHeightF       = 0.8
;plot contour

	    ; res@gsnLeftString = c(0,0)+"year"
		contour(0) = gsn_csm_contour_map(wks,avgT_yr(0,0,:,:),res)

		; res@gsnLeftString = c(1,0)+"year"
		contour(1) = gsn_csm_contour_map(wks,avgT_yr(1,0,:,:),res)

;panel
 	resP                    = True                 ; modify the panel plot

;colorbar and label
	resP@gsnSpreadColors     = True 
	; resP@gsnSpreadColorStart = 5 
	; resP@gsnSpreadColorEnd   = -5 
	resP@lbLabelFontHeightF  = 0.015 
;title
; 	res@tiMainString       = "annual mean of SST"
; 	res@tiMainFontHeightF  = .018 	
 	resP@gsnPanelMainString = "annual mean of SST"     ; new resource added in NCL V6.4.0
	; resP@txString           = "A common title"     ; use this for NCL V6.3.0 and earlier

	gsn_panel(wks,contour,(/2,1/),False)             ; now draw as one plot
end
