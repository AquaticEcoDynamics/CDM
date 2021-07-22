%The is the configuration file for the transect_plot.m function.


% Configuration____________________________________________________________

yr = 2012;
rgh = '2012';

fielddata_matfile = '..\polygon_timeseries_plot\TWEED_WQ_sites.mat';
fielddata = 'Tweed';

points_file = 'Tweed_pnt.shp';


def.pdates(1).value = [datenum(2012,07,01) datenum(2012,08,01)];
def.pdates(2).value = [datenum(2012,08,01) datenum(2012,09,01)];
def.pdates(3).value = [datenum(2012,09,01) datenum(2012,10,01)];
def.pdates(4).value = [datenum(2012,10,01) datenum(2012,11,01)];
def.pdates(5).value = [datenum(2012,11,01) datenum(2012,12,01)];
def.pdates(6).value = [datenum(2012,12,01) datenum(2012,12,31)];





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

def.linedist = 500;%  in m

def.xlim = [0 32];% xlim in KM
def.xticks = [0:5:32];
def.xlabel = 'Distance from TWE-2 (km)';


varname = {...
    'SAL',...
    'TEMP',...
    'WQ_DIAG_PHY_TCHLA',...
    'WQ_DIAG_TOT_TN',...
    'WQ_NIT_AMM',...
    'WQ_NIT_NIT',...
    'WQ_DIAG_TOT_TP',...
    'WQ_PHS_FRP',...
    'WQ_OXY_OXY',...
    'WQ_DIAG_TOT_TSS',...
    'WQ_DIAG_TOT_TURBIDITY',...
};


def.cAxis(1).value = [0 45];         %'SAL',...
def.cAxis(2).value = [10 30];         %'TEMP',...
def.cAxis(3).value = [0 30];         %'TCHLA',...
def.cAxis(4).value = [0 2];         %'TN',...
def.cAxis(5).value = [0 0.2];         %'AMM',...
def.cAxis(6).value = [0 0.5];         %'NIT',...
def.cAxis(7).value = [0 0.4];         %'TP',...
def.cAxis(8).value = [0 0.2];         %'FRP',...
def.cAxis(9).value = [0 15];         %'OXY',...
def.cAxis(10).value = [0 30];         %'TSS',...
def.cAxis(11).value = [0 30];         %'TURB',...

 start_plot_ID = 1;
 end_plot_ID = 11;

%start_plot_ID = 25;


% Add field data to figure
plotvalidation = 1; % 1 or 0


istitled = 1;
isylabel = 1;
islegend = 1;
isYlim = 1;
isHTML = 1;
isSurf = 1; %plot surface (1) or bottom (0)
% ____________________________________________________________Configuration

% Models___________________________________________________________________


outputdirectory = '.\plotting_output_Tweed\';
htmloutput = '.\plotting_output_Tweed\';

% ____________________________________________________________Configuration

% Models___________________________________________________________________

% ncfile(1).name = 'Z:\Peisheng\Tweed\v3_smooth_twe2_polygon_offset_z2\Output\tweed.nc';
 ncfile(1).name = 'Z:\Peisheng\Tweed\v1_simple_mesh\Output\tweed.nc';
 ncfile(1).legend = 'Tracer Sim';
%
%  ncfile(2).name = 'T:/HN_Cal_v5/output/HN_Cal_2017_2018_kpo4_WQ.nc';
%  ncfile(2).legend = 'kPO4 == 0';



def.boxlegend = 'southwest';
def.rangelegend = 'northeast';

def.dimensions = [16 8]; % Width & Height in cm

def.visible = 'on'; % on or off
