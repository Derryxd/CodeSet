load "/disk1/soft/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "/disk1/soft/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "/disk1/soft/lib/ncarg/nclscripts/csm/contributed.ncl"
load "/disk1/soft/lib/ncarg/nclscripts/csm/shea_util.ncl"
	
begin
fout = addfile("out.nc","c")
; create global attributes (生成全局属性)
fileAtt = True
fileAtt@title = "Sample"
fileAtt@Conventions = "None"
fileAtt@creation_date = systemfunc("date")
setfileoption(fout,“DefineMode”,True) ; optional
fileattdef(fout,fileAtt)
; predefine coordinate variables （预先定义坐标变量）
dimNames = (/"time","lat","lon"/)
dimSizes = (/-1,nlat,nlon/) ; -1 means unspecified
dimUnlim = (/True,False,False/)
; predefine names, type, dimensions （预先定义名称，类型，维数）
; explicit dimension naming or getvardims can be used （明确维名称，
或者可以用getvardims命令）
filedimdef(fout,dimNames,dimSizes,dimUnlim)
filevardef(fout,"time",typeof(time),getvardims(time))
filevardef(fout,"lat" ,typeof(lat) ,"lat")
filevardef(fout,"lon" ,"float" ,"lon")
filevardef(fout,"TMP" ,typeof(T) , getvardims(T) )
; predefine each variable’s attributes （预先定义每个变量的属性）
filevarattdef(fout,"time",time)
filevarattdef(fout,"lat" ,lat)
filevarattdef(fout,"lon" ,lon)
filevarattdef(fout,"TMP" ,T)
setfileoption(fout,”SuppressDefineMode”,False) ; optional
; output values only （输出值） [use (/… /) to strip metadata]
fout->time = (/time/)
fout->lat = (/lat/)
fout->lon = (/lon/)
fout->TMP = (/T/) ; T in script; TMP on file
end