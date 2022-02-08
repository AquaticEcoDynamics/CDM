clear all; close all;
load dew_barrage_2020.mat;

s2020 = barrages; clear barrages;


load dew_barrage_2021_v2.mat;

sss = find(barrages.Total.Flow.Date >= datenum(2019,01,01) & barrages.Total.Flow.Date <= datenum(2020,01,01));


load cewo.mat;

ttt = find(cewo.obs.Total.Flow.Date >= datenum(2019,01,01) & cewo.obs.Total.Flow.Date <= datenum(2020,01,01));


vvv = find(s2020.Total.Flow.Date >= datenum(2019,01,01) & ...
    s2020.Total.Flow.Date <= datenum(2020,01,01));

sum(barrages.Total.Flow.Data(sss) * 86400)

sum(cewo.obs.Total.Flow.Data(ttt) * 86400)

sum(s2020.Total.Flow.Data(vvv) * 86400)