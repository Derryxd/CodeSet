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
    var = (/"ustide","vstide"/)    
   ;for res  2 / 1 / 0.5 / 0.25 / 0.125
    nres = (/"2","4","5","114","216"/)
    nlat = (/115,196,446, 940,1892/)
    nlon = (/182,362,722,1442,2882/)
;wks
dirp = "/public/home/jinjb/liudezhi/test/"
pname= "speed"
wks = gsn_open_wks("ps",dirp + pname)
gsn_define_colormap(wks,"BlAqGrYeOrRevi200") 
plot= new(nrun,graphic)
titleForRes=(/"2~S~o~N~","1~S~o~N~","0.5~S~o~N~","0.25~S~o~N~","0.125~S~o~N~"/)
leftString =(/"(a)","(b)","(c)","(d)"/)

fii = addfile("/public/home/jinjb/liudezhi/data/TSRes2Yrs50.nc", "r") 
lev = fii->lev
lev1= fii->lev1
do z=0,nrun-1
;read files  
    diri= "/public/home/jinjb/liudezhi/data/"
    fi= addfile(diri + "UVRes" + nres(z) + "Yrs50.nc", "r")     
    ;dims
    lat = fi->lat
    lon = fi->lon
    ;vars
    tmp  =new((/5,nlat(z),nlon(z)/),float,1e+35)
    us   =new((/nlat(z),nlon(z)/),float,1e+35)
    vs   =new((/nlat(z),nlon(z)/),float,1e+35)
    speed=new((/nlat(z),nlon(z)/),float,1e+35)
    U= fi->$var(0)$  ;annual mean for 50yrs
    V= fi->$var(1)$  ;(yrs,lev,lat,lon)
    U(:,:,{90:78},:)=1e+35
    V(:,:,{90:78},:)=1e+35  
;do calculate 
    ;wgt
    dz=new(6,float)
    do i=0,5
        dz(i)=abs(lev1(i)-lev1(i+1))
    end do
    ;avg about lev(6:50m) & yrs(5)
    tmp=dim_avg_wgt_n_Wrap(U(25:29,0:5,:,:),dz,1,1)
    us=dim_avg_n_Wrap(tmp,0) 
    printVarSummary(us)
    tmp=dim_avg_wgt_n_Wrap(V(25:29,0:5,:,:),dz,1,1)
    vs=dim_avg_n_Wrap(tmp,0)     
    speed=(vs^2+us^2)^0.5
    copy_VarMeta(us,speed)
;para for plot
    fontheight = 0.015
;memory
    setvalues NhlGetWorkspaceObjectId()          ; increase the maximum workspace memory
        "wsMaximumSize" : 300000000
    end setvalues
;res
    res = True
    res@gsnAddCyclic         = False
    res@lbLabelStride        = 2
    res@gsnDraw              = False
    res@gsnFrame             = False
    res@gsnScalarContour     = True               ; contours desired
    res@gsnSpreadColors      = True               ; use full color map
    res@vpHeightF = 0.40
    res@vpWidthF  = 0.73
    res@cnFillOn             = True               ; turn on color for contours
    res@cnLinesOn            = False              ; turn off contour lines
    res@cnLineLabelsOn       = False              ; turn off contour line labels
    res@cnInfoLabelOn        = False              ; turns off contour info label
    res@cnLevelSelectionMode = "ManualLevels"
    res@cnMaxLevelValF       = 0.30               ; set max contour level
    res@cnMinLevelValF       = 0                  ; set min contour level
    res@cnLevelSpacingF      = 0.03
    ;res@vcLevelSelectionMode = "ManualLevels"
    res@vcRefMagnitudeF           = 0.15           ; add a reference vector
    res@vcRefLengthF              = 0.05           ; what the ref length is
    res@vcMinDistanceF            = 0.025          ; thin out vectors
    res@vcRefAnnoOrthogonalPosF   = -0.9           ; move ref vector
    res@vcRefAnnoParallelPosF     = 0.3            ; move ref vector
    ;res@vcMonoLineArrowColor  = False             ; vec's colored by their mag_p_n
    res@vcRefAnnoPerimOn          = False
    res@vcRefAnnoString1          = res@vcRefMagnitudeF + " m/s"
    res@vcRefAnnoArrowLineColor   = "black"        ; change ref vector color
    res@vcRefAnnoArrowUseVecColor = False          ; don't use vec color for ref
    res@vcGlyphStyle              = "CurlyVector"  ; turn on curly vectors（总共：LineArrow、FillArrow、WindBarb、CurlyVector）
    ;res@vcLineArrowThicknessF    = 0.5            ; change vector thickness
    res@vcLineArrowHeadMaxSizeF   = 0.015
    res@vcLineArrowHeadMinSizeF   = 0.005  
    res@vcVectorDrawOrder         = "PostDraw"     ; draw vectors last
    res@vcLineArrowColor          = "black"        ; change vector color
    res@mpMinLonF            = 0
    res@mpMaxLonF            = 360  
    res@mpCenterLonF         = 180
    res@mpLimitMode          = "LatLon"          ;共有8种，latlon可以设置以下属性
    ;res@mpMinLatF           = -35
    ;res@mpMaxLatF           = 35
    ;res@mpLandFillColor     = "gray"            ; set land to be gray
    ;res@lbOrientation       = "Vertical"        ; vertical label bar
    ;res@lbPerimOn           = False             ; no box around it
    res@lbLabelBarOn =  False
    ; tick mark  <<<2
    res@tmLabelAutoStride    = True
    res@tmYROn               = False
    res@tmXTOn               = False
    res@tmYLLabelFontHeightF = fontheight
    res@tmXBLabelFontHeightF = fontheight
    res@gsnLeftString        = leftString(z)
    res@gsnCenterString      = "Velocity" + titleForRes(z)
    plot(z) =  gsn_csm_vector_scalar_map_ce(wks, us, vs, speed, res)
  ;delete vars
    delete(lon)
    delete(lat)
    delete(U)
    delete(V)
    delete(tmp)
    delete(speed)
    delete(us)
    delete(vs)
end do

;panle
    resP                        = True           
    resP@gsnPanelLabelBar       = True
    resP@lbLabelAutoStride      = True        
    resP@lbLabelStride          = 2
    resP@gsnMaximize            = True             
    resP@lbOrientation          = "vertical"  
    gsn_panel(wks,plot,(/2,2/),resP)  

print(systemfunc("date"))
end
