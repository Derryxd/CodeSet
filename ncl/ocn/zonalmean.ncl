 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin
print(systemfunc("date"))

;res vars & purpuse
    nrun = 4        ;暂时计算两个分辨率
    nyrs = 30
    nlev = 30
    var = (/"ts","ss"/)    
   ;for res  2 / 1 / 0.5 / 0.25 / 0.125
    nres = (/"2","4","5","114","216"/)
    nlat = (/115,196,446, 940,1892/)
    nlon = (/182,362,722,1442,2882/)
;wks
wks_T= gsn_open_wks("ps","zonalmeanT")
wks_S= gsn_open_wks("ps","zonalmeanS")
plot_S = new(nrun,graphic)
plot_T = new(nrun,graphic)
gsn_define_colormap(wks_T,"BlAqGrYeOrRevi200") 
gsn_define_colormap(wks_S,"BlAqGrYeOrRevi200") 
titleForRes=(/"2~S~o~N~","1~S~o~N~","0.5~S~o~N~","0.25~S~o~N~","0.125~S~o~N~"/)

fii = addfile("/public/home/jinjb/liudezhi/data/TSRes2Yrs50.nc", "r") 
lev = fii->lev
lev1= fii->lev1
do z=0,nrun-1 
;read files  
    diri= "/public/home/jinjb/liudezhi/data/"
    fi= addfile(diri + "TSRes" + nres(z) + "Yrs50.nc", "r")     
    ;dims
    lat = fi->lat
    lon = fi->lon
    ;vars
    zonalmeanT=new((/nlev,nlat(z)/),float,1e+35)
    zonalmeanS=new((/nlev,nlat(z)/),float,1e+35)    
    Ttmp= fi->$var(0)$  ;annual mean for 50yrs
    Stmp= fi->$var(1)$  ;(yrs,lev,lat,lon)
    T=Ttmp(nyrs-5:nyrs-1,:,:,:)
    S=Stmp(nyrs-5:nyrs-1,:,:,:)
    T(:,:,{90:78},:)=1e+35
    S(:,:,{90:78},:)=1e+35  
;do calculate 
    ;avg about lev
    avgT_clm=dim_avg_n_Wrap(T,0)
    avgS_clm=dim_avg_n_Wrap(S,0)
    zonalmeanT=dim_avg_n_Wrap(avgT_clm,2)
    zonalmeanS=dim_avg_n_Wrap(avgS_clm,2) 
    printVarSummary(zonalmeanT)
;write files
    diro="/public/home/jinjb/liudezhi/test/"
    system ("rm "+ diro + "meanfile" + nres(z) + ".nc")
    fo = addfile(diro + "meanfile" + nres(z) + ".nc", "c")
    fo->cs  = avgS_clm
    fo->ct  = avgT_clm
    fo->zs  = zonalmeanS
    fo->zt  = zonalmeanT
    fo->lat = lat
    fo->lon = lon
    fo->lev = lev
    fo->lev1= lev1    
;res
    res                         = True         
    res@gsnFrame                = False
    res@gsnDraw                 = False
    res@cnInfoLabelOn           = False 
    res@cnFillOn                = True           
    ; res@cnLevelSelectionMode    = "ManualLevels"   
    ; res@cnMinLevelValF          =  min(zonalmeanS)-0.1            
    ; res@cnMaxLevelValF          =  max(zonalmeanS)+0.1            
    ; res@cnLevelSpacingF         =  (max(zonalmeanS)-min(zonalmeanS)+0.2)/15
    res@gsnSpreadColors         = True           
    res@gsnXAxisIrregular2Linear= True 
    res@gsnYAxisIrregular2Linear= True            ;深度坐标非线性
    res@lbOrientation           = "vertical"
    res@lbLabelBarOn            = False      
    ; res@gsnRightString        = "psu"
    ; res@gsnCenterString       = "salinity"
    res@tiMainString            = titleForRes(z)
    res@tiYAxisString           = "depth (m)"
    res@cnMissingValPerimOn     = True            ;缺失数据处设置
    res@cnMissingValFillPattern = 3               
    res@cnMissingValFillColor   = "black"       
    res@cnLinesOn               = True            ;设置等值线
    res@cnLineLabelsOn          = False         
    res@gsnXAxisIrregular2Linear= True 
    res@gsnYAxisIrregular2Linear= True            ;深度坐标非线性
    ; res@gsnContourZeroLineThicknessF=3
    res@cnLineLabelInterval     = 1
    res@cnLineLabelFontHeightF  = 0.018
    ; res@cnLineLabelDensityF    = 2.0
    res@cnLineThicknessF        = 1.5
    res@cnLineColor             ="black"
;contour
    res@cnLevelSelectionMode    = "ExplicitLevels"
    res@cnLevels                = ispan(0,28,2)
    plot_T(z) = gsn_csm_contour(wks_T,zonalmeanT,res)
    delete(res@cnLevels) 
    res@cnLevelSelectionMode    = "ExplicitLevels"
    res@cnLevels                = fspan(32.5,35.75,14)
    plot_S(z) = gsn_csm_contour(wks_S,zonalmeanS,res)
    delete(res@cnLevels) 
     
;delete vars
    delete(lon)
    delete(lat)
    delete(S)
    delete(T)
    delete(avgS_clm)
    delete(avgT_clm)
    delete(zonalmeanS)
    delete(zonalmeanT)
    delete(Ttmp)
    delete(Stmp)
end do

;panle
    resP                      = True           
    resP@gsnPanelLabelBar     = True        
    ;resP@lbLabelStride       = 2
    resP@gsnMaximize          = True 
    resP@lbLabelAutoStride    = True              
    resP@lbOrientation        = "vertical"  
    resP@gsnPanelMainString   = "zonal mean of salinity"  
    gsn_panel(wks_S,plot_S,(/2,2/),resP) 
    resP@gsnPanelMainString   = "zonal mean of temperature"
    gsn_panel(wks_T,plot_T,(/2,2/),resP) 

print(systemfunc("date"))
end
