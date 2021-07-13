clear all; close all;

addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

aws = tfv_readBCfile('../../../../data/store/metocean/Narrung_met.csv');

old = tfv_readBCfile('../../../../models/MER/MER_Coorong_eWater_2020_v1/BC/Met/wind_2012_2020.csv');

data = tfv_readnetcdf('BARRA_Coorong_wind_200601_201903_5km.nc');

data.hours = double(data.time) ./24;


data.Date = datenum(2006,01,01,10,00,00) + data.hours;

data.Wx = squeeze(data.av_uwnd10m(20,20,:));
data.Wy = squeeze(data.av_vwnd10m(20,20,:));



aws.WS = sqrt(power(aws.Wx,2) + power(aws.Wy,2));
aws.WD = (180 / pi) * atan2(aws.Wy,aws.Wx);

old.WS = sqrt(power(old.Wx,2) + power(old.Wy,2));
old.WD = (180 / pi) * atan2(old.Wy,old.Wx);

data.WS = sqrt(power(data.Wx,2) + power(data.Wy,2));
data.WD = (180 / pi) * atan2(data.Wy,data.Wx);


figure

plot(aws.Date,aws.WS);hold on
plot(old.Date,old.WS);hold on
plot(data.Date,data.WS);hold on


legend({'New AWS','Old AWS','BARRA'},'location','eastoutside');