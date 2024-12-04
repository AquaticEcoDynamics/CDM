clear all; close all;

addpath(genpath('Functions'));

outdir = 'BCs_BAR_2012_2024_V2/';

if ~exist(outdir,'dir')
    mkdir(outdir);
end

load '../../../../data/store/merged/cllmm_BC.mat';

lowerlakes = cllmm;
datearray(:,1) = datenum(2023,07,02,00,00,00):1:datenum(2024,11,14,00,00,00);


% lowerlakes = rmfield(lowerlakes,'TLM_Mundoo_Channel');
% lowerlakes = rmfield(lowerlakes,'TLM_Hunters_Creek');
% lowerlakes = rmfield(lowerlakes,'TLM_Ewe_Island');
% lowerlakes = rmfield(lowerlakes,'TLM_Monument_Road');

headers = {...
    'FLOW',...
    'SAL',...
    'TEMP',...
    'TRACE_1',...
    'TRACE_2',...
    'TRACE_3',...
    'TRACE_4',...
    'TRACE_5',...
    'WQ_NCS_SS1',...
    'WQ_TRC_RET',...
    'WQ_OXY_OXY',...
    'WQ_SIL_RSI',...
    'WQ_NIT_AMM',...
    'WQ_NIT_NIT',...
    'WQ_PHS_FRP',...
    'WQ_PHS_FRP_ADS',...
    'WQ_OGM_DOC',...
    'WQ_OGM_POC',...
    'WQ_OGM_DON',...
    'WQ_OGM_PON',...
    'WQ_OGM_DOP',...
    'WQ_OGM_POP',...
    'WQ_PHY_GRN',...
    'mag_ulva',...
    'mag_ulva_in',...
    'mag_ulva_ip',...
    'WQ_DIAG_TOT_TN',...
    'WQ_DIAG_TOT_TP',...
    'WQ_DIAG_TOT_TOC',...
    
    };

% %
% % %
% % % % ____________________________________________________

filename = [outdir,'Salt_Creek_20230701_20241114.csv'];
subdir = [outdir,'Salt_Creek/'];

X = 378834.;
Y = 6001351.5;

% Clear any existing preferred_sites structure
clear preferred_sites

create_tfv_inflow_file(lowerlakes,headers,datearray,filename,X,Y,subdir,'Salt_Creek');

filename = [outdir,'Goolwa_20230701_20241114.csv'];
subdir = [outdir,'Goolwa/'];

% X = 299425.0;
% Y = 6067810.0;
X = 300692;
Y = 6067199;

% Clear any existing preferred_sites structure
clear preferred_sites

% Create new preferred_sites structure
preferred_sites = struct();
preferred_sites.FLOW = 'Goolwa';

create_tfv_inflow_file(lowerlakes,headers,datearray,filename,X,Y,subdir,'Goolwa',preferred_sites);

filename = [outdir,'Tauwitchere_20230701_20241114.csv'];
subdir = [outdir,'Tauwitchere/'];

% X = 321940.0;
% Y = 6061790.0;
X = 324305;	
Y = 6067057;

% Clear any existing preferred_sites structure
clear preferred_sites

% Create new preferred_sites structure
preferred_sites = struct();
preferred_sites.FLOW = 'Tauwitchere';

create_tfv_inflow_file(lowerlakes,headers,datearray,filename,X,Y,subdir,'Tauwitchere',preferred_sites);

filename = [outdir,'Mundoo_20230701_20241114.csv'];
subdir = [outdir,'Mundoo/'];

% X = 314110.0;
% Y = 6068270.0;
X = 316257;	
Y = 6067122;

% Clear any existing preferred_sites structure
clear preferred_sites

% Create new preferred_sites structure
preferred_sites = struct();
preferred_sites.FLOW = 'Mundoo';

create_tfv_inflow_file(lowerlakes,headers,datearray,filename,X,Y,subdir,'Mundoo',preferred_sites);

filename = [outdir,'Boundary_20230701_20241114.csv'];
subdir = [outdir,'Boundary/'];

% X = 315780.0;
% Y = 6067390.0;
X = 316257;	
Y = 6067122;

% Clear any existing preferred_sites structure
clear preferred_sites

% Create new preferred_sites structure
preferred_sites = struct();
preferred_sites.FLOW = 'Boundary_Creek';

create_tfv_inflow_file(lowerlakes,headers,datearray,filename,X,Y,subdir,'Boundary_Creek',preferred_sites);

filename = [outdir,'Ewe_20230701_20241114.csv'];
subdir = [outdir,'Ewe/'];

% X = 317190.0;
% Y = 6063300.0;
X = 324305;	
Y = 6067057;

% Clear any existing preferred_sites structure
clear preferred_sites

% Create new preferred_sites structure
preferred_sites = struct();
preferred_sites.FLOW = 'Ewe_Island';

create_tfv_inflow_file(lowerlakes,headers,datearray,filename,X,Y,subdir,'Ewe_Island',preferred_sites);

headers{1} = 'H';
filename = [outdir,'BK_20230701_20241114.csv'];
subdir = [outdir,'BK/'];

X = 309703.3;
Y = 6062973;

% Clear any existing preferred_sites structure
clear preferred_sites

create_tfv_inflow_file(lowerlakes,headers,datearray,filename,X,Y,subdir,'BK');