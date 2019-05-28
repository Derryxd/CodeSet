
x=floor(min(lon)):0.1:ceil(max(lon));
y=floor(min(lat)):0.1:ceil(max(lat));
[X,Y]=meshgrid(x,y);
filename='test.gif';
for j=1:12
    for i=1:86
        a(i)=stat_month(i).temp(j,1);
    end
    scatter(lon,lat,'filled','cdata',a);
    colormap('default')
    colorbar
    title([num2str(j) 'ÔÂ'])
    im=frame2im(getframe(gcf));
    [A,map]=rgb2ind(im,256);
    if j==1
        imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',1);
    else
        imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',1);
    end    
end
