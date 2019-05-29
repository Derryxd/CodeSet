 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin
print(systemfunc("date"))

;var 
nrun= 2
nyrs= 50
nmon= 12
nlev= 30
var = (/"ts","ss"/)  
;for res 2 / 0.5 / 0.25 / 0.125
nres = (/"2","5","114","216"/)
nlat = (/115,446, 940,1892/)
nlon = (/182,722,1442,2882/)
time=fspan(1,50*12,50*12)
;build year string
    nl = str_get_nl()
    c = new((/nyrs,1/),string)
    do i = 1, nyrs
        c(i-1,0)= sprinti("%0.2i", i)
    end do
    print("built c array for years")
    print(nl + "-------------------------------------" + nl + "  ")
;build month string
    nl = str_get_nl()
    d = new((/nmon,1/),string)
    do i = 1, nmon
        d(i-1,0)= sprinti("%0.2i", i)
    end do
    print("built d array for months")
    print(nl + "-------------------------------------" + nl + "  ")
    diri= "/public/home/jinjb/mius" + nres(0) +"/exe/"
    do i= 1,1
        files= systemfunc ("ls " + diri + "MMEAN00" + c(:) + "-" + d(i-1,0) + ".nc")
        fi   = addfiles(files, "r")
        print(fi)
    end do

print(systemfunc("date"))
end
