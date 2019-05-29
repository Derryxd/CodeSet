load "/disk1/soft/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "/disk1/soft/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "/disk1/soft/lib/ncarg/nclscripts/csm/contributed.ncl"
load "/disk1/soft/lib/ncarg/nclscripts/csm/shea_util.ncl"
	
begin	
    diri = "//disk7/liudezhi/1/"
    finame= "aabb.nc"
    f=addfile(diri+finame, "r")
    a=f->a
    print(a)

end