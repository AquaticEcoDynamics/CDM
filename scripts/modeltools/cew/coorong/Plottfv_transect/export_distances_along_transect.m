clear all; close all;

pnt = shaperead('Coorong_line.shp');

for i = 1:length(pnt.X)
    data(i,1) = pnt.X(i);
    data(i,2) = pnt.Y(i);
end

dist(1,1) = 0;

for i = 2:length(pnt.X)
    
    dist(i,1) = sqrt(power((data(i,1) - data(i-1,1)),2) + power((data(i,2)- data(i-1,2)),2)) + dist(i-1,1);
    
end
    

% convert to km


%dist = dist / 1000;

%export_int = [10:10:260];

for i = 1:length(dist)
    
   % [~,int ] = min(abs(dist - export_int(i)));
    
    S(i).Geometry = 'Point';
    S(i).X = data(i,1);
    S(i).Y = data(i,2);
    S(i).Dist = dist(i,1);
    
end
shapewrite(S,'Coorong_pnt.shp')