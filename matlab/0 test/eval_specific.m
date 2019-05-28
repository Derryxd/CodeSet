clear;clc;close all;
var={'a','b'};
vv={'lat','lon','diff','re'};
a=ncread('diff.nc','a');
for i=1:2
    eval([var{i} '=ncread(''diff.nc'',''' var{i} ''');']);
    for j=1:4
        eval([var{i} vv{j} '=ncread(''diff.nc'',''' var{i} vv{j} ''');']);
    end
end
