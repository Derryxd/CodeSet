 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin
;var 
    nyrs= 50
    nlev= 30
    var = (/"ts","ss","us","vs"/)    
   ;for res 2
     nres= "2"
     nlat= 115
     nlon= 182
   ;for res 0.5
     ; nres= "5"
     ; nlat= 446
     ; nlon= 722
   ;for res 0.25
    ;  nres= "114"
    ;  nlat= 940
    ;  nlon= 1442
   ;for res 0.125
    ;  nres= "216"
    ;  nlat= 1892
    ;  nlon= 2882
;build year string
    nl = str_get_nl()
    c = new((/nyrs,1/),string)
    do i = 1, nyrs
        c(i-1,0)= sprinti("%0.2i", i)
    end do
    print("built c array for years")
    print(nl + "-------------------------------------" + nl + "  ")
;read files
    wgt = (/0.08493151, 0.076712325, 0.08493151, 0.08219178 \  ; same size as dimension "time"
           ,0.08493151, 0.08219178 , 0.08493151, 0.08493151 \  ; (weigths of months)
           ,0.08219178, 0.08493151 , 0.08219178, 0.08493151 /)
    diri= "/public/home/jinjb/mius" + nres +"/exe/"
    fi0 = addfile(diri + "/MMEAN0001-01.nc", "r") 
    lat= fi0->lat
    lon= fi0->lon
    lev= fi0->lev
    lev1=fi0->lev1
    avgT_yr= new((/nyrs,nlev,nlat,nlon/),float,1e+35)            ; annual average of ts
    avgS_yr= new((/nyrs,nlev,nlat,nlon/),float,1e+35)            ; annual average of ss
    avgU_yr= new((/nyrs,nlev,nlat,nlon/),float,1e+35)            ; annual average of us
    avgV_yr= new((/nyrs,nlev,nlat,nlon/),float,1e+35)            ; annual average of vs
    do i= 1,nyrs
        files = systemfunc ("ls " + diri + "MMEAN00" + c(i-1,0) +"-*.nc")
        fi= addfiles(files, "r")
;do calculate 
        T= fi[:]->$var(0)$
        S= fi[:]->$var(1)$
        U= fi[:]->$var(2)$
        V= fi[:]->$var(3)$
        ;dim_avg_wgt_n_Wrap(Var,wgt,opt,dim)  
        ;opt=0 means compute the weighted average only if all values are not missing
        ;opt=1 means compute the weighted mean of all non-missing values
        avgT_yr(i-1,:,:,:)= dim_avg_wgt_n_Wrap(T,wgt,1,0)  
        avgS_yr(i-1,:,:,:)= dim_avg_wgt_n_Wrap(S,wgt,1,0)
        avgU_yr(i-1,:,:,:)= dim_avg_wgt_n_Wrap(U,wgt,1,0)  
        avgV_yr(i-1,:,:,:)= dim_avg_wgt_n_Wrap(V,wgt,1,0)
    end do
    avgT_yr!0="time"
    avgT_yr&time@units="id of year"
    avgT_yr&time=fspan(1,50,50)
    avgS_yr!0="time"
    avgS_yr&time@units="id of year"
    avgS_yr&time=fspan(1,50,50)
    avgU_yr!0="time"
    avgU_yr&time@units="id of year"
    avgU_yr&time=fspan(1,50,50)
    avgV_yr!0="time"
    avgV_yr&time@units="id of year"
    avgV_yr&time=fspan(1,50,50)
;write files
    setfileoption("nc","Format","LargeFile") 
    diro="/public/home/jinjb/liudezhi/"
    fo = addfile(diro + "Res" + nres + "Yrs50.nc", "c")
    fo->ts= avgT_yr
    fo->ss= avgS_yr
    fo->us= avgU_yr
    fo->vs= avgV_yr
    fo->lat = lat
    fo->lon = lon
    fo->lev = lev
    fo->lev1= lev1
end