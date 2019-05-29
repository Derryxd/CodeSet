 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin
print(systemfunc("date"))

;res & depth & purpuse
    nrun = 4        ;暂时计算两个分辨率
    nyrs = 30
    nlev = 30
    var = (/"ts","ss"/)    
   ;for res  2 / 1 / 0.5 / 0.25 / 0.125
    nres = (/"2","4","5","114","216"/)
    nlat = (/115,196,446, 940,1892/)
    nlon = (/182,362,722,1442,2882/)
    dirp ="/public/home/jinjb/liudezhi/dept/"
    indfile=(/  "INDEX1152.nc"         , \
                "INDEX.DATA_362X196.nc", \ 
                "INDEX.DATA.nc"        , \
                "INDEXold9402.nc"      , \
                "INDEXooold1892n.nc "    /)
    globalmeanT=new((/nrun,nyrs/),float,1e+35)
    globalmeanS=new((/nrun,nyrs/),float,1e+35)
    globalmeanSST=new((/nrun,nyrs/),float,1e+35)
    globalmeanSSS=new((/nrun,nyrs/),float,1e+35)

fii = addfile("/public/home/jinjb/liudezhi/data/TSRes2Yrs50.nc", "r") 
lev = fii->lev
lev1= fii->lev1
do z=0,nrun-1 
;read files  
    fdep=addfile(dirp + indfile(z), "r")  
    indi =fdep->ind        ;(lev,lat,lon),有31层
    ;indi:units = "1 for sea, 0 for land"
    indi(nlev,:,:)=0       ;最后一层为缺失值，默认均为陆面
    diri= "/public/home/jinjb/liudezhi/data/"
    fi= addfile(diri + "TSRes" + nres(z) + "Yrs50.nc", "r")     
    ;dims
    lat= fi->lat
    lon= fi->lon
    ;vars
    Ttemp= fi->$var(0)$  ;annual mean for 50yrs
    Stemp= fi->$var(1)$  ;(yrs,lev,lat,lon)
    T=Ttemp(:nyrs-1,:,:,:)
    S=Stemp(:nyrs-1,:,:,:) 
    T(:,:,{90:78},:)=1e+35
    S(:,:,{90:78},:)=1e+35  

;do calculate 
    ;avg about lev
    dz=new(nlev,float)
    do i=0,nlev-1
        dz(i)=abs(lev1(i)-lev1(i+1))
    end do
    avgT_lev=dim_avg_wgt_n_Wrap(T,dz,1,1)
    avgS_lev=dim_avg_wgt_n_Wrap(S,dz,1,1)
      ;dim_avg_wgt_n_Wrap(Var,wgt,opt,dim)  
      ;opt=1 means compute the weighted mean of all non-missing values
    ;seadep
    seadep=new((/nlat(z),nlon(z)/),float,1e+35)
    tmp=conform_dims((/nlev+1,nlat(z),nlon(z)/),lev1,0) ;海洋深度矩阵，值为负
      ;conform_dims(dims,r,ndim)    
    indi_tmp=new((/nlev+1,nlat(z),nlon(z)/),float)
    indi_tmp(0,:,:)=indi(0,:,:)
    indi_tmp(1:nlev,:,:)=indi(0:nlev-1,:,:)
    seadep=dim_sum_n_Wrap((indi-indi_tmp)*tmp,0)  
      ;indi-indi_tmp结果为-1/0的逻辑判断矩阵
      ;两矩阵点乘只有海底位置有值，值为海洋深度，其余值为0
    delete(tmp)
    delete(indi_tmp)
         ;上述代码的意思如下，目的为减少do循环节约计算时间，代价为需要更多内存
         ; seadep=new((/nlat(z),nlon(z)/),float,1e+35)
         ; seadep=abs(lev1(30))
         ; do i=0,nlat(z)-1
         ; do j=0,nlon(z)-1
         ; do k=0,nlev-1
         ;    if (indi(k,i,j).eq.0)  then
         ;        seadep(i,j)=abs(lev1(k))
         ;        break
         ;    end if
         ; end do
         ; end do
         ; end do
    ;do wgt
    wgt=NormCosWgtGlobe(lat)
    dlat = new(nlat(z),float)
    do i=0,nlat(z)-2
       dlat(i)      = lat(i)-lat(i+1)
    end do
    dlat(nlat(z)-1) =1
    wgtlat_tmp= wgt*dlat
    wgtlat    = conform_dims((/nlat(z),nlon(z)/),wgtlat_tmp,0)
    wgtsum    = wgtlat*seadep
    globalmeanT(z,:)=wgt_areaave2(avgT_lev,wgtsum,0)
    globalmeanS(z,:)=wgt_areaave2(avgS_lev,wgtsum,0)
    Tupper= dim_avg_n_Wrap(T(:,:5,:,:),1)
    Supper= dim_avg_n_Wrap(S(:,:5,:,:),1)
    globalmeanSST(z,:)=wgt_areaave2(Tupper,wgtlat,0)
    globalmeanSSS(z,:)=wgt_areaave2(Supper,wgtlat,0)       
      ;If opt = 0, the area average is calculated using available non-missing data

