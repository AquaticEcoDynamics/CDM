clear all; close all;

load ../../../data/store/archive/cllmm.mat;

site_id_csl.A4260633.X = cllmm.A4260633.SAL.X;
site_id_csl.A4260633.Y = cllmm.A4260633.SAL.Y;

site_id_csl.A4261209.X = cllmm.A4261209.SAL.X;
site_id_csl.A4261209.Y = cllmm.A4261209.SAL.Y;

site_id_csl.A4261165.X = cllmm.A4261165.SAL.X;
site_id_csl.A4261165.Y = cllmm.A4261165.SAL.Y;

% site_id.A4261043.X = cllmm.A4261043.SAL.X;
% site_id.A4261043.Y = cllmm.A4261043.SAL.Y;

save site_id_csl.mat site_id_csl -mat

sit = fieldnames(site_id);

for i = 1:length(sit)
    S(i).X = site_id_csl.(sit{i}).X;
    S(i).Y = site_id_csl.(sit{i}).Y;
    S(i).Name = sit{i};
    S(i).Geometry = 'Point';
end
shapewrite(S,'CoorongPolygons_DEW/CSL_Sites.shp');