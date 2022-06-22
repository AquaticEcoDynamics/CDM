clear all; close all;
addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

filepath = '../../../../data/incoming/TandI_1/Sediment/';

filename = 'Oxygen and nutrient fluxes Nov 2020 (Parnka Point).xlsx';


agency = 'UA Sediment';

fullsite = 'Parnka_Point';

X = 355237;
Y = 6025730;
 

thedate = datenum(2020,11,12);

%__________________________________

sheetname = 'oxygen';

thevar = 'WQ_DIAG_SDF_FSED_OXY';
secvar = 'WQ_DIAG_OXY_OXY_DSF';

theconv = 0.024;

[snum,sstr] = xlsread([filepath,filename],sheetname,'B5:B9');

sites_suff = sstr(:,1);

for i = 1:length(sites_suff)
    sites(i) = {[fullsite,'_',sites_suff{i}]};
end

usites = unique(sites);

[data,~] = xlsread([filepath,filename],sheetname,'M5:M9');

thetime = 'L';


for i = 1:length(usites)
    ua_fluxes_nov.(usites{i}).(thevar) = [];
end

data = data * theconv;

for i = 1:length(sites)
    
    
    switch thetime
        case 'L'
            thedate_a = thedate + 0.5;
        case 'D'
            thedate_a = thedate;
    end
    
    
    
    if ~isfield(ua_fluxes_nov.(sites{i}).(thevar),'Date')
        
        ua_fluxes_nov.(sites{i}).(thevar).Date = thedate_a;
        ua_fluxes_nov.(sites{i}).(thevar).Data = data(i);
        ua_fluxes_nov.(sites{i}).(thevar).Depth = 0;
        
    else
        
        ua_fluxes_nov.(sites{i}).(thevar).Date = [ua_fluxes_nov.(sites{i}).(thevar).Date;thedate_a];
        ua_fluxes_nov.(sites{i}).(thevar).Data = [ua_fluxes_nov.(sites{i}).(thevar).Data;data(i) * theconv];
        ua_fluxes_nov.(sites{i}).(thevar).Depth = [ua_fluxes_nov.(sites{i}).(thevar).Depth;0];
    end
    
    ua_fluxes_nov.(sites{i}).(thevar).X = X;
    ua_fluxes_nov.(sites{i}).(thevar).Y = Y;
    ua_fluxes_nov.(sites{i}).(thevar).Agency = agency;
    
end

[snum,sstr] = xlsread([filepath,filename],sheetname,'B15:B19');

sites_suff = sstr(:,1);

for i = 1:length(sites_suff)
    sites(i) = {[fullsite,'_',sites_suff{i}]};
end

usites = unique(sites);

[data,~] = xlsread([filepath,filename],sheetname,'M15:M19');

thetime = 'D';


for i = 1:length(usites)
    ua_fluxes_nov.(usites{i}).(thevar) = [];
end

data = data * theconv;

for i = 1:length(sites)
    
    
    switch thetime
        case 'L'
            thedate_a = thedate + 0.5;
        case 'D'
            thedate_a = thedate;
    end
    
    
    
    if ~isfield(ua_fluxes_nov.(sites{i}).(thevar),'Date')
        
        ua_fluxes_nov.(sites{i}).(thevar).Date = thedate_a;
        ua_fluxes_nov.(sites{i}).(thevar).Data = data(i);
        ua_fluxes_nov.(sites{i}).(thevar).Depth = 0;
        
    else
        
        ua_fluxes_nov.(sites{i}).(thevar).Date = [ua_fluxes_nov.(sites{i}).(thevar).Date;thedate_a];
        ua_fluxes_nov.(sites{i}).(thevar).Data = [ua_fluxes_nov.(sites{i}).(thevar).Data;data(i) * theconv];
        ua_fluxes_nov.(sites{i}).(thevar).Depth = [ua_fluxes_nov.(sites{i}).(thevar).Depth;0];
    end
    
    ua_fluxes_nov.(sites{i}).(thevar).X = X;
    ua_fluxes_nov.(sites{i}).(thevar).Y = Y;
    ua_fluxes_nov.(sites{i}).(thevar).Agency = agency;
    
