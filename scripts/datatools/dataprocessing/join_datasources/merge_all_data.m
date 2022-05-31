clear all; close all;

restoredefaultpath
addpath(genpath('Functions'));

load ../../../../data/store/hydro/dew_WaterDataSA_hourly.mat;

cllmm = dew;

sites = fieldnames(cllmm);

% for i = 1:length(sites)
%     
%     lowerlakes.(sites{i}) = add_agency(lowerlakes.(sites{i}),'DEW');
% end
load ../../../../data/store/archive/sawater/saw_r.mat;

sites = fieldnames(saw);

for i = 1:length(sites);
    cllmm.(['SAW_',sites{i}]) = saw.(sites{i});
    cllmm.(['SAW_',sites{i}]) = add_agency(cllmm.(['SAW_',sites{i}]),'SA Water');
end

load ../../../../data/store/archive/sawater/saw_2017.mat;

sites = fieldnames(saw_2017);

for i = 1:length(sites);
    cllmm.(['SAW2017_',sites{i}]) = saw_2017.(sites{i});
    cllmm.(['SAW2017_',sites{i}]) = add_agency(cllmm.(['SAW2017_',sites{i}]),'SA Water');
end

load ../../../../data/store/archive/sawater/saw_2018.mat;

sites = fieldnames(saw_2018);

for i = 1:length(sites);
    cllmm.(['SAW2018_',sites{i}]) = saw_2018.(sites{i});
    cllmm.(['SAW2018_',sites{i}]) = add_agency(cllmm.(['SAW2018_',sites{i}]),'SA Water');
end
load ../../../../data/store/archive/sawater/saw_2019.mat;

sites = fieldnames(saw_2019);

for i = 1:length(sites);
    cllmm.(['SAW2019_',sites{i}]) = saw_2019.(sites{i});
    cllmm.(['SAW2019_',sites{i}]) = add_agency(cllmm.(['SAW2019_',sites{i}]),'SA Water');
end

% load ../../../../data/store/archive/sawater/saw_2020.mat;
% 
% sites = fieldnames(saw_2020);
% 
% for i = 1:length(sites)
%     cllmm.(['SAW2020_',sites{i}]) = saw_2020.(sites{i});
%     cllmm.(['SAW2020_',sites{i}]) = add_agency(cllmm.(['SAW2020_',sites{i}]),'SA Water');
% end

load ../../../../data/store/ecology/SAW_WQ.mat;

sites = fieldnames(SAW_WQ);

for i = 1:length(sites)
    cllmm.(['SAW2020_',sites{i}]) = SAW_WQ.(sites{i});
    cllmm.(['SAW2020_',sites{i}]) = add_agency(cllmm.(['SAW2020_',sites{i}]),'SA Water');
end

load ../../../../data/store/ecology/ruppia.mat;

sites = fieldnames(ruppia);

for i = 1:length(sites)
    cllmm.([sites{i}]) = ruppia.(sites{i});
    %cllmm.(['SAW2020_',sites{i}]) = add_agency(cllmm.(['SAW2020_',sites{i}]),'SA Water');
end



load ../../../../data/store/ecology/UA_Coorong_Compiled_WQ.mat;

sites = fieldnames(UA);

for i = 1:length(sites)
    
    if isfield(UA.(sites{i}),'TEMP')
        UA.(sites{i}) = rmfield(UA.(sites{i}),'TEMP');
    end
    cllmm.(sites{i}) = UA.(sites{i});
    %lowerlakes.(sites{i}) = add_agency(lowerlakes.(sites{i}),'UA WQ');
end

load ../../../../data/store/ecology/ALS.mat;

sites = fieldnames(ALS);

for i = 1:length(sites)
    cllmm.(sites{i}) = ALS.(sites{i});
    %lowerlakes.(sites{i}) = add_agency(lowerlakes.(sites{i}),'UA WQ');
end

load ../../../../data/store/ecology/DO_Logger.mat;

