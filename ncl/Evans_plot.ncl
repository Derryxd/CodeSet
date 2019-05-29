;
; Created by Jason Evans
; senior research fellow
; Climate Change Research Center,
; University of New South Wales, Sydney, Australia.
; 4 March 2013
;
; this is the generic template for creating color wheel map plots (with
; or without wind vectors)
;
; gsn_code.ncl, gsn_csm.ncl and contributed.ncl must be loaded first
;


undef("evans_plot_color_map")
undef("add_color_wheel")
undef("add_ep_label_bar")
undef("add_ep_label_bar_ndc")
undef("evans_plot_map")
undef("evans_plot_vector_map")
undef("add_ep_color_wheel_ndc")


;**********************************************************************;
; Function : evans_plot_color_map
;		nHues: integer
;		nSats: integer
;               hueoffset : float
;               minval : float
;		cyclic : logical
;		RevHue : logical
;		RevSat : logical
;		NumMaxSat : integer
;
; This function determines the color to use with with an Evans plot
;
;**********************************************************************;

function evans_plot_color_map(nHues:numeric,nSats:numeric,hueoffset:numeric, \
                               minval:numeric,minsat:numeric,cyclic:logical,RevHue:logical,RevSat:logical, \
                               NumMaxSat:numeric)

local hue,sat,val,i

begin
 hue = new(nHues*nSats,float)
 sat = hue
 val = hue
 
 do i = 0,nHues-1
   if (NumMaxSat.gt.1) then
     sat((i+1)*nSats-NumMaxSat:(i+1)*nSats-1) = fspan(1.,1.,NumMaxSat)     ; set saturation to 1.
     sat(i*nSats:(i+1)*nSats-NumMaxSat) = fspan(minsat,1.,nSats-NumMaxSat+1)     ; set saturation to range from minsat to 1.
   else
     sat(i*nSats:(i+1)*nSats-1) = fspan(minsat,1.,nSats)	; set saturation to range from minsat to 1.
   end if
 end do
 do i = 0,nSats*(nHues-1),nSats
   hue(i:i+nSats-1) = 360.*i/(nHues*nSats)     ; Set hue to range from 0 to 360
 end do
 do i = 0,nHues-1
   if (NumMaxSat.gt.1) then
     val((i+1)*nSats-NumMaxSat:(i+1)*nSats-1) = fspan(1.,0.6,NumMaxSat)         ; value range 1.0 to 0.5
     val((i*nSats):(i+1)*nSats-NumMaxSat) = fspan(minval,1.,nSats-NumMaxSat+1)         ; value range minval to 1.0.
   else
     val((i*nSats):(i+1)*nSats-1) = fspan(minval,1.,nSats)         ; value range minval to 1.0.
   end if
 end do

 ;add hueoffset
 hue = hue + hueoffset
 do i = 0,nHues*nSats-1
   if (hue(i).gt.360) then
     hue(i) = hue(i) - 360.
   end if
 end do

 ;if not cyclic then reverse the hues so red is the high number
 if (.not.cyclic) then
   hue = hue(::-1)
 end if
 
 ;if desired reverse the Hues
 if (RevHue) then
   hue = hue(::-1)
 end if
 
 ;if desired reverse the saturation and intensity
 if (RevSat) then
   sat = sat(::-1)
   val = val(::-1)
 end if
 
 cmap  = new((/(nHues*nSats)+2,3/),float)   

 cmap(0,:)    = (/1.,1.,1./)   ; Set the background to white.
 cmap(1,:)    = (/0.,0.,0./)   ; Set the foreground to black.

 cmap(2:,:) = hsv2rgb(hue,sat,val) ; Generate smooth range of RGB values.
 
 return(cmap)
 
end


;**********************************************************************;
; Procedure : add_color_wheel
;		wks: workstation object
;               mainplot: graphic object
;		nHues: numeric
;		nSats: numeric
;		title: string
;		huelabel: numeric
;		satlevels: numeric
;               scale : numeric
;               cx : numeric
;               cy : numeric
;               perim : logical
;
; This function draws an actual colorwheel in the top right hand corner
; of the plot. It also adds labels for the colors and a magnitude vector 
; for the saturation values.
; 
;**********************************************************************;

procedure add_color_wheel(wks:graphic,mainplot:graphic,nHues:numeric,nSats:numeric, \
				title:string,huelabel:numeric,satlevels:numeric, \
				scale:numeric,cx:numeric,cy:numeric, \
				perim:logical)

local i,pi,x,y,cx,cy,ploy_res,text_res,rinc,hue,ihue,\
	theta1,theta2,rlen,isat,xndc,yndc,xline,yline,ex,ey,cmap

begin
  ;xsize of canvas
  xcan = 0.23
  ycan = 0.25
 
  ;create a blank canvas to draw the colorwheel on
  canvas = create "canvas" logLinPlotClass wks
    "vpWidthF" : xcan*scale
    "vpHeightF" : ycan*scale
   end create
  
  ;the canvas ndc is warped from the main plot ndc because of the
  ;canvas aspect ratio - factor to account for this
  ar_fac = ycan/xcan
  
  ;center of color wheel in canvas
  ccx = 0.5
  ccy = 0.55
 

   ;add perimeter
   poly_res = True
   if (perim) then
     poly_res@gsFillColor = 0.
     poly_res@gsEdgesOn = True
     xndc = new(5,float)
     yndc = xndc
     xndc(0) = 0
     xndc(1) = xndc(0)
     xndc(2) = 1
     xndc(3) = xndc(2)
     xndc(4) = xndc(0)
     yndc(0) = 0
     yndc(1) = 1
     yndc(2) = yndc(1)
     yndc(3) = yndc(0)
     yndc(4) = yndc(0)
     
     str = unique_string("perim")
     mainplot@$str$ = gsn_add_polygon(wks,canvas,xndc,yndc,poly_res)
     delete(xndc)
     delete(yndc)
     delete(poly_res)     
   end if
   
   

 pi = acos(-1)
 
 cmap = gsn_retrieve_colormap(wks)
 
  x = new(4,float)
  y = new(4,float)
  
  
; Create variables to hold resource lists.
;
  poly_res = True
  text_res = True
  text_res@txFont = "helvetica"
  text_res@txFontHeightF = 0.018*scale

;
;  Loop on the values.
;
  rinc = 2 * pi/nHues
