%%   
clear;clc;close all  
load geoid  
% Create a figure with an Eckert projection.  
figure  
axesm lambcyln; %注意axesm后面的m了吗?,可以使用maps命令查看所有的地图投影的方式,然后选一个  
framem; gridm;%显示框架和网格线,注意后面都多了个m,表示map  
% axis off %关闭外部坐标轴,外部坐标轴不同于map axes  
  
% Display the geoid as a texture map.   
geoshow(geoid, geoidrefvec, 'DisplayType', 'texturemap');  
  
% Create a colorbar and title.  
hcb = colorbar('southoutside');  
set(get(hcb,'Xlabel'),'String','EGM96 Geoid Heights in Meters.')  
  
% Mask out all the land.  
geoshow('landareas.shp', 'FaceColor', 'none');  