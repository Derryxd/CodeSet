
%% one
map = zeros(15,3);
map=[   0   0   162
        0  107  253
        0  186  253
      111  248  255
        0  150   50
        0  220    0
      180  255  180
      196  166    0
      255  255    0
      255  200    0
      255    0    0
      255  100  100
      255  180  180
      200  100  155
      150    0  180 ];
map=map/255.0;
colormap(map);
caxis([0, 75]); %要显示的数值范围
colorbar('YTick', 0:5:75, 'YTickLabel', ...
    {' ', '5', '10', '15', '20', '25', '30', '35', '40', '45', '50', '55', '60', '65', ' '});

%% two
[x,y,z] = peaks(25);
c = zeros(size(z));
c(z>min(min(z))&z<-1) = 0;
c(z>=-1) = 1;
surf(x,y,z,c);hc = colorbar;colormap([1 0 0;0 1 0])
set(hc,'YTick',[0 0.5 1])
set(hc,'YTickLabel',[min(min(z)) -1 max(max(z))])