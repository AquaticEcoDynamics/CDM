clear all; close all;

addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));


load ../../../../data/store/hydro/dew_barrage.mat;


oldfile = 'C:\Users\00065525\Github\CDM\models\HCHB\hchb_tfvaed_2019_2021_v1\bc_dbase\calibration\tide\Offshore_BC_20150630_20200701.csv';

newfile = 'C:\Users\00065525\Github\CDM\scripts\datatools\bcs\append_bc_files/VH_Tide_2012_2021.csv';



old = tfv_readBCfile(oldfile);
new = tfv_readBCfile(newfile);

stop

plot(old.Date,old.temp);hold on

plot(new.Date,new.temp,'r--');

% plot(barrages.Tauwitchere.Date,barrages.Tauwitchere.Data,'g--')
% legend({'Old';'New';'RAW'});