;
;  Loop on the hues.
;
    do ihue = 0,nHues-1
      theta1 = (ihue -.5) * rinc
      theta2 = (ihue +.5) * rinc
      x(0) = 0.0
      x(3) = 0.0
      y(0) = 0.0
      y(3) = 0.0
;
;  Loop on the saturation values.
;
      do isat = 1,nSats
        poly_res@gsFillColor = cmap((ihue*nSats)+isat+1,:)
        rlen = ((1.*isat)/(3.5*nSats))
        x(1) = sin(theta1) * rlen * ar_fac
        y(1) = cos(theta1) * rlen
        x(2) = sin(theta2) * rlen * ar_fac
        y(2) = cos(theta2) * rlen
        xndc = x + ccx
	yndc = y + ccy
	
	str = unique_string("sat")
        mainplot@$str$ = gsn_add_polygon(wks,canvas,xndc,yndc,poly_res)
	
        x(0) = x(1)
        x(3) = x(2)
        y(0) = y(1)
        y(3) = y(2)
	
	      ;get location of magnitude vector
      if (ihue.eq.0.and.isat.eq.nSats-1) then
        ex = ((((xndc(2)+xndc(1))/2))*(1-(1/nSats)))
	ey = ((((yndc(2)+yndc(1))/2))*(1-(1/nSats)))
      end if

      end do
      
      ;draw time stamps
      ;line coords
      xstart = (xndc(2)+xndc(1))/2
      ystart = (yndc(2)+yndc(1))/2
      xend = (xstart - ccx)/nSats + xstart
      yend = (ystart - ccy)/nSats + ystart
      xline = (/xstart,xend/)
      yline = (/ystart,yend/)
      
      str = unique_string("timestamp")
      mainplot@$str$ = gsn_add_polyline(wks,canvas,xline,yline,False)
      
      ;change text justification depending on side
      if (ihue*rinc.le.pi/4.or.ihue*rinc.gt.7*pi/4) then
        text_res@txJust = "BottomCenter"
      end if
      if (ihue*rinc.gt.pi/4.and.ihue*rinc.le.3*pi/4) then
        text_res@txJust = "CenterLeft"
      end if
      if (ihue*rinc.gt.3*pi/4.and.ihue*rinc.le.5*pi/4) then
         text_res@txJust = "TopCenter"
      end if
      if (ihue*rinc.gt.5*pi/4.and.ihue*rinc.le.7*pi/4) then
        text_res@txJust = "CenterRight"
      end if
      str = unique_string("timestamp")
       mainplot@$str$ = gsn_add_text(wks,canvas,sprintf("%3.0f",huelabel(ihue)),((2.*xline(1)-xline(0))+xline(1))/2.,((2.*yline(1)-yline(0))+yline(1))/2.,text_res)
      
      
    end do

    ;ex and ey must be float so change them if they are double
    if (isdouble(ex)) then
      exd = ex
      delete(ex)
      ex = doubletofloat(exd)
      delete(exd)
    end if
    if (isdouble(ey)) then
      eyd = ey
      delete(ey)
      ey = doubletofloat(eyd)
      delete(eyd)
    end if


    ;draw magnitude vector (need to use the wmlabs stuff)
    wmsetp("ezf",-1)
    wmsetp("awc",1) ;arrow color
    wmsetp("aoc",1) ;outline color
    wmsetp("ard",90.) ;arrow direction
    wmsetp("ars",sqrt((ex-cx)^2 + (ey-cy)^2))  ;arrow length
    ;wmlabs(wks,ex,ey,"arrow")
    
    ares = True
     ares@gsLineThicknessF = 3.
     
    str = unique_string("arrow") 
    mainplot@$str$ = gsn_add_polyline(wks,canvas,(/ccx,ex/),(/ccy,ey/),ares)
    str = unique_string("arrow") 
    mainplot@$str$ = gsn_add_polyline(wks,canvas,(/ex-0.025,ex,ex+0.025/),(/ey-0.05,ey,ey-0.05/),ares)
    
    text_res@txFontHeightF = 0.015*scale
    text_res@txJust = "CenterRight"
    str = unique_string("text") 
    mainplot@$str$ = gsn_add_text(wks,canvas,min(satlevels),ccx-0.05,ccy,text_res)
    str = unique_string("text") 
    mainplot@$str$ = gsn_add_text(wks,canvas,max(satlevels),ex-0.05,ey,text_res)
 
 
   ;add title for color wheel
   text_res@txFontHeightF = 0.02*scale
   text_res@txJust = "BottomCenter"
   str = unique_string("cwtitle") 
   mainplot@$str$ = gsn_add_text(wks,canvas,title,0.5,0.03*scale,text_res)
   
   
   
   mainbox = NhlGetBB(mainplot)
   
   cy = ((cy - mainbox(1) + 0.06)/(mainbox(0)-mainbox(1)))
   cx = (cx - mainbox(2))/(mainbox(3)-mainbox(2))
     
   ;anotate the label bar
   lbanres = True
    lbanres@gsnMaximize = nHues@maximize
    lbanres@amZone = 1
    lbanres@amParallelPosF = cx
    lbanres@amOrthogonalPosF = cy
    
   
   lbanno = gsn_add_annotation(mainplot,canvas,lbanres)
   

   
 end



;**********************************************************************;
; Procedure : add_ep_color_wheel_ndc
;		wks: workstation object
;		resources : logical
;
; This function draws an actual colorwheel in the plot. Located in NDC
; coordinates. It also adds labels for the colors and a magnitude vector 
; for the saturation values.
; 
;**********************************************************************;

procedure ep_add_color_wheel_ndc(wks:graphic,resources:logical)

local i,pi,x,y,cwX,cwY,ploy_res,text_res,rinc,hue,ihue,\
	theta1,theta2,rlen,isat,xndc,yndc,xline,yline,ex,ey,cmap, \
	cwScale,hueunits,satunits,hueoffset,minV,cwPerim,res, \
	huemidlevels,huelevels,satlevels

