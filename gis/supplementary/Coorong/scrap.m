clear all; close all;

shp = shaperead('31_Zones_PHnumbering.shp');

fid = fopen('31_Zones_PHnumbering.csv','wt')

fprintf(fid,'Read Order,Name,Plot Order\n');

for i = 1:length(shp)
fprintf(fid,'%d,%s,%d\n',i,shp(i).Name,shp(i).Plot_Order);
end
fclose(fid);