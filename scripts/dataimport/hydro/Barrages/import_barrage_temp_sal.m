clear all; close all;

load '../../../../data/store/archive/cllmm.mat';

vars = {'TEMP';'SAL'};

for i = 1:length(vars)
    
    bar.Goolwa.(vars{i}).Date = cllmm.A4261123.(vars{i}).Date;
    bar.Goolwa.(vars{i}).Data = cllmm.A4261123.(vars{i}).Data;
    [bar.Goolwa.(vars{i}).Adate,bar.Goolwa.(vars{i}).Adata] = calculate_daily_ave(bar.Goolwa.(vars{i}).Date,bar.Goolwa.(vars{i}).Data);
    
    
    
    bar.Ewe.(vars{i}).Date = cllmm.A4261206.(vars{i}).Date;;
    bar.Ewe.(vars{i}).Data = cllmm.A4261206.(vars{i}).Data;
    [bar.Ewe.(vars{i}).Adate,bar.Ewe.(vars{i}).Adata] = calculate_daily_ave(bar.Ewe.(vars{i}).Date,bar.Ewe.(vars{i}).Data);
    
    bar.Mundoo.(vars{i}).Date = cllmm.A4261204.(vars{i}).Date;;
    bar.Mundoo.(vars{i}).Data = cllmm.A4261204.(vars{i}).Data;
    [bar.Mundoo.(vars{i}).Adate,bar.Mundoo.(vars{i}).Adata] = calculate_daily_ave(bar.Mundoo.(vars{i}).Date,bar.Mundoo.(vars{i}).Data);
    
    bar.Boundary.(vars{i}).Date = cllmm.A4261205.(vars{i}).Date;;
    bar.Boundary.(vars{i}).Data = cllmm.A4261205.(vars{i}).Data;
    [bar.Boundary.(vars{i}).Adate,bar.Boundary.(vars{i}).Adata] = calculate_daily_ave(bar.Boundary.(vars{i}).Date,bar.Boundary.(vars{i}).Data);
    
    bar.Tauwitchere.(vars{i}).Date = cllmm.A4261207.(vars{i}).Date;;
    bar.Tauwitchere.(vars{i}).Data = cllmm.A4261207.(vars{i}).Data;
    [bar.Tauwitchere.(vars{i}).Adate,bar.Tauwitchere.(vars{i}).Adata] = calculate_daily_ave(bar.Tauwitchere.(vars{i}).Date,bar.Tauwitchere.(vars{i}).Data);
    
end

save('../../../../data/store/hydro/dew_barrage_temperature_salinity.mat','bar','-mat');