sites = fieldnames(DO);

for i = 1:length(sites)
    cllmm.(['UA_DO_',sites{i}]) = DO.(sites{i});
    %lowerlakes.(sites{i}) = add_agency(lowerlakes.(sites{i}),'UA WQ');
end

load ../../../../data/store/ecology/ua_sonde.mat;

sites = fieldnames(ua_sonde);

for i = 1:length(sites)
    cllmm.(['UA_Sonde_',sites{i}]) = ua_sonde.(sites{i});
    %lowerlakes.(sites{i}) = add_agency(lowerlakes.(sites{i}),'UA WQ');
end


load ../../../../data/store/ecology/AWQC.mat;

sites = fieldnames(AWQC);

for i = 1:length(sites)
   if isfield(AWQC.(sites{i}),'TEMP')
        AWQC.(sites{i}) = rmfield(AWQC.(sites{i}),'TEMP');
    end
    cllmm.(sites{i}) = AWQC.(sites{i});
    %lowerlakes.(sites{i}) = add_agency(lowerlakes.(sites{i}),'UA WQ');
end


load ../../../../data/store/hydro/UA_temperature_loggers.mat;

%load ../../../../data/store/hydro/dew_turbidity.mat;



sites = fieldnames(temp);

for i = 1:length(sites)
    cllmm.(sites{i}) = temp.(sites{i});
    %lowerlakes.(sites{i}) = add_agency(lowerlakes.(sites{i}),'UA Logger');
end


%merge_sed_ruppia;





cllmm = check_XY(cllmm);

cllmm = add_offset(cllmm);

%datearray(:,1) = datenum(2008,01:180,01);
datearray(:,1) = [datenum(2008,01,01):01:datenum(2022,01,01)];

%cllmm = cleanse_sites(cllmm);





export_shapefile(cllmm,'../../../../gis/mapping/field/fieldsites.shp');

save ../../../../data/store/archive/cllmm.mat cllmm -mat;

% 
load ../../../../data/store/archive/saepa/epa_2016.mat;

sites = fieldnames(epa_2016);

% for i = 1:length(sites)
%     cllmm.(['EPA_',sites{i}]) = epa_2016.(sites{i});
%     cllmm.(['EPA_',sites{i}]) = add_agency(cllmm.(['EPA_',sites{i}]),'SA EPA');
% end
% 
% load ../../../../data/store/archive/saepa/epa_2014.mat;
% 
% sites = fieldnames(epa_2014);
% 
% for i = 1:length(sites)
%     cllmm.(['EPA2014_',sites{i}]) = epa_2014.(sites{i});
%     cllmm.(['EPA2014_',sites{i}]) = add_agency(cllmm.(['EPA2014_',sites{i}]),'SA EPA');
% end

load ../../../../data/store/archive/saepa/epa.mat;


sites = fieldnames(epa);

for i = 1:length(sites)
    cllmm.(['EPA2014_',sites{i}]) = epa.(sites{i});
    %cllmm.(['EPA2014_',sites{i}]) = add_agency(cllmm.(['EPA2014_',sites{i}]),'SA EPA');
end

cllmm = check_XY(cllmm);

cllmm = add_offset(cllmm);

%datearray(:,1) = datenum(2008,01:180,01);
datearray(:,1) = [datenum(2008,01,01):01:datenum(2022,0,01)];
cllmm = cleanse_sites(cllmm);




cllmm_sec = add_secondary_data(cllmm,datearray);
save ../../../../data/store/archive/cllmm_sec.mat cllmm_sec -mat;


coorong = remove_Lake_Sites(cllmm,'GIS/Coorong_Boundary1.shp');

save('../../../../data/store/archive/coorong.mat','coorong','-mat');

run('../../../../data/store/archive/merge_sites_within_matfile');

% summerise_data('lowerlakes.mat','lowerlakes/');
% 
% plot_data_polygon_regions;
