clear all; close all;
addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

filepath = '../../../../data/incoming/TandI_1/Sediment/';

filename = 'Fluxes February 2021.xlsx';

[snum,sstr] = xlsread('05_Sites.csv','A2:D100');

tSites = sstr(:,2);
lat = snum(:,1);
lon = snum(:,2);

[XX,YY] = ll2utm(lat,lon);


agency = 'UA Sediment';


thedate = datenum(2020,02,12);



%__________________________________

sheetname = 'Oxygen';

thevar = 'WQ_DIAG_SDF_FSED_OXY';
secvar = 'WQ_DIAG_OXY_OXY_DSF';

theconv = 0.024;

[snum,sstr] = xlsread([filepath,filename],sheetname,'B5:C34');

sites = sstr(:,1); usites = unique(sites);
thetime = sstr(:,2); utime = unique(thetime);

[data,~] = xlsread([filepath,filename],sheetname,'N5:N34');

for i = 1:length(usites)
    ua_fluxes_feb.(usites{i}).(thevar) = [];
end


for i = 1:length(sites)
    gg = find(strcmpi(tSites,sites{i}) == 1);
    
    if ~isempty(gg)
        X = XX(gg);
        Y = YY(gg);
    else
        stop;
    end
    
    switch thetime{i}
        case 'L'
            thedate_a = thedate + 0.5;
        case 'D'
            thedate_a = thedate;
    end
    
    
    
    if ~isfield(ua_fluxes_feb.(sites{i}).(thevar),'Date')
        
        ua_fluxes_feb.(sites{i}).(thevar).Date = thedate_a;
        ua_fluxes_feb.(sites{i}).(thevar).Data = data(i) * theconv;
        ua_fluxes_feb.(sites{i}).(thevar).Depth = 0;
        
    else
        
        ua_fluxes_feb.(sites{i}).(thevar).Date = [ua_fluxes_feb.(sites{i}).(thevar).Date;thedate_a];
        ua_fluxes_feb.(sites{i}).(thevar).Data = [ua_fluxes_feb.(sites{i}).(thevar).Data;data(i) * theconv];
        ua_fluxes_feb.(sites{i}).(thevar).Depth = [ua_fluxes_feb.(sites{i}).(thevar).Depth;0];
    end
    
    ua_fluxes_feb.(sites{i}).(thevar).X = X;
    ua_fluxes_feb.(sites{i}).(thevar).Y = Y;
    ua_fluxes_feb.(sites{i}).(thevar).Agency = agency;
    
end

for i = 1:length(usites)
    ua_fluxes_feb.(usites{i}).(secvar) = ua_fluxes_feb.(sites{i}).(thevar);
end

%__________________________________

sheetname = 'DOC';

thevar = 'WQ_DIAG_SDF_FSED_DOC';
secvar = 'WQ_DIAG_OGM_DOC_SWI';

theconv = 0.024;

[snum,sstr] = xlsread([filepath,filename],sheetname,'B5:C34');

sites = sstr(:,1); usites = unique(sites);
thetime = sstr(:,2); utime = unique(thetime);

[data,~] = xlsread([filepath,filename],sheetname,'N5:N34');

for i = 1:length(usites)
    ua_fluxes_feb.(usites{i}).(thevar) = [];
end


for i = 1:length(sites)
    
    
    
    switch thetime{i}
        case 'L'
            thedate_a = thedate + 0.5;
        case 'D'
            thedate_a = thedate;
    end
    
    
    
    if ~isfield(ua_fluxes_feb.(sites{i}).(thevar),'Date')
        
        ua_fluxes_feb.(sites{i}).(thevar).Date = thedate_a;
        ua_fluxes_feb.(sites{i}).(thevar).Data = data(i) * theconv;
        ua_fluxes_feb.(sites{i}).(thevar).Depth = 0;
        
    else
        
        ua_fluxes_feb.(sites{i}).(thevar).Date = [ua_fluxes_feb.(sites{i}).(thevar).Date;thedate_a];
        ua_fluxes_feb.(sites{i}).(thevar).Data = [ua_fluxes_feb.(sites{i}).(thevar).Data;data(i) * theconv];
        ua_fluxes_feb.(sites{i}).(thevar).Depth = [ua_fluxes_feb.(sites{i}).(thevar).Depth;0];
    end
    
    ua_fluxes_feb.(sites{i}).(thevar).X = X;
    ua_fluxes_feb.(sites{i}).(thevar).Y = Y;
    ua_fluxes_feb.(sites{i}).(thevar).Agency = agency;
    
