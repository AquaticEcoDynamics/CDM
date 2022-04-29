% load ../../../../data/store/archive/sawater/saw_2017.mat;
% 
% sites = fieldnames(saw_2017);
% 
% for i = 1:length(sites);
%     cllmm.(['SAW2017_',sites{i}]) = saw_2017.(sites{i});
%     cllmm.(['SAW2017_',sites{i}]) = add_agency(cllmm.(['SAW2017_',sites{i}]),'SA Water');
% end
% 
% clear all; close all;
% 
% sed = [];

load('../../../../data/store/ecology/ua_macben.mat');

sed = ua_macben;

%____________________________________________________________________
load('../../../../data/store/ecology/ua_sediment_results.mat');

sites = fieldnames(ua_sediment_results);

for i = 1:length(sites)
    cllmm.(['sed_res_',sites{i}]) = ua_sediment_results.(sites{i});
end

%____________________________________________________________________
load('../../../../data/store/ecology/ua_grainsize.mat');

sites = fieldnames(ua_grainsize);

for i = 1:length(sites)
    cllmm.(['grain_res_',sites{i}]) = ua_grainsize.(sites{i});
end

%____________________________________________________________________
load('../../../../data/store/ecology/ua_sediment_quality.mat');

sites = fieldnames(ua_sediment_quality);

for i = 1:length(sites)
    cllmm.(['sed_qual_',sites{i}]) = ua_sediment_quality.(sites{i});
end

%____________________________________________________________________
load('../../../../data/store/ecology/ua_sediment_field.mat');

sites = fieldnames(ua_sediment_field);

for i = 1:length(sites)
    cllmm.(['sed_field_',sites{i}]) = ua_sediment_field.(sites{i});
end

%____________________________________________________________________
load('../../../../data/store/ecology/ua_fluxes_feb.mat');

sites = fieldnames(ua_fluxes_feb);

for i = 1:length(sites)
    cllmm.(['flux_feb_',sites{i}]) = ua_fluxes_feb.(sites{i});
end

%____________________________________________________________________
load('../../../../data/store/ecology/ua_fluxes_nov.mat');

sites = fieldnames(ua_fluxes_nov);

for i = 1:length(sites)
    cllmm.(['flux_nov_',sites{i}]) = ua_fluxes_nov.(sites{i});
end


%____________________________________________________________________
load('../../../../data/store/ecology/union.mat');

sites = fieldnames(union);

for i = 1:length(sites)
    cllmm.(['union_',sites{i}]) = union.(sites{i});
end



%____________________________________________________________________
load('../../../../data/store/ecology/TLM.mat');

sites = fieldnames(TLM);

for i = 1:length(sites)
    cllmm.(['TLM_',sites{i}]) = TLM.(sites{i});
end



%____________________________________________________________________
load('../../../../data/store/ecology/porewater.mat');

sites = fieldnames(porewater);

for i = 1:length(sites)
    cllmm.(['porewater_',sites{i}]) = porewater.(sites{i});
end
%____________________________________________________________________
load('../../../../data/store/ecology/phenology.mat');
sites = fieldnames(phenology);

for i = 1:length(sites)
    cllmm.(['phenology_',sites{i}]) = phenology.(sites{i});
end
%____________________________________________________________________

load('../../../../data/store/ecology/baseline_ruppia_all.mat');
sites = fieldnames(baseline_ruppia_all);

for i = 1:length(sites)
    cllmm.(['ruppia_',sites{i}]) = baseline_ruppia_all.(sites{i});
end
