 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin
print(systemfunc("date"))

;var 
nrun=2
nyrs= 50
nlev= 30
var = (/"ts","ss"/)  
;for res 2 / 0.5 / 0.25 / 0.125
nres = (/"2","5","114","216"/)
nlat = (/115,446, 940,1892/)
nlon = (/182,722,1442,2882/)
time=fspan(1,50,50)
;build year string
    nl = str_get_nl()
    c = new((/nyrs,1/),string)
    do i = 1, nyrs
        c(i-1,0)= sprinti("%0.2i", i)
    end do
    print("built c array for years")
    print(nl + "-------------------------------------" + nl + "  ")

do z=0,nrun-1
;read files
    wgt = (/0.08493151, 0.076712325, 0.08493151, 0.08219178 \  ; same size as dimension "time"
           ,0.08493151, 0.08219178 , 0.08493151, 0.08493151 \  ; (weigths of months)
           ,0.08219178, 0.08493151 , 0.08219178, 0.08493151 /)
    diri= "/public/home/jinjb/mius" + nres(z) +"/exe/"
    fi0 = addfile(diri + "MMEAN0001-01.nc", "r") 
    lat= fi0->lat
    lon= fi0->lon
    lev= fi0->lev
    lev1=fi0->lev1
    avgT_yr= new((/nyrs,nlev,nlat(z),nlon(z)/),float,1e+35)            ; annual average of us
    avgS_yr= new((/nyrs,nlev,nlat(z),nlon(z)/),float,1e+35)            ; annual average of vs
    do i= 1,nyrs
        files= systemfunc ("ls " + diri + "MMEAN00" + c(i-1,0) +"-*.nc")
        fi   = addfiles(files, "r")
;do calculate 
        T= fi[:]->$var(0)$
        S= fi[:]->$var(1)$
        ;dim_avg_wgt_n_Wrap(Var,wgt,opt,dim)  
        ;opt=0 means compute the weighted average only if all values are not missing
        ;opt=1 means compute the weighted mean of all non-missing values
        avgT_yr(i-1,:,:,:)= dim_avg_wgt_n_Wrap(T,wgt,1,0)  
        avgS_yr(i-1,:,:,:)= dim_avg_wgt_n_Wrap(S,wgt,1,0)
    end do
    avgT_yr!0="time"
    avgT_yr&time=time
    avgT_yr&time@units="id of year"
    avgS_yr!0="time"
    avgS_yr&time=time   
    avgS_yr&time@units="id of year"
;write files
    setfileoption("nc","Format","LargeFile") 
    diro="/public/home/jinjb/liudezhi/"
    foname= "TSRes" + nres(z) + "Yrs50.nc"
    system ("rm "+ diro + foname)
    fo = addfile(diro + foname, "c")
    fo->ts= avgT_yr
    fo->ss= avgS_yr
    fo->lat = lat
    fo->lon = lon
    fo->lev = lev
    fo->lev1= lev1
    fo->time= time   
;delete vars
    delete(lon)
    delete(lat)
    delete(T)
    delete(S)
    delete(avgT_yr)
    delete(avgS_yr)
end do

print(systemfunc("date"))
end