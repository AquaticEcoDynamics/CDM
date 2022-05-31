clear all; close all;

load ../../../data/store/archive/cllmm.mat;

site_id.A4261036.X = cllmm.A4261036.SAL.X;
site_id.A4261036.Y = cllmm.A4261036.SAL.Y;

site_id.A4261039.X = cllmm.A4261039.SAL.X;
site_id.A4261039.Y = cllmm.A4261039.SAL.Y;

site_id.A4261128.X = cllmm.A4261128.SAL.X;
site_id.A4261128.Y = cllmm.A4261128.SAL.Y;

site_id.A4261043.X = cllmm.A4261043.SAL.X;
site_id.A4261043.Y = cllmm.A4261043.SAL.Y;

save site_id.mat site_id -mat

sit = fieldnames(site_id);

for i = 1:length(sit)
    S(i).X = site_id.(sit{i}).X;
    S(i).Y = site_id.(sit{i}).Y;
    S(i).Name = sit{i};
    S(i).Geometry = 'Point';
end
shapewrite(S,'CoorongPolygons_DEW/Sites.shp');