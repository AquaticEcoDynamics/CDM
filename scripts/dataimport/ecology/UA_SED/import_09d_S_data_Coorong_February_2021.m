clear all; close all;

load('../../../../data/store/ecology/porewater.mat');

addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

filepath = '../../../../data/incoming/TandI_1/Sediment/';

filename = 'S data (Coorong February 2021).xlsx';

thedate = datenum(2021,02,01);

[snum,sstr] = xlsread('05_Sites.csv','A2:D100');

sites = sstr(:,1);
sites = regexprep(sites,'\s','_');
lat = snum(:,1);
lon = snum(:,2);

[XX,YY] = ll2utm(lat,lon);

agency = 'UA Sediment';


%_______________________________________

%Near Swan

sheetname = 'Near Swan Island ';
conv = 1/1000;
varname1 = 'WQ_DIAG_SDG_H2S05';
varname2 = 'WQ_DIAG_SDG_H2S10';

thedate_m = thedate + 00;

sites_id = 5;

%Night
[snum,~] = xlsread([filepath,filename],sheetname,'A3:G275');
sss = find(snum(:,1) >= 0 & snum(:,1) <= 5);

if ~isfield(porewater,sites{sites_id})

    porewater.(sites{sites_id}).(varname1).Date = thedate_m;
    porewater.(sites{sites_id}).(varname1).Data = mean(snum(sss,end));
    porewater.(sites{sites_id}).(varname1).Depth = 0 ;
    porewater.(sites{sites_id}).(varname1).Agency = agency;
    porewater.(sites{sites_id}).(varname1).X = XX(sites_id);
    porewater.(sites{sites_id}).(varname1).Y = YY(sites_id);
    
else
    if ~isfield(porewater.(sites{sites_id}),(varname1))
        
            porewater.(sites{sites_id}).(varname1).Date = thedate_m;
            porewater.(sites{sites_id}).(varname1).Data = mean(snum(sss,end));
            porewater.(sites{sites_id}).(varname1).Depth = 0 ;
            porewater.(sites{sites_id}).(varname1).Agency = agency;
            porewater.(sites{sites_id}).(varname1).X = XX(sites_id);
            porewater.(sites{sites_id}).(varname1).Y = YY(sites_id);
            
    else
            porewater.(sites{sites_id}).(varname1).Date = [porewater.(sites{sites_id}).(varname1).Date;thedate_m];
            porewater.(sites{sites_id}).(varname1).Data = [porewater.(sites{sites_id}).(varname1).Data;mean(snum(sss,end))];
            porewater.(sites{sites_id}).(varname1).Depth = [porewater.(sites{sites_id}).(varname1).Depth;0] ;
            
    end
end

sss = find(snum(:,1) >= 5 & snum(:,1) <= 10);

if ~isfield(porewater,sites{sites_id})

    porewater.(sites{sites_id}).(varname2).Date = thedate_m;
    porewater.(sites{sites_id}).(varname2).Data = mean(snum(sss,end));
    porewater.(sites{sites_id}).(varname2).Depth = 0 ;
    porewater.(sites{sites_id}).(varname2).Agency = agency;
    porewater.(sites{sites_id}).(varname2).X = XX(sites_id);
    porewater.(sites{sites_id}).(varname2).Y = YY(sites_id);
    
else
    if ~isfield(porewater.(sites{sites_id}),(varname2))
        
            porewater.(sites{sites_id}).(varname2).Date = thedate_m;
            porewater.(sites{sites_id}).(varname2).Data = mean(snum(sss,end));
            porewater.(sites{sites_id}).(varname2).Depth = 0 ;
            porewater.(sites{sites_id}).(varname2).Agency = agency;
            porewater.(sites{sites_id}).(varname2).X = XX(sites_id);
            porewater.(sites{sites_id}).(varname2).Y = YY(sites_id);
            
    else
            porewater.(sites{sites_id}).(varname2).Date = [porewater.(sites{sites_id}).(varname2).Date;thedate_m];
            porewater.(sites{sites_id}).(varname2).Data = [porewater.(sites{sites_id}).(varname2).Data;mean(snum(sss,end))];
            porewater.(sites{sites_id}).(varname2).Depth = [porewater.(sites{sites_id}).(varname2).Depth;0] ;
            
    end
end
        
%_______________________________________

%South of Salt Creek

