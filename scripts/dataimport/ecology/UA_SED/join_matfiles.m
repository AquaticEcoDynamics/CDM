clear all; close all;

import_01_Macrobenthic_and_sediment_data_Orlando_Sabine;
import_02_1_Component_4_sediment_results_with_GPS;
import_02_Component_4_grain_size_results_with_GPS;
import_03_Coorong_Sediment_Quality_survey_Mar20_Lab_Results;
import_04_Coorong_March_2020_final_FIeld_Results_and_Photos;
import_05_Fluxes_February_2021;
import_06_Oxygen_and_nutrient_fluxes_Nov_2020;
import_07_UNI012_SS_K5799_Sediment_Results_Feb_Mar_2021;
import_08_TLM_water_quality_data_and_chl;
import_09a_ammonium_and_phosphate_data_November_2020;
import_09b_Fe_data_Coorong_February_2021;
import_09c_Fe_data_November_2020;
import_09d_S_data_Coorong_February_2021;
import_09e_S_data_November_2020;


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
