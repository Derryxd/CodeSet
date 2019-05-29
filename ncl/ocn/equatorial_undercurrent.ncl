 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

;具体设置labelbar要用overlay

begin
print(systemfunc("date"))

;res vars & purpuse
    nrun = 4
    nyrs = 30
    nlev = 30
    nlev300=19              ;19层深为300m
    var = (/"ustide"/)      ;纬向流
;for res  2 / 1 / 0.5 / 0.25 / 0.125
    nres = (/"2","4","5","114","216"/)
    vres = (/ 2 , 1 ,0.5, 0.25,0.125/)
    nlat = (/115,196,446, 940,1892/)
    nlon = (/182,362,722,1442,2882/)
;wks
wks= gsn_open_wks("ps","equaCurrent")
plot = new(nrun,graphic)
gsn_define_colormap(wks,"BkBlAqGrYeOrReViWh200") 
titleForRes=(/"(2~S~o~N~)","(1~S~o~N~)","(0.5~S~o~N~)","(0.25~S~o~N~)","(0.125~S~o~N~)"/)
leftString =(/"(a)","(b)","(c)","(d)"/)

fii = addfile("/public/home/jinjb/liudezhi/data/TSRes2Yrs50.nc", "r") 
lev = fii->lev
lev1= fii->lev1
do z=0,nrun-1 
;read files  
    diri=   "/public/home/jinjb/liudezhi/data/"
    ; diri="/disk7/liudezhi/1/"
    finame= "UVRes" + nres(z) + "Yrs50.nc"
    fi= addfile(diri + finame, "r")     
    ;dims
    lat = fi->lat
    lon = fi->lon
    ;vars
    U_zonal_equa=new((/nlev300,nlon(z)/),float,1e+35)
    tmp=new((/nlev300,nlon(z)/),float,1e+35)
    Utmp= fi->$var(0)$  ;annual mean for 50yrs(yrs,lev,lat,lon)
    U=Utmp(25:29,:,:,:)
    U(:,:,{90:78},:)=1e+35
    U_clim=dim_avg_n_Wrap(U,0)          ;气候态(lev,lat,lon)
    ; U_clim=U(0,:,:,:)
    U_300m=U_clim(:nlev300-1,:,:)    ;300深数据(lev,lat,lon)
;judge & calculate
    indice=ind(lat.eq.78)
    size=dimsizes(lat)
    if (size%2 .eq. 0) then 
        ind_lat= (size-indice)/2+indice
        tmp=U_300m(:,ind_lat,:)
        U_zonal_equa=(U_300m(:,ind_lat,:)+U_300m(:,ind_lat+1,:))/2
        copy_VarMeta(tmp,U_zonal_equa)
    else 
        ind_lat= ind(lat.eq.0)
        U_zonal_equa= U_300m(:,ind_lat,:)
    end if 
    ; print(ind_lat)
    U_zonal_equa=U_zonal_equa*100      ;单位转化(m/s--->cm/s)
    ; printVarSummary(U_zonal_equa)
    maxU=max(U_zonal_equa(:,{140:270}))
    ; print(maxU)
;write files
    diro="/public/home/jinjb/liudezhi/test/"
    system ("rm "+ diro + "eqRes" + nres(z) + ".nc")
    fo = addfile(diro + "eqRes" + nres(z) + ".nc", "c")
    fo->us  = U_zonal_equa
    fo->lat = lat
    fo->lon = lon
    fo->lev = lev(:18)
    fo->lev1= lev1  
