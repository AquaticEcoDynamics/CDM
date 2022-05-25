clear all; close all;

import_ruppia_data_full;

import_ruppia_100sites_data_full_Updated

ruppia = [];

load('../../../../data/store/ecology/baseline_ruppia_all.mat');

ruppia = baseline_ruppia_all;

%____________________________________________________________________
load('../../../../data/store/ecology/phenology.mat');

sites = fieldnames(phenology);

for i = 1:length(sites)
    ruppia.(['phenology_',sites{i}]) = phenology.(sites{i});
end


save('../../../../data/store/ecology/ruppia.mat','ruppia','-mat');
