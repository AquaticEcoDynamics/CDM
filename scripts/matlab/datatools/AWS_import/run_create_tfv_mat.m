clear all; close all;

addpath(genpath('Functions'));

load('D:\Github\CDM\data\store\NRMAWS\Narrung\metdata.mat');

load('D:\Github\CDM\data\store\DEW/dwlbc.mat');


data_file = metdata.RMPW18;

metfile = 'D:\Github\CDM\data\store\NRMAWS/Narrung_met.csv';
rainfile = 'D:\Github\CDM\data\store\NRMAWS/Narrung_rain.csv';
imagefile = 'D:\Github\CDM\data\store\NRMAWS/Narrung.png';


startdate = datenum(2016,02,01);
enddate = datenum(2021,03,01);

TZ = 9.5;

seatemp = calc_seatemp(dwlbc,'A4261039',startdate,enddate);

new_data = convert_data_hourly(data_file,startdate,enddate);

create_TFV_Met_From_AWS(metfile,rainfile,imagefile,new_data,startdate,enddate,TZ,seatemp);