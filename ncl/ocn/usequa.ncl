load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl" 
;************************************************
begin
;************************************************
; variable and file handling
;************************************************
   
  
if (.not. isdefined("fs_IAP41")) then
     fs_LICOM = systemfunc("ls /public/home/jinjb/cesm1.0.5/test63/run1/cycle5/MMEAN030*.nc")
  end if

  f_LICOM                        = addfiles(fs_LICOM,"r")
  ListSetType(f_LICOM,"cat")
  us1                    = f_LICOM[:]->us(:,:,104,:)*100

if (.not. isdefined("fs_IAP41")) then
     fs_LICOM1 = systemfunc("ls /public/home/jinjb/cesm1.0.5/test6/run1/cycle5/MMEAN030*.nc")
  end if

  f_LICOM1                        = addfiles(fs_LICOM1,"r")
  ListSetType(f_LICOM1,"cat")
  us2                   = f_LICOM1[:]->us(:,:,104,:)*100




 c   =addfile("/public/home/jinjb/mius118/exe/MMEAN0001-01.nc","r")
   lat =c->lat
   lev =c->lev
   lev1=c->lev1
   lon =c->lon
  
   
 
   us11     =dim_avg_n(us1(:,:,:),0)
  
 
  
 

  ;diff1  =ssnotide
  ;diff1    =diff4+diff3
  ;diff1    =diff3-diff4 
  us11!0  ="lev"
  us11!1  ="lon"
  us11&lev=lev
  us11&lon=lon

   us21=us11
   us21     =dim_avg_n(us2(:,:,:),0)

 plot          =new(2,graphic)
 ;wks=gsn_open_wks("eps","SSTmius3bias")
  wks=gsn_open_wks("pdf","usequ")
   ; gsn_define_colormap(wks,"BlAqGrYeOrRe")
 ; gsn_define_colormap(wks,"amwg") ; choose a colormap
  ;gsn_define_colormap(wks,"BlAqGrYeOrRevi200")
   
  gsn_define_colormap(wks,"BkBlAqGrYeOrReViWh200")

res                          =True
res@gsnAddCyclic         =False
res@gsnFrame                 =False
res@gsnDraw                  =False
res@cnFillOn                 =True
res@cnLinesOn                =False

res@gsnYAxisIrregular2Linear =True 
res@gsnXAxisIrregular2Linear =True 

res@cnLineLabelsOn           =False
res@cnInfoLabelOn            =False
;res@gsnSpreadColors          =True

res@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
;res@cnLevels             =(/28,30,32,33,34,34.5,35,35.5,36,36.5,37,38/)
res@cnLevels             =(/-80,-60,-40,-20,-10,-5,0,5,10,20,40,60,80,100/)
;res@cnFillColors    = (/17,33,38,44,58,65,75,93,99,124,141,145,150,159,169,184/) 
;res@cnFillColors    = (/17,33,44,65,58,75,99,124,141,150,159,169,184/)
res@cnFillColors   = (/177,17,33,58,63,81,201,201,100,113,125,135,147,159,184/)


res@lbTopMarginF             =0.2
res@pmLabelBarWidthF         =0.7
res@lbLabelFontHeightF       =0.018
res@lbLabelBarOn         =False
res@lbLabelFont              =25
;res@tmXBLabelFontHeightF     =0.017
;res@tmXBLabelFont            ="helvetica"
;res@tmXTLabelFontHeightF     =0.017
res@tmYLLabelFont            ="helvetica"
res@tmYLLabelFontHeightF     =0.017


res@gsnLeftString        =""
res@gsnCenterString       ="(a)U(CTRL)"
res@gsnRightString       ="cm/s"
res@cnMissingValPerimOn      = True   
res@cnMissingValFillPattern  = 3  
res@cnMissingValFillColor    = "black" 



res_upper                   =   res
res_upper@tiMainString      =   "" 
res_upper@tiYAxisString     =   "(Depth)" 
;res_upper@tiXAxisString     =   ""
res_upper@tmYLMode          =   "Explicit"

;res_upper@tmXBLabelsOn      =   False
;res_upper@tmXBOn            =   False
;res_upper@tmXTOn            =   True 
   
  
res_upper@tmYLValues        =   (/-300,-200,-100,-5/) 
res_upper@tmYLLabels        =   (/-300,-200,-100,0/) 

res_upper@tmXBMode          =   "Explicit"
res_upper@tmXBValues        =   (/280,260,240,220,200,180,160,140/) 
res_upper@tmXBLabels =   (/"80W","100W","120W","140W","160W","180","160E","140E"/) 
res_upper@tmXBMinorValues   =   ispan(280,140,5)

