clear all; close all;

addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

% filename = '../../../../data/incoming/DEW/hydrology/compiled/VH_Tide_2023.csv';
% filename = '../../../../data/incoming/DEW/hydrology/compiled/VH_Tide_2024.csv';
filename = '../../../../data/incoming/DEW/hydrology/compiled/VH_Tide_2024_filled.csv';

%[snum,sstr] = xlsread(filename,'A2:B762626');
fid = fopen(filename,'rt');

textformat = [repmat('%s ',1,3)];

datacell = textscan(fid,textformat,'Headerlines',2,'Delimiter',',');

sstr = datacell{1};
snum = str2double(datacell{3});
mdate = datenum(sstr,'yyyy-mm-dd HH:MM:SS');
% 
% 
% for i = 1:length(sstr)
%     
%     dd = sstr{i,1};
%     
%     if length(dd)>10
%     
%         mdate(i,1) = datenum(sstr(i,1),'yyyy-mm-dd HH:MM:DD');
%         
%     else
%         
%         mdate(i,1) = datenum(sstr(i,1),'yyyy-mm-dd');
%         
%     end
% end

tide.VH.H.Date = mdate;

tide.VH.H.Data = snum(:,1);


tide.VH.H.Lat = -35.562481;
tide.VH.H.Lon = 138.635403;

[tide.VH.H.X,tide.VH.H.Y]= ll2utm(tide.VH.H.Lat,tide.VH.H.Lon);




tide.VH.H.Agency = 'DEW Tide';


plot(tide.VH.H.Date,tide.VH.H.Data);hold on


legend('VH Tide');

datetick('x');

xlabel('Date');
ylabel('Height (mAHD)');
title('VH Tidal Height: Export WDSA (DATUM Uncorrected)');


% save('../../../../data/store/hydro/dew_tide_VH_2023.mat','tide','-mat');
save('../../../../data/store/hydro/dew_tide_VH_2024.mat','tide','-mat');


% data = load('../../../../data/store/hydro/dew_tide_VH_uncorrected_2021.mat');
% plot(data.tide.VH.H.Date,data.tide.VH.H.Data,'b');hold on
% 
% data2 = load('../../../../data/store/hydro/dew_tide_VH.mat');
% plot(data2.tide.VH.H.Date,data2.tide.VH.H.Data,'r');hold on
% 
% legend({'VH Uncorrected Tide';'VH Corrected Tide'});
% 
% datetick('x');
% 
% xlabel('Date');
% ylabel('Height (mAHD)');
% title('VH Tidal Height Comparison: 1990 - 2021');
