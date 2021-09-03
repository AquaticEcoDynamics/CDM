function out = grab_ALS_Data(filename)

%filename = 'C:\Users\00065525\Github\CDM\data\incoming\DEW\wq\WQ_HCHB_Phase1\ALS Results\2021 Results\April\7_4_2021/EM2106129_0_ENMRG.CSV';

int = 1;

fid = fopen(filename,'rt');
out.dates = [];
out.sites = [];
while ~feof(fid)
    data = [];
    
    fline = fgetl(fid);
    if fline ~= -1
        str = split(fline,',');
        
        %length(str);
        
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
                thedata = str(6:end);                

                if length(thedata) < 30
                
                out.Algal_Count.data = str2double(thedata);
                out.Algal_Count.Var = str{1};
                out.Algal_Count.Units = str{3};end
                
            case 'Total Dissolved Solids @180°C'
                thedata = str(6:end);if length(thedata) < 30
                %str2double(thedata)
                out.Total_Dissolved_Solids.data = str2double(thedata);
                out.Total_Dissolved_Solids.Var = str{1};
                out.Total_Dissolved_Solids.Units = str{3};end
            case 'Turbidity'
                thedata = str(6:end);if length(thedata) < 30
                out.Turbidity.data = str2double(thedata);
                out.Turbidity.Var = str{1};
                out.Turbidity.Units = str{3};end
            case 'Hydroxide Alkalinity'
                thedata = str(6:end);if length(thedata) < 30
                
                out.Hydroxide_Alkalinity.data = str2double(thedata);
                out.Hydroxide_Alkalinity.Var = str{1};
                out.Hydroxide_Alkalinity.Units = str{3};end
                
            case 'Carbonate Alkalinity'
                thedata = str(6:end);if length(thedata) < 30
                
                out.Carbonate_Alkalinity.data = str2double(thedata);
                out.Carbonate_Alkalinity.Var = str{1};
                out.Carbonate_Alkalinity.Units = str{3};end
                
            case 'Bicarbonate Alkalinity'
                thedata = str(6:end);if length(thedata) < 30
                
                out.Bicarbonate_Alkalinity.data = str2double(thedata);
                out.Bicarbonate_Alkalinity.Var = str{1};
                out.Bicarbonate_Alkalinity.Units = str{3};end
            case 'Total Alkalinity'
                thedata = str(6:end);if length(thedata) < 30
                
                out.Total_Alkalinity.data = str2double(thedata);
                out.Total_Alkalinity.Var = str{1};
                out.Total_Alkalinity.Units = str{3};end
            case 'Chloride'
                thedata = str(6:end);if length(thedata) < 30
                
                out.Chloride.data = str2double(thedata);
                out.Chloride.Var = str{1};
                out.Chloride.Units = str{3};end
            case 'Reactive Silica'
                thedata = str(6:end);if length(thedata) < 30
                
                out.Reactive_Silica.data = str2double(thedata);
                out.Reactive_Silica.Var = str{1};
                out.Reactive_Silica.Units = str{3};end
            case 'Ammonia as N'
                thedata = str(6:end);if length(thedata) < 30
                
                out.Ammonia_as_N.data = str2double(thedata);
                out.Ammonia_as_N.Var = str{1};
                out.Ammonia_as_N.Units = str{3};end
            case 'Nitrite as N'
                thedata = str(6:end);if length(thedata) < 30
                
                out.Nitrite_as_N.data = str2double(thedata);
                out.Nitrite_as_N.Var = str{1};
                out.Nitrite_as_N.Units = str{3};end
            case 'Nitrate as N'
                thedata = str(6:end);if length(thedata) < 30
                
                out.Nitrate_as_N.data = str2double(thedata);
                out.Nitrate_as_N.Var = str{1};
                out.Nitrate_as_N.Units = str{3};end
            case 'Nitrite + Nitrate as N'
                thedata = str(6:end);if length(thedata) < 30
                
                out.Nitrite_n_Nitrate_as_N.data = str2double(thedata);
                out.Nitrite_n_Nitrate_as_N.Var = str{1};
                out.Nitrite_n_Nitrate_as_N.Units = str{3};end
            case 'Total Kjeldahl Nitrogen'
                thedata = str(6:end);if length(thedata) < 30
                
                out.Total_Kjeldahl_Nitrogen.data = str2double(thedata);
                out.Total_Kjeldahl_Nitrogen.Var = str{1};
                out.Total_Kjeldahl_Nitrogen.Units = str{3};end
            case 'Total Nitrogen as N'
                thedata = str(6:end);if length(thedata) < 30
                
                out.Total_Nitrogen_as_N.data = str2double(thedata);
                out.Total_Nitrogen_as_N.Var = str{1};
                out.Total_Nitrogen_as_N.Units = str{3};end
            case 'Total Phosphorus as P'
                thedata = str(6:end);if length(thedata) < 30
                
                out.Total_Phosphorus_as_P.data = str2double(thedata);
                out.Total_Phosphorus_as_P.Var = str{1};
                out.Total_Phosphorus_as_P.Units = str{3};end
            case 'Reactive Phosphorus as P'
                thedata = str(6:end);if length(thedata) < 30
                
                out.Reactive_Phosphorus_as_P.data = str2double(thedata);
                out.Reactive_Phosphorus_as_P.Var = str{1};
                out.Reactive_Phosphorus_as_P.Units = str{3};end
            case 'Dissolved Organic Carbon'
                thedata = str(6:end);if length(thedata) < 30
                
                out.Dissolved_Organic_Carbon.data = str2double(thedata);
                out.Dissolved_Organic_Carbon.Var = str{1};
                out.Dissolved_Organic_Carbon.Units = str{3};end
            case 'Total Organic Carbon'
                thedata = str(6:end);if length(thedata) < 30
                
                out.Total_Organic_Carbon.data = str2double(thedata);
                out.Total_Organic_Carbon.Var = str{1};
                out.Total_Organic_Carbon.Units = str{3};end
                
            case 'Chlorophyll a'
                thedata = str(6:end);if length(thedata) < 30
                
                out.Chlorophyll_a.data = str2double(thedata);
                out.Chlorophyll_a.Var = str{1};
                out.Chlorophyll_a.Units = str{3};end
            case 'Chlorophyll b'
                thedata = str(6:end);if length(thedata) < 30
                
                out.Chlorophyll_b.data = str2double(thedata);
                out.Chlorophyll_b.Var = str{1};
                out.Chlorophyll_b.Units = str{3};end
            case 'Pheophytin a'
                thedata = str(6:end);if length(thedata) < 30
                
                out.Pheophytin_a.data = str2double(thedata);
                out.Pheophytin_a.Var = str{1};
                out.Pheophytin_a.Units = str{3};end
            otherwise
                
        end
        
        
        %    disp([num2str(length(dates)) ,';', num2str(length(data))]);
        
        
        
    end
    int = int + 1;
end