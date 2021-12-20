clear all; close all;

fid = fopen('Material_Roughness_z31.fvc','wt');

shp = shaperead('../GIS/31_material_zones.shp');

for i = 1:length(shp)
    
    fprintf(fid,'material == %d\n',shp(i).Mat);
    fprintf(fid,'bottom roughness == 0.018\n');
    fprintf(fid,'end material\n');
    fprintf(fid,'\n');
    fprintf(fid,'\n');
end
fclose(fid);