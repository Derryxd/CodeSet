 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin
print(systemfunc("date"))


 fn = "gpp2_2000.nc"

 fi = addfile(fn, "r")

 setfileoption("nc", "Format",  "NetCDF4")

 printVarSummary(fi)

 a = fi->gpp


 printVarSummary(a)

print(a(1:2,2:4))

print(systemfunc("date"))
end