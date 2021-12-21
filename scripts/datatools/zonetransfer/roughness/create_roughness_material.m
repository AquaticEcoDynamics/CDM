clear all; close all;

fid = fopen('Material_Roughness_z31.fvc','wt');

shp = shaperead('../GIS/31_material_zones.shp');

[~,zones] = xlsread('Roughness_Values.xlsx','B2:B100');

for i = 1:length(zones)
    zoneID(i) = str2num(regexprep(zones{i},'Zone ',''));
end

[vals,~] = xlsread('Roughness_Values.xlsx','C2:C100');

for i = 1:length(shp)
    
    sss = find(zoneID == shp(i).Mat);
    
    fprintf(fid,'material == %d\n',shp(i).Mat);
    fprintf(fid,'bottom roughness == %4.4f\n',vals(sss));
    fprintf(fid,'end material\n');
    fprintf(fid,'\n');
    fprintf(fid,'\n');
end
fclose(fid);