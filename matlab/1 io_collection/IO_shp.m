

a=shaperead('landareas.shp');
lon=[a(:).X]; %提取经度信息，第二维
lat=[a(:).Y]; %提取纬度信息，第一维