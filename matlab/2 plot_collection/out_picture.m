
% test
%     i=1;
%     figure(i);
%       scatter(lat,lon,'filled','cdata',qbot_yr(7,:));
%       colorbar;
%      print(i,'-dpng',[sprintf('qbot_stn_%d.png',i+2008)]);


for i=1:4
    figure(i);
    scatter(lon,lat,'filled','cdata',qbot_yr(i+6,:));
    colorbar;
    print(i,'-dpng',[sprintf('qbot_stn_%d.png',i+2008)]);
end
 figure(5);
    scatter(lon,lat,'filled','cdata',elev);
    colorbar;
     print(5,'-dpng',['stn.png']);