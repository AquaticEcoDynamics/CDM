clear all; close all;

addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

filepath = '../../../../data/incoming/TandI_1/Sediment/';

filename = 'Component 4 grain size results with GPS.xlsx';

thedate = datenum(2019,05,19);

agency = 'UA Sediment';

% >2mm gravel
% 1-2mm very coarse
% 500um - 1mm coarse sand
% 250-500 medium sand
% 125-250 fine sand
% 63-125 very fine sand
% <63 mud


thevars =  {...
    'WQ_DIAG_NCS_fs001',...
    'WQ_DIAG_NCS_fs002',...
    'WQ_DIAG_NCS_fs003',...
    'WQ_DIAG_NCS_fs004',...
    'WQ_DIAG_NCS_fs005',...
    'WQ_DIAG_NCS_fs006',...
    'WQ_DIAG_NCS_fs007',...
    };

% theconv = [
%     0.01
% 0.01
% 0.01
% 0.01
% 0.01
% 0.01
% 0.01
% ];

theconv = [
    1
1
1
1
1
1
1
];



[snum,sstr] = xlsread([filepath,filename],'Sample GPS coordinates','A2:C8');

site1 = sstr(:,1); site1 = regexprep(site1,' ','_');

lat = snum(:,1);
lon = snum(:,2);

[X,Y] = ll2utm(lat,lon);

[snum,sstr] = xlsread([filepath,filename],'Sieve data','T11:Z17');
[~,sstr] = xlsread([filepath,filename],'Sieve data','A11:A17');
site = sstr(:,1); site = regexprep(site,' ','_');

data = snum;

for i = 1:length(site)
    for j = 1:length(thevars)
        
        sss = find(strcmpi(site1,site{i}) == 1);
        
        if strcmpi(thevars{j},'Ignore') == 0
            
            ua_grainsize.(site{i}).(thevars{j}).Date = thedate;
            ua_grainsize.(site{i}).(thevars{j}).Data = data(i,j) * theconv(j);
            ua_grainsize.(site{i}).(thevars{j}).Depth = 0;
            ua_grainsize.(site{i}).(thevars{j}).X = X(i);
            ua_grainsize.(site{i}).(thevars{j}).Y = Y(i);
            ua_grainsize.(site{i}).(thevars{j}).Agency = agency;
            
        end
    end
end

save('../../../../data/store/ecology/ua_grainsize.mat','ua_grainsize','-mat');
