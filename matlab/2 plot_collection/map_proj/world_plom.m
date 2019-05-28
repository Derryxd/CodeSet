
figure
lat=[-90 90];
lon=[0 360];
ll=coastll(:,1);
ll(ll<0)=ll(ll<0)+360;
h1=axesm('MapProjection','eqdcylin','maplatlimit',lat,'maplonlimit',lon);
plotm(coastll(:,2),ll)

