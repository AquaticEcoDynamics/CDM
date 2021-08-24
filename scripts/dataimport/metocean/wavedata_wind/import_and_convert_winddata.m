clear all; close all;

addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));
% The metdata
% Site	Latitude	Longitude
% Policeman Point Boat Ramp 1	 36° 2'59.95"S	139°34'44.11"E
% Policeman Point Boat Ramp 2	 36° 3'3.15"S	139°34'40.25"E
% Villa dei Yumpa	 35°55'59.67"S	139°29'2.02"E


site(1).Lat = (36 + (2/60) + (59.95/3600)) * -1 ;
site(1).Lon = 139 + (34/60) + (44.11/3600);

site(2).Lat = (36 + (3/60) + (3.15/3600)) * -1 ;
site(2).Lon = 139 + (34/60) + (40.25/3600);

site(3).Lat = (35 + (55/60) + (59.67/3600)) * -1 ;
site(3).Lon = 139 + (29/60) + (2.02/3600);

[site(1).X,site(1).Y] = ll2utm(site(1).Lat,site(1).Lon);
[site(2).X,site(2).Y] = ll2utm(site(2).Lat,site(2).Lon);
[site(3).X,site(3).Y] = ll2utm(site(3).Lat,site(3).Lon);

datafile = '../../../../data/incoming/UA/wave/Wind data DEC20-MAR21.csv';

fid = fopen(datafile,'rt');

x  = 4;
textformat = [repmat('%s ',1,x)];
% read single line: number of x-values
datacell = textscan(fid,textformat,'Headerlines',1,'Delimiter',',');
fclose(fid);

mDate = datenum(datacell{1},'dd/mm/yyyy HH:MM');
windspeed = str2double(datacell{2});
winddir= str2double(datacell{3});

Wx = (round(-1.0.*(windspeed).*sin((pi/180).* winddir)*1000000)/1000000);
Wy = (round(-1.0.*(windspeed).*cos((pi/180).* winddir)*1000000)/1000000);

siteID = datacell{4};

siteID = regexprep(siteID,' ','_');

uSites = unique(siteID);

for i = 1:length(uSites)
    
    sss = find(strcmpi(siteID,uSites{i}) == 1);
    
    wavewind.(uSites{i}).Wx.Data = Wx(sss);
    wavewind.(uSites{i}).Wx.Date = mDate(sss);
    wavewind.(uSites{i}).Wx.X = site(i).X;
    wavewind.(uSites{i}).Wx.Y = site(i).Y;
    wavewind.(uSites{i}).Wx.Lat = site(i).Lat;
    wavewind.(uSites{i}).Wx.Lon = site(i).Lon;
    wavewind.(uSites{i}).Wx.Name = uSites{i};
    wavewind.(uSites{i}).Wx.Agency = 'UA Wave';
    
    wavewind.(uSites{i}).Wy.Data = Wy(sss);
    wavewind.(uSites{i}).Wy.Date = mDate(sss);
    wavewind.(uSites{i}).Wy.X = site(i).X;
    wavewind.(uSites{i}).Wy.Y = site(i).Y;
    wavewind.(uSites{i}).Wy.Lat = site(i).Lat;
    wavewind.(uSites{i}).Wy.Lon = site(i).Lon;
    wavewind.(uSites{i}).Wy.Name = uSites{i};
    wavewind.(uSites{i}).Wy.Agency = 'UA Wave';

    wavewind.(uSites{i}).Ws.Data = windspeed(sss);
    wavewind.(uSites{i}).Ws.Date = mDate(sss);
    wavewind.(uSites{i}).Ws.X = site(i).X;
    wavewind.(uSites{i}).Ws.Y = site(i).Y;
    wavewind.(uSites{i}).Ws.Lat = site(i).Lat;
    wavewind.(uSites{i}).Ws.Lon = site(i).Lon;
    wavewind.(uSites{i}).Ws.Name = uSites{i};
    wavewind.(uSites{i}).Ws.Agency = 'UA Wave';
    
    wavewind.(uSites{i}).Wd.Data = winddir(sss);
    wavewind.(uSites{i}).Wd.Date = mDate(sss);
    wavewind.(uSites{i}).Wd.X = site(i).X;
    wavewind.(uSites{i}).Wd.Y = site(i).Y;
    wavewind.(uSites{i}).Wd.Lat = site(i).Lat;
    wavewind.(uSites{i}).Wd.Lon = site(i).Lon;
    wavewind.(uSites{i}).Wd.Name = uSites{i};
    wavewind.(uSites{i}).Wd.Agency = 'UA Wave';
    
end

save('../../../../data/store/metocean/wave_wind.mat','wavewind','-mat');

fid = fopen('Wave_Wind.csv','wt');

fprintf(fid,'ISOTime,Wx,Wy\n');
for i = 1:length(mDate)
    fprintf(fid,'%s,%4.4f,%4.4f\n',datestr(mDate(i),'dd/mm/yyyy HH:MM:SS'),Wx(i),Wy(i));
end
fclose(fid);
