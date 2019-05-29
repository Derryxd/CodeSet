 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin
print(systemfunc("date"))

;res vars & purpuse
    nrun = 1
    nyrs = 50
    nlev = 30
    var = (/"us","vs"/)    
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
;wks
    dirp = "/public/home/jinjb/liudezhi/test/"
    pname= "speed_04"
    wks = gsn_open_wks("ps",dirp + pname)
    plot= new(nrun,graphic)
    gsn_define_colormap(wks,"BlAqGrYeOrRevi200") 
    titleForRes=(/"2~S~o~N~","0.5~S~o~N~","0.25~S~o~N~","0.125~S~o~N~"/)
    leftString =(/"(a)","(b)","(c)","(d)"/)

do z=0,nrun-1
;read files
    diri= "/public/home/jinjb/mius" + nres(z) +"/exe/"
    files= systemfunc ("ls " + diri + "MMEAN00*.nc")
    fi0 = addfiles(files, "r") 
    lat= fi0[0]->lat
    lon= fi0[0]->lon
    lev= fi0[0]->lev
    lev1=fi0[0]->lev1
    T=fi0[0:599]->ts
    sst =T(:,0,{-5:5},{190:240})
    printVarSummary(sst)
;write files
    diro="/public/home/jinjb/liudezhi/"
    foname= "tt.nc"
    system ("rm "+ diro + foname)
    fo = addfile(diro + foname, "c")
    fo->ts= sst
end do



print(systemfunc("date"))
end
