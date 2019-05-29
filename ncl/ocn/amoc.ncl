load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
begin


c =addfile("/public/home/jinjb/mius118/exe/MMEAN0001-01.nc","r")
lat    =c->lat
lon    =c->lon
lev1   =c->lev1
lev    =c->lev

b0  = addfile("/public/home/jinjb/cesm1.0.5/ctrl/chengxu/amocctrl.nc","r")
bmoctide0   =b0->amoc
b1  =addfile("/public/home/jinjb/cesm1.0.5/ctrl/chengxu/amocheat.nc","r")

bmoctide1   =b1->amoc


bmoctide01  =dim_avg_n(bmoctide0(:,:,:),0)
bmoctide11  =dim_avg_n(bmoctide1(:,:,:),0)
k01=max(bmoctide01)
k11=max(bmoctide11)
print(k01)
print(k11)

bmocbias=bmoctide11-bmoctide01

bmoctide31=bmoctide01
bmoctide31!0           = "depth"
bmoctide31!1           = "lat"
bmoctide31&depth       = lev
bmoctide31&lat         = lat

copy_VarCoords(bmoctide31,bmoctide01)
copy_VarCoords(bmoctide31,bmoctide11)
copy_VarCoords(bmoctide31,bmocbias)



wks = gsn_open_wks("pdf","amoc")                
plot              =new(4,graphic)
gsn_define_colormap(wks,"BlAqGrYeOrRevi200")      

res1                      =True
res1@cnLinesOn            =True
res1@cnFillOn             =False
res1@cnLevelSelectionMode = "ExplicitLevels"
res1@cnLevels             = (/-2,0,10,15/)
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
res2@cnMaxLevelValF          =  18         
res2@cnLevelSpacingF         = 2.0
res2@gsnSpreadColors         = True           
res2@gsnYAxisIrregular2Linear=True
res2@lbOrientation          = "vertical"      
res2@lbLabelAutoStride      = True            
;res@sfXArray               = moct&lat          
;res@sfYArray               = moct&depth/1000 
;res@tiXAxisString          = "depth (m)"

res2@gsnRightString="Sv"
res2@gsnCenterString ="(a) AMOC(CTRL)"
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
res3@cnLevels             = (/-2,0,5,15/)
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

plot7   = gsn_csm_contour(wks,bmoctide01,res2)       
plot8   = gsn_csm_contour(wks,bmoctide01,res3)
overlay(plot7,plot8)
plot(0) =plot7

res2@gsnCenterString         ="(b) AMOC(Exp1)"
plot9   = gsn_csm_contour(wks,bmoctide11,res2)       
plot10   = gsn_csm_contour(wks,bmoctide11,res3)
overlay(plot9,plot10)
plot(1) =plot9

res2                         = True         
res2@gsnFrame                = False
res2@gsnDraw                 = False  
res2@cnFillOn                = True           
;res2@lbLabelBarOn            = False
res2@cnLineLabelsOn          = False         
res2@cnLinesOn               = False         
res2@cnInfoLabelOn           = False       
res2@cnLevelSelectionMode    = "ManualLevels"   
res2@cnMinLevelValF          =  -2          
res2@cnMaxLevelValF          =  2       
res2@cnLevelSpacingF         = 0.25
res2@gsnSpreadColors         = True           
res2@gsnYAxisIrregular2Linear=True
res2@lbOrientation          = "vertical"      
res2@lbLabelAutoStride      = True            
;res@sfXArray               = moct&lat          
;res@sfYArray               = moct&depth/1000 
;res@tiXAxisString          = "depth (m)"

res2@gsnRightString="Sv"
res2@gsnCenterString ="(c) AMOC bias(EXP1-CTRL)"
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
res3@cnLevels             = (/-2,0,2,3/)
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

plot13   = gsn_csm_contour(wks,bmocbias,res2)       
plot14   = gsn_csm_contour(wks,bmocbias,res3)
overlay(plot13,plot14)
plot(2) =plot13


resPanel                 = True           
;resPanel@gsnPanelLabelBar= True        
;resPanel@lbLabelStride   = 2
resPanel@gsnMaximize     = True             
;resPanel@lbOrientation          = "vertical"       
gsn_panel(wks,plot,(/2,2/),resPanel)       
end




