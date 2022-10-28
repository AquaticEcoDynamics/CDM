clear all; close all;

addpath(genpath('Functions'));

outdir = 'GLM_LAke_BCs/';

if ~exist(outdir,'dir')
    mkdir(outdir);
end

load '../../../../data/store/archive/cllmm.mat';


lowerlakes = cllmm;%limit_datasites(cllmm,1);

datearray(:,1) = datenum(2010,01,01,00,00,00):1:datenum(2022,01,01,00,00,00);

zero_missing = 1;

headers = {...
    'FLOW',...
    'SAL',...
    'TEMP',...
    };

%     };

headers = {...
    'FLOW',...
    'SAL',...
    'TEMP',...
    };




% % 
% % % 
% % % % % % % ____________________________________________________
filename = [outdir,'Lock1_Obs.csv'];
subdir = [outdir,'Lock1_Obs/'];

X = 372816.2;
Y = 6197980.5;

create_tfv_inflow_file_v2(lowerlakes,headers,datearray,filename,X,Y,subdir,'Lock1_Obs',0);
% % % 
%create_scenarios_flows(outdir,'Lock1_Obs',headers);




filename = [outdir,'Bremer.csv'];
subdir = [outdir,'Bremer/'];

X = 322978.0;
Y = 6082138.0;

create_tfv_inflow_file_v2(lowerlakes,headers,datearray,filename,X,Y,subdir,'Bremer_BC_v2',zero_missing);

% %__________________________________________________

filename = [outdir,'Angus.csv'];
subdir = [outdir,'Angus/'];

X = 318450.0;
Y = 6084627.0;

create_tfv_inflow_file_v2(lowerlakes,headers,datearray,filename,X,Y,subdir,'Angus_BC_v2',zero_missing);


% %__________________________________________________
filename = [outdir,'Finniss.csv'];
subdir = [outdir,'Finniss/'];

X = 301350.0;
Y = 6081355.0;

create_tfv_inflow_file_v2(lowerlakes,headers,datearray,filename,X,Y,subdir,'Finniss_BC_v2',zero_missing);
% % 

filename = [outdir,'Currency.csv'];
subdir = [outdir,'Currency/'];

X = 298066.0;
Y = 6074055.0;

create_tfv_inflow_file_v2(lowerlakes,headers,datearray,filename,X,Y,subdir,'Currency_BC_v2',zero_missing);
% % % % % % % % 




% 
%merge_files_cewh;
