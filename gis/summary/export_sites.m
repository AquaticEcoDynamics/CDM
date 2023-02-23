clear all; close all;

shp = shaperead('dew_WaterDataSA.shp');

inc = 1;

for i = 1:length(shp)
    switch shp(i).Name
        case 'A4261135'
            s(inc).X = shp(i).X;
            s(inc).Y = shp(i).Y;
            s(inc).Name = shp(i).Name;
            s(inc).Geometry = 'Point';
            
            inc = inc + 1;
%         case 'A4260633'
%             s(inc).X = shp(i).X;
%             s(inc).Y = shp(i).Y;
%             s(inc).Name = shp(i).Name;
%             s(inc).Geometry = 'Point';
%             
%             inc = inc + 1;
%             
%         case 'A4261209'
%             s(inc).X = shp(i).X;
%             s(inc).Y = shp(i).Y;
%             s(inc).Name = shp(i).Name;
%             s(inc).Geometry = 'Point';
%             
%             inc = inc + 1;
            
            
        otherwise
            
    end
    
end
shapewrite(s,'dew_single.shp');
    