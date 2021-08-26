function out = grab_ALS_Data(filename)

filename = 'C:\Users\00065525\Github\CDM\data\incoming\DEW\wq\WQ_HCHB_Phase1\ALS Results\2020 Results\August\4_8_2020\EM2013637_0_ENMRG.CSV';

int = 1;

fid = fopen(filename,'rt');
out.dates = [];
out.sites = [];
while ~feof(fid)
    data = [];
    
    fline = fgetl(fid); 
    if fline ~= -1
    str = split(fline,',');
    if int == 3
        % Sites;
        out.dates = datenum(str(6:end),'dd/mm/yyyy');
    end
    if int == 4
        % Sites;
        out.sites = str(6:end);
    end
    
    switch str{1}
%         case 'Project name/number:'
%             
%             out.date = datenum(str(6:end),'dd/mm/yyyy');
        
        
        case 'Algal Count'

            out.Algal_Count.data = str2double(str(6:end));
            out.Algal_Count.Var = str{1};
            out.Algal_Count.Units = str{3};
            
        case 'Total Dissolved Solids @180°C'
            
            out.Total_Dissolved_Solids.data = str2double(str(6:end));   
            out.Total_Dissolved_Solids.Var = str{1};
            out.Total_Dissolved_Solids.Units = str{3};
        case 'Turbidity'
            
            out.Turbidity.data = str2double(str(6:end));
            out.Turbidity.Var = str{1};
            out.Turbidity.Units = str{3};
        case 'Hydroxide Alkalinity'
            out.Hydroxide_Alkalinity.data = str2double(str(6:end));
            out.Hydroxide_Alkalinity.Var = str{1};
            out.Hydroxide_Alkalinity.Units = str{3};
            
        case 'Carbonate Alkalinity'
            out.Carbonate_Alkalinity.data = str2double(str(6:end));
            out.Carbonate_Alkalinity.Var = str{1};
            out.Carbonate_Alkalinity.Units = str{3};
            
        case 'Bicarbonate Alkalinity'
            out.Bicarbonate_Alkalinity.data = str2double(str(6:end));
            out.Bicarbonate_Alkalinity.Var = str{1};
            out.Bicarbonate_Alkalinity.Units = str{3};
        case 'Total Alkalinity'
            out.Total_Alkalinity.data = str2double(str(6:end));
            out.Total_Alkalinity.Var = str{1};
            out.Total_Alkalinity.Units = str{3};
        case 'Chloride'
            out.Chloride.data = str2double(str(6:end));
            out.Chloride.Var = str{1};
            out.Chloride.Units = str{3};
        case 'Reactive Silica'
             out.Reactive_Silica.data = str2double(str(6:end));   
             out.Reactive_Silica.Var = str{1}; 
             out.Reactive_Silica.Units = str{3};
        case 'Ammonia as N'
            out.Ammonia_as_N.data = str2double(str(6:end));
            out.Ammonia_as_N.Var = str{1};
            out.Ammonia_as_N.Units = str{3};
        case 'Nitrite as N'
            out.Nitrite_as_N.data = str2double(str(6:end));
            out.Nitrite_as_N.Var = str{1};
            out.Nitrite_as_N.Units = str{3};
        case 'Nitrate as N'
            out.Nitrate_as_N.data = str2double(str(6:end));
            out.Nitrate_as_N.Var = str{1};
            out.Nitrate_as_N.Units = str{3};
        case 'Nitrite + Nitrate as N'
            out.Nitrite_n_Nitrate_as_N.data = str2double(str(6:end));
            out.Nitrite_n_Nitrate_as_N.Var = str{1};
            out.Nitrite_n_Nitrate_as_N.Units = str{3};
        case 'Total Kjeldahl Nitrogen'
            out.Total_Kjeldahl_Nitrogen.data = str2double(str(6:end));
            out.Total_Kjeldahl_Nitrogen.Var = str{1};
            out.Total_Kjeldahl_Nitrogen.Units = str{3};
        case 'Total Nitrogen as N'
            out.Total_Nitrogen_as_N.data = str2double(str(6:end));
            out.Total_Nitrogen_as_N.Var = str{1};
            out.Total_Nitrogen_as_N.Units = str{3};
        case 'Total Phosphorus as P'
            out.Total_Phosphorus_as_P.data = str2double(str(6:end));
            out.Total_Phosphorus_as_P.Var = str{1};
            out.Total_Phosphorus_as_P.Units = str{3};
        case 'Reactive Phosphorus as P'
            out.Reactive_Phosphorus_as_P.data = str2double(str(6:end));
            out.Reactive_Phosphorus_as_P.Var = str{1};
            out.Reactive_Phosphorus_as_P.Units = str{3};
        case 'Dissolved Organic Carbon'
            out.Dissolved_Organic_Carbon.data = str2double(str(6:end));
            out.Dissolved_Organic_Carbon.Var = str{1};
            out.Dissolved_Organic_Carbon.Units = str{3};
        case 'Total Organic Carbon'
            out.Total_Organic_Carbon.data = str2double(str(6:end));
            out.Total_Organic_Carbon.Var = str{1};
            out.Total_Organic_Carbon.Units = str{3};
            
        case 'Chlorophyll a'
            out.Chlorophyll_a.data = str2double(str(6:end));
            out.Chlorophyll_a.Var = str{1};
            out.Chlorophyll_a.Units = str{3};
        case 'Chlorophyll b'
            out.Chlorophyll_b.data = str2double(str(6:end));
            out.Chlorophyll_b.Var = str{1};
            out.Chlorophyll_b.Units = str{3};
        case 'Pheophytin a'
            out.Pheophytin_a.data = str2double(str(6:end));
            out.Pheophytin_a.Var = str{1};
            out.Pheophytin_a.Units = str{3};
        otherwise
            
    end
            
      
%    disp([num2str(length(dates)) ,';', num2str(length(data))]);
    
    
    
    end
    int = int + 1;
end