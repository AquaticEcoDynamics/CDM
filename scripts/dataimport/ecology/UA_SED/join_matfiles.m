clear all; close all;

sed = [];

load('../../../../data/store/ecology/ua_macben.mat');

sed = ua_macben;

%____________________________________________________________________
load('../../../../data/store/ecology/ua_sediment_results.mat');

sites = fieldnames(ua_sediment_results);

for i = 1:length(sites)
    sed.(['sed_res_',sites{i}]) = ua_sediment_results.(sites{i});
end

%____________________________________________________________________
load('../../../../data/store/ecology/ua_grainsize.mat');

sites = fieldnames(ua_grainsize);

for i = 1:length(sites)
    sed.(['grain_res_',sites{i}]) = ua_grainsize.(sites{i});
end

%____________________________________________________________________
load('../../../../data/store/ecology/ua_sediment_quality.mat');

sites = fieldnames(ua_sediment_quality);

for i = 1:length(sites)
    sed.(['sed_qual_',sites{i}]) = ua_sediment_quality.(sites{i});
end

%____________________________________________________________________
load('../../../../data/store/ecology/ua_sediment_field.mat');

sites = fieldnames(ua_sediment_field);

for i = 1:length(sites)
    sed.(['sed_field_',sites{i}]) = ua_sediment_field.(sites{i});
end

%____________________________________________________________________
load('../../../../data/store/ecology/ua_fluxes_feb.mat');

sites = fieldnames(ua_fluxes_feb);

for i = 1:length(sites)
    sed.(['flux_feb_',sites{i}]) = ua_fluxes_feb.(sites{i});
end

%____________________________________________________________________
load('../../../../data/store/ecology/ua_fluxes_nov.mat');

sites = fieldnames(ua_fluxes_nov);

for i = 1:length(sites)
    sed.(['flux_nov_',sites{i}]) = ua_fluxes_nov.(sites{i});
end

save('../../../../data/store/ecology/sed.mat','sed','-mat');

%____________________________________________________________________
load('../../../../data/store/ecology/union.mat');

sites = fieldnames(union);

for i = 1:length(sites)
    sed.(['union_',sites{i}]) = union.(sites{i});
end

save('../../../../data/store/ecology/sed.mat','sed','-mat');


%____________________________________________________________________
load('../../../../data/store/ecology/TLM.mat');

sites = fieldnames(TLM);

for i = 1:length(sites)
    sed.(['TLM_',sites{i}]) = TLM.(sites{i});
end

save('../../../../data/store/ecology/sed.mat','sed','-mat');


%____________________________________________________________________
load('../../../../data/store/ecology/porewater.mat');

sites = fieldnames(porewater);

for i = 1:length(sites)
    sed.(['porewater_',sites{i}]) = porewater.(sites{i});
end

save('../../../../data/store/ecology/sed.mat','sed','-mat');
