function export_shapefile(data,filename)

sites = fieldnames(data);

for i = 1:length(sites)
    vars = fieldnames(data.(sites{i}));
    
    S(i).X = data.(sites{i}).(vars{1}).X;
    S(i).Y = data.(sites{i}).(vars{1}).Y;
    S(i).Agency = data.(sites{i}).(vars{1}).Agency;
    S(i).Name = sites{i};
    S(i).Geometry = 'Point';
    
end
shapewrite(S,filename);
    
    