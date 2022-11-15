clear all; close all;

addpath(genpath('Functions'));

load('../../../../../..\CDM\data\store\metocean\NRM_metdata.mat');

load('../../../../../../CDM\data\store\hydro\dew_WaterDataSA_hourly.mat');



data_file = metdata.RMPW18;

metfile = '../../../../../../CDM\data\store\metocean\Narrung_met_20160201_20221101.csv';
rainfile = '../../../../../../CDM\data\store\metocean\Narrung_rain_20160201_20221101.csv';
imagefile = '../../../../../../CDM\data\store\metocean\Narrung_20160201_20221101.png';


startdate = datenum(2016,02,01);
enddate = datenum(2022,11,01);

TZ = 9.5;

seatemp = calc_seatemp(dew,'A4261039',startdate,enddate);

new_data = convert_data_hourly(data_file,startdate,enddate);

create_TFV_Met_From_AWS(metfile,rainfile,imagefile,new_data,startdate,enddate,TZ,seatemp);