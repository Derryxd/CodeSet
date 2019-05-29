load "/disk1/soft/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "/disk1/soft/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "/disk1/soft/lib/ncarg/nclscripts/csm/contributed.ncl"
load "/disk1/soft/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin
    nl = str_get_nl()

    c = new((/12,1/),string)
    do i = 0, 11
        c(i,0)=sprinti("%0.2i", i+1)
    end do
    print(c)
    print(nl + "-------------------------------------" + nl + "  ")
    diri = "/disk7/liudezhi/licom/res2/"
    files = systemfunc ("ls " + diri + "MMEAN00" + "[01-31]*-" + c(0,0) + ".nc")
    print(files)

    print(nl + "-------------------------------------" + nl + "  ")

    f_jan=addfiles(files,"r") ;f属于list类型，所以用[]
    lat=f_jan[0]->lat
    temp=f_jan[:]->ts
    print(lat)
    print(nl + "-------------------------------------" + nl + "  ")
    printVarSummary(temp)
    print(temp@units)  
    print(temp!0+" "+temp!1+" "+temp!2+" "+temp!3) 
    print(temp(0,0,{4:21},{105:118}))  ;坐标变量CV用{}

    print(nl + "-------------------------------------" + nl + "  ")
    a=temp&lat 
    diff=a-lat
    print(diff)

    ;@ 属性
    ;! 命名的行列
    ;& 坐标变量CV
    ;x@_FillValue 缺失值
end