sheetname = '3 km south of Salt creek   ';
conv = 1/1000;
varname1 = 'WQ_DIAG_SDG_FEII05';
varname2 = 'WQ_DIAG_SDG_FEII10';

thedate_m = thedate + 00;

sites_id = 4;

%Night
[snum,~] = xlsread([filepath,filename],sheetname,'A3:G276');
sss = find(snum(:,1) >= 0 & snum(:,1) <= 5);

if ~isfield(porewater,sites{sites_id})

    porewater.(sites{sites_id}).(varname1).Date = thedate_m;
    porewater.(sites{sites_id}).(varname1).Data = mean(snum(sss,end));
    porewater.(sites{sites_id}).(varname1).Depth = 0 ;
    porewater.(sites{sites_id}).(varname1).Agency = agency;
    porewater.(sites{sites_id}).(varname1).X = XX(sites_id);
    porewater.(sites{sites_id}).(varname1).Y = YY(sites_id);
    
else
    if ~isfield(porewater.(sites{sites_id}),(varname1))
        
            porewater.(sites{sites_id}).(varname1).Date = thedate_m;
            porewater.(sites{sites_id}).(varname1).Data = mean(snum(sss,end));
            porewater.(sites{sites_id}).(varname1).Depth = 0 ;
            porewater.(sites{sites_id}).(varname1).Agency = agency;
            porewater.(sites{sites_id}).(varname1).X = XX(sites_id);
            porewater.(sites{sites_id}).(varname1).Y = YY(sites_id);
            
    else
            porewater.(sites{sites_id}).(varname1).Date = [porewater.(sites{sites_id}).(varname1).Date;thedate_m];
            porewater.(sites{sites_id}).(varname1).Data = [porewater.(sites{sites_id}).(varname1).Data;mean(snum(sss,end))];
            porewater.(sites{sites_id}).(varname1).Depth = [porewater.(sites{sites_id}).(varname1).Depth;0] ;
            
    end
end  

sss = find(snum(:,1) >= 5 & snum(:,1) <= 10);

if ~isfield(porewater,sites{sites_id})

    porewater.(sites{sites_id}).(varname2).Date = thedate_m;
    porewater.(sites{sites_id}).(varname2).Data = mean(snum(sss,end));
    porewater.(sites{sites_id}).(varname2).Depth = 0 ;
    porewater.(sites{sites_id}).(varname2).Agency = agency;
    porewater.(sites{sites_id}).(varname2).X = XX(sites_id);
    porewater.(sites{sites_id}).(varname2).Y = YY(sites_id);
    
else
    if ~isfield(porewater.(sites{sites_id}),(varname2))
        
            porewater.(sites{sites_id}).(varname2).Date = thedate_m;
            porewater.(sites{sites_id}).(varname2).Data = mean(snum(sss,end));
            porewater.(sites{sites_id}).(varname2).Depth = 0 ;
            porewater.(sites{sites_id}).(varname2).Agency = agency;
            porewater.(sites{sites_id}).(varname2).X = XX(sites_id);
            porewater.(sites{sites_id}).(varname2).Y = YY(sites_id);
            
    else
            porewater.(sites{sites_id}).(varname2).Date = [porewater.(sites{sites_id}).(varname2).Date;thedate_m];
            porewater.(sites{sites_id}).(varname2).Data = [porewater.(sites{sites_id}).(varname2).Data;mean(snum(sss,end))];
            porewater.(sites{sites_id}).(varname2).Depth = [porewater.(sites{sites_id}).(varname2).Depth;0] ;
            
    end
end

%_______________________________________

%Parnka point

sheetname = 'Parnka point';
conv = 1/1000;
varname1 = 'WQ_DIAG_SDG_FEII05';
varname2 = 'WQ_DIAG_SDG_FEII10';

thedate_m = thedate + 0.5;

sites_id = 2;

%Day
[snum,~] = xlsread([filepath,filename],sheetname,'A3:G275');
sss = find(snum(:,1) >= 0 & snum(:,1) <= 5);

if ~isfield(porewater,sites{sites_id})

    porewater.(sites{sites_id}).(varname1).Date = thedate_m;
    porewater.(sites{sites_id}).(varname1).Data = mean(snum(sss,end));
    porewater.(sites{sites_id}).(varname1).Depth = 0 ;
    porewater.(sites{sites_id}).(varname1).Agency = agency;
    porewater.(sites{sites_id}).(varname1).X = XX(sites_id);
    porewater.(sites{sites_id}).(varname1).Y = YY(sites_id);
    
