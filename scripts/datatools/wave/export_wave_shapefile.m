clear all; close all;

load('Coorong_swn_20201101_20210401_UA_Wind_200g_2000w\01_geometry\Bathymetry.mat');	

X(1) = xxx(1,1);
Y(1) = yyy(1,1);

X(4) = xxx(1,end);
Y(4) = yyy(1,end);

X(2) = xxx(end,1);
Y(2) = yyy(end,1);

X(3) = xxx(end,end);
Y(3) = yyy(end,end);

S(1).X = X;
S(1).Y = Y;
S(1).Name = 'Coorong_swn_20201101_20210401_UA_Wind_200g_2000w';
S(1).Geometry = 'Polygon';

shapewrite(S,'SWAN.shp');

