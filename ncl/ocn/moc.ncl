load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
begin

b1=addfile("/public/home/jinjb/jinjb_plot/high/data/mocmius93yr26.nc","r")
moc1   =b1->moc
moc10=moc1(0,:,:)
moc10  =dim_avg_n(moc1(0:4,:,:),0)
;k01=dim_max_n(amoctide01(0:15,157:177),1)

b2=addfile("/public/home/jinjb/jinjb_plot/high/data/mocmius88yr5.nc","r")
moc2   =b2->moc
moc20=moc2(0,:,:)
moc20  =dim_avg_n(moc2(0:4,:,:),0)

b3=addfile("/public/home/jinjb/jinjb_plot/high/data/mocmius114yr5.nc","r")
moc3  =b3->moc
moc30=moc3(0,:,:)
moc30  =dim_avg_n(moc3(0:4,:,:),0)

b4=addfile("/public/home/jinjb/jinjb_plot/high/data/mocmius216yr5.nc","r")
moc4  =b4->moc
moc40=moc4(0,:,:)
moc40  =dim_avg_n(moc4(0:4,:,:),0)

;c=addfile("/disk6/jiangti/test1/Tide0100-01.nc","r")
;lat    =b0->lat
;lat1   =c->lat
;lev1   =c->lev1
;lev    =c->lev


wks = gsn_open_wks("pdf","moc")                
plot              =new(4,graphic)
gsn_define_colormap(wks,"BlAqGrYeOrRevi200")      
res                         = True            
res@gsnFrame                = False     
res@gsnDraw                 = False     
res@cnFillOn                = True           
;res@lbLabelBarOn            = False
res@cnLineLabelsOn          = False         
res@cnLinesOn               = False         
res@cnInfoLabelOn           = False       
res@cnLevelSelectionMode    = "ManualLevels"   
res@cnMinLevelValF          =  -40            
res@cnMaxLevelValF          =  40            
res@cnLevelSpacingF         =5
res@gsnSpreadColors         = True           
res@gsnYAxisIrregular2Linear=True
res@lbOrientation          = "vertical"      
res@lbLabelAutoStride      = True            
;res@sfXArray               = moct&lat          
;res@sfYArray               = moct&depth/1000 
;res@tiXAxisString          = "depth (m)"

res@gsnRightString="Sv"
res@gsnCenterString ="(a) MOC(1~S~o~N~)"
res@tiYAxisString =""
res@tiMainString  =""
res@cnMissingValPerimOn     = True           
res@cnMissingValFillPattern = 3               
res@cnMissingValFillColor   = "black"       
res@gsnXAxisIrregular2Linear=True

res1                      =True
res1@cnLinesOn            =True
res1@cnFillOn             =False
res1@cnLevelSelectionMode = "ExplicitLevels"
;res1@cnLevels             = (/-2,0,10,15/)
res1@cnLevels             = (/0/)

res1@gsnDraw              =False
res1@gsnFrame             =False
res1@gsnContourZeroLineThicknessF=3
res1@cnLineLabelInterval  = 1
res1@cnInfoLabelOn        = False
res1@cnLineLabelFontHeightF=0.018
res1@cnLineLabelDensityF   = 2.0
res1@cnLineThicknessF      = 1.5
res1@cnLineColor           ="black"

res1@gsnLeftString        =""
plot1   = gsn_csm_contour(wks,moc10,res)       
plot2   = gsn_csm_contour(wks,moc10,res1)
overlay(plot1,plot2)
plot(0) =plot1

res@gsnCenterString ="(b) MOC(0.5~S~o~N~)"
plot3   = gsn_csm_contour(wks,moc20,res)       
plot4   = gsn_csm_contour(wks,moc20,res1)
overlay(plot3,plot4)
plot(1) =plot3

res@gsnCenterString ="(c) MOC(0.25~S~o~N~)"
plot5  = gsn_csm_contour(wks,moc30,res)       
plot6   = gsn_csm_contour(wks,moc30,res1)
overlay(plot5,plot6)
plot(2) =plot5

res@gsnCenterString ="(d) MOC(0.125~S~o~N~)"
plot7 = gsn_csm_contour(wks,moc40,res)       
plot8  = gsn_csm_contour(wks,moc40,res1)
overlay(plot7,plot8)
plot(3) =plot7


res2                         = True         
res2@gsnFrame                = False
res2@gsnDraw                 = False  
res2@cnFillOn                = True           
;res2@lbLabelBarOn            = False
res2@cnLineLabelsOn          = False         
res2@cnLinesOn               = False         
res2@cnInfoLabelOn           = False       
res2@cnLevelSelectionMode    = "ManualLevels"   
res2@cnMinLevelValF          =  -10             
res2@cnMaxLevelValF          =  22            
res2@cnLevelSpacingF         = 1
res2@gsnSpreadColors         = True           
res2@gsnYAxisIrregular2Linear=True
res2@lbOrientation          = "vertical"      
res2@lbLabelAutoStride      = True            
;res@sfXArray               = moct&lat          
;res@sfYArray               = moct&depth/1000 
;res@tiXAxisString          = "depth (m)"

res2@gsnRightString="Sv"
res2@gsnCenterString ="(b) AMOC(HIGH)"
res2@tiYAxisString =""
res2@tiMainString  =""
res2@cnMissingValPerimOn     = True           
res2@cnMissingValFillPattern = 3               
res2@cnMissingValFillColor   = "black"       
res2@gsnXAxisIrregular2Linear=True

res3                      =True
res3@cnLinesOn            =True
res3@cnFillOn             =False
res3@cnLevelSelectionMode = "ExplicitLevels"
;res3@cnLevels             = (/-2,0,5,10,13/)
res3@cnLevels             = (/-33/)

res3@gsnDraw              =False
res3@gsnFrame             =False
res3@gsnContourZeroLineThicknessF=3
res3@cnLineLabelInterval  = 1
res3@cnInfoLabelOn        = False
res3@gsnLeftString        =""
res3@cnLineLabelFontHeightF=0.018
res3@cnLineLabelDensityF   = 2.0
res3@cnLineThicknessF      = 1.5
res3@cnLineColor           ="black"

;plot7   = gsn_csm_contour(wks,bmoctide01,res2)       
;plot8   = gsn_csm_contour(wks,bmoctide01,res3)
;overlay(plot7,plot8)
;plot(1) =plot7

resPanel                 = True           
;resPanel@gsnPanelLabelBar= True        
;resPanel@lbLabelStride   = 2
resPanel@gsnMaximize     = True             
;resPanel@lbOrientation          = "vertical"       
gsn_panel(wks,plot,(/2,2/),resPanel)       
end