end

for i = 1:length(usites)
    ua_fluxes_feb.(usites{i}).(secvar) = ua_fluxes_feb.(sites{i}).(thevar);
end

%__________________________________

sheetname = 'Methane';

thevar = 'WQ_DIAG_SDF_FSED_CH4';
secvar = 'WQ_DIAG_CAR_CH4_DSF';

theconv = 0.000024;

[snum,sstr] = xlsread([filepath,filename],sheetname,'B5:C34');

sites = sstr(:,1); usites = unique(sites);
thetime = sstr(:,2); utime = unique(thetime);

[data,~] = xlsread([filepath,filename],sheetname,'L5:L34');

for i = 1:length(usites)
    ua_fluxes_feb.(usites{i}).(thevar) = [];
end


for i = 1:length(sites)
    
    
    
    switch thetime{i}
        case 'L'
            thedate_a = thedate + 0.5;
        case 'D'
            thedate_a = thedate;
    end
    
    
    
    if ~isfield(ua_fluxes_feb.(sites{i}).(thevar),'Date')
        
        ua_fluxes_feb.(sites{i}).(thevar).Date = thedate_a;
        ua_fluxes_feb.(sites{i}).(thevar).Data = data(i) * theconv;
        ua_fluxes_feb.(sites{i}).(thevar).Depth = 0;
        
    else
        
        ua_fluxes_feb.(sites{i}).(thevar).Date = [ua_fluxes_feb.(sites{i}).(thevar).Date;thedate_a];
        ua_fluxes_feb.(sites{i}).(thevar).Data = [ua_fluxes_feb.(sites{i}).(thevar).Data;data(i) * theconv];
        ua_fluxes_feb.(sites{i}).(thevar).Depth = [ua_fluxes_feb.(sites{i}).(thevar).Depth;0];
    end
    
    ua_fluxes_feb.(sites{i}).(thevar).X = X;
    ua_fluxes_feb.(sites{i}).(thevar).Y = Y;
    ua_fluxes_feb.(sites{i}).(thevar).Agency = agency;
    
end

for i = 1:length(usites)
    ua_fluxes_feb.(usites{i}).(secvar) = ua_fluxes_feb.(sites{i}).(thevar);
end

%__________________________________

sheetname = 'N2O';

thevar = 'WQ_DIAG_SDF_FSED_N2O';
secvar = 'WQ_DIAG_NIT_N2O_DSF';

theconv = 0.000024;

[snum,sstr] = xlsread([filepath,filename],sheetname,'B5:C34');

sites = sstr(:,1); usites = unique(sites);
thetime = sstr(:,2); utime = unique(thetime);

[data,~] = xlsread([filepath,filename],sheetname,'L5:L34');

for i = 1:length(usites)
    ua_fluxes_feb.(usites{i}).(thevar) = [];
end


for i = 1:length(sites)
    
    
    
    switch thetime{i}
        case 'L'
            thedate_a = thedate + 0.5;
        case 'D'
            thedate_a = thedate;
    end
    
    
    
    if ~isfield(ua_fluxes_feb.(sites{i}).(thevar),'Date')
        
        ua_fluxes_feb.(sites{i}).(thevar).Date = thedate_a;
        ua_fluxes_feb.(sites{i}).(thevar).Data = data(i) * theconv;
        ua_fluxes_feb.(sites{i}).(thevar).Depth = 0;
        
    else
        
        ua_fluxes_feb.(sites{i}).(thevar).Date = [ua_fluxes_feb.(sites{i}).(thevar).Date;thedate_a];
        ua_fluxes_feb.(sites{i}).(thevar).Data = [ua_fluxes_feb.(sites{i}).(thevar).Data;data(i) * theconv];
        ua_fluxes_feb.(sites{i}).(thevar).Depth = [ua_fluxes_feb.(sites{i}).(thevar).Depth;0];
    end
    
    ua_fluxes_feb.(sites{i}).(thevar).X = X;
    ua_fluxes_feb.(sites{i}).(thevar).Y = Y;
    ua_fluxes_feb.(sites{i}).(thevar).Agency = agency;
    
end

for i = 1:length(usites)
    ua_fluxes_feb.(usites{i}).(secvar) = ua_fluxes_feb.(sites{i}).(thevar);
end

save('../../../../data/store/ecology/ua_fluxes_feb.mat','ua_fluxes_feb','-mat');

