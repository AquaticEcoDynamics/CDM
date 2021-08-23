clear all; close all;

restoredefaultpath
addpath(genpath('Functions'));

load ../../../../data/store/hydro/dew_WaterDataSA_hourly.mat;

lowerlakes = dew;

sites = fieldnames(lowerlakes);

% for i = 1:length(sites)
%     
%     lowerlakes.(sites{i}) = add_agency(lowerlakes.(sites{i}),'DEW');
% end
load ../../../../data/store/archive/sawater/saw_r.mat;

sites = fieldnames(saw);

for i = 1:length(sites);
    lowerlakes.(['SAW_',sites{i}]) = saw.(sites{i});
    lowerlakes.(['SAW_',sites{i}]) = add_agency(lowerlakes.(['SAW_',sites{i}]),'SA Water');
end

load ../../../../data/store/archive/sawater/saw_2017.mat;

sites = fieldnames(saw_2017);

for i = 1:length(sites);
    lowerlakes.(['SAW2017_',sites{i}]) = saw_2017.(sites{i});
    lowerlakes.(['SAW2017_',sites{i}]) = add_agency(lowerlakes.(['SAW2017_',sites{i}]),'SA Water');
end

load ../../../../data/store/archive/sawater/saw_2018.mat;

sites = fieldnames(saw_2018);

for i = 1:length(sites);
    lowerlakes.(['SAW2018_',sites{i}]) = saw_2018.(sites{i});
    lowerlakes.(['SAW2018_',sites{i}]) = add_agency(lowerlakes.(['SAW2018_',sites{i}]),'SA Water');
end
load ../../../../data/store/archive/sawater/saw_2019.mat;

sites = fieldnames(saw_2019);

for i = 1:length(sites);
    lowerlakes.(['SAW2019_',sites{i}]) = saw_2019.(sites{i});
    lowerlakes.(['SAW2019_',sites{i}]) = add_agency(lowerlakes.(['SAW2019_',sites{i}]),'SA Water');
end

load ../../../../data/store/archive/sawater/saw_2020.mat;

sites = fieldnames(saw_2020);

for i = 1:length(sites)
    lowerlakes.(['SAW2020_',sites{i}]) = saw_2020.(sites{i});
    lowerlakes.(['SAW2020_',sites{i}]) = add_agency(lowerlakes.(['SAW2020_',sites{i}]),'SA Water');
end


load ../../../../data/store/ecology/UA_Coorong_Compiled_WQ.mat;

sites = fieldnames(UA);

for i = 1:length(sites)
    lowerlakes.(sites{i}) = UA.(sites{i});
    %lowerlakes.(sites{i}) = add_agency(lowerlakes.(sites{i}),'UA WQ');
end


load ../../../../data/store/hydro/UA_temperature_loggers.mat;

%load ../../../../data/store/hydro/dew_turbidity.mat;



sites = fieldnames(temp);

for i = 1:length(sites)
    lowerlakes.(sites{i}) = temp.(sites{i});
    %lowerlakes.(sites{i}) = add_agency(lowerlakes.(sites{i}),'UA Logger');
end



% sites = fieldnames(turb);
% 
% 
% for i = 1:length(sites)
%     
%     
%     
%     if isfield(lowerlakes,sites{i})
%         
%         lowerlakes.(sites{i}) = add_agency(lowerlakes.(sites{i}),'DEW');
%         
%         lowerlakes.(sites{i}).WQ_DIAG_TOT_TURBIDITY = turb.(sites{i}).WQ_DIAG_TOT_TURBIDITY;
%         
%         vars = fieldnames(lowerlakes.(sites{i}));
%         lowerlakes.(sites{i}).WQ_DIAG_TOT_TURBIDITY.X = lowerlakes.(sites{i}).(vars{1}).X;
%         lowerlakes.(sites{i}).WQ_DIAG_TOT_TURBIDITY.Y = lowerlakes.(sites{i}).(vars{1}).Y;
%         lowerlakes.(sites{i}).WQ_DIAG_TOT_TURBIDITY.Agency = 'DEW Sonde';
%     else
%         stop;
%     end
%     
%     
% end


load ../../../../data/store/archive/saepa/epa_2016.mat;

sites = fieldnames(epa_2016);

for i = 1:length(sites)
    lowerlakes.(['EPA_',sites{i}]) = epa_2016.(sites{i});
    lowerlakes.(['EPA_',sites{i}]) = add_agency(lowerlakes.(['EPA_',sites{i}]),'SA EPA');
end

load ../../../../data/store/archive/saepa/epa_2014.mat;

sites = fieldnames(epa_2014);

for i = 1:length(sites)
    lowerlakes.(['EPA2014_',sites{i}]) = epa_2014.(sites{i});
    lowerlakes.(['EPA2014_',sites{i}]) = add_agency(lowerlakes.(['EPA2014_',sites{i}]),'SA EPA');
end







lowerlakes = check_XY(lowerlakes);

lowerlakes = add_offset(lowerlakes);

datearray(:,1) = datenum(2008,01:132,01);

lowerlakes = cleanse_sites(lowerlakes);


lowerlakes = add_secondary_data(lowerlakes,datearray);


export_shapefile(lowerlakes,'../../../../gis/mapping/field/fieldsites.shp');

save ../../../../data/store/archive/lowerlakes.mat lowerlakes -mat;





coorong = remove_Lake_Sites(lowerlakes,'GIS/Coorong_Boundary1.shp');

save('../../../../data/store/archive/coorong.mat','coorong','-mat');


% summerise_data('lowerlakes.mat','lowerlakes/');
% 
% plot_data_polygon_regions;
