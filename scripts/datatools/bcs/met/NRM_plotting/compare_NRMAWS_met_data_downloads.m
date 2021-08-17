clear all; close all;

addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

newfile = '../../../../data/store/NRMAWS/Narrung_met.csv';

old_rad_file = '../../../../models/MER/MER_Coorong_eWater_2020_v1/BC/Met/rad_2012_2020.csv';

old_met_file = '../../../../models/MER/MER_Coorong_eWater_2020_v1/BC/Met/met_2012_2020.csv';


new = tfv_readBCfile(newfile);

oldrad = tfv_readBCfile(old_rad_file);

oldmet = tfv_readBCfile(old_met_file);

%%__________________________________________
figure

plot(oldrad.Date,oldrad.LW_Net);hold on
plot(new.Date,new.LW_Net);hold on