;res
    res                         = True         
    res@gsnFrame                = False
    res@gsnDraw                 = False
    res@gsnAddCyclic            = False       
    res@cnFillOn                = True 
    res@cnLinesOn               = True            ;设置等值线
    res@cnLineLabelsOn          = True   
    res@cnInfoLabelOn           = False      
    res@lbLabelBarOn            = False           ;panel设置公用lb
    ; res@cnLevelSelectionMode    = "ManualLevels"   
    ; res@cnMinLevelValF          =  min(zonalmeanS)-0.1            
    ; res@cnMaxLevelValF          =  max(zonalmeanS)+0.1            
    ; res@cnLevelSpacingF         =  (max(zonalmeanS)-min(zonalmeanS)+0.2)/15
    res@gsnSpreadColors         = True           
    res@gsnXAxisIrregular2Linear= True 
    res@gsnYAxisIrregular2Linear= True            ;深度坐标非线性
    res@cnLevelSelectionMode    = "ExplicitLevels"     
    res@cnLevels                = (/-80,-60,-40,-20,-10,-5,0,5,10,20,40,60,80,100/)
    res@cnFillColors            = (/177,17,33,58,63,81,201,201,100,113,125,135,147,159,184/)
    res@cnLineLabelDensityF     = 1.5               ; increase the number of line labels/line
    ; res@cnLineLabelInterval   = 2                 ; labels for every line (default=2)
    res@cnLabelMasking          = True              ; do not draw labels over contour
    res@gsnContourZeroLineThicknessF= 2
    ; res@cnLineLabelDensityF   = 2.0
    res@cnLineThicknessF        = 1.5
    res@cnLineColor             ="black"
    ; res@lbOrientation           = "vertical"      
    ; res@lbLabelAutoStride       = True            
    res@gsnCenterString         = "U" + titleForRes(z)
    res@gsnLeftString           = leftString(z)
    res@gsnRightString          = "(cm/s)"
    res@tiYAxisString           = "depth (m)"
    ; res@mpMinLonF             = 40
    ; res@mpMaxLonF             = 320  
    ; res@mpCenterLonF          = 180
    res@vpHeightF         =   0.25
    res@vpWidthF          =   0.75
    res@vpYF              =   0.8
    res@vpXF              =   0.2
    res@tmYLMode          =  "Explicit"
    res@tmYLValues        =  (/-300,-200,-100,-5/) 
    res@tmYLLabels        =  (/-300,-200,-100,0/) 
    res@tmXBMode          =  "Explicit"
    res@tmXBValues        =  (/280,260,240,220,200,180,160,140/) 
    res@tmXBLabels        =  (/"80W","100W","120W","140W","160W","180","160E","140E"/) 
    res@tmXBMinorValues   =  ispan(280,140,5)
    res@tmYLMinorValues   =  ispan(0,-300,20)

    ; res_upper                  =   res
    ; res_upper@cnLinesOn        =   True
    ; res_upper@cnFillOn         =   False
    ; res_upper@cnLineLabelsOn   =   True
    ; res_upper@gsnContourZeroLineThicknessF=2
    ; res_upper@cnMinLevelValF       =-20
    ; res_upper@cnMaxLevelValF       =80
    ; res_upper@cnLevelSpacingF      =20
    ; res_upper@cnLineLabelFontHeightF= 0.008
    ; ;res_upper@cnLineLabelDensityF  = 2.0

;contour
    ; plot1   =gsn_csm_contour(wks,U_zonal_equa(:,{140:270}),res)
    ; plot2   =gsn_csm_contour(wks,U_zonal_equa(:,{140:270}),res_upper)
    ; overlay(plot1,plot2)
    ; plot(z)=plot1
    plot(z)=gsn_csm_contour(wks,U_zonal_equa(:,{140:270}),res)
;delete vars
    delete(lon)
    delete(lat)
    delete(U)
    delete(U_300m)
    delete(U_clim)
    delete(U_zonal_equa)
    delete(tmp)
    delete(Utmp)
end do

;panel
    resP                      = True  
    resP@gsnPanelLabelBar     = True        
    resP@gsnMaximize          = True    
    resP@lbLabelStride        = 2   
    resP@lbOrientation        = "vertical"  
    resP@gsnPanelMainString   = "Equatorial Current"  
    gsn_panel(wks,plot,(/2,2/),resP) 

print(systemfunc("date"))
end