begin
 res = get_resources(resources)
 
  ;do they have units?
 if (isatt(res,"epHueLabel")) then
   hueunits = res@epHueLabel
 else
   hueunits = ""
 end if
 if (isatt(res,"epSatLabel")) then
   satunits = res@epSatLabel
 else
   satunits = ""   
 end if

 ;should we scale the color wheel?
 if (isatt(res,"epColorWheelScale")) then
   cwScale = res@epColorWheelScale
   delete(res@epColorWheelScale)
 else
   cwScale = 1.
 end if
 
 ;should we move the color wheel?
 if (isatt(res,"epColorWheelCenterX")) then
   cwX = res@epColorWheelCenterX
   delete(res@epColorWheelCenterX)
 else
   cwX = 0.8
 end if
 
 if (isatt(res,"epColorWheelCenterY")) then
   cwY = res@epColorWheelCenterY
   delete(res@epColorWheelCenterY)
 else
   cwY = 0.85
 end if
 
 ;box around the color wheel?
 if (isatt(res,"epColorWheelPerimOn")) then
   cwPerim = res@epColorWheelPerimOn
   delete(res@epColorWheelPerimOn)
 else
   cwPerim = False
 end if
 
  
 
  ;set saturation values
 if (isatt(res,"epExplicitSatLevels")) then
   nSats = dimsizes(res@epExplicitSatLevels) + 1
   satlevels = res@epExplicitSatLevels
   delete(res@epExplicitSatLevels)
   
 else
 
   if (isatt(res,"epMinSatLevel").AND.isatt(res,"epMaxSatLevel").AND. \
       isatt(res,"epSatLevelSpacing")) then
     nSats = round(((res@epMaxSatLevel-res@epMinSatLevel)/res@epSatLevelSpacing),3) + 2
     
     satlevels = fspan(res@epMinSatLevel,res@epMaxSatLevel,nSats-1)
     
   else
     print("need to set saturation levels")
     exit
 
   end if
 end if

 ;set hue values
 if (isatt(res,"epExplicitHueLevels")) then
   nHues = dimsizes(res@epExplicitHueLevels)
   huelevels = res@epExplicitHueLevels
   delete(res@epExplicitHueLevels)
   
 else
 
    if (isatt(res,"epMinHueLevel").AND.isatt(res,"epMaxHueLevel").AND. \
       isatt(res,"epHueLevelSpacing")) then
     nHues = round(((res@epMaxHueLevel-res@epMinHueLevel)/res@epHueLevelSpacing),3) + 1
     
     huelevels = fspan(res@epMinHueLevel,res@epMaxHueLevel,nHues)

   else

     print("need to set hue levels")
     exit
     
   end if
 end if
 


   huemidlevels = huelevels
   delete(huelevels)
   huelevels = (huemidlevels(:nHues-2)+huemidlevels(1:))/2.
			

 

   ;add perimeter
   poly_res = True
   if (cwPerim) then
     poly_res@gsFillColor = 0.
     poly_res@gsEdgesOn = True
     xndc = new(5,float)
     yndc = xndc
     xndc(0) = cwX - 0.115*cwScale
     xndc(1) = xndc(0)
     xndc(2) = cwX + 0.115*cwScale
     xndc(3) = xndc(2)
     xndc(4) = xndc(0)
     yndc(0) = cwY - 0.14*cwScale
     yndc(1) = cwY + 0.11*cwScale
     yndc(2) = yndc(1)
     yndc(3) = yndc(0)
     yndc(4) = yndc(0)
     
     gsn_polygon_ndc(wks,xndc,yndc,poly_res)
     delete(xndc)
     delete(yndc)
     delete(poly_res)     
   end if
   
   

 pi = acos(-1)
 
 cmap = gsn_retrieve_colormap(wks)
 
  x = new(4,float)
  y = new(4,float)
  
  
; Create variables to hold resource lists.
;
  poly_res = True
  text_res = True
  text_res@txFont = "helvetica"
  text_res@txFontHeightF = 0.018*cwScale

;
;  Loop on the values.
;
  rinc = 2 * pi/nHues
;
;  Loop on the hues.
;
    do ihue = 0,nHues-1
      theta1 = (ihue -.5) * rinc
      theta2 = (ihue +.5) * rinc
      x(0) = 0.0
      x(3) = 0.0
      y(0) = 0.0
      y(3) = 0.0
;
;  Loop on the saturation values.
;
      do isat = 1,nSats
        poly_res@gsFillColor = cmap((ihue*nSats)+isat+1,:)
        rlen = cwScale*((1.*isat)/(14.*nSats))
        x(1) = sin(theta1) * rlen * cwScale
        y(1) = cos(theta1) * rlen * cwScale
        x(2) = sin(theta2) * rlen * cwScale
        y(2) = cos(theta2) * rlen * cwScale
        xndc = x + cwX
	yndc = y + cwY
	
	gsn_polygon_ndc(wks,xndc,yndc,poly_res)
	
        x(0) = x(1)
        x(3) = x(2)
        y(0) = y(1)
        y(3) = y(2)
	
	      ;get location of magnitude vector
      if (ihue.eq.0.and.isat.eq.nSats-1) then
        ex = ((((xndc(2)+xndc(1))/2))*(1-(1/nSats)))
	ey = ((((yndc(2)+yndc(1))/2))*(1-(1/nSats)))
      end if

      end do
      
      ;draw time stamps
      ;line coords
      xstart = (xndc(2)+xndc(1))/2
      ystart = (yndc(2)+yndc(1))/2
      xend = (xstart - cwX)/nSats + xstart
      yend = (ystart - cwY)/nSats + ystart
      xline = (/xstart,xend/)
      yline = (/ystart,yend/)
      
      gsn_polyline_ndc(wks,xline,yline,False)
      
      ;change text justification depending on side
      if (ihue*rinc.le.pi/4.or.ihue*rinc.gt.7*pi/4) then
        text_res@txJust = "BottomCenter"
      end if
      if (ihue*rinc.gt.pi/4.and.ihue*rinc.le.3*pi/4) then
        text_res@txJust = "CenterLeft"
      end if
      if (ihue*rinc.gt.3*pi/4.and.ihue*rinc.le.5*pi/4) then
         text_res@txJust = "TopCenter"
      end if
      if (ihue*rinc.gt.5*pi/4.and.ihue*rinc.le.7*pi/4) then
        text_res@txJust = "CenterRight"
      end if
      gsn_text_ndc(wks,sprintf("%3.0f",huemidlevels(ihue)),((2.*xline(1)-xline(0))+xline(1))/2.,((2.*yline(1)-yline(0))+yline(1))/2.,text_res)
      
      
    end do

    ;ex and ey must be float so change them if they are double
    if (isdouble(ex)) then
      exd = ex
      delete(ex)
      ex = doubletofloat(exd)
      delete(exd)
    end if
    if (isdouble(ey)) then
      eyd = ey
      delete(ey)
      ey = doubletofloat(eyd)
      delete(eyd)
    end if


    ;draw magnitude vector (need to use the wmlabs stuff)
    wmsetp("ezf",-1)
    wmsetp("awc",1) ;arrow color
    wmsetp("aoc",1) ;outline color
    wmsetp("ard",90.) ;arrow direction
    wmsetp("ars",sqrt((ex-cwX)^2 + (ey-cwY)^2))  ;arrow length
    wmlabs(wks,ex,ey,"arrow")
    
    ares = True
     ares@gsLineThicknessF = 3.
     
