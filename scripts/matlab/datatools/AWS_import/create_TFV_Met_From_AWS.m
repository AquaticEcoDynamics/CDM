function create_TFV_Met_From_AWS(metfile,rainfile,imagefile,SP,startdate,enddate,TZ,seatemp)

addpath(genpath('functions'));

%load swan.mat;
%load(data_file);

% metfile = 'BCs/Met_PI001.csv';
% rainfile = 'BCs/Rain_PI001.csv';
% imagefile = 'BCs/PI001';

Lat = SP.Lat;
Lon = SP.Lon;

% Lat = -31.991043;
% Lon = 115.886068;

% TZ = 9.5;

SP.mDate = SP.Date;
SP.SolRad = SP.Solar_Rad;
SP.Atemp = SP.AirTemperature;
SP.RelHum = SP.RelativeHumidity;
SP.WS = SP.WindSpeed;
SP.WD = SP.WindDir;

% startdate = datenum(2012,01,01);
% enddate = datenum(2017,01,01);

% startdate = min(SP.mDate);
% enddate = max(SP.mDate);
%BB
%SP.SolRad = SP.SolRad * 1000. / (60.*60.); % Old conversion
SP.SolRad(SP.SolRad < 0) = 0;
SP.SolRad(SP.SolRad > 1100) = 1100;

SP.Clouds(:,1) = calc_Cloud_Cover_me(startdate,enddate,TZ,Lat,Lon,SP);

%seatemp = calc_seatemp(dwlbc,'A4261039',startdate,enddate);
%seatemp = calc_Narrows_Temp(swan,SP);
%seatemp(1:length(SP.Atemp)) = 25;

SP.LW = blwhf(seatemp,SP.Atemp,SP.RelHum,SP.Clouds,'berliand');

SP.LW = SP.LW *1.2;

SP.Atemp(SP.Atemp < 0.1) = 0.1;

SP.RelHum(SP.RelHum < 0.1) = 0.1;
SP.RelHum(SP.RelHum > 99.98) = 99.98;


SP.Rain = SP.Rain /1e3;

SP.WS = SP.WS * (1000/(60*60));

SP.Wx = (round(-1.0.*(SP.WS).*sin((pi/180).*SP.WD)*1000000)/1000000);
SP.Wy = (round(-1.0.*(SP.WS).*cos((pi/180).*SP.WD)*1000000)/1000000);

SP.Days = unique(floor(SP.mDate));
for i = 1:length(SP.Days)
    ss = find(floor(SP.mDate) == SP.Days(i));
    SP.Rain_Daily(i) = sum(SP.Rain(ss));
end

save SP.mat SP -mat

vars = fieldnames(SP);
for i = 1:length(vars)
    if isnumeric(SP.(vars{i}))
    ss = find(isnan(SP.(vars{i})) == 1);
    
    SP.(vars{i})(ss) = SP.(vars{i})(ss-10);
    end
end
write_TFV_Metfile(SP,metfile,rainfile);

tfv_plot_met_infile(metfile,rainfile,imagefile);

%tfv_plot_met_infile('BCs/swan_met_Dardanup_dirmh.csv','BCs/swan_rain_Dardanup.csv','BCs/Dardanup_2008_2011');
