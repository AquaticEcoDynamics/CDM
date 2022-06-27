clear all; close all;

load ../../../data/store/archive/cllmm.mat;

site_id_csl.A4261134.X = cllmm.A4261134.SAL.X;
site_id_csl.A4261134.Y = cllmm.A4261134.SAL.Y;

site_id_csl.A4261209.X = cllmm.A4261209.SAL.X;
site_id_csl.A4261209.Y = cllmm.A4261209.SAL.Y;

site_id_csl.A4261165.X = 345916;%cllmm.A4260572.SAL.X;
site_id_csl.A4261165.Y = 6038429;%cllmm.A4260572.SAL.Y;

% site_id.A4261043.X = cllmm.A4261043.SAL.X;
% site_id.A4261043.Y = cllmm.A4261043.SAL.Y;

save site_id_csl.mat site_id_csl -mat

sit = fieldnames(site_id_csl);

for i = 1:length(sit)
    S(i).X = site_id_csl.(sit{i}).X;
    S(i).Y = site_id_csl.(sit{i}).Y;
    S(i).Name = sit{i};
    S(i).Geometry = 'Point';
end
shapewrite(S,'CoorongPolygons_DEW/csl_Sites.shp');