;    mainplot@arrow1 = gsn_add_polyline(wks,canvas,(/ccx,ex/),(/ccy,ey/),ares)
;    mainplot@arrow2 = gsn_add_polyline(wks,canvas,(/ex-0.025,ex,ex+0.025/),(/ey-0.05,ey,ey-0.05/),ares)
    
    text_res@txFontHeightF = 0.015*cwScale
    text_res@txJust = "CenterRight"
    gsn_text_ndc(wks,min(satlevels),cwX-0.01,cwY,text_res)
    gsn_text_ndc(wks,max(satlevels),ex-0.01,ey,text_res)
 
 
   ;add title for color wheel
   text_res@txFontHeightF = 0.02*cwScale
   text_res@txJust = "BottomCenter"
   gsn_text_ndc(wks,hueunits,cwX,cwY-(0.13*cwScale),text_res)
   
     
   
 end



;**********************************************************************;
; Procedure : add_ep_label_bar
;		wks: workstation object
;               mainplot: graphic object
;		nHues: numeric
;		nSats: numeric
;		hue_units: string
;		hue_levels: numeric
;		sat_units: string
;		sat_levels: numeric
;
; This function draws a label bar in the plot. 
; It also adds labels for the colors and a magnitude vector 
; for the saturation values.
;
; I first create a blank canvas to create the label bar in
; then I annotate this to the plot
; 

procedure add_ep_label_bar(wks:graphic,mainplot:graphic,nHues:numeric, \
				nSats:numeric, \
				hue_units:string,hue_levels:numeric, \
				sat_units:string,sat_levels:numeric)

local i,ymin,ymax,ploy_res,text_res,hue,ihue,\
	theta1,theta2,rlen,isat,xndc,yndc,xline,yline,ex,ey,cmap, \
	xstep,ystep

begin
 
 cmap = gsn_retrieve_colormap(wks)
 
  xndc = new(4,float)
  yndc = new(4,float)
    
    
 ;get the size of the current plot
 getvalues mainplot
   "vpWidthF" : xmax
   "vpXF" : xmin
   "vpHeightF" : ymin
   "vpYF" : ymax
 end getvalues
 

 xmax = xmax + xmin
 ymin = ymax - ymin
 
  
  
  
  ;create a blank canvas to draw the label bar on
  canvas = create "canvas" logLinPlotClass wks
    "vpXF" : xmin
    "vpWidthF" : xmax-xmin
    "vpYF" : ymin
    "vpHeightF" : 0.14
   end create
  
  

; Create variables to hold resource lists.
;
  poly_res = True
  
  text_res = True
   text_res@txFont = "helvetica"
   text_res@txFontHeightF = 0.018

  
  ;hue_levels may be double - convert to float if they are
  if (isdouble(hue_levels)) then
    hue_levels_flt = dble2flt(hue_levels)
  else
    hue_levels_flt = hue_levels
  end if
  
;
;  Loop on the values.
;
; set the x and y step sizes in NDC inside the canvas
  cxmin = 0.2
  cxmax = 0.99
  xstep = (cxmax-cxmin)/nHues
  cymin = 0.35
  cymax = 0.65
  ystep = (cymax-cymin)/nSats

;
;  Loop on the hues.
;
dumsat = new(dimsizes(cmap(:,0)),graphic)
dumhue =  new(nHues,graphic)
dumtext = dumhue

    do ihue = 0,nHues-1
      xndc(0) = cxmin + xstep*ihue
      xndc(1) = xndc(0)
      xndc(2) = cxmin + xstep*(ihue+1)
      xndc(3) = xndc(2)
;
;  Loop on the saturation values.
;
      do isat = 0,nSats-1
        poly_res@gsFillColor = cmap((ihue*nSats)+isat+2,:)
        yndc(0) = cymin + ystep*isat 
        yndc(1) = cymin + ystep*(isat+1)
        yndc(2) = yndc(1)
        yndc(3) = yndc(0)

	str = unique_string("sat")
        mainplot@$str$ = gsn_add_polygon(wks,canvas,xndc,yndc,poly_res)
      end do
      
      ;draw hue stamps
      if (ihue.gt.0) then
        xline = (/xndc(0),xndc(0)/)
        yline = (/cymax,cymin-0.01/)
	
	str = unique_string("hue")
        mainplot@$str$ = gsn_add_polyline(wks,canvas,xline,yline,False)
	str = unique_string("text")
	mainplot@$str$ = gsn_add_text(wks,canvas,flt2string(hue_levels_flt(ihue-1)),xline(0),yline(1)-0.15,text_res)
      end if
      
    end do


    ;draw magnitude vector (need to use the wmlabs stuff)
    wmsetp("ezf",-1)
    wmsetp("awc",1) ;arrow color
    wmsetp("aoc",1) ;outline color
    wmsetp("ard",90.)  ;arrow direction
    wmsetp("ars",ystep*(nSats-2))   ;arrow length
    ;wmlabs(canvas,xmin-0.02,ymax-ystep,"arrow")
    
    ares = True
     ares@gsLineThicknessF = 3.
    
    str = unique_string("arrow1")
    mainplot@$str$ = gsn_add_polyline(wks,canvas,(/cxmin-0.02,cxmin-0.02/), \
    			(/cymax-ystep*(nSats-1),cymax-ystep/),ares)
    str = unique_string("arrow2")
    mainplot@$str$ = gsn_add_polyline(wks,canvas,(/cxmin-0.025,cxmin-0.02,cxmin-0.015/), \
    			(/cymax-ystep-0.05,cymax-ystep,cymax-ystep-0.05/),ares)
			

    
    ;gsn_polyline_ndc(wks,(/cx,ex/),(/cy,ey/),False)
    text_res@txFontHeightF = 0.015
    str = unique_string("text")
    mainplot@$str$ = gsn_add_text(wks,canvas,min(sat_levels),cxmin-0.08,cymin+ystep,text_res)
    str = unique_string("text")
    mainplot@$str$ = gsn_add_text(wks,canvas,max(sat_levels),cxmin-0.08,cymax-ystep,text_res)

    ;draw box around the label bar
    delete(poly_res@gsFillColor)
    poly_res@gsFillColor = -1
    poly_res@gsEdgesOn = True
    str = unique_string("box")
    mainplot@$str$ = gsn_add_polygon(wks,canvas,(/cxmin,cxmin,cxmax,cxmax,cxmin/),(/cymin,cymax,cymax,cymin,cymin/),poly_res)
 
   ;add units
    text_res@txFontHeightF = 0.02

    str = unique_string("text")
    mainplot@$str$ = gsn_add_text(wks,canvas,hue_units,(cxmax+cxmin)/2.,cymin-0.35,text_res)
    str = unique_string("text")
    mainplot@$str$ = gsn_add_text(wks,canvas,sat_units,cxmin-0.2,(cymax+cymin)/2.,text_res)
   
   
   ;anotate the label bar
   lbanres = True
    lbanres@gsnMaximize = nHues@maximize
    lbanres@amZone = 2
    lbanres@amParallelPosF = 0.5
    lbanres@amOrthogonalPosF = 0.02
    
   
   lbanno = gsn_add_annotation(mainplot,canvas,lbanres)
   
   
 end



