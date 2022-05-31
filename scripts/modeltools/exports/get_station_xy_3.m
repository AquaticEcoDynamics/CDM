clear all; close all;

load ../../../data/store/archive/cllmm.mat;

site_id_system.A4261134.X = cllmm.A4261134.SAL.X;
site_id_system.A4261134.Y = cllmm.A4261134.SAL.Y;

site_id_system.A4261135.X = cllmm.A4261135.SAL.X;
site_id_system.A4261135.Y = cllmm.A4261135.SAL.Y;

site_id_system.A4260572.X = 345916;%cllmm.A4260572.SAL.X;
site_id_system.A4260572.Y = 6038429;%cllmm.A4260572.SAL.Y;

% site_id.A4261043.X = cllmm.A4261043.SAL.X;
% site_id.A4261043.Y = cllmm.A4261043.SAL.Y;

save site_id_system.mat site_id_system -mat

sit = fieldnames(site_id_system);

for i = 1:length(sit)
    S(i).X = site_id_system.(sit{i}).X;
    S(i).Y = site_id_system.(sit{i}).Y;
    S(i).Name = sit{i};
    S(i).Geometry = 'Point';
end
shapewrite(S,'CoorongPolygons_DEW/system_Sites.shp');