else
    if ~isfield(porewater.(sites{sites_id}),(varname1))
        
            porewater.(sites{sites_id}).(varname1).Date = thedate_m;
            porewater.(sites{sites_id}).(varname1).Data = mean(snum(sss,end));
            porewater.(sites{sites_id}).(varname1).Depth = 0 ;
            porewater.(sites{sites_id}).(varname1).Agency = agency;
            porewater.(sites{sites_id}).(varname1).X = XX(sites_id);
            porewater.(sites{sites_id}).(varname1).Y = YY(sites_id);
            
    else
            porewater.(sites{sites_id}).(varname1).Date = [porewater.(sites{sites_id}).(varname1).Date;thedate_m];
            porewater.(sites{sites_id}).(varname1).Data = [porewater.(sites{sites_id}).(varname1).Data;mean(snum(sss,end))];
            porewater.(sites{sites_id}).(varname1).Depth = [porewater.(sites{sites_id}).(varname1).Depth;0] ;
            
    end
end  

sss = find(snum(:,1) >= 5 & snum(:,1) <= 10);

if ~isfield(porewater,sites{sites_id})

    porewater.(sites{sites_id}).(varname2).Date = thedate_m;
    porewater.(sites{sites_id}).(varname2).Data = mean(snum(sss,end));
    porewater.(sites{sites_id}).(varname2).Depth = 0 ;
    porewater.(sites{sites_id}).(varname2).Agency = agency;
    porewater.(sites{sites_id}).(varname2).X = XX(sites_id);
    porewater.(sites{sites_id}).(varname2).Y = YY(sites_id);
    
else
    if ~isfield(porewater.(sites{sites_id}),(varname2))
        
            porewater.(sites{sites_id}).(varname2).Date = thedate_m;
            porewater.(sites{sites_id}).(varname2).Data = mean(snum(sss,end));
            porewater.(sites{sites_id}).(varname2).Depth = 0 ;
            porewater.(sites{sites_id}).(varname2).Agency = agency;
            porewater.(sites{sites_id}).(varname2).X = XX(sites_id);
            porewater.(sites{sites_id}).(varname2).Y = YY(sites_id);
            
    else
            porewater.(sites{sites_id}).(varname2).Date = [porewater.(sites{sites_id}).(varname2).Date;thedate_m];
            porewater.(sites{sites_id}).(varname2).Data = [porewater.(sites{sites_id}).(varname2).Data;mean(snum(sss,end))];
            porewater.(sites{sites_id}).(varname2).Depth = [porewater.(sites{sites_id}).(varname2).Depth;0] ;
            
    end
end

thedate_m = thedate;


%Night
[snum,~] = xlsread([filepath,filename],sheetname,'A3:P275');
sss = find(snum(:,1) >= 0 & snum(:,1) <= 5);

if ~isfield(porewater,sites{sites_id})

    porewater.(sites{sites_id}).(varname1).Date = thedate_m;
    porewater.(sites{sites_id}).(varname1).Data = mean(snum(sss,end));
    porewater.(sites{sites_id}).(varname1).Depth = 0 ;
    porewater.(sites{sites_id}).(varname1).Agency = agency;
    porewater.(sites{sites_id}).(varname1).X = XX(sites_id);
    porewater.(sites{sites_id}).(varname1).Y = YY(sites_id);
    
else
    if ~isfield(porewater.(sites{sites_id}),(varname1))
        
            porewater.(sites{sites_id}).(varname1).Date = thedate_m;
            porewater.(sites{sites_id}).(varname1).Data = mean(snum(sss,end));
            porewater.(sites{sites_id}).(varname1).Depth = 0 ;
            porewater.(sites{sites_id}).(varname1).Agency = agency;
            porewater.(sites{sites_id}).(varname1).X = XX(sites_id);
            porewater.(sites{sites_id}).(varname1).Y = YY(sites_id);
            
    else
            porewater.(sites{sites_id}).(varname1).Date = [porewater.(sites{sites_id}).(varname1).Date;thedate_m];
            porewater.(sites{sites_id}).(varname1).Data = [porewater.(sites{sites_id}).(varname1).Data;mean(snum(sss,end))];
            porewater.(sites{sites_id}).(varname1).Depth = [porewater.(sites{sites_id}).(varname1).Depth;0] ;
            
    end
