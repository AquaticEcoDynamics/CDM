clear all; close all;

filename = '../../../../data/incoming/DEW/barrages/barrage_daily_total_2023_2024.csv';

fid = fopen(filename,'rt');

x  = 6; %Number of Column
textformat = [repmat('%s ',1,x)];
% read single line: number of x-values
datacell = textscan(fid,textformat,'Headerlines',5,'Delimiter',',');
fclose(fid);

thedate = datenum(datacell{1},'dd/mm/yyyy');

barrages.Goolwa.FLOW.Date = thedate;
barrages.Goolwa.FLOW.Data = str2double(datacell{2});
barrages.Goolwa.FLOW.Depth(1:length(thedate),1) = 0;
barrages.Goolwa.FLOW.X = 299425.0;
barrages.Goolwa.FLOW.Y = 6067810.0;

barrages.Tauwitchere.FLOW.Date = thedate;
barrages.Tauwitchere.FLOW.Data = str2double(datacell{3});
barrages.Tauwitchere.FLOW.Depth(1:length(thedate),1) = 0;
barrages.Tauwitchere.FLOW.X = 321940.0;
barrages.Tauwitchere.FLOW.Y = 6061790.0;

barrages.Mundoo.FLOW.Date = thedate;
barrages.Mundoo.FLOW.Data = str2double(datacell{4});
barrages.Mundoo.FLOW.Depth(1:length(thedate),1) = 0;
barrages.Mundoo.FLOW.X = 314110.0;
barrages.Mundoo.FLOW.Y = 6068270.0;

barrages.Boundary_Creek.FLOW.Date = thedate;
barrages.Boundary_Creek.FLOW.Data = str2double(datacell{5});
barrages.Boundary_Creek.FLOW.Depth(1:length(thedate),1) = 0;
barrages.Boundary_Creek.FLOW.X = 315780.0;
barrages.Boundary_Creek.FLOW.Y = 6067390.0;

barrages.Ewe_Island.FLOW.Date = thedate;
barrages.Ewe_Island.FLOW.Data = str2double(datacell{6});
barrages.Ewe_Island.FLOW.Depth(1:length(thedate),1) = 0;
barrages.Ewe_Island.FLOW.X = 317190.0;
barrages.Ewe_Island.FLOW.Y = 6063300.0;

save('../../../../data/store/hydro/dew_barrage_2024.mat','barrages','-mat');

