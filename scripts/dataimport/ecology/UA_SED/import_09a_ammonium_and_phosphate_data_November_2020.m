clear all; close all;

addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

filepath = '../../../../data/incoming/TandI_1/Sediment/';

filename = 'ammonium and phosphate data (November 2020).xlsx';

thedate = datenum(2020,11,01);

[snum,sstr] = xlsread([filepath,filename],'Site information','A2:F4');

lat = snum(:,1);
lon = snum(:,2);

[XX,YY] = ll2utm(lat,lon);

sites = regexprep(sstr(:,1),'\s','_');

agency = '09a UA Sediment';

%_______________________________________

%NH4

sheetname = 'ammonium';
conv = 1/1000;
varname1 = 'WQ_DIAG_SDG_AMM05';
varname2 = 'WQ_DIAG_SDG_AMM10';

%Noona..
sites_id = 1;

%Day
[snum,~] = xlsread([filepath,filename],sheetname,'A4:G23');
sss = find(snum(:,1) >= 0 & snum(:,1) <= 5);

porewater.(sites{sites_id}).(varname1).Date = thedate + 0.5;
porewater.(sites{sites_id}).(varname1).Data = mean(snum(sss,end));
porewater.(sites{sites_id}).(varname1).Depth = 0 ;
porewater.(sites{sites_id}).(varname1).Agency = agency;
porewater.(sites{sites_id}).(varname1).X = XX(sites_id);
porewater.(sites{sites_id}).(varname1).Y = YY(sites_id);

%Night
[snum,~] = xlsread([filepath,filename],sheetname,'A30:G47');
sss = find(snum(:,1) >= 5 & snum(:,1) <= 10);

porewater.(sites{sites_id}).(varname2).Date = thedate + 00;
porewater.(sites{sites_id}).(varname2).Data = mean(snum(sss,end));
porewater.(sites{sites_id}).(varname2).Depth = 0 ;
porewater.(sites{sites_id}).(varname2).Agency = agency;
porewater.(sites{sites_id}).(varname2).X = XX(sites_id);
porewater.(sites{sites_id}).(varname2).Y = YY(sites_id);

%Parnka..
sites_id = 2;

%Day
[snum,~] = xlsread([filepath,filename],sheetname,'L4:S23');
sss = find(snum(:,1) >= 0 & snum(:,1) <= 5);

porewater.(sites{sites_id}).(varname1).Date = thedate + 0.5;
porewater.(sites{sites_id}).(varname1).Data = mean(snum(sss,end));
porewater.(sites{sites_id}).(varname1).Depth = 0 ;
porewater.(sites{sites_id}).(varname1).Agency = agency;
porewater.(sites{sites_id}).(varname1).X = XX(sites_id);
porewater.(sites{sites_id}).(varname1).Y = YY(sites_id);

%Night
[snum,~] = xlsread([filepath,filename],sheetname,'L30:S47');
sss = find(snum(:,1) >= 5 & snum(:,1) <= 10);

porewater.(sites{sites_id}).(varname2).Date = thedate + 00;
porewater.(sites{sites_id}).(varname2).Data = mean(snum(sss,end));
porewater.(sites{sites_id}).(varname2).Depth = 0 ;
porewater.(sites{sites_id}).(varname2).Agency = agency;
porewater.(sites{sites_id}).(varname2).X = XX(sites_id);
porewater.(sites{sites_id}).(varname2).Y = YY(sites_id);

%Pol Pol..
sites_id = 3;

%Day
[snum,~] = xlsread([filepath,filename],sheetname,'X4:AE23');
sss = find(snum(:,1) >= 0 & snum(:,1) <= 5);

porewater.(sites{sites_id}).(varname1).Date = thedate + 0.5;
porewater.(sites{sites_id}).(varname1).Data = mean(snum(sss,end));
porewater.(sites{sites_id}).(varname1).Depth = 0 ;
porewater.(sites{sites_id}).(varname1).Agency = agency;
porewater.(sites{sites_id}).(varname1).X = XX(sites_id);
porewater.(sites{sites_id}).(varname1).Y = YY(sites_id);

%Night
[snum,~] = xlsread([filepath,filename],sheetname,'X30:AE47');
sss = find(snum(:,1) >= 5 & snum(:,1) <= 10);

