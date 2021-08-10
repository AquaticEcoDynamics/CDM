clear all; close all;

addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

oldfile = '../append_bc_files/VH_Tide_2012_2021.csv';

newfile = '../append_bc_files/VH_Tide_2012_2021_v2.csv';

old = tfv_readBCfile(oldfile);

new = tfv_readBCfile(newfile);


%load ../append_bc_files/dew_tide_VH_uncorrected.mat;

plot(old.Date,old.VH_Tide_mAHD);hold on
plot(new.Date,new.VH_Tide_mAHD,'r--');
%plot(tide.Date,tide.Data,'g--');