end

for i = 1:length(usites)
    ua_fluxes_nov.(usites{i}).(secvar) = ua_fluxes_nov.(sites{i}).(thevar);
end

%__________________________________

sheetname = 'phsophate ';

thevar = 'WQ_DIAG_SDF_FSED_FRP';
secvar = 'WQ_DIAG_PHS_FRP_DSF';

theconv = 0.024;

[snum,sstr] = xlsread([filepath,filename],sheetname,'B5:B9');

sites_suff = sstr(:,1);

for i = 1:length(sites_suff)
    sites(i) = {[fullsite,'_',sites_suff{i}]};
end

usites = unique(sites);

[data,~] = xlsread([filepath,filename],sheetname,'M5:M9');

thetime = 'L';


for i = 1:length(usites)
    ua_fluxes_nov.(usites{i}).(thevar) = [];
end

data = data * theconv;

for i = 1:length(data)
    
    
    switch thetime
        case 'L'
            thedate_a = thedate + 0.5;
        case 'D'
            thedate_a = thedate;
    end
    
    
    
    if ~isfield(ua_fluxes_nov.(sites{i}).(thevar),'Date')
        
        ua_fluxes_nov.(sites{i}).(thevar).Date = thedate_a;
        ua_fluxes_nov.(sites{i}).(thevar).Data = data(i);
        ua_fluxes_nov.(sites{i}).(thevar).Depth = 0;
        
    else
        
        ua_fluxes_nov.(sites{i}).(thevar).Date = [ua_fluxes_nov.(sites{i}).(thevar).Date;thedate_a];
        ua_fluxes_nov.(sites{i}).(thevar).Data = [ua_fluxes_nov.(sites{i}).(thevar).Data;data(i) * theconv];
        ua_fluxes_nov.(sites{i}).(thevar).Depth = [ua_fluxes_nov.(sites{i}).(thevar).Depth;0];
    end
    
    ua_fluxes_nov.(sites{i}).(thevar).X = X;
    ua_fluxes_nov.(sites{i}).(thevar).Y = Y;
    ua_fluxes_nov.(sites{i}).(thevar).Agency = agency;
    
end

[snum,sstr] = xlsread([filepath,filename],sheetname,'B15:B19');

sites_suff = sstr(:,1);

for i = 1:length(sites_suff)
    sites(i) = {[fullsite,'_',sites_suff{i}]};
end

usites = unique(sites);

[data,~] = xlsread([filepath,filename],sheetname,'M15:M19');

thetime = 'D';


for i = 1:length(usites)
    ua_fluxes_nov.(usites{i}).(thevar) = [];
end

data = data * theconv;

for i = 1:length(data)
    
    
    switch thetime
        case 'L'
            thedate_a = thedate + 0.5;
        case 'D'
            thedate_a = thedate;
    end
    
    
    
    if ~isfield(ua_fluxes_nov.(sites{i}).(thevar),'Date')
        
        ua_fluxes_nov.(sites{i}).(thevar).Date = thedate_a;
        ua_fluxes_nov.(sites{i}).(thevar).Data = data(i);
        ua_fluxes_nov.(sites{i}).(thevar).Depth = 0;
        
    else
        
        ua_fluxes_nov.(sites{i}).(thevar).Date = [ua_fluxes_nov.(sites{i}).(thevar).Date;thedate_a];
        ua_fluxes_nov.(sites{i}).(thevar).Data = [ua_fluxes_nov.(sites{i}).(thevar).Data;data(i) * theconv];
        ua_fluxes_nov.(sites{i}).(thevar).Depth = [ua_fluxes_nov.(sites{i}).(thevar).Depth;0];
    end
    
    ua_fluxes_nov.(sites{i}).(thevar).X = X;
    ua_fluxes_nov.(sites{i}).(thevar).Y = Y;
    ua_fluxes_nov.(sites{i}).(thevar).Agency = agency;
    