;**********************************************************************;
; Procedure : add_ep_label_bar_ndc
;		wks: workstation object
;               resources: logical
;
; This function draws a label bar in the plot using NDC coords. 
; It also adds labels for the colors and a magnitude vector 
; for the saturation values.
;
; I first create a blank canvas to create the label bar in
; then I annotate this to the plot
; 

procedure add_ep_label_bar_ndc(wks:graphic,resources:logical)

local i,ymin,ymax,ploy_res,text_res,hue,ihue,\
	theta1,theta2,rlen,isat,xndc,yndc,xline,yline,ex,ey,cmap, \
	xstep,ystep,HueFsize,SatFsize

begin
  res = get_resources(resources)
 
  ;do they have units?
 if (isatt(res,"epHueLabel")) then
   hueunits = res@epHueLabel
 else
   hueunits = ""
 end if
 if (isatt(res,"epSatLabel")) then
   satunits = res@epSatLabel
 else
   satunits = ""   
 end if 
 
 ;bottom/left corner of label bar
 if (isatt(res,"epLabelBarXMin")) then
   xmin = res@epLabelBarXMin
   delete(res@epLabelBarXMin)
 else
   xmin  = 0.15
 end if
 
 if (isatt(res,"epLabelBarYMin")) then
   ymin = res@epLabelBarYMin
   delete(res@epLabelBarYMin)
 else
   ymin = 0.1
 end if
 
 ;set the width and height of the label bar
 if (isatt(res,"epLabelBarWidthF")) then
   width = res@epLabelBarWidthF
   delete(res@epLabelBarWidthF)
 else
   width = 0.8
 end if
 
 if (isatt(res,"epLabelBarHeightF")) then
   height = res@epLabelBarHeightF
   delete(res@epLabelBarHeightF)
 else
   height = 0.05
 end if
 
 ;set the font heights
 if (isatt(res,"epHueFontSize")) then
   HueFsize = res@epHueFontSize
   delete(res@epHueFontSize)
 else
   HueFsize = 0.018
 end if
 
 if (isatt(res,"epSatFontSize")) then
   SatFsize = res@epSatFontSize
   delete(res@epSatFontSize)
 else
   SatFsize = 0.015
 end if


 
  ;set saturation values
 if (isatt(res,"epExplicitSatLevels")) then
   nSats = dimsizes(res@epExplicitSatLevels) + 1
   satlevels = res@epExplicitSatLevels
   delete(res@epExplicitSatLevels)
   
 else
 
   if (isatt(res,"epMinSatLevel").AND.isatt(res,"epMaxSatLevel").AND. \
       isatt(res,"epSatLevelSpacing")) then
     nSats = round(((res@epMaxSatLevel-res@epMinSatLevel)/res@epSatLevelSpacing),3) + 2
     
     satlevels = fspan(res@epMinSatLevel,res@epMaxSatLevel,nSats-1)
     
   else
     print("need to set saturation levels")
     exit
 
   end if
 end if

 ;set hue values
 if (isatt(res,"epExplicitHueLevels")) then
   nHues = dimsizes(res@epExplicitHueLevels)
   huelevels = res@epExplicitHueLevels
   delete(res@epExplicitHueLevels)
   
 else
 
    if (isatt(res,"epMinHueLevel").AND.isatt(res,"epMaxHueLevel").AND. \
       isatt(res,"epHueLevelSpacing")) then
     nHues = round(((res@epMaxHueLevel-res@epMinHueLevel)/res@epHueLevelSpacing),3) + 2
     
     huelevels = fspan(res@epMinHueLevel,res@epMaxHueLevel,nHues-1)

   else

     print("need to set hue levels")
     exit
     
   end if
 end if
 
 
 
 
 
 cmap = gsn_retrieve_colormap(wks)
 
  xndc = new(4,float)
  yndc = new(4,float)
    
    
 

 xmax = width + xmin
 ymax = height + ymin
 
 

; Create variables to hold resource lists.
;
  poly_res = True
  
  text_res = True
   text_res@txFont = "helvetica"
   text_res@txFontHeightF = HueFsize

 
;
;  Loop on the values.
;
; set the x and y step sizes in NDC inside the canvas
  xstep = 1.*(xmax-xmin)/nHues
  ystep = 1.*(ymax-ymin)/nSats

;
;  Loop on the hues.
;
dumsat = new(dimsizes(cmap(:,0)),graphic)
dumhue =  new(nHues,graphic)
dumtext = dumhue

    do ihue = 0,nHues-1
      xndc(0) = xmin + xstep*ihue
      xndc(1) = xndc(0)
      xndc(2) = xmin + xstep*(ihue+1)
      xndc(3) = xndc(2)
