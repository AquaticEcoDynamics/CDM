function out_data = convert_data_hourly(data,startdate,enddate)


vars = fieldnames(data);

mdate = data.(vars{1}).Date;

% startdate = min(mdate);
% enddate = max(mdate);


newarray(:,1) = startdate:1/24:enddate;




for i = 1:length(vars)
    out_data.(vars{i}) = data.(vars{i});
    
    
    out_data.(vars{i}).Data = interp1(mdate,data.(vars{i}).Data,newarray);
    out_data.(vars{i}).Date = newarray;
    
end