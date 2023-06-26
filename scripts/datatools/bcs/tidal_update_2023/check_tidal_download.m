clear all; close all;

addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

old = tfv_readBCfile('VH_20120101_20221101_Plim.csv');
bk = tfv_readBCfile('BK_20120101_20230601.csv');
load('../../../../data/store/hydro/dew_tide_VH_2023.mat');


tt = readtable('../../../../data/incoming/DEW/hydrology/compiled/vh1990-2022pred_10Nov2022/vh1990-2022pred_10Nov2022.csv');%,'A2:D500000');

tt.mdate = datenum(tt.dateAndTime);


vh = readtable('Tide_Prediction (2).csv');

vh.mdate = datenum(vh.Var1);

[vh.mdate,ind] = unique(vh.mdate);
vh.H = vh.Var2(ind);


plot(bk.Date,bk.WL);hold on


plot(tt.mdate,tt.vh_pre);hold on

plot(old.Date,old.WL);hold on

plot(vh.mdate,vh.H - 0.58);hold on

plot(tide.VH.H.Date,tide.VH.H.Data- 0.58);



plot(tt.mdate,tt.vh_gre);hold on

plot(tt.mdate + 0.395833333372138,tt.vh_gob - 0.58);hold on


xlim([datenum(2022,01,01) datenum(2023,06,01)]);

ylim([-2 2]);

set(gca,'xtick',datenum(2022,01:03:18,01),'xticklabel',datestr(datenum(2022,01:03:18,01),'mm-yyyy'));

legend({'BK';'VH Download';'PREP from BOM';'Current BC';'VH Residual'});