clear all; close all;

shp = shaperead('bounding.shp');

load dew_TSL_daily_ave.mat;

sites = fieldnames(dwlbc);



for i = 1:length(sites)
    
    vars = fieldnames(dwlbc.(sites{i}));
    
    X = dwlbc.(sites{i}).(vars{1}).X;
    Y = dwlbc.(sites{i}).(vars{1}).Y;
    
    if inpolygon(X,Y,shp.X,shp.Y)
        
        sitelist.(sites{i}).Name = sites{i};
        sitelist.(sites{i}).X = X;
        sitelist.(sites{i}).Y = Y;
        
    end
    
end
save sitelist.mat sitelist -mat;