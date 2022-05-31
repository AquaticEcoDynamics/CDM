addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

tide = tfv_readBCfile('BK_20120101_20210701_v7_BK_SAL.csv');

load ../../../../data/store/hydro/dew_WaterDataSA_hourly.mat;

thesite = 'A4261039';

thetimearray = datenum(2017,01,01):1/24:datenum(2021,01,01);

raw.Date = thetimearray;
raw.Data = interp1(dew.(thesite).H.Date,dew.(thesite).H.Data,thetimearray);

new.Date = thetimearray;
new.Data = interp1(tide.Date,tide.VH_TIDE_MAHD,thetimearray);

plot(new.Date,new.Data);hold on
plot(raw.Date,raw.Data,'--');hold on
