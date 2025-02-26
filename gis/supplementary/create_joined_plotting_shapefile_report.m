clear all; close all;

% Script to create a single shapefile that contains the 31 material zones,
% as well as the Export locations (zone and point).


   
% shp = shaperead('../../scripts/modeltools/exports/CoorongPolygons_DEW/1-Estuary/Estuary.shp');
% 
% S(inc).X = shp.X;
% S(inc).Y = shp.Y;
% S(inc).Name = 'Estuary';
% S(inc).Plot_Order = inc;
% S(inc).Geometry = 'Polygon';
% inc = inc + 1;
% 
% shp = shaperead('../../scripts/modeltools/exports/CoorongPolygons_DEW/7-CoorongSystem/CoorongSystem.shp');
% 
% S(inc).X = shp.X;
% S(inc).Y = shp.Y;
% S(inc).Name = 'Coorong System';
% S(inc).Plot_Order = inc;
% S(inc).Geometry = 'Polygon';
% inc = inc + 1;

inc = 1;

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

thesites  = fliplr([12, 22, 23, 31, 32, 33, 41, 42, 43, 51, 53, 63, 73, 82, 92, 101, 102, 103]);





shp = shaperead('../../models/HCHB/hchb_tfvaed_Gen1.5_4PFT_MAG/model/gis/shp/31_material_zones.shp');


for i = 1:length(thesites)
    for j = 1:length(shp)
        if shp(j).Mat == thesites(i)
            S(inc).X = shp(j).X;
            S(inc).Y = shp(j).Y;
            S(inc).Name = ['Zone ',num2str(thesites(i))];
            S(inc).Plot_Order = inc;
            S(inc).Geometry = 'Polygon';
            inc = inc + 1;
        end
    end
end

shapewrite(S,'HCHB_Report_Sites.shp');
    