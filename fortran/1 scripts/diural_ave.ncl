  ;export NCARG_COLORMAPS=/home/lixy/CMORPH_LST/check_inputdata_lixy/cbar/:$NCARG_ROOT/lib/ncarg/colormaps 
;export NCARG_COLORMAPS=/home/lixy/CMORPH_LST/check_inputdata_lixy/cbar/:$NCARG_ROOT/lib/ncarg/colormaps
load "/usr/local/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "/usr/local/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "/usr/local/lib/ncarg/nclscripts/csm/contributed.ncl"
load "/usr/local/lib/ncarg/nclscripts/csm/shea_util.ncl"
begin
  diri1="/home/lixy/CMORPH_LST/check_inputdata_lixy/diural_var/7_AREA/cmorph/"    
  diri2="/home/lixy/CMORPH_LST/check_inputdata_lixy/diural_var/7_AREA/cmorph/" 
  diri3="/home/lixy/CMORPH_LST/check_inputdata_lixy/diural_var/7_AREA/cmorph/amplitude/ave/"    
  file1 = systemfunc ("ls "+ diri1 + "amount_sum_season_yu.dat");四季
  file2= systemfunc ("ls "+ diri2 + "tmax_sum_season_yu.dat");四季
  file3= systemfunc ("ls "+ diri3 + "Y.dat");夏季
  file4=systemfunc ("ls "+ diri3 + "C_amplitude.dat");夏季
   Pr=new((/24/),float,-9999);真实降水量
   Pr_Y=new((/24/),float,-9999);模拟降水量
   Pr1=new((/24/),float,-9999);真实降水量
   Pr_Y1=new((/24/),float,-9999);模拟降水量   
   C=new((/1/),float,-9999);模拟降水振幅   
   Y2=new((/2,24/), float, -9999)
   tmax=new((/1/),float,-9999)
   time=new((/24/), integer)

    Pr1(:) = fbindirread(file1,1,(/24/),"float")
    Pr_Y1(:) = fbindirread(file3,0,(/24/),"float")
    C(:) = fbindirread(file4,0,(/1/),"float")
    Pr=Pr1*2;这里乘以2，因为采用的是amount中的降水，在4.f90中并没有x2.
    Pr_Y=Pr_Y1;这里不乘以2，是因为在6.f90中已经乘以2 了
    Pr_ave=sum(Pr)/24
        ; print(maxind(Pr_Y(:)));从这里可以看到，Pr的tmax为16，但是Pr_Y为18。我没计算错，因为是拟合的时候是一项谐波方程。
    ; printVarSummary(time)
    ; print(Pr)
    ; print(Pr_Y)

;计算相关系数
relation=escorc(Pr_Y, Pr)
;把两个放到一个方程组中，这样就可以一起画出来
    ; Y2(0,:)=Pr(:)
    Y2(1,:)=Pr_Y(:)
    tmax=fbindirread(file2,1,(/1/),"float")
    time=(/0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23/);这里用了0-23，所以在计算tmax_sum的时候需要减1。如果不减1，这里就用1-24

    ; time=(/1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24/);这里用了1-24，虽然在计算tmax_sum的时候减1。但是这里就用1-24也是平移了，所以应该也没问题。但是如果这样的话，得到的结果就和平面箭头图的结果不一致了。

    wks=gsn_open_wks("png", "diural_AREA7")

    text_res=True
    text_res@FontColor=1
    text_res@txJust = "CenterCenter"
    text_res@txFontHeightF    = 0.02
    gsn_text_ndc(wks, "correlation  "+relation, 0.5, 0.02, text_res)  

    text_res@FontColor=1
    text_res@txJust = "CenterCenter"
    text_res@txFontHeightF    = 0.02
    gsn_text_ndc(wks, "ave"+Pr_ave, 0.5, 0.12, text_res)  

    text_res@FontColor=1
    text_res@txJust = "CenterCenter"
    text_res@txFontHeightF    = 0.02
    gsn_text_ndc(wks, "amplitude"+C, 0.5, 0.07, text_res) 

    res                  = True                     ; plot mods desired
    ; res@trYMaxF =1.0
    ; res@trYMinF =0.0
    ; res@trXMaxF =23
    ; res@trXMinF =0    
    ; res@tmYLTickSpacingF  = 3      
    res@tiMainString     = "diural_var_AREA7_cmorph"          ; add title
    res@xyLineColors        = (/200,100/)
    res@xyLineThicknesses   = (/1.,3./)


    plot1  = gsn_csm_xy (wks,time,Y2,res) ; create plot
end