end

for i = 1:length(usites)
    ua_fluxes_nov.(usites{i}).(secvar) = ua_fluxes_nov.(sites{i}).(thevar);
end

%__________________________________

sheetname = 'ammonium';

thevar = 'WQ_DIAG_SDF_FSED_AMM';
secvar = 'WQ_DIAG_NIT_AMM_DSF';

theconv = 0.024;

[snum,sstr] = xlsread([filepath,filename],sheetname,'B5:B9');

sites_suff = sstr(:,1);

for i = 1:length(sites_suff)
    sites(i) = {[fullsite,'_',sites_suff{i}]};
end

usites = unique(sites);

[data,~] = xlsread([filepath,filename],sheetname,'M5:M9');

thetime = 'L';


for i = 1:length(usites)
    ua_fluxes_nov.(usites{i}).(thevar) = [];
end

data = data * theconv;

for i = 1:length(data)
    
    
    switch thetime
        case 'L'
            thedate_a = thedate + 0.5;
        case 'D'
            thedate_a = thedate;
    end
    
    
    
    if ~isfield(ua_fluxes_nov.(sites{i}).(thevar),'Date')
        
        ua_fluxes_nov.(sites{i}).(thevar).Date = thedate_a;
        ua_fluxes_nov.(sites{i}).(thevar).Data = data(i);
        ua_fluxes_nov.(sites{i}).(thevar).Depth = 0;
        
    else
        
        ua_fluxes_nov.(sites{i}).(thevar).Date = [ua_fluxes_nov.(sites{i}).(thevar).Date;thedate_a];
        ua_fluxes_nov.(sites{i}).(thevar).Data = [ua_fluxes_nov.(sites{i}).(thevar).Data;data(i) * theconv];
        ua_fluxes_nov.(sites{i}).(thevar).Depth = [ua_fluxes_nov.(sites{i}).(thevar).Depth;0];
    end
    
    ua_fluxes_nov.(sites{i}).(thevar).X = X;
    ua_fluxes_nov.(sites{i}).(thevar).Y = Y;
    ua_fluxes_nov.(sites{i}).(thevar).Agency = agency;
    
end

[snum,sstr] = xlsread([filepath,filename],sheetname,'B15:B19');

sites_suff = sstr(:,1);

for i = 1:length(sites_suff)
    sites(i) = {[fullsite,'_',sites_suff{i}]};
end

usites = unique(sites);

[data,~] = xlsread([filepath,filename],sheetname,'M15:M19');

thetime = 'D';


for i = 1:length(usites)
    ua_fluxes_nov.(usites{i}).(thevar) = [];
end

data = data * theconv;

for i = 1:length(data)
    
    
    switch thetime
        case 'L'
            thedate_a = thedate + 0.5;
        case 'D'
            thedate_a = thedate;
    end
    
    
    
    if ~isfield(ua_fluxes_nov.(sites{i}).(thevar),'Date')
        
        ua_fluxes_nov.(sites{i}).(thevar).Date = thedate_a;
        ua_fluxes_nov.(sites{i}).(thevar).Data = data(i);
        ua_fluxes_nov.(sites{i}).(thevar).Depth = 0;
        
    else
        
        ua_fluxes_nov.(sites{i}).(thevar).Date = [ua_fluxes_nov.(sites{i}).(thevar).Date;thedate_a];
        ua_fluxes_nov.(sites{i}).(thevar).Data = [ua_fluxes_nov.(sites{i}).(thevar).Data;data(i) * theconv];
        ua_fluxes_nov.(sites{i}).(thevar).Depth = [ua_fluxes_nov.(sites{i}).(thevar).Depth;0];
    end
    
    ua_fluxes_nov.(sites{i}).(thevar).X = X;
    ua_fluxes_nov.(sites{i}).(thevar).Y = Y;
    ua_fluxes_nov.(sites{i}).(thevar).Agency = agency;
    
end

for i = 1:length(usites)
    ua_fluxes_nov.(usites{i}).(secvar) = ua_fluxes_nov.(sites{i}).(thevar);