porewater.(sites{sites_id}).(varname2).Date = thedate + 00;
porewater.(sites{sites_id}).(varname2).Data = mean(snum(sss,end));
porewater.(sites{sites_id}).(varname2).Depth = 0 ;
porewater.(sites{sites_id}).(varname2).Agency = agency;
porewater.(sites{sites_id}).(varname2).X = XX(sites_id);
porewater.(sites{sites_id}).(varname2).Y = YY(sites_id);

%_______________________________________

%PO4

sheetname = 'phosphate';
conv = 1/1000;
varname1 = 'WQ_DIAG_SDG_PO405';
varname2 = 'WQ_DIAG_SDG_PO410';

%Noona..
sites_id = 1;

%Day
[snum,~] = xlsread([filepath,filename],sheetname,'A4:G23');
sss = find(snum(:,1) >= 0 & snum(:,1) <= 5);

porewater.(sites{sites_id}).(varname1).Date = thedate + 0.5;
porewater.(sites{sites_id}).(varname1).Data = mean(snum(sss,end));
porewater.(sites{sites_id}).(varname1).Depth = 0 ;
porewater.(sites{sites_id}).(varname1).Agency = agency;
porewater.(sites{sites_id}).(varname1).X = XX(sites_id);
porewater.(sites{sites_id}).(varname1).Y = YY(sites_id);

%Night
[snum,~] = xlsread([filepath,filename],sheetname,'A30:G47');
sss = find(snum(:,1) >= 5 & snum(:,1) <= 10);

porewater.(sites{sites_id}).(varname2).Date = thedate + 00;
porewater.(sites{sites_id}).(varname2).Data = mean(snum(sss,end));
porewater.(sites{sites_id}).(varname2).Depth = 0 ;
porewater.(sites{sites_id}).(varname2).Agency = agency;
porewater.(sites{sites_id}).(varname2).X = XX(sites_id);
porewater.(sites{sites_id}).(varname2).Y = YY(sites_id);

%Parnka..
sites_id = 2;

%Day
[snum,~] = xlsread([filepath,filename],sheetname,'L4:S23');
sss = find(snum(:,1) >= 0 & snum(:,1) <= 5);

porewater.(sites{sites_id}).(varname1).Date = thedate + 0.5;
porewater.(sites{sites_id}).(varname1).Data = mean(snum(sss,end));
porewater.(sites{sites_id}).(varname1).Depth = 0 ;
porewater.(sites{sites_id}).(varname1).Agency = agency;
porewater.(sites{sites_id}).(varname1).X = XX(sites_id);
porewater.(sites{sites_id}).(varname1).Y = YY(sites_id);

%Night
[snum,~] = xlsread([filepath,filename],sheetname,'L30:S47');
sss = find(snum(:,1) >= 5 & snum(:,1) <= 10);

porewater.(sites{sites_id}).(varname2).Date = thedate + 00;
porewater.(sites{sites_id}).(varname2).Data = mean(snum(sss,end));
porewater.(sites{sites_id}).(varname2).Depth = 0 ;
porewater.(sites{sites_id}).(varname2).Agency = agency;
porewater.(sites{sites_id}).(varname2).X = XX(sites_id);
porewater.(sites{sites_id}).(varname2).Y = YY(sites_id);

%Pol Pol..
sites_id = 3;

%Day
[snum,~] = xlsread([filepath,filename],sheetname,'X4:AE23');
sss = find(snum(:,1) >= 0 & snum(:,1) <= 5);

porewater.(sites{sites_id}).(varname1).Date = thedate + 0.5;
porewater.(sites{sites_id}).(varname1).Data = mean(snum(sss,end));
porewater.(sites{sites_id}).(varname1).Depth = 0 ;
porewater.(sites{sites_id}).(varname1).Agency = agency;
porewater.(sites{sites_id}).(varname1).X = XX(sites_id);
porewater.(sites{sites_id}).(varname1).Y = YY(sites_id);

%Night
[snum,~] = xlsread([filepath,filename],sheetname,'X30:AE47');
sss = find(snum(:,1) >= 5 & snum(:,1) <= 10);

porewater.(sites{sites_id}).(varname2).Date = thedate + 00;
porewater.(sites{sites_id}).(varname2).Data = mean(snum(sss,end));
porewater.(sites{sites_id}).(varname2).Depth = 0 ;
porewater.(sites{sites_id}).(varname2).Agency = agency;
porewater.(sites{sites_id}).(varname2).X = XX(sites_id);
porewater.(sites{sites_id}).(varname2).Y = YY(sites_id);

save('../../../../data/store/ecology/porewater.mat','porewater','-mat');
