clear all; close all;

filename = 'C:\Users\00065525\Github\CDM\data\incoming\DEW\wq\WQ_HCHB_Phase1\ALS Results\2020 Results\August\4_8_2020\EM2013637_0_ENMRG.CSV';

int = 1;

fid = fopen(filename,'rt');
dates = [];
sites = [];
while ~feof(fid)
    data = [];
    
    fline = fgetl(fid); 
    if fline ~= -1
    str = split(fline,',');
    if int == 3
        % Sites;
        dates = str(6:end);
    end
    if int == 4
        % Sites;
        sites = str(6:end);
    end
    
    switch str{1}
        case 'Algal Count'
            
            data = str(6:end);
            
        case 'Turbidity'
            
            data = str(6:end);
        case 'Hydroxide Alkalinity'
            data = str(6:end);
            
            
        case 'Carbonate Alkalinity'
            data = str(6:end);
            
            
        case 'Bicarbonate Alkalinity'
            data = str(6:end);
            
        case 'Total Alkalinity'
            data = str(6:end);
            
        case 'Chloride'
            data = str(6:end);
            
        case 'Reactive Silica'
             data = str(6:end);   
                
        case 'Ammonia as N'
            data = str(6:end);
            
        case 'Nitrite as N'
            data = str(6:end);
            
        case 'Nitrate as N'
            data = str(6:end);
            
        case 'Nitrite + Nitrate as N'
            data = str(6:end);
            
        case 'Total Kjeldahl Nitrogen'
            data = str(6:end);
            
        case 'Total Nitrogen as N'
            data = str(6:end);
            
        case 'Total Phosphorus as P'
            data = str(6:end);
        case 'Reactive Phosphorus as P'
            data = str(6:end);
        case 'Dissolved Organic Carbon'
            data = str(6:end);
        case 'Total Organic Carbon'
            data = str(6:end);
            
        case 'Chlorophyll a'
            data = str(6:end);
            
        case 'Chlorophyll b'
            data = str(6:end);
            
        case 'Pheophytin a'
            data = str(6:end);
            
        otherwise
            
    end
            
      
    disp([num2str(length(dates)) ,';', num2str(length(data))]);
    
    
    
    end
    int = int + 1;
end