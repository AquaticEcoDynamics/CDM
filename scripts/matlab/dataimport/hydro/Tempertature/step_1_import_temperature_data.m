clear all; close all;

addpath(genpath('../../../../aed_matlab_modeltools/TUFLOWFV/bmt_matlab_tools/'));

filename = '..\..\..\data\incoming\TandI_2\UA_Loggers\All HOBO temperature data to March 2020.xlsx';

sheetname = 'all data';


[~,~,sraw] = xlsread(filename,sheetname,'A2:D49849');

sites = {'Site10';'Site14';'Site30'};

for i = 1:length(sites)
    temp.(sites{i}).TEMP.Data = [];
    temp.(sites{i}).TEMP.Date = [];
    temp.(sites{i}).TEMP.Depth = [];
end



for i = 1:length(sraw)
    
    tt = strsplit(sraw{i,1},' ');
    
    if length(tt) == 1
        nDates(i) = datenum(tt{1},'dd/mm/yyyy');
    else
        switch tt{3}
            case 'AM'
                nDates(i) = datenum([tt{1},' ',tt{2},' ',tt{3}],'dd/mm/yyyy HH:MM:SS AM');
            case 'PM'
                nDates(i) = datenum([tt{1},' ',tt{2},' ',tt{3}],'dd/mm/yyyy HH:MM:SS PM');
            otherwise
                stop;
        end
    end
    
    for j = 1:length(sites)
        thedata = sraw{i,j+1};
        if ~isnan(thedata)
            temp.(sites{j}).TEMP.Data = [temp.(sites{j}).TEMP.Data;thedata];
            temp.(sites{j}).TEMP.Date = [temp.(sites{j}).TEMP.Date;nDates(i)];
            temp.(sites{j}).TEMP.Depth = [temp.(sites{j}).TEMP.Depth;0];
        end
    end
end
   


temp.Site10.TEMP.Name = 'Wild Dog Island (inshore)';
temp.Site10.TEMP.Lat = -36.120183;
temp.Site10.TEMP.Lon = 139.636667;

[temp.Site10.TEMP.X, temp.Site10.TEMP.Y, ~] = ll2utm (temp.Site10.TEMP.Lon, temp.Site10.TEMP.Lat);


temp.Site14.TEMP.Name = 'Policeman Point';
temp.Site14.TEMP.Lat = -36.058983;
temp.Site14.TEMP.Lon = 139.585867;

[temp.Site14.TEMP.X, temp.Site14.TEMP.Y, ~] = ll2utm (temp.Site14.TEMP.Lon, temp.Site14.TEMP.Lat);


temp.Site30.TEMP.Name = 'North Magrath Flats';
temp.Site30.TEMP.Lat = -35.852717;
temp.Site30.TEMP.Lon = 139.384750;
[temp.Site30.TEMP.X, temp.Site30.TEMP.Y, ~] = ll2utm (temp.Site30.TEMP.Lon, temp.Site30.TEMP.Lat);

save temp.mat temp -mat;
    
