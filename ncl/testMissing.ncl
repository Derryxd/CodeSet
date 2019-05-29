 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin
print(systemfunc("date"))

;res vars & purpuse
    nrun = 2
    nyrs = 50
    nlev = 30
    var = (/"us","vs"/)    
   ;for res 2 / 0.5 / 0.25 / 0.125
    nres = (/"2","5","114","216"/)
    nlat = (/115,446, 940,1892/)
    nlon = (/182,722,1442,2882/)
;wks
dirp= "/public/home/jinjb/liudezhi/test/"
wks = gsn_open_wks("ps",dirp + "speed")
plot= new(nrun,graphic)
gsn_define_colormap(wks,"BlAqGrYeOrRevi200") 
titleForRes=(/"2~S~o~N~","0.5~S~o~N~","0.25~S~o~N~","0.125~S~o~N~"/)
leftString =(/"(a)","(b)","(c)","(d)"/)
;build year string
    nl = str_get_nl()
    c = new((/nyrs,1/),string)
    do i = 1, nyrs
        c(i-1,0)= sprinti("%0.2i", i)
    end do
    print("built c array for years")
    print(nl + "-------------------------------------" + nl + "  ")
    wgt = (/0.08493151, 0.076712325, 0.08493151, 0.08219178 \  ; same size as dimension "time"
           ,0.08493151, 0.08219178 , 0.08493151, 0.08493151 \  ; (weigths of months)
           ,0.08219178, 0.08493151 , 0.08219178, 0.08493151 /)

do z=1,nrun-1
avgU= new((/nyrs,nlev,nlat(z),nlon(z)/),float,1e+35)    
;read files  
    diri= "/public/home/jinjb/liudezhi/"
    fi= addfile(diri + "UVRes" + nres(z) + "Yrs50.nc", "r")     
    ;dims
    lat = fi->lat
    lon = fi->lon
    lev = fi->lev
    lev1= fi->lev1
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
    a=us({30:20},{185:195})
  if(any(ismissing(a))) then
    print("Your data  a  contains some missing values. Beware.")
  end if
 
    tmp=dim_avg_wgt_n_Wrap(U(0:4,0:5,:,:),dz,1,1)
    vs=dim_avg_n_Wrap(tmp,0)  
    b=vs({30:20},{185:195})
  if(any(ismissing(b))) then
    print("Your data  b  contains some missing values. Beware.")
  end if


    dirii= "/public/home/jinjb/mius" + nres(z) +"/exe/"
    do i= 8,8
        files= systemfunc ("ls " + dirii + "MMEAN00" + c(i-1,0) +"-*.nc")
        fii   = addfiles(files, "r")
;do calculate 
        UU= fii[:]->$var(0)$
        ;dim_avg_wgt_n_Wrap(Var,wgt,opt,dim)  
        ;opt=0 means compute the weighted average only if all values are not missing
        ;opt=1 means compute the weighted mean of all non-missing values
        ; avgU(i-1,:,:,:)= dim_avg_wgt_n_Wrap(UU,wgt,1,0) 
        do j=0,11 
        dd=UU(j,0,{30:20},{185:195})

        if(any(ismissing(dd))) then
            print(j)
            print("Your data  dd  contains some missing values. Beware.")
        end if
        end do
    end do





end do

end



