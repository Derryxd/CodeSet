#!/bin/bash 
# =========
echo $NCARG_ROOT
DATE=2017070112
while [ "$DATE"==2017070112 ]
do
cat > wind << EOF
	;================================================;
	load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
	load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
	load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
	load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
	load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/skewt_func.ncl"
	load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/wind_rose.ncl"
	load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
	load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
	begin
		;=================================================;
		;open file and read in data
		;=================================================;
      	diri="/PARA/p_wrf_11/WORK/NM_DJD/ALS_d04/data_ALS/wrf_24h/"
      	fname=systemfunc("ls " + diri +  "*.nc")
      	f    = addfiles(fname,"r")
      	print(f)
      	u0 = wrf_user_getvar(f,"U",-1)
      	u = wrf_user_unstagger(u0,u0@stagger)
      	v0 = wrf_user_getvar(f,"V",-1)
      	v = wrf_user_unstagger(v0,v0@stagger) 
      	printVarSummary(u)     
  		;printVarSummary(u)

      	;interp 100m vertically

      	vert_coord       = "ght_agl"
      	interp_levels    = (/0.10/)
      	opts             = True
      	;opts@extrapolate = True
      	;opts@field_type  = "ght"
      	;opts@logP        = True  
      	u_100m=wrf_user_vert_interp(f,u,vert_coord,interp_levels,opts)
      	v_100m=wrf_user_vert_interp(f,v,vert_coord,interp_levels,opts)
      	printVarSummary(u_100m)
            
		;WS and WD 
      	ws_100m = sqrt(u_100m^2+v_100m^2)
      	r2d = 45.0/atan(1.0)     ; conversion factor (radians to degrees)
      	wd_100m = atan2(u_100m, v_100m) * r2d + 180
      	copy_VarCoords(u_100m, ws_100m)
      	copy_VarCoords(u_100m, wd_100m)
      	printVarSummary(ws_100m)

      	; fn = "wind_d04_24all.nc"
      	; system("rm -f " + fn) ; remove if exists
      	; fout = addfile(fn, "c")
      	; ;Write the data out.
      	; fout->ws_100m  = ws_100m
      	; fout->wd_100m = wd_100m

      	ws_avg_100m=dim_avg_n_Wrap(ws_100m, 0)
      	printVarSummary(ws_avg_100m)
      	fn1 = "wind_d04_avg.nc"
      	system("rm -f " + fn1) ; remove if exists
      	fout1 = addfile(fn1, "c")
      	;Write the data out.
      	fout1->ws_avg_100m  = ws_avg_100m


	end
	



EOF

echo "aaa"
cat wind
ncl wind
done