;
;  Loop on the saturation values.
;
      do isat = 0,nSats-1
        poly_res@gsFillColor = cmap((ihue*nSats)+isat+2,:)
        yndc(0) = ymin + ystep*isat 
        yndc(1) = ymin + ystep*(isat+1)
        yndc(2) = yndc(1)
        yndc(3) = yndc(0)

        gsn_polygon_ndc(wks,xndc,yndc,poly_res)
      end do
      
      ;draw hue stamps
      if (ihue.gt.0) then
        xline = (/xndc(0),xndc(0)/)
        yline = (/ymax,ymin-0.01/)
	
        gsn_polyline_ndc(wks,xline,yline,False)
	gsn_text_ndc(wks,flt2string(huelevels(ihue-1)),xline(0),yline(1)-0.005-(HueFsize*0.5),text_res)
      end if
      
    end do


    
    ares = True
     ares@gsLineThicknessF = 3.
    
    gsn_polyline_ndc(wks,(/xmin-0.02,xmin-0.02/), \
    			(/ymin+ystep,ymax-ystep/),ares)
    gsn_polyline_ndc(wks,(/xmin-0.025,xmin-0.02,xmin-0.015/), \
    			(/ymax-ystep-0.005,ymax-ystep,ymax-ystep-0.005/),ares)
			

    
    ;gsn_polyline_ndc(wks,(/cx,ex/),(/cy,ey/),False)
    text_res@txFontHeightF = SatFsize
    gsn_text_ndc(wks,min(satlevels),xmin-0.02-(SatFsize*2),ymin+ystep,text_res)
    gsn_text_ndc(wks,max(satlevels),xmin-0.02-(SatFsize*2),ymax-ystep,text_res)

    ;draw box around the label bar
    delete(poly_res@gsFillColor)
    poly_res@gsFillColor = -1
    poly_res@gsEdgesOn = True
    gsn_polygon_ndc(wks,(/xmin,xmin,xmax,xmax,xmin/),(/ymin,ymax,ymax,ymin,ymin/),poly_res)
 
   ;add units
    text_res@txFontHeightF = HueFsize*1.1111111

    gsn_text_ndc(wks,hueunits,(xmax+xmin)/2.,ymin-0.0075-(HueFsize*0.5)-(HueFsize*2.777778),text_res)
    
    
    text_res@txFontHeightF = SatFsize*1.33333333
    gsn_text_ndc(wks,satunits,xmin-0.04-(SatFsize*3.33),(ymax+ymin)/2.,text_res)
   
   
   
 end



;**********************************************************************;
; Function : evans_plot_map
;		wks: workstation object
;		hue_data: 2D color data
;		sat_data: 2D saturation data
;		resources: optional resources
;
; This function creates a color/saturation raster map on the workstation
; "wks". "hue_data" is the 2D data to be mapped as color. "sat_data" is
; the data to be mapped as saturation. "resources" is a list of resources 
;
; Note that several resources apply specifically to this type of plot.
;
; epCyclic {logical} : is the hue variable cyclic? default is [True]
;
; epHueLabel {string} : [hue_data@units]
; epSatLabel {string} : [sat_data@units]
;
; epExplicitSatLevels {float[*]} : user set saturation levels
; epMaxSatLevel {float} : max saturation level
; epMinSatLevel {float} : min saturation level
; epSatLevelSpacing {float} : saturation level spacing
;
; epExplicitHueLevels {float[*]} : user set hue levels
; epMaxHueLevel {float} : max hue level
; epMinHueLevel {float} : min hue level
; epHueLevelSpacing {float} : hue level spacing
;
; epMinIntensity {float} : minimum intensity to use (0-1) [0.8]
; epMinSat {float} : minimum saturation to use (0-1) [0.0]
;
; epLabelBarOn {logical} : draw the label bar? [True] only when epCyclic = False
; epColorWheelOn {logical} : draw the color wheel? [True] only when epCyclic = True
; epColorWheelScale {float} : change the size of the color wheel by
;                              multiplying by this scale factor [1.]
; epColorWheelCenterX {float} : center X of color wheel in ndc [0.85]
; epColorWheelCenterY {float} : center Y of color wheel in ndc [0.85]
; epColorWheelPerimOn {logical} : draw a box around the color wheel? [False]
; epHueOffset {float} : make the first hue this many degrees around the
;                        color wheel from red (0-360) [0.]
; epReverseHueColors {logical} : reverse the order of the Hues [False]
; epReverseSatColors {logical} : reverse the order of the Saturation/Intensity changes [False]
; epNumMaxSat {integer} : number of saturation levels to be fully saturated and distinguished by ;                                   changes in intensity [1 if <6 sat levels, 4 otherwise]
;
; It uses gsn_csm_contour_map to plot so all the relevant resources also
; apply.
;
; 
;*************************************************************************;

function evans_plot_map(wks:graphic,hue_data[*][*]:numeric,\
				sat_data[*][*],resources:logical)
				
local i,dsize,mnmxint,nSats,minsat,maxsat,nHues,minhue,maxhue, \
      nHues,vmin,vmax,vstep,hue_data1d,sat_data1d,thishue,res, \
      	huelevels,satlevels,colunits,satunits,hueinds,satinds, \
	plotinds,plotvar1d,plotvar,plot_obj,dnames,huename,satname, \
	HueCyclic,satspace,dvar,hueoffset,minV,huemidlevels, \
	cwScale,cwX,cwY,cwPerim,framenow,drawguide,RevHue,RevSat,numMaxSat