end  

sss = find(snum(:,1) >= 5 & snum(:,1) <= 10);

if ~isfield(porewater,sites{sites_id})

    porewater.(sites{sites_id}).(varname2).Date = thedate_m;
    porewater.(sites{sites_id}).(varname2).Data = mean(snum(sss,end));
    porewater.(sites{sites_id}).(varname2).Depth = 0 ;
    porewater.(sites{sites_id}).(varname2).Agency = agency;
    porewater.(sites{sites_id}).(varname2).X = XX(sites_id);
    porewater.(sites{sites_id}).(varname2).Y = YY(sites_id);
    
else
    if ~isfield(porewater.(sites{sites_id}),(varname2))
        
            porewater.(sites{sites_id}).(varname2).Date = thedate_m;
            porewater.(sites{sites_id}).(varname2).Data = mean(snum(sss,end));
            porewater.(sites{sites_id}).(varname2).Depth = 0 ;
            porewater.(sites{sites_id}).(varname2).Agency = agency;
            porewater.(sites{sites_id}).(varname2).X = XX(sites_id);
            porewater.(sites{sites_id}).(varname2).Y = YY(sites_id);
            
    else
            porewater.(sites{sites_id}).(varname2).Date = [porewater.(sites{sites_id}).(varname2).Date;thedate_m];
            porewater.(sites{sites_id}).(varname2).Data = [porewater.(sites{sites_id}).(varname2).Data;mean(snum(sss,end))];
            porewater.(sites{sites_id}).(varname2).Depth = [porewater.(sites{sites_id}).(varname2).Depth;0] ;
            
    end
end

%_______________________________________

%Policeman point

sheetname = ' policeman poin';
conv = 1/1000;
varname1 = 'WQ_DIAG_SDG_FEII05';
varname2 = 'WQ_DIAG_SDG_FEII10';

thedate_m = thedate + 0.5;

sites_id = 3;

%Day
[snum,~] = xlsread([filepath,filename],sheetname,'A3:G275');
sss = find(snum(:,1) >= 0 & snum(:,1) <= 5);

if ~isfield(porewater,sites{sites_id})

    porewater.(sites{sites_id}).(varname1).Date = thedate_m;
    porewater.(sites{sites_id}).(varname1).Data = mean(snum(sss,end));
    porewater.(sites{sites_id}).(varname1).Depth = 0 ;
    porewater.(sites{sites_id}).(varname1).Agency = agency;
    porewater.(sites{sites_id}).(varname1).X = XX(sites_id);
    porewater.(sites{sites_id}).(varname1).Y = YY(sites_id);
    
else
    if ~isfield(porewater.(sites{sites_id}),(varname1))
        
            porewater.(sites{sites_id}).(varname1).Date = thedate_m;
            porewater.(sites{sites_id}).(varname1).Data = mean(snum(sss,end));
            porewater.(sites{sites_id}).(varname1).Depth = 0 ;
            porewater.(sites{sites_id}).(varname1).Agency = agency;
            porewater.(sites{sites_id}).(varname1).X = XX(sites_id);
            porewater.(sites{sites_id}).(varname1).Y = YY(sites_id);
            
    else
            porewater.(sites{sites_id}).(varname1).Date = [porewater.(sites{sites_id}).(varname1).Date;thedate_m];
            porewater.(sites{sites_id}).(varname1).Data = [porewater.(sites{sites_id}).(varname1).Data;mean(snum(sss,end))];
            porewater.(sites{sites_id}).(varname1).Depth = [porewater.(sites{sites_id}).(varname1).Depth;0] ;
            
    end
end  

sss = find(snum(:,1) >= 5 & snum(:,1) <= 10);

if ~isfield(porewater,sites{sites_id})

    porewater.(sites{sites_id}).(varname2).Date = thedate_m;
    porewater.(sites{sites_id}).(varname2).Data = mean(snum(sss,end));
    porewater.(sites{sites_id}).(varname2).Depth = 0 ;
    porewater.(sites{sites_id}).(varname2).Agency = agency;
    porewater.(sites{sites_id}).(varname2).X = XX(sites_id);
    porewater.(sites{sites_id}).(varname2).Y = YY(sites_id);
    
