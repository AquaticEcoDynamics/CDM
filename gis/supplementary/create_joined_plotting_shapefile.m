clear all; close all;

% Script to create a single shapefile that contains the 31 material zones,
% as well as the Export locations (zone and point).

shp = shaperead('../../models/HCHB/hchb_Gen1.5_20220523/model/gis/shp/31_material_zones.shp');

for i = 1:length(shp)
    Mat(i) = shp(i).Mat;
end

matsort = sort(Mat);

S = [];
inc = 1;

for i = 1:length(matsort)
    for j = 1:length(shp)
        if shp(j).Mat == matsort(i)
            S(inc).X = shp(j).X;
            S(inc).Y = shp(j).Y;
            S(inc).Name = ['Material Zone ',num2str(matsort(i))];
            S(inc).Plot_Order = inc;
            S(inc).Geometry = 'Polygon';
            inc = inc + 1;
        end
    end
end
   
shp = shaperead('../../scripts/modeltools/exports/CoorongPolygons_DEW/1-Estuary/Estuary.shp');

S(inc).X = shp.X;
S(inc).Y = shp.Y;
S(inc).Name = 'Estuary';
S(inc).Plot_Order = inc;
S(inc).Geometry = 'Polygon';
inc = inc + 1;

shp = shaperead('../../scripts/modeltools/exports/CoorongPolygons_DEW/7-CoorongSystem/CoorongSystem.shp');

S(inc).X = shp.X;
S(inc).Y = shp.Y;
S(inc).Name = 'Coorong System';
S(inc).Plot_Order = inc;
S(inc).Geometry = 'Polygon';
inc = inc + 1;

shp = shaperead('../../scripts/modeltools/exports/CoorongPolygons_DEW/2-NorthLagoon/ExtendedNorth3_Merge.shp');

S(inc).X = shp.X;
S(inc).Y = shp.Y;
S(inc).Name = 'CNL';
S(inc).Plot_Order = inc;
S(inc).Geometry = 'Polygon';
inc = inc + 1;

shp = shaperead('../../scripts/modeltools/exports/CoorongPolygons_DEW/3-SouthLagoon/ExtendedSouth_Merge.shp');

S(inc).X = shp.X;
S(inc).Y = shp.Y;
S(inc).Name = 'CSL';
S(inc).Plot_Order = inc;
S(inc).Geometry = 'Polygon';
inc = inc + 1;
    