function outdata = reformat_metdata(metdata)


sites = fieldnames(metdata);

outdata = [];

for i = 1:length(sites)
    
    vars = fieldnames(metdata.(sites{i}));
    
    for j = 1:length(vars)
        
        switch vars{j}
            
            case 'Date'
                
            case 'X'
                
                
            case 'Y'
                
                
            case 'Lat'
                
                
            case 'Lon'
                
            otherwise
                outdata.(sites{i}).(vars{j}).Date = metdata.(sites{i}).Date;
                outdata.(sites{i}).(vars{j}).Data = metdata.(sites{i}).(vars{j});
                outdata.(sites{i}).(vars{j}).X = metdata.(sites{i}).X;
                outdata.(sites{i}).(vars{j}).Y = metdata.(sites{i}).Y;
                outdata.(sites{i}).(vars{j}).Lon = metdata.(sites{i}).Lon;
                outdata.(sites{i}).(vars{j}).Lat = metdata.(sites{i}).Lat;
                outdata.(sites{i}).(vars{j}).Agency = 'NRM';
        end
    end
end