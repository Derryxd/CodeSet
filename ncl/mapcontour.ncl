
;
; Open file containing surface pressure data for the entire globe.
;
a = addfile("/disk7/liudezhi/licom/res2/MMEAN0001-01.nc","r")

;
; Convert pressure to millibars.
ts = a->ts/100.0
p=ts(0,0,:,:)
; frtime = a->frtime
; tmp = new(dimsizes(p(0,0,:,:)),float)
; ind = 0

; ;
; ; Sort pressure so that timesteps are in order.
; ;
; do i = 0, dimsizes(frtime) - 2
;         ind = i
;         do j = i + 1, 10
;                 if(frtime(j) .lt. frtime(ind))
;                         ind = j
;                 end if
;         end do
;         if(ind.ne.i)
;                 tmp = p(ind,:,:)
;                 p(ind,:,:) = p(i,:,:)
;                 p(i,:,:) = tmp
;                 tmp2 = frtime(ind)
;                 frtime(ind) = frtime(i)
;                 frtime(i) = tmp2
;         end if
; end do

;
; Determine extents of latitude and longitude coordinate.
;
lat = a->lat
if(lat(0) .lt. lat(dimsizes(lat)-1)) then
    ymin = lat(0)
    ymax = lat(dimsizes(lat)-1)
else
    ymax= lat(0)
    ymin = lat(dimsizes(lat)-1)
end if

lon = a->lon
if(lon(0) .lt. lon(dimsizes(lon)-1)) then
    xmin = lon(0)
    xmax = lon(dimsizes(lon)-1)
else
    xmax= lon(0)
    xmin = lon(dimsizes(lon)-1)
end if

;
; Set up the scalar field needed by the contour object with the first
; pressure time step.
;
field1 = create "field1" scalarFieldLayerClass noparent
        "sfDataArray" : p(0,:,:) 
        "sfMissingValueV" : p@_FillValue
        "sfXCStartV" : a->lon(0)
        "sfXCEndV" : a->lon(dimsizes(a->lon)- 1)
        "sfYCStartV" : a->lat(0)
        "sfYCEndV" : a->lat(dimsizes(a->lon) - 1)
end create

wks = create "wks" xWorkstationLayerClass noparent end create
wks1 = create "wks1" ncgmWorkstationLayerClass noparent end create
map = create "map" mapPlotLayerClass wks
    "vpXF": .1
    "vpYF": .9
    "vpWidthF": .8
    "vpHeightF": .8
    "mpCenterLatF": -89.5
    "mpCenterLonF": 90.0
    "mpProjection": "ORTHOGRAPHIC"
end create
map1 = create "map1" mapPlotLayerClass wks1
    "vpXF": .1
    "vpYF": .9
    "vpWidthF": .8
    "vpHeightF": .8
    "mpCenterLatF": -89.5
    "mpCenterLonF": 90.0
    "mpProjection": "ORTHOGRAPHIC"
end create

con1 = create "con1" contourLayerClass wks1
    "cnScalarFieldData" : field1
    "tfOverlayPlotBase": "True"
    "cnMonoFillPattern": "False"
    "cnLevelSelectionMode" : "MANUAL"
    "cnMinLevelValF" : 960.0
        "cnMaxLevelValF" : 1040.0
        "cnLevelSpacingF" : 5.0
        "cnMaxLevelCount" : 25
    "trYMinF": ymin
    "trYMaxF": ymax
    "trXMinF": xmin
    "trXMaxF": xmax
    "cnMonoFillPattern" : "True"
        "cnFillPatterns" : 0
        "cnMonoLineColor" : "True"
    "cnFillOn" : "True"
        "cnLineColors" : 0
        "tiMainString" : "Forcast time " + 0 + " hours"
    "cnLowLabelsOn" : "False"
    "cnHighLabelsOn" : "False"
    "cnLineLabelsOn" : "False"
end create
con = create "con" contourLayerClass wks
    "cnScalarFieldData" : field1
    "tfOverlayPlotBase": "True"
    "cnMonoFillPattern": "False"
    "cnLevelSelectionMode" : 1
    "cnMinLevelValF" : 960.0
        "cnMaxLevelValF" : 1040.0
        "cnLevelSpacingF" : 5.0
        "cnMaxLevelCount" : 25
    "trYMinF": ymin
    "trYMaxF": ymax
    "trXMinF": xmin
    "trXMaxF": xmax
    "cnMonoFillPattern" : 1
        "cnFillPatterns" : 0
    "cnFillOn" : "True"
        "cnMonoLineColor" : 1
        "cnLineColors" : -1
        "tiMainString" : "Forcast time " + 0 + " hours"
    "cnLowLabelsOn" : "False"
    "cnHighLabelsOn" : "False"
    "cnLineLabelsOn" : "False"
end create
overlay(map,con)
overlay(map1,con1)
maps = (/map,map1/)
cons= (/con,con1/)
works= (/wks,wks1/)
draw(maps)
frame(works)
do i = 1, dimsizes(frtime) - 1
        setvalues field1
                "sfDataArray" : p(i,:,:)
        end setvalues
        setvalues cons
                "tiMainString" : "Forcast time " + frtime(i) + " hours"
        end setvalues
        draw(maps)
        frame(works)
end do
; 
; Free variables used in this script.
;
delete(frtime)
delete(a)
delete(p)
; delete(tmp)