;write files
    diro="/public/home/jinjb/liudezhi/test/"
    system ("rm "+ diro + "Res" + nres(z) + "depth.nc")
    setfileoption ("nc","Format","LargeFile") 
    fo = addfile(diro + "Res" + nres(z) + "depth.nc", "c")
    fo->seadep = seadep
    fo@creation_date = systemfunc("date")

;delete vars
    delete(dlat)
    delete(wgt)
    delete(wgtlat)
    delete(wgtlat_tmp)
    delete(wgtsum)
    delete(seadep)
    delete(lon)
    delete(lat)
    delete(indi)
    delete(S)
    delete(T)
    delete(avgS_lev)
    delete(avgT_lev)
    delete(Ttemp)
    delete(Stemp)
    delete(Tupper)
    delete(Supper)
end do 

;plot 
    ;wks & var
    wks_T=gsn_open_wks("ps", "globalmeanT")
    wks_S=gsn_open_wks("ps", "globalmeanS")    
    gsn_define_colormap(wks_T,"BlAqGrYeOrRevi200")
    gsn_define_colormap(wks_S,"BlAqGrYeOrRevi200")
    plot_T=new(nrun,graphic)
    plot_S=new(nrun,graphic)
    x=ispan(1, nyrs, 1)
    lineColor=(/"red","blue","orange","black","WhiteBlue"/)
    legendLabel=(/"2~S~o~N~","1~S~o~N~","0.5~S~o~N~","0.25~S~o~N~","0.125~S~o~N~"/)
   
    ;main res
    res                        = True
    res@trXMinF                = 1
    res@trXMaxF                = nyrs
    res@gsnFrame               = False
    res@gsnDraw                = False
    res@xyLineThicknesses      = conform_dims((/1,nrun/),2.0,0)
    res@xyDashPatterns         = conform_dims((/1,nrun/),0.0,0)
    res@vpWidthF               = 0.6
    res@vpHeightF              = 0.3 
    res@xyLineColors           = lineColor(0:nrun-1)
    res@xyExplicitLegendLabels = legendLabel(0:nrun-1)
    res@lgPerimOn              = False          ; 图例
    ; res@gsnYRefLine            =34.72829       ；参考线
    ; res@gsnYRefLineDashPattern =1.0
    ; res@gsnYRefLineThicknessF  =1.5
    ; res@gsnYRefLineColor       ="black"
    res@pmLegendDisplayMode    = "Always"        ; 图例管理
    res@pmLegendWidthF         = 0.10
    res@pmLegendHeightF        = 0.08
    res@pmLegendOrthogonalPosF = -1.48  ;-1.10
    res@pmLegendParallelPosF   = 0.88   ;0.10
    ; res@lbBoxMajorExtentF    = 0.80    
    res@lgLabelFontHeightF     = 0.009
  
    ;plot & specific res
    ;SST
    res@gsnCenterString        ="(a) SST"
    res@trYMinF                = min(globalmeanSST)-0.05
    res@trYMaxF                = max(globalmeanSST)+0.05 
    res@tiYAxisString          = "~S~o~N~C"   ; y轴单位为°C
    plot_T(0)  =gsn_csm_xy(wks_T,x,globalmeanSST,res)
    ;T
    res@gsnCenterString        ="(b) T"
    res@trYMinF                = min(globalmeanT)-0.05
    res@trYMaxF                = max(globalmeanT)+0.05
    plot_T(1)  =gsn_csm_xy(wks_T,x,globalmeanT,res)
    ;panel 
    resP_T                 = True           
    resP_T@gsnMaximize     = True             
    gsn_panel(wks_T,plot_T,(/2,1/),resP_T) 
    
    ;SSS
    res@gsnCenterString        ="(a) SSS"
    res@trYMinF                = min(globalmeanSSS)-0.05
    res@trYMaxF                = max(globalmeanSSS)+0.05 
    res@tiYAxisString          = "(psu)"         ; y轴单位为psu
    plot_S(0)  =gsn_csm_xy(wks_S,x,globalmeanSSS,res)
    ;S
    res@gsnCenterString        ="(b) S"
    res@trYMinF                = 34.720
    res@trYMaxF                = 34.750
    plot_S(1)  =gsn_csm_xy(wks_S,x,globalmeanS,res)
    ;panel
    resP_S                 = True           
    resP_S@gsnMaximize     = True             
    gsn_panel(wks_S,plot_S,(/2,1/),resP_S) 

print(systemfunc("date"))
end