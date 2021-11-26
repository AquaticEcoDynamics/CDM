clear all; close all;

addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

oldfile = 'Tide2/VH_20190101_20210701_v2.csv';

newfile = 'Tide2/VH_20120101_20210701_v5.csv';

newfile2 = 'Tide2/VH_20120101_20210701_v6.csv';

%VH = load('../../../../data/store/hydro/dew_tide_VH.mat');


old = tfv_readBCfile(oldfile);

new = tfv_readBCfile(newfile);
new2 = tfv_readBCfile(newfile2);
figure;

%load ../append_bc_files/dew_tide_VH_uncorrected.mat;
plot(new.Date,new.VH_Tide_mAHD,'r');hold on

plot(old.Date,old.VH_Tide_mAHD,'b');hold on
plot(new2.Date,new2.VH_Tide_mAHD,'g--');

%plot(VH.tide.VH.H.Date,VH.tide.VH.H.Data,'g--');hold on;

%plot(tide.Date,tide.Data,'g--');

legend({'v5';'v2';'v6'});


xarray = datenum(2017,01:06:60,01);


xlim([xarray(1) xarray(end)]);

ylabel('Tide (mAHD)');
xlabel('Date');

grid on

set(gca,'xtick',xarray,'xticklabel',datestr(xarray,'yyyy'));