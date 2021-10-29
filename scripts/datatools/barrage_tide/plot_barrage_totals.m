clear all; close all;

bar2020 = load('../../../data/store/hydro/dew_barrage_2020.mat');
bar2021 = load('../../../data/store/hydro/dew_barrage.mat');


figure

plot(bar2020.barrages.Total.Flow.Date,bar2020.barrages.Total.Flow.Data);hold on;
plot(bar2021.barrages.Total.Flow.Date,bar2021.barrages.Total.Flow.Data);hold on;

xarray = datenum(2017,01:06:60,01);

xlim([xarray(1) xarray(end)]);

ylim([0 400]);
set(gca,'xtick',xarray,'xticklabel',datestr(xarray,'mm-yyyy'));

xlabel('Date');
ylabel('Flow (m^3/s)');
title('Total Barrage Flow');
legend({'1990 - 2020';'1990 - 2021'});