begin
 res = get_resources(resources)
 
 dsize = dimsizes(hue_data)
 dnames = getvardims(hue_data)


 ;if dimensions weren't named then name them
 if (ismissing(dnames(0))) then
   dnames(0) = "lat"
   hue_data!0 = "lat"
   sat_data!0 = "lat"
 end if
 if (ismissing(dnames(1))) then
   dnames(1) = "lon"
   hue_data!1 = "lon"
   sat_data!1 = "lon"
 end if

 ;are the color and saturation datasets named?
 if (isatt(hue_data,"long_name")) then
   huename = hue_data@long_name
 else
   huename = ""
 end if
 if (isatt(sat_data,"long_name")) then
   satname = sat_data@long_name
 else
   satname = ""
 end if
 
 ;do they have units?
 if (isatt(res,"epHueLabel")) then
   hueunits = res@epHueLabel
   delete(res@epHueLabel)
 else
   if (isatt(hue_data,"units")) then
     hueunits = hue_data@units
   else
     hueunits = ""
   end if
 end if
 if (isatt(res,"epSatLabel")) then
   satunits = res@epSatLabel
   delete(res@epSatLabel)
 else
   if (isatt(sat_data,"units")) then
     satunits = sat_data@units
   else
     satunits = ""
   end if
 end if

 ;is there a hue offset?
 if (isatt(res,"epHueOffset")) then
   hueoffset = res@epHueOffset
   delete(res@epHueOffset)
 else
   hueoffset = 0.
 end if
 
 ;do you want to reverse the order of the Hues?
 if (isatt(res,"epReverseHueColors")) then
   RevHue = res@epReverseHueColors
   delete(res@epReverseHueColors)
 else
   RevHue = False
 end if
 
 ;do you want to reverse the saturation/intensity order?
 if (isatt(res,"epReverseSatColors")) then
   RevSat = res@epReverseSatColors
   delete(res@epReverseSatColors)
 else
   RevSat = False
 end if
 
 
 ;is there a minimum intensity
 if (isatt(res,"epMinIntensity")) then
   minV = res@epMinIntensity
   delete(res@epMinIntensity)
 else
   minV = 0.8
 end if
 
 if (isatt(res,"epMinSat")) then
   minSat = res@epMinSat
   delete(res@epMinSat)
 else
   minSat = 0.0
 end if
 
 ;should we scale the color wheel?
 if (isatt(res,"epColorWheelScale")) then
   cwScale = res@epColorWheelScale
   delete(res@epColorWheelScale)
 else
   cwScale = 1.
 end if
 
 ;should we move the color wheel?
 if (isatt(res,"epColorWheelCenterX")) then
   cwX = res@epColorWheelCenterX
   delete(res@epColorWheelCenterX)
 else
   cwX = 0.8
 end if
 
 if (isatt(res,"epColorWheelCenterY")) then
   cwY = res@epColorWheelCenterY
   delete(res@epColorWheelCenterY)
 else
   cwY = 0.85
 end if
 
 ;box around the color wheel?
 if (isatt(res,"epColorWheelPerimOn")) then
   cwPerim = res@epColorWheelPerimOn
   delete(res@epColorWheelPerimOn)
 else
   cwPerim = False
 end if
 
 
 
 ;Initialize
 res@lbLabelBarOn = False
 ;res@cnRasterModeOn = True
 res@cnFillMode = "CellFill"
 res@cnFillOn = True
 res@cnMissingValFillColor = 0
 res@gsnSpreadColors = False
 res@cnInfoLabelOn = False
 res@cnLinesOn = False
 res@cnLineLabelsOn = False
 

 if (.not.isatt(res,"epCyclic")) then
   HueCyclic = True
 else
   HueCyclic = res@epCyclic
   delete(res@epCyclic)
 end if
 
 if (HueCyclic) then
   if (isatt(res,"epColorWheelOn")) then
     drawguide = res@epColorWheelOn
     delete(res@epColorWheelOn)
     if (.not.isatt(res,"vpXF").and.drawguide) then
       res@vpXF = 0.1
     end if
     if (.not.isatt(res,"vpYF").and.drawguide) then
       res@vpYF = 0.65
     end if
   else
     drawguide = True
   end if
 else
   if (isatt(res,"epLabelBarOn")) then
     drawguide = res@epLabelBarOn
     delete(res@epLabelBarOn)
   else
     drawguide = True
   end if
 end if

 
 ;set saturation values
 if (isatt(res,"epExplicitSatLevels")) then
   nSats = dimsizes(res@epExplicitSatLevels) + 1
   satlevels = res@epExplicitSatLevels
   delete(res@epExplicitSatLevels)
   
 else
 
   if (isatt(res,"epMinSatLevel").AND.isatt(res,"epMaxSatLevel").AND. \
       isatt(res,"epSatLevelSpacing")) then
     nSats = round(((res@epMaxSatLevel-res@epMinSatLevel)/res@epSatLevelSpacing),3) + 2
     
     satlevels = fspan(res@epMinSatLevel,res@epMaxSatLevel,nSats-1)
     
     delete(res@epMinSatLevel)
     delete(res@epMaxSatLevel)
     delete(res@epSatLevelSpacing)
   
   else
     
     if (isatt(res,"epMinSatLevel")) then
       minsat = res@epMinSatLevel 
       delete(res@epMinSatLevel)
     else
       minsat = min(sat_data)
     end if

     if (isatt(res,"epMaxSatLevel")) then
       maxsat = res@epMaxSatLevel
       delete(res@epMaxSatLevel)
     else
       maxsat = max(sat_data)
     end if
     
     if (isatt(res,"epSatLevelSpacing")) then
       nSats = round(((maxsat-minsat)/res@epSatLevelSpacing),3) + 2
       delete(res@epSatLevelSpacing)
     else
       nSats = 8
     end if
  
     mnmxint = nice_mnmxintvl(minsat,maxsat,nSats,False)
   
     nSats = round(((mnmxint(1) - mnmxint(0))/mnmxint(2)),3) + 2

     satlevels = fspan(mnmxint(0),mnmxint(1),nSats-1)

     delete(mnmxint)
     
   end if
 end if


 ;how many colors should have maximum saturation
 if (isatt(res,"epNumMaxSat")) then
   NumMaxSat = res@epNumMaxSat
   delete(res@epNumMaxSat)
 else
   if nSats.lt.6
     NumMaxSat = 1
   else
     NumMaxSat = 4
   end if
 end if


 ;set hue values
 if (isatt(res,"epExplicitHueLevels")) then
   nHues = dimsizes(res@epExplicitHueLevels)
   huelevels = res@epExplicitHueLevels
   delete(res@epExplicitHueLevels)
   
 else
 
    if (isatt(res,"epMinHueLevel").AND.isatt(res,"epMaxHueLevel").AND. \
       isatt(res,"epHueLevelSpacing")) then
     nHues = round(((res@epMaxHueLevel-res@epMinHueLevel)/res@epHueLevelSpacing),3) + 1
     
     huelevels = fspan(res@epMinHueLevel,res@epMaxHueLevel,nHues)
     
     delete(res@epMinHueLevel)
     delete(res@epMaxHueLevel)
     delete(res@epHueLevelSpacing)
   
   else

     if (isatt(res,"epMinHueLevel")) then
       minhue = res@epMinHueLevel
       delete(res@epMinHueLevel)
     else
       minhue = min(hue_data)
     end if

     if (isatt(res,"epMaxHueLevel")) then
       maxhue = res@epMaxHueLevel
       delete(res@epMaxHueLevel)
     else
       maxhue = max(hue_data)
     end if
     
     if (isatt(res,"epHueLevelSpacing")) then
       nHues = round(((maxhue-minhue)/res@epHueLevelSpacing),3)+2
       delete(res@epHueLevelSpacing)
     else
       nHues = 8
     end if
 
     mnmxint = nice_mnmxintvl(minhue,maxhue,nHues,False)
   
     nHues = round(((mnmxint(1) - mnmxint(0))/mnmxint(2)),3) + 1
   
     huelevels = fspan(mnmxint(0),mnmxint(1),nHues)

   end if
 end if
 

 if (HueCyclic) then
   huemidlevels = huelevels
   delete(huelevels)
   huelevels = (huemidlevels(:nHues-2)+huemidlevels(1:))/2.
 else
   nHues = nHues + 1
 end if
   				
			
			
				
 ;create HSV colormap
 cmap = evans_plot_color_map(nHues,nSats,hueoffset,minV,minSat,HueCyclic,RevHue,RevSat,NumMaxSat)
 gsn_define_colormap(wks,cmap)
 
