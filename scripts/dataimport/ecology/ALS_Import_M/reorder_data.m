function dataout = reorder_data(data)

sites = fieldnames(data);

for i = 1:length(sites)
    
    vars = fieldnames(data.(sites{i}));
    
    for j = 1:length(vars)
        
        dataout.(sites{i}).(vars{j}) = data.(sites{i}).(vars{j});
        
        [dataout.(sites{i}).(vars{j}).Date,ind] = unique(data.(sites{i}).(vars{j}).Date);
        dataout.(sites{i}).(vars{j}).Data = data.(sites{i}).(vars{j}).Data(ind);
        dataout.(sites{i}).(vars{j}).Depth = data.(sites{i}).(vars{j}).Depth(ind);
        
    end
    
end