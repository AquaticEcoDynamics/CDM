clear all; close all;

STP = load('../../../../data/store/hydro/dew_WaterDataSA_hourly_STP.mat');
Conv = load('../../../../data/store/hydro/dew_WaterDataSA_hourly.mat');


plot(STP.dew.A4261039.SAL.Date,STP.dew.A4261039.SAL.Data);hold on
plot(Conv.dew.A4261039.SAL.Date,Conv.dew.A4261039.SAL.Data);hold on

datearray = datenum(2019,01:03:26,01);

set(gca,'xtick',datearray,'xticklabel',datestr(datearray,'mm-yyyy'));

xlim([datearray(1) datearray(end)]);

legend({'STP';'Temp Corrected'});

title('A4261039');
figure

plot(STP.dew.A4261165.SAL.Date,STP.dew.A4261165.SAL.Data);hold on
plot(Conv.dew.A4261165.SAL.Date,Conv.dew.A4261165.SAL.Data);hold on

datearray = datenum(2019,01:03:26,01);

set(gca,'xtick',datearray,'xticklabel',datestr(datearray,'mm-yyyy'));

xlim([datearray(1) datearray(end)]);

legend({'STP';'Temp Corrected'});
title('A4261165');
