clear all; close all;

addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));


load ../../../../data/store/hydro/dew_barrage.mat;


oldfile = 'X:\HCHB\bc_dbase\calibration\inflow\Barrage_BC_Tauwitchere_20130101_20200701.csv';

newfile = '../append_bc_files/Tauwitchere.csv';

old = tfv_readBCfile(oldfile);
new = tfv_readBCfile(newfile);

stop

plot(old.Date,old.temp);hold on

plot(new.Date,new.TEMP,'r--');

plot(barrages.Tauwitchere.Date,barrages.Tauwitchere.Data,'g--')
legend({'Old';'New';'RAW'});