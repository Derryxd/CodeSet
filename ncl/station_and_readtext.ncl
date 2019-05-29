;----------------------------------------------------------------------
; station_1.ncl
;----------------------------------------------------------------------
; Concepts illustrated:
;   - Contouring one-dimensional X, Y, Z data
;   - Reading an ASCII file with several columns of data
;   - Drawing lat/lon locations as filled dots using gsn_coordinates
;   - Controlling which contour lines get drawn
;   - Using opacity to emphasize or subdue overlain features
;   - Reversing a color map
;----------------------------------------------------------------------
; This example reads in station data represented by
; 1D arrays, and generates a filled contour plot over a map.
;
; It uses a newer method (NCL V6.4.0 and later) for specifying the
; lat/lon information via special lat1d/lon1d attributes attached
; to the data to be plotted. See station_old_1.ncl if you have an 
; older version of NCL.
;----------------------------------------------------------------------
; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin
;
; Data is stored in four columns:  station_name  lat  lon  pwv
; Read in each line as a string, and use "str_get_field" to 
; read in the fields of interest.
;
  fname = "pw.dat"
  lines = asciiread(fname,-1,"string")
;
; Use "str_get_field" to indicate which fields to read in.
; Each field is separated by an arbitrary number of spaces.
;
  pwv       = tofloat(str_get_field(lines(1:),4," "))
  pwv@lat1d = tofloat(str_get_field(lines(1:),2," "))  ; Attach as lat1d, lon1d
  pwv@lon1d = tofloat(str_get_field(lines(1:),3," "))  ; for plotting later

  wks = gsn_open_wks("png","station")       ; send graphics to PNG file

  cmap = read_colormap_file("WhViBlGrYeOrRe") ; read color map
  cmap = cmap(::-1,:)                         ; reverse the color map

  res                             = True
  res@gsnMaximize                 = True
  res@gsnFrame                    = False   ; Want to draw markers later.
  res@gsnDraw                     = False

  res@cnLineLabelPlacementMode    = "Constant"
  res@cnLineLabelFontColor        = "Gray15"
  res@cnLineDashSegLenF           = 0.3

  res@cnLevelSelectionMode        = "ManualLevels"
  res@cnMinLevelValF              = 15         	; 15.25
  res@cnMaxLevelValF              = 50		; 49.75
  res@cnLevelSpacingF             = 0.25

  res@cnFillOn                    = True
  res@cnFillPalette               = cmap(2:88,:)
  res@cnFillOpacityF              = 0.75 
  res@cnLinesOn                   = True
  res@cnLineLabelsOn              = True
  res@cnLevelFlags		  = new(139,"string")
  res@cnLevelFlags(:)		  = "NoLine"
  res@cnLevelFlags(0::20)         = "LineAndLabel"

  res@lbOrientation               = "vertical"
  res@lbBoxLinesOn                = False

;---Zoom in on map area of interest
  res@mpMinLatF                   = min(pwv@lat1d)-.5
  res@mpMinLonF                   = min(pwv@lon1d)-.5
  res@mpMaxLatF                   = max(pwv@lat1d)+.5
  res@mpMaxLonF                   = max(pwv@lon1d)+.5

  res@mpFillOn                    = False
  res@mpOutlineDrawOrder          = "PostDraw"
  res@mpFillDrawOrder             = "PreDraw"
  res@mpOutlineBoundarySets       = "GeophysicalAndUSStates"
  res@mpUSStateLineColor          = "Gray10"
  res@mpUSStateLineDashPattern    = 2

  res@pmTickMarkDisplayMode       = "Always"   ; nicer map tickmarks

;---Create the plot; it won't get drawn because gsnFrame was set to False.
  res@tiMainString = "GPS PWV (18Z)"
  plot = gsn_csm_contour_map(wks,pwv,res)

;---Draw markers on the plot in the lat/lon locations.
  mkres               = True
  mkres@gsMarkerIndex = 16     ; Filled circle
  gsn_coordinates(wks,plot,pwv,mkres)
end 