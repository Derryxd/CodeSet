from simplekml import (Kml, OverlayXY, ScreenXY, Units, RotationXY,
                       AltitudeMode, Camera)


def make_kml(llcrnrlon, llcrnrlat, urcrnrlon, urcrnrlat,
             figs, colorbar=None, **kw):
    """TODO: LatLon bbox, list of figs, optional colorbar figure,
    and several simplekml kw..."""

    kml = Kml()
    altitude = kw.pop('altitude', 2e3)
    roll = kw.pop('roll', 0)
    tilt = kw.pop('tilt', 0)
    altitudemode = kw.pop('altitudemode', AltitudeMode.relativetoground)
    camera = Camera(latitude=np.mean([urcrnrlat, llcrnrlat]),
                    longitude=np.mean([urcrnrlon, llcrnrlon]),
                    altitude=altitude, roll=roll, tilt=tilt,
                    altitudemode=altitudemode)

    kml.document.camera = camera
    draworder = 0
    for fig in figs:  # NOTE: Overlays are limited to the same bbox.
        draworder += 1
        ground = kml.newgroundoverlay(name='GroundOverlay')
        ground.draworder = draworder
        ground.visibility = kw.pop('visibility', 1)
        ground.name = kw.pop('name', 'overlay')
        ground.color = kw.pop('color', '90effffff')
        ground.atomauthor = kw.pop('author', 'ocefpaf')
        ground.latlonbox.rotation = kw.pop('rotation', 0)
        ground.description = kw.pop('description', 'Matplotlib figure')
        ground.gxaltitudemode = kw.pop('gxaltitudemode',
                                       'clampToSeaFloor')
        ground.icon.href = fig
        ground.latlonbox.east = llcrnrlon
        ground.latlonbox.south = llcrnrlat
        ground.latlonbox.north = urcrnrlat
        ground.latlonbox.west = urcrnrlon

    if colorbar:  # Options for colorbar are hard-coded (to avoid a big mess).
        screen = kml.newscreenoverlay(name='ScreenOverlay')
        screen.icon.href = colorbar
        screen.overlayxy = OverlayXY(x=0, y=0,
                                     xunits=Units.fraction,
                                     yunits=Units.fraction)
        screen.screenxy = ScreenXY(x=0.015, y=0.075,
                                   xunits=Units.fraction,
                                   yunits=Units.fraction)
        screen.rotationXY = RotationXY(x=0.5, y=0.5,
                                       xunits=Units.fraction,
                                       yunits=Units.fraction)
        screen.size.x = 0
        screen.size.y = 0
        screen.size.xunits = Units.fraction
        screen.size.yunits = Units.fraction
        screen.visibility = 1
    kmzfile = kw.pop('kmzfile', 'overlay.kmz')
    kml.savekmz(kmzfile)
    
import numpy as np
import matplotlib.pyplot as plt



def gearth_fig(llcrnrlon, llcrnrlat, urcrnrlon, urcrnrlat, pixels=1024):
    """Return a Matplotlib `fig` and `ax` handles for a Google-Earth Image."""
    aspect = np.cos(np.mean([llcrnrlat, urcrnrlat]) * np.pi/180.0)
    xsize = np.ptp([urcrnrlon, llcrnrlon]) * aspect
    ysize = np.ptp([urcrnrlat, llcrnrlat])
    aspect = ysize / xsize

    if aspect > 1.0:
        figsize = (10.0 / aspect, 10.0)
    else:
        figsize = (10.0, 10.0 * aspect)

    if False:
        plt.ioff()  # Make `True` to prevent the KML components from poping-up.
    fig = plt.figure(figsize=figsize,
                     frameon=False,
                     dpi=pixels)
    # KML friendly image.  If using basemap try: `fix_aspect=False`.
    ax = fig.add_axes([0, 0, 1, 1])
    ax.set_xlim(llcrnrlon, urcrnrlon)
    ax.set_ylim(llcrnrlat, urcrnrlat)
    return fig, ax

import numpy.ma as ma
from netCDF4 import Dataset, date2index, num2date
import os
from pylab import *
from matplotlib import colors
if __name__ == '__main__':
    '''画图谱'''
    os.chdir(r'F:\2 GOLDWRF项目\3 河北怀来WRF项目\8 风险区识别\2 无SCADA风险区（WRF-测风塔）\画图\风险区图谱\数据')
    nc = Dataset('wind_TP_d03_V2.nc') #V2和V1只是坐标格式有差别
    lat = nc.variables['lat2d'][:]
    lon = nc.variables['lon2d'][:]    
    fdl = nc.variables['ws_avg2_100m'][:] 
    x,y = lat.shape   
    pixels = 1024 * 5
    fig, ax = gearth_fig(llcrnrlon=lon[0,60],
                         llcrnrlat=lat[62,0],
                         urcrnrlon=lon[0,y-51],
                         urcrnrlat=lat[x-48,0],
                         pixels=pixels//10)
    levels=(-1.8,-1.5,-1.2,-0.9,-0.6,-0.3,0,0.3,0.6,0.9,1.2,1.5,1.8)      
    cs =ax.contourf(lon, lat, fdl, levels,cmap=cm.RdBu,alpha=0.7)
    ax.contour(lon, lat, fdl, levels,colors='k') 
    fig.savefig('overlay_ws.png', transparent=True, format='png')

    
    fig = plt.figure(figsize=(0.5, 4.0), facecolor=None, frameon=False)
    ax = fig.add_axes([0.01, 0.03, 0.2, 0.9])
    cb = fig.colorbar(cs, cax=ax)
    cb.set_label('Wind Speed [m/s]', rotation=-90, color='k', labelpad=10)
    fig.savefig('legend_ws.png', transparent=False, format='png')  # Change transparent to True if your colorbar is not on space :)

         
    make_kml(llcrnrlon=lon[0,60], llcrnrlat=lat[62,0],
             urcrnrlon=lon[0,y-51], urcrnrlat=lat[x-48,0],
             figs=['overlay_ws.png'], colorbar='legend_ws.png',
             kmzfile='mdt_ws.kmz', name='Mean Dynamic Topography and velocity')
