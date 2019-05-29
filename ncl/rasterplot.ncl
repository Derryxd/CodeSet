 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin
print(systemfunc("date"))

; path1 = "/media/新加卷/firemip_1deg/"

f2 = addfile("gpp_2000.nc","r")

gpp_modis = f2->gpp
lat_modis = f2->lat
lon_modis = f2->lon

  wks = gsn_open_wks("png","raster3")         ; Open a workstation.

  res                 = True                ; Plot mods desired.

  res@gsnMaximize     = True                ; Maximize plot in frame.

  res@gsnStringFontHeightF         = 0.013
  res@gsnRightStringOrthogonalPosF = 0.02
  res@gsnLeftStringOrthogonalPosF  = 0.02

  res@cnFillOn        = True               ; Color plot desired.
  res@cnLinesOn       = False              ; Turn off contour lines      .
  res@cnLineLabelsOn  = False              ; Turn off contour labels.

  ; res@mpProjection           = "LambertConformal"
  ; res@mpLambertParallel1F    = 33.0                ; two parallels
  ; res@mpLambertParallel2F    = 45.0
  ; res@mpLambertMeridianF     = -95.0               ; central meridian
  ; res@mpLimitMode            = "LatLon"

  ; res@mpMinLatF              = 24.0                ; map area
  ; res@mpMaxLatF              = 50.0                ; latitudes
  ; res@mpMinLonF              = -125.0              ; and
  ; res@mpMaxLonF              = -65.0               ; longitudes

  res@cnInfoLabelOn       = False           ; Turn off info label.

  res@mpGeophysicalLineColor = "red"     ; color of continental outlines
  res@mpUSStateLineColor     = "red" 
  res@mpGridLineDashPattern  = 2         ; lat/lon lines as dashed
  res@mpOutlineBoundarySets  = "GeophysicalAndUSStates" 

  res@pmTickMarkDisplayMode = "Always"       ; Turn on map tickmarks.

  ; res@cnFillPalette        = "BlAqGrYeOrRe"
  res@cnFillMode           = "RasterFill"
  ; res@cnLevelSelectionMode = "ManualLevels"
  ; res@cnMinLevelValF       = 0.0              ; min contour level
  ; res@cnMaxLevelValF       = 1.0             ; max contour level
  ; res@cnLevelSpacingF      = 0.1              ; contour spacing
  res@cnLevelSelectionMode = "ExplicitLevels"      ; set explicit contour levels
  res@cnLevels = (/0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9/) ;(/0.1, 0.2, 0.5, 1, 1.5, 2, 2.5, 3, 5/)
  ; res@cnLevels = fspan(0, 1.0, 128)
  res@pmLabelBarWidthF     = 0.6
  res@lbLabelFontHeightF   = 0.013
  res@lbLabelStride        = 2
  res@lbBoxLinesOn         = False
  cn_color = (/"blue4","dodgerblue2","forestgreen","green","greenyellow","yellow","orange2","brown",\
             "red","ghostwhite"/)
  res@cnFillColors         = cn_color
    ; cmap = read_colormap_file("gsdtol")   ; 100 colors
    ; res@cnFillPalette       = cmap        ; choose colormap

  map = gsn_csm_contour_map(wks,gpp_modis,res) 


  print(systemfunc("date"))
end