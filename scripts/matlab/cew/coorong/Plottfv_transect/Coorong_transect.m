%The is the configuration file for the transect_plot.m function.


% Configuration____________________________________________________________

yr = 2017;
rgh = '2017';

fielddata_matfile = 'lowerlakes.mat';
fielddata = 'lowerlakes';

points_file = 'Transect_Coorong.shp';

for i=1:36
def.pdates(i).value = [datenum(2017,07+i-1,01) datenum(2017,07+i,01)];
end


def.binfielddata = 1;
% radius distance to include field data. Used to bin data where number of
% sites is higher, but the frequency of sampling is low. The specified
% value will also make where on the line each polygon will be created. So
% if radius == 5, then there will be a search polygon found at r*2, so 0km, 10km, 20km etc. In windy rivers these polygons may overlap.

def.binradius = 0.5;% in km;

%distance from model polyline to be consided.
%Field data further than specified distance won't be included.
%Even if found with search radius. This is to attempt to exclude data
%sampled outside of the domain.

def.linedist = 1500;%  in m

def.xlim = [0 110];% xlim in KM
def.xticks = [0:10:110];
def.xlabel = 'Distance from Goolwa (km)';
%def.xlabel

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


def.cAxis(1).value = [0 150];   %'SAL',...
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

 start_plot_ID = 5;
 end_plot_ID = 13;

%start_plot_ID = 25;


% Add field data to figure
plotvalidation = 1; % 1 or 0


istitled = 1;
isylabel = 1;
islegend = 1;
isYlim = 1;
isHTML = 1;
isSurf = 1; %plot surface (1) or bottom (0)
isSpherical = 0;
% ____________________________________________________________Configuration

% Models___________________________________________________________________


outputdirectory = '.\plotting_output_basecase\';
htmloutput = '.\plotting_output_basecase\';

% ____________________________________________________________Configuration

% Models___________________________________________________________________

% ncfile(1).name = 'Z:\Peisheng\Tweed\v3_smooth_twe2_polygon_offset_z2\Output\tweed.nc';
 ncfile(1).name = 'Z:\Busch\Studysites\Lowerlakes\Ruppia\MER_Coorong_eWater_2020_v1\Output\MER_Base_20170701_20200701.nc';
 ncfile(1).legend = 'Base case';
%
%  ncfile(2).name = 'T:/HN_Cal_v5/output/HN_Cal_2017_2018_kpo4_WQ.nc';
%  ncfile(2).legend = 'kPO4 == 0';



def.boxlegend = 'southwest';
def.rangelegend = 'northeast';

def.dimensions = [16 8]; % Width & Height in cm

def.visible = 'on'; % on or off
