
 

% SITE Configuration_______________________________________________________
fielddata_matfile = 'lowerlakes.mat';
fielddata = 'lowerlakes';

polygon_file = '.\Coorong_obs_sites.shp';

%polygon_file = '.\GDSTN_Polygons_200m_v2_C3.shp';

%sites = [17,18,20];  % Sites in shapefile (polygon IDs) to plot
% ____________________________________________________________Configuration



% VAR Configuration________________________________________________________
varname = {...
 'SAL',...
%  'SED_5',...
%  'SED_6',...
%  'WQ_PHY_CYANO',...
%  'WQ_PHY_LDIAT',...
%  'WQ_PHY_CHLOR',...
%  'WQ_PHY_CRYPT',...
%  'WQ_PHY_EDIAT',...
%  'WQ_PHY_CYANO_RHO',...
%  'WQ_PHY_CYANO_IN',...
%  'WQ_PHY_CYANO_IP',...
%  'WQ_PHY_CHLOR_IN',...
%  'WQ_PHY_CHLOR_IP',...
%  'WQ_PHY_CRYPT_IN',...
%  'WQ_PHY_CRYPT_IP',...
%  'WQ_PHY_EDIAT_IN',...
%  'WQ_PHY_EDIAT_IP',...
%  'WQ_PHY_LDIAT_IN',...
%  'WQ_PHY_LDIAT_IP',...
%  'WQ_PHS_FRP',...
%  'WQ_NCS_SS1',...
%  'WQ_TRC_AGE',...
%  'WQ_SIL_RSI',...
%  'WQ_NIT_AMM',...
%  'WQ_NIT_NIT',...
%  'WQ_BIV_FILTFRAC',...
%  'WQ_PHS_FRP_ADS',...
%  'WQ_OGM_DOC',...
%  'WQ_OGM_POC',...
%  'WQ_OGM_DON',...
%  'WQ_OGM_PON',...
%  'WQ_OGM_DOP',...
%  'WQ_OGM_POP',...
};

def.cAxis(1).value = [0 150];   %'TSS',...
def.cAxis(2).value = [0 200];  %'SED_5',...
def.cAxis(3).value = [0 200];   %'SED_6',...
% def.cAxis(4).value = [0 600];	%'WQ_DIAG_TOT_TSS',...
% def.cAxis(5).value = [0 750];  %'WQ_DIAG_TOT_LIGHT',...
% def.cAxis(6).value = [0 400];  %'WQ_DIAG_TOT_PAR',...
% def.cAxis(7).value = [0 50];  %'WQ_DIAG_TOT_UV',...
% def.cAxis(8).value = [0 2];   %'WQ_DIAG_TOT_EXTC',...
% def.cAxis(9).value = [0 50];   %'WQ_DIAG_PHY_TCHLA',...
% ____________________________________________________________Configuration



% PLOT Configuration_______________________________________________________
plottype = 'timeseries'; %timeseries or 'profile'

plotvalidation = true; % Add field data to figure (true or false)

plotdepth = {'surface'};%;'bottom'};  % Cell-array with either one or both
depth_range = [0.2 100];
validation_minmax = 1;

istitled = 1;
isylabel = 1;
islegend = 1;
isYlim   = 1;
isRange  = 1;
isRange_Bottom = 1;
Range_ALL = 0;

filetype = 'eps';
def.expected = 1; % plot expected WL

isFieldRange = 1;
fieldprctile = [10 90];

isHTML = 1;

yr = 2017;
def.datearray = datenum(yr,7:6:43,1);

%outputdirectory = './Timeseries_Basecase_June/RAW/';
%htmloutput = './Timeseries_Basecase_June/HTML/';
outputdirectory = './compare_scens/RAW/';
htmloutput = './compare_scens/HTML/';
% ____________________________________________________________Configuration





% Models___________________________________________________________________

 %ncfile(1).name = 'Y:\GDSTN\TUFLOWFV\output_PH_debug\tauce02v1\GLAD_EXT_SEDI_HIND_2D_000_bund_leaks_PH_v2_withbund_testingMZ_new_full_tauce02.nc';
  
ncfile(1).name = 'Z:\Busch\Studysites\Lowerlakes\Ruppia\MER_Coorong_eWater_2020_v1\Output\MER_Base_20170701_20200701.nc';
ncfile(1).symbol = {'-';'--'};
ncfile(1).colour = {[0 96 100]./255,[62 39 35]./255}; % Surface and Bottom
ncfile(1).legend = 'MER-Coorong';
ncfile(1).translate = 1;

% ncfile(2).name = 'Y:\GDSTN\TUFLOWFV\output_PH_tracer_scenarios_median\GLAD_EXT_SEDI_HIND_2D_000_bund_leaks_PH_tracer_bund_T02Er5_median_Jul_Sep.nc';
% ncfile(2).symbol = {'-';'--'};
% ncfile(2).colour = {[140,81,10]./255,[216,179,101]./255}; % Surface and Bottom
% ncfile(2).legend = 'Median';
% ncfile(2).translate = 1;

ncfile(2).name = 'Z:\Busch\Studysites\Lowerlakes\CEWH_2020\v001_CEW_2013_2020_v1\Output\lower_lakes.nc';
 ncfile(2).symbol = {'-';'-'};
 ncfile(2).colour = {[140,81,10]./255,[216,179,101]./255};% Surface and Bottom % Surface and Bottom
 ncfile(2).legend = 'CEW';
 ncfile(2).translate = 1;
% 
% 
%  ncfile(3).name = 'Y:\GDSTN\TUFLOWFV\output_PH_tracer_scenarios_high\GLAD_EXT_SEDI_HIND_2D_000_bund_leaks_PH_tracer_bund_T02Er5_high_Jul_Sep.nc';
%  ncfile(3).symbol = {'-';'--'};
%  ncfile(3).colour = {[90,180,172]./255,[1,102,94]./255}; % Surface and Bottom
%  ncfile(3).legend = 'High';
%  ncfile(3).translate = 1;
 

% ___________________________________________________________________Models



% Defaults_________________________________________________________________

% Makes start date, end date and datetick array
%def.datearray = datenum(yr,0def.datearray = datenum(yr,01:4:36,01);
%def.datearray = datenum(yr,1:12:96,01);

% yr = 2012;
% def.datearray = datenum(yr,01:01:04,01);

def.dateformat = 'mm/yyyy';
% Must have same number as variable to plot & in same order

def.dimensions = [20 8]; % Width & Height in cm

def.dailyave = 0; % 1 for daily average, 0 for off. Daily average turns off smoothing.
def.smoothfactor = 3; % Must be odd number (set to 3 if none)

def.fieldsymbol = {'.','.'}; % Cell with same number of levels
def.fieldcolour = {'m',[0.6 0.6 0.6]}; % Cell with same number of levels

def.font = 'Arial';

def.xlabelsize = 7;
def.ylabelsize = 7;
def.titlesize = 10;
def.legendsize = 6;
def.legendlocation = 'northeastoutside';

def.visible = 'off'; % on or off
