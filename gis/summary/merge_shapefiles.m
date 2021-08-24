clear all; close all;

int = 1;

shp = shaperead('dew_barrage.shp');

for i = 1:length(shp)
    S(int).Legend = 'DEW Barrage';
    S(int).Agency = shp(i).Agency;
    S(int).X = shp(i).X;
    S(int).Y = shp(i).Y;
    S(int).Name = shp(i).Name;
    S(int).Geometry = 'Point';
    int = int + 1;
end

shp = shaperead('dew_tide_VH.shp');

for i = 1:length(shp)
    S(int).Legend = 'DEW Tide';
    S(int).Agency = shp(i).Agency;
    S(int).X = shp(i).X;
    S(int).Y = shp(i).Y;
    S(int).Name = shp(i).Name;
    S(int).Geometry = 'Point';
    int = int + 1;
end

shp = shaperead('dew_WaterDataSA.shp');

for i = 1:length(shp)
    S(int).Legend = 'DEW WaterDataSA';
    S(int).Agency = shp(i).Agency;
    S(int).X = shp(i).X;
    S(int).Y = shp(i).Y;
    S(int).Name = shp(i).Name;
    S(int).Geometry = 'Point';
    int = int + 1;
end

shp = shaperead('NRM_metdata.shp');

for i = 1:length(shp)
    S(int).Legend = 'NRM Met';
    S(int).Agency = shp(i).Agency;
    S(int).X = shp(i).X;
    S(int).Y = shp(i).Y;
    S(int).Name = shp(i).Name;
    S(int).Geometry = 'Point';
    int = int + 1;
end

shp = shaperead('UA_Coorong_WQ.shp');

for i = 1:length(shp)
    S(int).Legend = 'UA Coorong WQ';
    S(int).Agency = shp(i).Agency;
    S(int).X = shp(i).X;
    S(int).Y = shp(i).Y;
    S(int).Name = shp(i).Name;
    S(int).Geometry = 'Point';
    int = int + 1;
end

shp = shaperead('UA_temperature_loggers.shp');

for i = 1:length(shp)
    S(int).Legend = 'UA Temperature Loggers';
    S(int).Agency = shp(i).Agency;
    S(int).X = shp(i).X;
    S(int).Y = shp(i).Y;
    S(int).Name = shp(i).Name;
    S(int).Geometry = 'Point';
    int = int + 1;
end

shp = shaperead('UA_wave_wind.shp');

for i = 1:length(shp)
    S(int).Legend = 'UA Wave';
    S(int).Agency = shp(i).Agency;
    S(int).X = shp(i).X;
    S(int).Y = shp(i).Y;
    S(int).Name = shp(i).Name;
    S(int).Geometry = 'Point';
    int = int + 1;
end

shapewrite(S,'Merged.shp');