end

%__________________________________

sheetname = 'nitrate';

thevar = 'WQ_DIAG_SDF_FSED_NIT';
secvar = 'WQ_DIAG_NIT_NIT_DSF';

theconv = 0.024;

[snum,sstr] = xlsread([filepath,filename],sheetname,'B5:B9');

sites_suff = sstr(:,1);

for i = 1:length(sites_suff)
    sites(i) = {[fullsite,'_',sites_suff{i}]};
end

usites = unique(sites);

[data,~] = xlsread([filepath,filename],sheetname,'M5:M9');

thetime = 'L';


for i = 1:length(usites)
    ua_fluxes_nov.(usites{i}).(thevar) = [];
end

data = data * theconv;

for i = 1:length(data)
    
    
    switch thetime
        case 'L'
            thedate_a = thedate + 0.5;
        case 'D'
            thedate_a = thedate;
    end
    
    
    
    if ~isfield(ua_fluxes_nov.(sites{i}).(thevar),'Date')
        
        ua_fluxes_nov.(sites{i}).(thevar).Date = thedate_a;
        ua_fluxes_nov.(sites{i}).(thevar).Data = data(i);
        ua_fluxes_nov.(sites{i}).(thevar).Depth = 0;
        
    else
        
        ua_fluxes_nov.(sites{i}).(thevar).Date = [ua_fluxes_nov.(sites{i}).(thevar).Date;thedate_a];
        ua_fluxes_nov.(sites{i}).(thevar).Data = [ua_fluxes_nov.(sites{i}).(thevar).Data;data(i) * theconv];
        ua_fluxes_nov.(sites{i}).(thevar).Depth = [ua_fluxes_nov.(sites{i}).(thevar).Depth;0];
    end
    
    ua_fluxes_nov.(sites{i}).(thevar).X = X;
    ua_fluxes_nov.(sites{i}).(thevar).Y = Y;
    ua_fluxes_nov.(sites{i}).(thevar).Agency = agency;
    
end

[snum,sstr] = xlsread([filepath,filename],sheetname,'B15:B19');

sites_suff = sstr(:,1);

for i = 1:length(sites_suff)
    sites(i) = {[fullsite,'_',sites_suff{i}]};
end

usites = unique(sites);

[data,~] = xlsread([filepath,filename],sheetname,'M15:M19');

thetime = 'D';


for i = 1:length(usites)
    ua_fluxes_nov.(usites{i}).(thevar) = [];
end

data = data * theconv;

for i = 1:length(data)
    
    
    switch thetime
        case 'L'
            thedate_a = thedate + 0.5;
        case 'D'
            thedate_a = thedate;
    end
    
    
    
    if ~isfield(ua_fluxes_nov.(sites{i}).(thevar),'Date')
        
        ua_fluxes_nov.(sites{i}).(thevar).Date = thedate_a;
        ua_fluxes_nov.(sites{i}).(thevar).Data = data(i);
        ua_fluxes_nov.(sites{i}).(thevar).Depth = 0;
        
    else
        
        ua_fluxes_nov.(sites{i}).(thevar).Date = [ua_fluxes_nov.(sites{i}).(thevar).Date;thedate_a];
        ua_fluxes_nov.(sites{i}).(thevar).Data = [ua_fluxes_nov.(sites{i}).(thevar).Data;data(i) * theconv];
        ua_fluxes_nov.(sites{i}).(thevar).Depth = [ua_fluxes_nov.(sites{i}).(thevar).Depth;0];
    end
    
    ua_fluxes_nov.(sites{i}).(thevar).X = X;
    ua_fluxes_nov.(sites{i}).(thevar).Y = Y;
    ua_fluxes_nov.(sites{i}).(thevar).Agency = agency;
    
end

for i = 1:length(usites)
    ua_fluxes_nov.(usites{i}).(secvar) = ua_fluxes_nov.(sites{i}).(thevar);
end

save('../../../../data/store/ecology/ua_fluxes_nov.mat','ua_fluxes_nov','-mat');
