%% A11650 - Coorong Barrage Release
% Define Bathymetry Points by Shapefile
%{
Description: Assigns cell centred bathymetry based on designation of data
via polygon shapefile

Inputs:
    - Interpolated cell centred bathymetry (via SMS) with multiple Z_*
    databases
    - Shapefile designating databases (integer based - i.e. requires
    conversion from integer to assigned bathymetry database

Outputs:
    - New cell centred elevation file with appropriate fields for TFV
    - Figure for checking bathymetry

%}
% MJB, Feb 2022
%
%% Prelim Formalities

% clear all;
% close all;
fclose all;
clc;

script = dbstack();
script = script.name;

save_csv = 0;

addpath(genpath('./functions/'))


%% Inputs

IN.cc_bathy = '../input/interp_scatter/demonstration/SMS/Coorong_detailed_006_cc_working.txt';
IN.raster_stats = '../input/interp_scatter/demonstration/QGIS/Coorong_detailed_006_cc_Coorong_Parnka_Narrows_survey_pts_202103_TIN_linear_mAHD.csv';
IN.shp = '../input/shapefiles/bathy_source_merged_004.shp';  % same as 002 but updated for new mesh
IN.mesh = '../../../mesh/Coorong_detailed_006.2dm';

OUT.root = ['./output/' script '/'];
OUT.path.csv  = [OUT.root 'csv/'];
OUT.name = 'Coorong_detailed_006_cc_2021_ParnkaNarrows_pts_TIN.csv';

if save_csv && ~isfolder(OUT.path.csv)
    mkdir(OUT.path.csv)
end


%% Processing inputs

DEF.key = {     %Value assigned in shapefile and what corresponding column to take from cell centred output
    1   'Parnka_2021'   % hacky patch to read in raster sampled values
    2   'Z_CI_006_20150101'
    3   'Z_Coorong_detailed_rma_001'
    };

DEF.fontSize = 9;


%% Load data

% Read cell centered bathymetry
CC = readtable(IN.cc_bathy);

% hacky patch to read in raster sampled values
opts = detectImportOptions(IN.raster_stats);
opts.EmptyLineRule = 'read';
opts = opts.setvartype("x_mean", 'double');
opts = opts.setvartype("x_median", 'double');
tmp = readtable(IN.raster_stats, opts);
CC.Parnka_2021 = tmp.x_median; clear tmp

% Read shapefile
[filepath, file, ~] = fileparts(IN.shp);
SHP = m_shaperead([filepath '/' file]);


% Read mesh
MESH = RD2DM(IN.mesh);
nodes = MESH.ND(:,2:3);

t_nd = MESH.E3T(:,2:4);
t_id = MESH.E3T(:,1);

q_nd = MESH.E4Q(:,2:5);
q_id = MESH.E4Q(:,1);

t_c = (nodes(t_nd(:,1),:)+nodes(t_nd(:,2),:)+nodes(t_nd(:,3),:))/3;
q_c = (nodes(q_nd(:,1),:)+nodes(q_nd(:,2),:)+nodes(q_nd(:,3),:)+nodes(q_nd(:,4),:))/4;

centres = [t_c t_id; q_c q_id];
centres = sortrows(centres,3);

% Sort faces based on id
t_nd = [t_nd, nan(size(t_id))];
[~, I] = sort([t_id; q_id]);
faces = [t_nd; q_nd]; 
faces = faces(I, :);

MESH = struct('X', centres(:, 1), 'Y', centres(:, 2), 'ID', centres(:, 3), ...
    'faces', faces, 'nodes', nodes);

clear nodes t_id q_id t_c q_c q_nd t_nd centres faces


%% Process

% Prepopulate data
T = table(CC.X, CC.Y, NaN(size(CC.X)), CC.ID, 'VariableNames', {'X' 'Y' 'Z' 'ID'});

% Loop through features and assign Z values
for aa = 1:length(SHP.dbfdata)
    key_val = SHP.dbfdata{aa};
    key_bathy = DEF.key{ismember([DEF.key{:, 1}], key_val), 2};
    coords = SHP.ncst{aa};
    
    lgc = inpolygon(T.X, T.Y, coords(:, 1), coords(:, 2));
    
    T.Z(lgc) = CC.(key_bathy)(lgc);
  
end

T.Z(isnan(T.Z)) = CC.Z_master(isnan(T.Z));

if any(isnan(T.Z))
    warning('NaNs in final bathymetry output. Check polygon defining inputs for coverage. Assigning "master" by default')    
end


%% Check bathymetry

fig = figure;
fig.Units = 'centimeters';
fig.PaperUnits = 'centimeters';
fig.Position = [2 2 40 20];
fig.PaperPosition = [0 0 fig.Position(3:4)];
fig.Visible = 'on';
fig.InvertHardcopy = 'off';
fig.Color = 'w';

ax = myaxes(fig, 1, 1, 'top_buff', 0.05, 'bot_buff', 0.05, ...
    'left_buff', 0.1, 'right_buff', 0.1, 'top_gap', 0.05);

hold(handle(ax(:)), 'on')
grid(handle(ax(:)), 'off')
box(handle(ax(:)), 'on')
linkaxes(ax(:), 'xy')
xticks(handle(ax(:)), [])
yticks(handle(ax(:)), [])
xlim(handle(ax(:)), [min(MESH.X) max(MESH.X)])
ylim(handle(ax(:)), [min(MESH.Y) max(MESH.Y)])
set(handle(ax(:)), 'Colormap', turbo)
set(handle(ax(:)), 'DataAspectRatio', [1, 1, 1])
set(handle(ax(:)), 'fontsize', 0.8*DEF.fontSize)
  
p = patch('Faces', MESH.faces, 'Vertices', MESH.nodes, 'parent', ax(1));
p.CData = T.Z;
p.FaceColor = 'flat';
p.EdgeColor = 'none';
    
cbar = colorbar(ax(1), 'location', 'southoutside');
cbar.Label.String = 'Elevation (mAHD)';
cbar.Label.FontWeight = 'bold';
cbar.Label.FontSize = DEF.fontSize;
caxis([-3 0.5])



%% Save output

if save_csv
    writetable(T, [OUT.path.csv OUT.name])
end

disp('All done!')
