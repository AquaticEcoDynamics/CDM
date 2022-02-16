clear all; close all;


filename = '../../../../data/incoming/DEW/barrages/barrage_daily_total.csv';

options = weboptions('Timeout',Inf);

url = 'https://water.data.sa.gov.au/Export/BulkExport?DateRange=EntirePeriodOfRecord&TimeZone=9.5&Calendar=CALENDARYEAR&Interval=PointsAsRecorded&Step=1&ExportFormat=csv&TimeAligned=True&RoundData=False&IncludeGradeCodes=False&IncludeApprovalLevels=False&IncludeInterpolationTypes=False&Datasets[0].DatasetName=Discharge.Total%20Barrage%20Flow--Daily%20Totals%20(ML)%40A4261005&Datasets[0].Calculation=Instantaneous&Datasets[0].UnitId=239&Datasets[1].DatasetName=Discharge.Total%20Barrage%20Flow--Daily%20Totals%20(ML)%40A4261006&Datasets[1].Calculation=Instantaneous&Datasets[1].UnitId=239&Datasets[2].DatasetName=Discharge.Total%20Barrage%20Flow--Daily%20Totals%20(ML)%40A4260526&Datasets[2].Calculation=Instantaneous&Datasets[2].UnitId=239&Datasets[3].DatasetName=Discharge.Total%20Barrage%20Flow--Daily%20Total%20(ML)%40A4260570&Datasets[3].Calculation=Instantaneous&Datasets[3].UnitId=239&Datasets[4].DatasetName=Discharge.Total%20Barrage%20Flow--Daily%20Totals%20(ML)%40A4260571&Datasets[4].Calculation=Instantaneous&Datasets[4].UnitId=239&_=1644291031234';


outfilename = websave(filename,url,options);


fid = fopen(filename,'rt');


x  = 6; %Number of Column
textformat = [repmat('%s ',1,x)];
% read single line: number of x-values
datacell = textscan(fid,textformat,'Headerlines',5,'Delimiter',',');
fclose(fid);

thedate = datenum(datacell{1},'yyyy-mm-dd HH:MM:SS');

barrages.Goolwa.Flow.Date = thedate;
barrages.Goolwa.Flow.Data = str2double(datacell{2});
barrages.Goolwa.Flow.Depth(1:length(thedate),1) = 0;
barrages.Goolwa.Flow.X = 0;
barrages.Goolwa.Flow.Y = 0;

barrages.Tauwitchere.Flow.Date = thedate;
barrages.Tauwitchere.Flow.Data = str2double(datacell{3});
barrages.Tauwitchere.Flow.Depth(1:length(thedate),1) = 0;
barrages.Tauwitchere.Flow.X = 0;
barrages.Tauwitchere.Flow.Y = 0;

barrages.Mundoo.Flow.Date = thedate;
barrages.Mundoo.Flow.Data = str2double(datacell{4});
barrages.Mundoo.Flow.Depth(1:length(thedate),1) = 0;
barrages.Mundoo.Flow.X = 0;
barrages.Mundoo.Flow.Y = 0;

barrages.Boundary_Creek.Flow.Date = thedate;
barrages.Boundary_Creek.Flow.Data = str2double(datacell{5});
barrages.Boundary_Creek.Flow.Depth(1:length(thedate),1) = 0;
barrages.Boundary_Creek.Flow.X = 0;
barrages.Boundary_Creek.Flow.Y = 0;

barrages.Ewe_Island.Flow.Date = thedate;
barrages.Ewe_Island.Flow.Data = str2double(datacell{6});
barrages.Ewe_Island.Flow.Depth(1:length(thedate),1) = 0;
barrages.Ewe_Island.Flow.X = 0;
barrages.Ewe_Island.Flow.Y = 0;

save('../../../../data/store/hydro/dew_barrage_2022.mat','barrages','-mat');

