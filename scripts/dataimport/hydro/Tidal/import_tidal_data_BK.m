clear all; close all;

filename = '../../../../data/incoming/DEW/hydrology/compiled/A4261039-20210805155110.csv';


fid = fopen(filename,'rt');

textformat = [repmat('%s ',1,2)];

datacell = textscan(fid,textformat,'Headerlines',10,'Delimiter',',');

sdate = datacell{1};



for i = 1:length(sdate)
mDate(i,1) = datenum(sdate{i},'yyyy-mm-dd HH:MM:SS');
end
Level(:,1) = str2double(datacell{2});

tide.Date = mDate;

tide.Data = Level(:,1);


plot(tide.Date,tide.Data);hold on


legend('BK Tide');

datetick('x');

xlabel('Date');
ylabel('Height (mAHD)');
title('BK Tidal Height: 2002 - 2021');


save('../../../../data/store/hydro/dew_tide_BK.mat','tide','-mat');
