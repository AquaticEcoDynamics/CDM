clear all; close all;

addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

oldfile = 'Offshore_BC_20150630_20200701.csv';

%newfile = 'BK_Tide_2012_2021.csv';

old = tfv_readBCfile(oldfile);

%new = tfv_readBCfile(newfile);


load ../../../../data/store/hydro/dew_tide_VH_uncorrected.mat;

plot(old.Date,old.VH_Tide_mAHD);hold on
%plot(new.Date,new.VH_Tide_mAHD,'r--');
plot(tide.Date,tide.Data,'g--');