else
    if ~isfield(porewater.(sites{sites_id}),(varname2))
        
            porewater.(sites{sites_id}).(varname2).Date = thedate_m;
            porewater.(sites{sites_id}).(varname2).Data = mean(snum(sss,end));
            porewater.(sites{sites_id}).(varname2).Depth = 0 ;
            porewater.(sites{sites_id}).(varname2).Agency = agency;
            porewater.(sites{sites_id}).(varname2).X = XX(sites_id);
            porewater.(sites{sites_id}).(varname2).Y = YY(sites_id);
            
    else
            porewater.(sites{sites_id}).(varname2).Date = [porewater.(sites{sites_id}).(varname2).Date;thedate_m];
            porewater.(sites{sites_id}).(varname2).Data = [porewater.(sites{sites_id}).(varname2).Data;mean(snum(sss,end))];
            porewater.(sites{sites_id}).(varname2).Depth = [porewater.(sites{sites_id}).(varname2).Depth;0] ;
            
    end
end

thedate_m = thedate;


%Night
[snum,~] = xlsread([filepath,filename],sheetname,'A3:P275');
sss = find(snum(:,1) >= 0 & snum(:,1) <= 5);

if ~isfield(porewater,sites{sites_id})

    porewater.(sites{sites_id}).(varname1).Date = thedate_m;
    porewater.(sites{sites_id}).(varname1).Data = mean(snum(sss,end));
    porewater.(sites{sites_id}).(varname1).Depth = 0 ;
    porewater.(sites{sites_id}).(varname1).Agency = agency;
    porewater.(sites{sites_id}).(varname1).X = XX(sites_id);
    porewater.(sites{sites_id}).(varname1).Y = YY(sites_id);
    
else
    if ~isfield(porewater.(sites{sites_id}),(varname1))
        
            porewater.(sites{sites_id}).(varname1).Date = thedate_m;
            porewater.(sites{sites_id}).(varname1).Data = mean(snum(sss,end));
            porewater.(sites{sites_id}).(varname1).Depth = 0 ;
            porewater.(sites{sites_id}).(varname1).Agency = agency;
            porewater.(sites{sites_id}).(varname1).X = XX(sites_id);
            porewater.(sites{sites_id}).(varname1).Y = YY(sites_id);
            
    else
            porewater.(sites{sites_id}).(varname1).Date = [porewater.(sites{sites_id}).(varname1).Date;thedate_m];
            porewater.(sites{sites_id}).(varname1).Data = [porewater.(sites{sites_id}).(varname1).Data;mean(snum(sss,end))];
            porewater.(sites{sites_id}).(varname1).Depth = [porewater.(sites{sites_id}).(varname1).Depth;0] ;
            
    end
end  

sss = find(snum(:,1) >= 5 & snum(:,1) <= 10);

if ~isfield(porewater,sites{sites_id})

    porewater.(sites{sites_id}).(varname2).Date = thedate_m;
    porewater.(sites{sites_id}).(varname2).Data = mean(snum(sss,end));
    porewater.(sites{sites_id}).(varname2).Depth = 0 ;
    porewater.(sites{sites_id}).(varname2).Agency = agency;
    porewater.(sites{sites_id}).(varname2).X = XX(sites_id);
    porewater.(sites{sites_id}).(varname2).Y = YY(sites_id);
    
else
    if ~isfield(porewater.(sites{sites_id}),(varname2))
        
            porewater.(sites{sites_id}).(varname2).Date = thedate_m;
            porewater.(sites{sites_id}).(varname2).Data = mean(snum(sss,end));
            porewater.(sites{sites_id}).(varname2).Depth = 0 ;
            porewater.(sites{sites_id}).(varname2).Agency = agency;
            porewater.(sites{sites_id}).(varname2).X = XX(sites_id);
            porewater.(sites{sites_id}).(varname2).Y = YY(sites_id);
            
    else
            porewater.(sites{sites_id}).(varname2).Date = [porewater.(sites{sites_id}).(varname2).Date;thedate_m];
            porewater.(sites{sites_id}).(varname2).Data = [porewater.(sites{sites_id}).(varname2).Data;mean(snum(sss,end))];
            porewater.(sites{sites_id}).(varname2).Depth = [porewater.(sites{sites_id}).(varname2).Depth;0] ;
            
    end
end

save('../../../../data/store/ecology/porewater.mat','porewater','-mat');
