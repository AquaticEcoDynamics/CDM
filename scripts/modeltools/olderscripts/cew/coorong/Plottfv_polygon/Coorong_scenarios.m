
 

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
 'TEMP',...
 'WQ_DIAG_HAB_RUPPIA_HSI',...
 'WQ_DIAG_TOT_TN',...
 'WQ_DIAG_TOT_TP',...
 'WQ_DIAG_PHY_TCHLA',...
     'WQ_NIT_AMM',...
    'WQ_NIT_NIT',...
    'WQ_DIAG_TOT_TP',...
    'WQ_PHS_FRP',...
    'WQ_OXY_OXY',...
    'WQ_DIAG_TOT_TSS',...
    'WQ_DIAG_TOT_TURBIDITY',...
};

def.cAxis(1).value = [0 200];   %'SAL',...
def.cAxis(2).value = [5 35];  %'TEMP',...
def.cAxis(3).value = [0 1];   %'RUPPIA_HSI',...
def.cAxis(4).value = [0 10];   %'TN',...
def.cAxis(5).value = [0 2];   %'TP',...
def.cAxis(6).value = [0 50];   %'TCHLA',...
def.cAxis(7).value = [0 0.2];         %'AMM',...
def.cAxis(8).value = [0 2];         %'NIT',...
def.cAxis(9).value = [0 0.4];         %'TP',...
def.cAxis(10).value = [0 0.2];         %'FRP',...
def.cAxis(11).value = [0 15];         %'OXY',...
def.cAxis(12).value = [0 30];         %'TSS',...
def.cAxis(13).value = [0 30];         %'TURB',...
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
isRange  = 0;
isRange_Bottom = 0;
Range_ALL = 0;

filetype = 'eps';
def.expected = 1; % plot expected WL

isFieldRange = 0;
fieldprctile = [10 90];

isHTML = 1;

yr = 2017;
def.datearray = datenum(yr,7:6:43,1);

%outputdirectory = './Timeseries_Basecase_June/RAW/';
%htmloutput = './Timeseries_Basecase_June/HTML/';
outputdirectory = './Final/compare_scens/RAW/';
htmloutput = './Final/compare_scens/HTML/';
% ____________________________________________________________Configuration





% Models___________________________________________________________________

 %ncfile(1).name = 'Y:\GDSTN\TUFLOWFV\output_PH_debug\tauce02v1\GLAD_EXT_SEDI_HIND_2D_000_bund_leaks_PH_v2_withbund_testingMZ_new_full_tauce02.nc';
  
ncfile(1).name = 'Z:\Busch\Studysites\Lowerlakes\Ruppia\MER_Coorong_eWater_2020_v1\Output\MER_Base_20170701_20200701.nc';
ncfile(1).symbol = {'-';'--'};
ncfile(1).colour = {[0 96 100]./255,[62 39 35]./255}; % Surface and Bottom
ncfile(1).legend = 'Base case';
ncfile(1).translate = 1;


ncfile(2).name = 'Z:\Busch\Studysites\Lowerlakes\Ruppia\MER_Coorong_eWater_2020_v1\Output\MER_Scen1_20170701_20200701.nc';
 ncfile(2).symbol = {'-';'--'};
 ncfile(2).colour = {[140,81,10]./255,[216,179,101]./255};% Surface and Bottom % Surface and Bottom
 ncfile(2).legend = 'no eWater';
 ncfile(2).translate = 1;

 
 ncfile(3).name = 'Z:\Busch\Studysites\Lowerlakes\Ruppia\MER_Coorong_eWater_2020_v1\Output\MER_Scen2_20170701_20200701.nc';
 ncfile(3).symbol = {'-';'--'};
 ncfile(3).colour = {[145,207,96]./255,[145,207,96]./255};% Surface and Bottom % Surface and Bottom
 ncfile(3).legend = 'mixed';
 ncfile(3).translate = 1;
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
