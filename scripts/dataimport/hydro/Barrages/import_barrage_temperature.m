clear all; close all;

filename = '../../../../data/incoming/DEW/barrages/BulkExport-7 Locations-20210809092330.csv';

fid = fopen(filename,'rt');

x = 16;

textformat = [repmat('%s ',1,x)];

datacell = textscan(fid,textformat,'HeaderLines',5,'delimiter',',');

mdates = datenum(datacell{1},'yyyy-mm-dd HH:MM:SS');

% The data

bar.Goolwa.TEMP.Date = mdates;
bar.Goolwa.TEMP.Data = str2double(datacell{5});

bar.Ewe.TEMP.Date = mdates;
bar.Ewe.TEMP.Data = str2double(datacell{7});

bar.Mundoo.TEMP.Date = mdates;
bar.Mundoo.TEMP.Data = str2double(datacell{15});

bar.Boundary.TEMP.Date = mdates;
bar.Boundary.TEMP.Data = str2double(datacell{11});

bar.Tauwitchere.TEMP.Date = mdates;
bar.Tauwitchere.TEMP.Data = str2double(datacell{13});

udates = unique(floor(mdates));

sites = fieldnames(bar);

for i = 1:length(udates)
    
    sss = find(floor(mdates) == udates(i));
    
    for j = 1:length(sites)
        
        bar.(sites{j}).TEMP.Ave(i,1) = max(bar.(sites{j}).TEMP.Data(sss));
    end
end
for j = 1:length(sites)
    bar.(sites{j}).TEMP.uDates = udates;
end


save('../../../../data/store/hydro/dew_barrage_temperature.mat','bar','-mat');

%
% [~,barrage_name] = xlsread(filename,'B1:G1');
%
% barrage_name = regexprep(barrage_name,' ','_');
%
% [snum,sstr] = xlsread(filename,'A3:G11508');
%
% mdate = datenum(sstr(:,1),'dd/mm/yyyy');
%
% figure
%
% for i = 1:length(barrage_name)
%
%     barrages.(barrage_name{i}).Date = mdate;
%     barrages.(barrage_name{i}).Data = snum(:,i);
%
%     plot(barrages.(barrage_name{i}).Date,barrages.(barrage_name{i}).Data);hold on
%
% end
%
%
% legend(regexprep(barrage_name,'_',' '));
%
% datetick('x');
%
% xlabel('Date');
% ylabel('Flow (m^3/s)');
% title('Barrage Flow: 1990 - 2021');
%
% save('../../../../data/store/hydro/dew_barrage.mat','barrages','-mat');