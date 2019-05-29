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
dirp = "/public/home/jinjb/liudezhi/test/"
pname= "T_distribution"
wks_T = gsn_open_wks("ps",dirp + pname)
pname= "S_distribution"
wks_S = gsn_open_wks("ps",dirp + pname)
gsn_define_colormap(wks_T,"BlAqGrYeOrRevi200") 
gsn_define_colormap(wks_S,"BlAqGrYeOrRevi200") 
contour_T= new(nrun,graphic)
contour_S= new(nrun,graphic)
titleForRes=(/"(2~S~o~N~)","(1~S~o~N~)","(0.5~S~o~N~)","(0.25~S~o~N~)","(0.125~S~o~N~)"/)
leftString =(/"(a)","(b)","(c)","(d)"/)

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
    ; lat=lat(::-1)
    ;vars
    Ttmp = fi->$var(0)$  ;annual mean for 50yrs
    Stmp = fi->$var(1)$  ;(yrs,lev,lat,lon)  
    T= Ttmp(25:29,:5,:,:)     ;5年上层50米气候态
    S= Stmp(25:29,:5,:,:)
    T(:,:,{90:78},:)=1e+35
    S(:,:,{90:78},:)=1e+35 
    ; T=T(:,:,::-1,:) 
    ; S=S(:,:,::-1,:) 
    avgT_clm=dim_avg_n_Wrap(T,0)
    avgS_clm=dim_avg_n_Wrap(S,0)
    ts=dim_avg_n_Wrap(avgT_clm,0)
    ss=dim_avg_n_Wrap(avgS_clm,0) 
;para for plot
    fontheight = 0.015
;memory
    setvalues NhlGetWorkspaceObjectId()          ; increase the maximum workspace memory
        "wsMaximumSize" : 300000000
    end setvalues
;res
    res = True
    res@gsnDraw              = False
    res@gsnFrame             = False
    ; res@gsnScalarContour     = True               ; contours desired
    res@gsnSpreadColors      = True               ; use full color map
    res@gsnAddCyclic         = False  ;默认为经度范围0~360，而模式结果为0~362，故设置false
    res@mpGridAndLimbOn      = False 
    res@mpPerimOn            = False 
    res@mpGridLatSpacingF    = 20.               
    res@mpGridLonSpacingF    = 30.
    res@mpFillOn             = False
    res@cnFillOn             = True
    res@cnLinesOn            = False
    res@cnLineLabelsOn       = False 
    res@lbLabelBarOn         = False
    res@mpMinLonF            = 0
    res@mpMaxLonF            = 360  
    res@mpCenterLonF         = 180
    ;res@sfXArray=lon
    ;res@sfYArray=lat
    res@vpHeightF = 0.40
    res@vpWidthF  = 0.73         
    ;res@vpWidthF        = 0.8
    ;res@vpHeightF       = 0.8
    res@mpLimitMode          = "LatLon"          ;共有8种，latlon可以设置以下属性
    res@mpLandFillColor      = "gray90"            ; set land to be gray
    res@gsnLeftString        = leftString(z)
;contour
    res@cnLevelSelectionMode =  "ManualLevels"   
    res@cnMinLevelValF       =  28.
    res@cnMaxLevelValF       =  38.
    res@cnLevelSpacingF      =  1. 
    res@gsnCenterString      = "S" + titleForRes(z)
    res@gsnRightString       = "(psu)"
    contour_S(z)= gsn_csm_contour_map_ce(wks_S,ss,res)
    res@cnLevelSelectionMode =  "ManualLevels"   
    res@cnMinLevelValF       =  0.
    res@cnMaxLevelValF       =  28.
    res@cnLevelSpacingF      =  2. 
    res@gsnCenterString      = "T" + titleForRes(z)
    res@gsnRightString       = "(~S~o~N~C)"
    contour_T(z)= gsn_csm_contour_map_ce(wks_T,ts,res)
;delete vars
    delete(lon)
    delete(lat)
    delete(S)
    delete(T)
    delete(Stmp)
    delete(Ttmp)
    delete(avgS_clm)
    delete(avgT_clm)
    delete(ss)
    delete(ts)
end do

;panle
    resP                        = True           
    resP@gsnPanelLabelBar       = True
    resP@lbLabelAutoStride      = True        
    resP@lbLabelStride          = 2
    resP@gsnMaximize            = True             
    resP@lbOrientation          = "vertical"  
    gsn_panel(wks_S,contour_S,(/2,2/),resP)  
    gsn_panel(wks_T,contour_T,(/2,2/),resP)

print(systemfunc("date"))
end
