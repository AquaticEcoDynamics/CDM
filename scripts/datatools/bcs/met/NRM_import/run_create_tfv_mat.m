clear all; close all;

addpath(genpath('Functions'));

load('C:\Users\00065525\GITHUB\CDM\data\store\metocean\NRM_metdata.mat');

load('C:\Users\00065525\GITHUB\CDM\data\store\hydro\dew_WaterDataSA_hourly.mat');



data_file = metdata.RMPW18;

metfile = 'C:\Users\00065525\GITHUB\CDM\data\store\metocean\Narrung_met_20160201_20210801.csv';
rainfile = 'C:\Users\00065525\GITHUB\CDM\data\store\metocean\Narrung_rain_20160201_20210801.csv';
imagefile = 'C:\Users\00065525\GITHUB\CDM\data\store\metocean\Narrung_20160201_20210801.png';


startdate = datenum(2016,02,01);
enddate = datenum(2021,08,01);

TZ = 9.5;

seatemp = calc_seatemp(dew,'A4261039',startdate,enddate);

new_data = convert_data_hourly(data_file,startdate,enddate);

create_TFV_Met_From_AWS(metfile,rainfile,imagefile,new_data,startdate,enddate,TZ,seatemp);