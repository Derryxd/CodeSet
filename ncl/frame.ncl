begin
;
; Create workstation.
;
  wks = create "poly" psWorkstationClass  defaultapp end create

;
; Create a data object.
;
  npts = 500
  x    = fspan(0,npts-1,npts)
  y    = 500.+ 0.9 * x * sin(0.031415926535898*x)

  dataid = create "data" coordArraysClass noparent
    "caYArray" : y
  end create

  xy = create "xy" xyPlotClass wks
    "xyCoordData" : dataid
  end create

  text1 = create "text1" textItemClass wks
    "txString"      : "This is a string at the top" 
    "txPosYF"       : 0.5
    "txPosYF"       : 0.9
    "txFontHeightF" : 0.03
  end create

  text2 = create "text1" textItemClass wks
    "txString"      : "This is a string at the bottom"
    "txFont"        : 22
    "txPosXF"       : 0.5
    "txPosYF"       : 0.1
    "txFontHeightF" : 0.03
  end create

  draw((/xy,text1,text2/))
  frame(wks)
end
 