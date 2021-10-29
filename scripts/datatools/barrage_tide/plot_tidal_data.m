clear all; close all;

VH = load('../../../data/store/hydro/dew_tide_VH.mat');
BK = load('../../../data/store/hydro/dew_tide_BK.mat');
VHuC = load('../../../data/store/hydro/dew_tide_VH_uncorrected.mat');

figure
plot(VHuC.tide.Date,VHuC.tide.Data);hold on;
plot(BK.tide.Date,BK.tide.Data);hold on;
plot(VH.tide.VH.H.Date,VH.tide.VH.H.Data);hold on;

xarray = datenum(2017,01:06:60,01);

xlim([xarray(1) xarray(end)]);

%ylim([0 400]);
set(gca,'xtick',xarray,'xticklabel',datestr(xarray,'mm-yyyy'));

xlabel('Date');
ylabel('H (mAHD)');
title('Tidal Height');
legend({'VH uC';'BK';'VH'});