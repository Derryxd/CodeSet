load "/disk1/soft/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "/disk1/soft/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "/disk1/soft/lib/ncarg/nclscripts/csm/contributed.ncl"
load "/disk1/soft/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

    ; diri = "/disk7/liudezhi/licom/res2/"
    ; fils = systemfunc ("ls " + diri + "MMEAN00" + "[0-2]*")
    ; print(fils)
    nl = str_get_nl()

    a=(/"01","02","3"/)
    print(a)

    print(nl + "-------------------------------------" + nl + "  ")

    b = (/ 65, 97, 33, -1, 150 /)
    print(inttochar(b))

    print(nl + "-------------------------------------" + nl + "  ")

    c = new((/12,1/),string)
    ; printVarSummary(c)    
    do i = 0, 11
        c(i,0)=sprinti("%0.2i", i+1)
    end do
    print(c)
          
end