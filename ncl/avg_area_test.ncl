load "/disk1/soft/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "/disk1/soft/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "/disk1/soft/lib/ncarg/nclscripts/csm/contributed.ncl"
load "/disk1/soft/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin	
;var : for res 0.5
nyrs=1
nlat=446
nlon=722
nlev=30

diri = "/disk7/liudezhi/licom/res05/"
files = systemfunc ("ls " + diri + "MMEAN0001*.nc")
f=addfile("/disk7/liudezhi/licom/res2/MMEAN0001-01.nc", "r")

F=addfiles(files,"r")
T = F[:]->ts    
printVarSummary(T)

a=T(0,:,::-1,:)  ;res5
printVarSummary(a)
b=f->ts
bb=b(0,0,::-1,:) ;res2
printVarSummary(b)
; p=area_hi2lores_Wrap(a&lon,a&lat, a , True, 1,  b&lon,b&lat, False)
p=linint2(bb&lon,bb&lat, bb, True,  a&lon,a&lat, 0)
printVarSummary(p)
aa=a(0,:,:)
copy_VarMeta(aa,p)
diff=a(0,:,:)-p
copy_VarMeta(aa,diff)
printVarSummary(diff)


wks = gsn_open_wks("ps","l2h")
gsn_define_colormap(wks,"BlAqGrYeOrRevi200");colormap
contour = new(3,graphic)                          ; create a plot array


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
; res@cnLevelSelectionMode =  "ManualLevels"   
;   res@cnMinLevelValF       =  0.

;   res@cnMaxLevelValF       = 28.
;   res@cnLevelSpacingF      =  2. 
res@mpMinLonF            = 0
res@mpMaxLonF            = 360  
res@mpCenterLonF         = 180
; res@sfXArray=lon
; res@sfYArray=lat
; ;viewport
;     res@vpXF            = 0.1                 
;     res@vpYF            = 0.9         
;     res@vpWidthF        = 0.8
;     res@vpHeightF       = 0.8
res@gsnSpreadColors         = True  
;plot contour

res@gsnLeftString = "high2 resolution"
contour(0) = gsn_csm_contour_map(wks,p,res)

res@gsnLeftString = "high resolution"
contour(1) = gsn_csm_contour_map(wks,a(0,:,:),res)

; res@cnLevelSelectionMode =  "ManualLevels"   
; res@cnMinLevelValF       =  -3.
; res@cnMaxLevelValF       = 3.
; res@cnLevelSpacingF      =  0.5 
; res@gsnLeftString = "diff"
contour(2) = gsn_csm_contour_map(wks,diff,res)

;panel
resP                    = True                 ; modify the panel plot
;colorbar and label
; resP@gsnSpreadColors     = True 
; resP@gsnSpreadColorStart = 5 
; resP@gsnSpreadColorEnd   = -5 
resP@lbLabelFontHeightF  = 0.015 
;title
;     res@tiMainString       = "annual mean of SST"
;     res@tiMainFontHeightF  = .018   
resP@gsnPanelMainString = "annual mean of SST"     ; new resource added in NCL V6.4.0
; resP@txString           = "A common title"     ; use this for NCL V6.3.0 and earlier

gsn_panel(wks,contour,(/3,1/),False)             ; now draw as one plot



pp=area_hi2lores_Wrap(a&lon,a&lat, a , True, 1,  b&lon,b&lat, False)
printVarSummary(pp)
wks1 = gsn_open_wks("ps","h2l")
gsn_define_colormap(wks1,"BlAqGrYeOrRevi200")
contour1 = new(3,graphic)                          ; create a plot array
res@gsnLeftString = "low2 resolution"
contour1(0) = gsn_csm_contour_map(wks1,pp(0,:,:),res)

res@gsnLeftString = "low resolution"
contour1(1) = gsn_csm_contour_map(wks1,bb,res)
c=bb-pp(0,::-1,:)
copy_VarMeta(bb,c)
contour1(2) = gsn_csm_contour_map(wks1,c,res)

gsn_panel(wks1,contour1,(/3,1/),False)             ; now draw as one plot

end
