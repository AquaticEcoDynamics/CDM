clear all; close all;

shp = shaperead('../../../../gis/summary/Ruppia_2-3-3_Database_v2.shp');

[snum,sstr] = xlsread('../../../../data/incoming/TandI_2/UA_Ruppia/Ruppia_2-3-3_Database/seasonal sampling 20210304.xlsx','seasonal.sample','A2:D1188');

outfile = '../../../../data/incoming/TandI_2/UA_Ruppia/Ruppia_2-3-3_Database/Seasonal_sites.csv';

fid = fopen(outfile,'wt');

fprintf(fid,'Site Code,Bag Code,X,Y,Lat,Lon\n');
% 
 for i = 1:length(snum)
     
     for j = 1:length(shp)
         
         if strcmpi(sstr{i,1},shp(j).Code) == 1
            
             fprintf(fid,'%s,%s,%10.4f,%10.4f,%4.4f,%4.4f\n',sstr{i,1},regexprep(sstr{i,3},'–','-'),shp(j).X,shp(j).Y,shp(j).lat,shp(j).lon);
             
         end
     end
 end
 
 fclose(fid);
     
     