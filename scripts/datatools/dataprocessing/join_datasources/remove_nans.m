function data =  remove_nans(data)

sites = fieldnames(data);

for i = 1:length(sites)
    vars = fieldnames(data.(sites{i}));
    
    for j = 1:length(vars)
        
        sss = find(~isnan(data.(sites{i}).(vars{j}).Data) == 1);
        
        if ~isempty(sss)
            disp([sites{i},' ',vars{j}]);
            data.(sites{i}).(vars{j}).Data = data.(sites{i}).(vars{j}).Data(sss);
            data.(sites{i}).(vars{j}).Date = data.(sites{i}).(vars{j}).Date(sss);
            data.(sites{i}).(vars{j}).Depth = data.(sites{i}).(vars{j}).Depth(sss);
        end
        
    end
end