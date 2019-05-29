load "/disk1/soft/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "/disk1/soft/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "/disk1/soft/lib/ncarg/nclscripts/csm/contributed.ncl"
load "/disk1/soft/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

    f_jan=addfile("LPJ-GUESS-BLAZE_SF1_gpp_re.nc","r") ;f属于list类型，所以用[]
    lat=f_jan->lat
    a=(/"gpp_monthly"/)
    temp=f_jan->$a$
    printVarSummary(temp)
printVarSummary(lat)


    ;@ 属性
    ;! 命名的行列
    ;& 坐标变量CV
    ;x@_FillValue 缺失值
end