res_upper@tmYLMinorValues   =   ispan(0,-300,20)
res_upper@vpHeightF         =   0.25
res_upper@vpWidthF          =   0.75
res_upper@vpYF              =   0.8
res_upper@vpXF              =   0.2
;res_upper@lbLabelBarOn      =   False 

res_upper1                  =   res_upper
res_upper1@cnLinesOn        =   True
res_upper1@cnFillOn         =   False
res_upper1@cnLineLabelsOn   =   True
res_upper1@gsnContourZeroLineThicknessF=2
res_upper1@cnLevelSelectionMode ="ManualLevels"
;res_upper1@cnLevelSelectionMode ="ExplicitLevels"
res_upper1@cnMinLevelValF       =-20
res_upper1@cnMaxLevelValF       =80
res_upper1@cnLevelSpacingF      =20



res_upper1@cnLineLabelFontHeightF=0.008
res_upper1@cnLineLabelDensityF   = 2.0





plot3   =gsn_csm_contour(wks,us11(0:18,140:280),res_upper)
plot4   =gsn_csm_contour(wks,us11(0:18,140:280),res_upper1)
overlay(plot3,plot4)
plot(0)=plot3

res1                          =True
res1@gsnAddCyclic         =False
res1@gsnFrame                 =False
res1@gsnDraw                  =False
res1@cnFillOn                 =True
res1@cnLinesOn                =False

res1@gsnYAxisIrregular2Linear =True 
res1@gsnXAxisIrregular2Linear =True 

res1@cnLineLabelsOn           =False
res1@cnInfoLabelOn            =False


res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels

res1@cnLevels             =(/-80,-60,-40,-20,-10,-5,0,5,10,20,40,60,80,100/)
res1@cnFillColors   = (/177,17,33,58,63,81,201,201,100,113,125,135,147,159,184/)


res1@lbTopMarginF             =0.2
res1@pmLabelBarWidthF         =0.7
res1@lbLabelFontHeightF       =0.018
res1@lbLabelBarOn         =False
res1@lbLabelFont              =25

res1@tmYLLabelFont            ="helvetica"
res1@tmYLLabelFontHeightF     =0.017


res1@gsnLeftString        =""
res1@gsnCenterString       ="(b)U(Exp1)"
res1@gsnRightString       ="cm/s"
res1@cnMissingValPerimOn      = True   
res1@cnMissingValFillPattern  = 3  
res1@cnMissingValFillColor    = "black" 



res_upper2                   =   res1
res_upper2@tiMainString      =   "" 
res_upper2@tiYAxisString     =   "(Depth)" 
res_upper2@tmYLMode          =   "Explicit"

    
res_upper2@tmYLValues        =   (/-300,-200,-100,-5/) 
res_upper2@tmYLLabels        =   (/-300,-200,-100,0/) 

res_upper2@tmXBMode          =   "Explicit"
res_upper2@tmXBValues        =   (/280,260,240,220,200,180,160,140/) 
res_upper2@tmXBLabels =   (/"80W","100W","120W","140W","160W","180","160E","140E"/) 
res_upper2@tmXBMinorValues   =   ispan(280,140,5)

res_upper2@tmYLMinorValues   =   ispan(0,-300,20)
res_upper2@vpHeightF         =   0.25
res_upper2@vpWidthF          =   0.75
res_upper2@vpYF              =   0.8
res_upper2@vpXF              =   0.2
;res_upper@lbLabelBarOn      =   False 

res_upper3                  =   res_upper2
res_upper3@cnLinesOn        =   True
res_upper3@cnFillOn         =   False
res_upper3@cnLineLabelsOn   =   True
res_upper3@gsnContourZeroLineThicknessF=2
res_upper3@cnLevelSelectionMode ="ManualLevels"

res_upper3@cnMinLevelValF       =-20
res_upper3@cnMaxLevelValF       =80
res_upper3@cnLevelSpacingF      =20



res_upper3@cnLineLabelFontHeightF=0.008
res_upper3@cnLineLabelDensityF   = 2.0

plot5   =gsn_csm_contour(wks,us21(0:18,140:280),res_upper2)
plot6   =gsn_csm_contour(wks,us21(0:18,140:280),res_upper3)
overlay(plot5,plot6)
plot(1)=plot5

resPanel                    = True           
resPanel@gsnPanelLabelBar   = True        
resPanel@lbLabelAutoStride  = True              
resPanel@lbLabelStride      = 2
resPanel@lbOrientation          = "vertical"                      
resPanel@gsnMaximize        = True             
gsn_panel(wks,plot,(/2,1/),resPanel)           



end                                               
