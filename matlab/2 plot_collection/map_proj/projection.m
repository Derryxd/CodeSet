%%   
clear;clc;close all  
load geoid  
% Create a figure with an Eckert projection.  
figure  
axesm lambcyln; %ע��axesm�����m����?,����ʹ��maps����鿴���еĵ�ͼͶӰ�ķ�ʽ,Ȼ��ѡһ��  
framem; gridm;%��ʾ��ܺ�������,ע����涼���˸�m,��ʾmap  
% axis off %�ر��ⲿ������,�ⲿ�����᲻ͬ��map axes  
  
% Display the geoid as a texture map.   
geoshow(geoid, geoidrefvec, 'DisplayType', 'texturemap');  
  
% Create a colorbar and title.  
hcb = colorbar('southoutside');  
set(get(hcb,'Xlabel'),'String','EGM96 Geoid Heights in Meters.')  
  
% Mask out all the land.  
geoshow('landareas.shp', 'FaceColor', 'none');  