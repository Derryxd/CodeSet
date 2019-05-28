% Multiply-connected polygon - a square with a square hole.
% Counterclockwise outer loop, clockwise inner loop.
%% matlab example
%Define the x and y coordinates of polygon vertices to create a pentagon.
tic
L = linspace(0,2.*pi,6);
xv = cos(L)';
yv = sin(L)';
rng default
xq = randn(250,1);
yq = randn(250,1);
%Determine whether each point lies inside or on the edge of the polygon area. 
%Also determine whether any of the points lie on the edge of the polygon area.
[in,on] = inpolygon(xq,yq,xv,yv);
numel(xq(in))
numel(xq(on))
numel(xq(~in))
%Plot the polygon and the query points. Display the points inside the polygon with a red plus. 
%Display the points outside the polygon with a blue circle.
figure
plot(xv,yv) % polygon
axis equal
hold on
plot(xq(in),yq(in),'r+') % points inside
plot(xq(~in),yq(~in),'bo') % points outside
hold off
toc