;gsn_draw_colormap(wks)
 
 

  
 ;want to convert data to a single layer with values representing the
 ;colormap location of each point
 plotvar = hue_data
 plotvar = plotvar@_FillValue
 plotvar1d = ndtooned(plotvar)
 thishue = new(dimsizes(plotvar1d),logical)
 

 hue_data1d = ndtooned(hue_data)
 sat_data1d = ndtooned(sat_data)
 

 ;for the first hue
 hueinds = ind(hue_data1d.lt.huelevels(0))
 if (any(.not.ismissing(hueinds))) then
   thishue(hueinds) = True
 end if
   
 if (any(thishue)) then
     
   ;for the first sat  
   satinds = ind(sat_data1d.lt.satlevels(0).AND.thishue)   
   if (any(.not.ismissing(satinds))) then    
     plotvar1d(satinds) = 0.5
   end if
   delete(satinds)
   
   ;for the middle sats
   do i = 1,nSats-2
     satinds = ind(sat_data1d.ge.satlevels(i-1).AND.sat_data1d.lt.satlevels(i) \
		   .AND.thishue)
     if (any(.not.ismissing(satinds))) then
       plotvar1d(satinds) = 0.5 + i
     end if
     delete(satinds)
   end do	   
       
   ;for last sat
   satinds = ind(sat_data1d.ge.satlevels(nSats-2).AND.thishue)
   if (any(.not.ismissing(satinds))) then
     plotvar1d(satinds) = 0.5 + nSats-1
   end if
   delete(satinds)
   
 end if
 delete(hueinds)
 thishue = False
 
 ;for the middle hues
 do j = 1,nHues-2
   hueinds = ind(hue_data1d.ge.huelevels(j-1).AND.hue_data1d.lt.huelevels(j))
   if (any(.not.ismissing(hueinds))) then
     thishue(hueinds) = True
   end if
   
   if (any(thishue)) then
     
     ;for the first sat  
     satinds = ind(sat_data1d.lt.satlevels(0).AND.thishue)
     if (any(.not.ismissing(satinds))) then      
       plotvar1d(satinds) = 0.5 + j*nSats 
     end if
     delete(satinds)
     
     ;for the middle sats
     do i = 1,nSats-2
       satinds = ind(sat_data1d.ge.satlevels(i-1).AND.sat_data1d.lt.satlevels(i) \
		   .AND.thishue)
		
       if (any(.not.ismissing(satinds))) then		   
         plotvar1d(satinds) = 0.5 + j*nSats + i 
       end if
       delete(satinds)
     end do	   
       
     ;for last sat
     satinds = ind(sat_data1d.ge.satlevels(nSats-2).AND.thishue)
     if (any(.not.ismissing(satinds))) then
       plotvar1d(satinds) = 0.5 + j*nSats + nSats-1 
     end if
     delete(satinds)
        
   end if
   delete(hueinds)
   thishue = False
 end do  		  
       
 ;for the last hue
 hueinds = ind(hue_data1d.ge.huelevels(nHues-2))
 if (any(.not.ismissing(hueinds))) then
   thishue(hueinds) = True
 end if
 
 if (any(thishue)) then
     
   ;for the first sat  
   satinds = ind(sat_data1d.lt.satlevels(0).AND.thishue)
   if (any(.not.ismissing(satinds))) then      
     plotvar1d(satinds) = 0.5 + (nHues-1)*nSats
   end if
   delete(satinds)
   
   ;for the middle sats
   do i = 1,nSats-2
     satinds = ind(sat_data1d.ge.satlevels(i-1).AND.sat_data1d.lt.satlevels(i) \
		   .AND.thishue)
     if (any(.not.ismissing(satinds))) then
       plotvar1d(satinds) = 0.5 +(nHues-1)*nSats + i
     end if
     delete(satinds)
   end do	   
       
   ;for last sat
   satinds = ind(sat_data1d.ge.satlevels(nSats-2).AND.thishue)
   if (any(.not.ismissing(satinds))) then
     plotvar1d(satinds) = 0.5 + (nHues-1)*nSats + nSats-1
   end if
   delete(satinds)
   
 end if
 delete(hueinds)
 

 
 plotvar = onedtond(plotvar1d,dimsizes(plotvar))
 
 copy_VarMeta(hue_data,plotvar)
 if (isatt(plotvar,"units")) then
   delete(plotvar@units)
 end if
 
 if (isatt(res,"gsnDraw")) then
   drawnow = res@gsnDraw
 else
   drawnow = True
 end if
 
 if (isatt(res,"gsnFrame")) then
   framenow = res@gsnFrame
 else
   framenow = True
 end if
 
 res@gsnFrame = False
 res@gsnDraw = False

 res@cnLevelSelectionMode = "ManualLevels"
 res@cnMinLevelValF = 1.
 res@cnMaxLevelValF = (nSats*nHues) - 1.
 res@cnLevelSpacingF = 1.
 
  
 plot_obj = gsn_csm_contour_map(wks,plotvar,res)
 
; print(res)


   ;want to pass in whether or not to maximize the plot
 if (isatt(res,"gsnMaximize")) then
   nHues@maximize = res@gsnMaximize
 else
   nHues@maximize = False
 end if

 
 ;add the color wheel or label bar
if (drawguide) then
 if (HueCyclic) then
   add_color_wheel(wks,plot_obj,nHues,nSats,hueunits,huemidlevels,satlevels,cwScale, \
                     cwX,cwY,cwPerim)
 else
   add_ep_label_bar(wks,plot_obj,nHues,nSats,hueunits,huelevels,satunits,satlevels)
 end if
end if 

 if (drawnow) then
   draw(plot_obj)
 end if
 if (framenow) then
   frame(wks)
 end if


 
 return(plot_obj)

end

				
				