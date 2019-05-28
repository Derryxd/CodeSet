clear;clc;
fid=fopen('11.txt','r','n','utf-8');
title = fgetl(fid);
title = split(title)';
content = textscan(fid,'%s%s','delimiter','\t');
name = content{1};
point= content{2};
point= split(cellstr(point),',');
[m,n]= size(point);
temp = char(point{:});
numl = str2num(temp);
numl = reshape(numl,[m n]);
fullCont = cat(1,title,[name point]);
fclose(fid);
clearvars fid m n temp ans