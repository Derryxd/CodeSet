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
pname= "distribution"
wks = gsn_open_wks("ps",dirp + pname)
gsn_define_colormap(wks,"BlAqGrYeOrRevi200") 
plot= new(nrun,graphic)
titleForRes=(/"2~S~o~N~","1~S~o~N~","0.5~S~o~N~","0.25~S~o~N~","0.125~S~o~N~"/)
leftString =(/"(a)","(b)","(c)","(d)"/)
rightString ="(~S~o~N~C)"

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
    Ttmp = fi->$var(0)$  ;annual mean for 50yrs
    Stmp = fi->$var(1)$  ;(yrs,lev,lat,lon)  
    T= Ttmp(25:29,:5,:,:)     ;5年上层50米气候态
    S= Stmp(25:29,:5,:,:)
    T(:,:,{90:78},:)=1e+35
    S(:,:,{90:78},:)=1e+35 
    T=T(:,:,::-1,:) 
    S=S(:,:,::-1,:) 
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
    res@gsnDraw             = False
    res@gsnFrame            = False
    res@gsnScalarContour    = True               ; contours desired
    res@gsnSpreadColors     = True               ; use full color map
    res@gsnAddCyclic        = False  ;默认为经度范围0~360，而模式结果为0~362，故设置false
    res@mpGridAndLimbOn     = False 
    res@mpPerimOn           = False 
    res@mpGridLatSpacingF   = 20.               
    res@mpGridLonSpacingF   = 30.
    res@mpFillOn            = False
    res@cnFillOn            = True
    res@cnLineLabelsOn      = False 
    ;res@cnLevelSelectionMode =  "ManualLevels"   
    ;res@cnMinLevelValF       =  0.
    ;res@cnMaxLevelValF       = 28.
    ;res@cnLevelSpacingF      =  2. 
    res@mpMinLonF           = 0
    res@mpMaxLonF           = 360  
    res@mpCenterLonF        = 180
    ;res@sfXArray=lon
    ;res@sfYArray=lat
    ;res@vpXF            = 0.1                 
    ;res@vpYF            = 0.9         
    ;res@vpWidthF        = 0.8
    ;res@vpHeightF       = 0.8
  
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
    resP@lbLabelStride          = 1
    resP@gsnMaximize            = True             
    resP@lbOrientation          = "vertical"  
    gsn_panel(wks,contour,(/2,2/),resP)  

print(systemfunc("date"))
end
