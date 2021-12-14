clear all; close all;

shp = shaperead('DO_Sites.shp');

[snum,sstr] = xlsread('../../../../data/incoming/TandI_1/Logger/Logger_1.csv','A3:F4783');

for i = 1:length(sstr)
    
    temp = split(sstr{i},' ');
    
    switch length(temp)
        case 1
            mdate(i,1) = datenum([sstr{i}],['mm/dd/yy']);
        case 3
            mdate(i,1) = datenum([sstr{i}],['mm/dd/yy HH:MM:SS',' ',temp{3}]);
    end
    
end
    
DO.North_McGrath_Flat.WQ_OXY_OXY.Data = snum(:,3) * 1000/32;
DO.North_McGrath_Flat.WQ_OXY_OXY.Date = mdate;
DO.North_McGrath_Flat.WQ_OXY_OXY.Depth(1:length(mdate),1) = 0;
DO.North_McGrath_Flat.WQ_OXY_OXY.X = shp(1).X;
DO.North_McGrath_Flat.WQ_OXY_OXY.Y = shp(1).Y;
DO.North_McGrath_Flat.WQ_OXY_OXY.Agency = 'UA DO Logger';
DO.North_McGrath_Flat.WQ_OXY_OXY.Name = 'North McGrath Flat';

DO.North_McGrath_Flat.WQ_OXY_OXY_ADJUSTED.Data = snum(:,5) * 1000/32;
DO.North_McGrath_Flat.WQ_OXY_OXY_ADJUSTED.Date = mdate;
DO.North_McGrath_Flat.WQ_OXY_OXY_ADJUSTED.Depth(1:length(mdate),1) = 0;
DO.North_McGrath_Flat.WQ_OXY_OXY_ADJUSTED.X = shp(1).X;
DO.North_McGrath_Flat.WQ_OXY_OXY_ADJUSTED.Y = shp(1).Y;
DO.North_McGrath_Flat.WQ_OXY_OXY_ADJUSTED.Agency = 'UA DO Logger';
DO.North_McGrath_Flat.WQ_OXY_OXY_ADJUSTED.Name = 'North McGrath Flat';



DO.North_McGrath_Flat.TEMP.Data = snum(:,4);
DO.North_McGrath_Flat.TEMP.Date = mdate;
DO.North_McGrath_Flat.TEMP.Depth(1:length(mdate),1) = 0;
DO.North_McGrath_Flat.TEMP.X = shp(1).X;
DO.North_McGrath_Flat.TEMP.Y = shp(1).Y;
DO.North_McGrath_Flat.TEMP.Agency = 'UA DO Logger';
DO.North_McGrath_Flat.TEMP.Name = 'North McGrath Flat';

DO.North_McGrath_Flat.WQ_OXY_SAT.Data = snum(:,6);
DO.North_McGrath_Flat.WQ_OXY_SAT.Date = mdate;
DO.North_McGrath_Flat.WQ_OXY_SAT.Depth(1:length(mdate),1) = 0;
DO.North_McGrath_Flat.WQ_OXY_SAT.X = shp(1).X;
DO.North_McGrath_Flat.WQ_OXY_SAT.Y = shp(1).Y;
DO.North_McGrath_Flat.WQ_OXY_SAT.Agency = 'UA DO Logger';
DO.North_McGrath_Flat.WQ_OXY_SAT.Name = 'North McGrath Flat';


%_________________________________

clear mdate;

[snum,sstr] = xlsread('../../../../data/incoming/TandI_1/Logger/Logger_2.csv','A3:F4778');

for i = 1:length(sstr)
    
    temp = split(sstr{i},' ');
    
    switch length(temp)
        case 1
            mdate(i,1) = datenum([sstr{i}],['mm/dd/yy']);
        case 3
            mdate(i,1) = datenum([sstr{i}],['mm/dd/yy HH:MM:SS',' ',temp{3}]);
    end
    
end
    
DO.Salt_Creek.WQ_OXY_OXY.Data = snum(:,3) * 1000/32;
DO.Salt_Creek.WQ_OXY_OXY.Date = mdate;
DO.Salt_Creek.WQ_OXY_OXY.Depth(1:length(mdate),1) = 0;
DO.Salt_Creek.WQ_OXY_OXY.X = shp(1).X;
DO.Salt_Creek.WQ_OXY_OXY.Y = shp(1).Y;
DO.Salt_Creek.WQ_OXY_OXY.Agency = 'UA DO Logger';
DO.Salt_Creek.WQ_OXY_OXY.Name = 'Salt_Creek';

DO.Salt_Creek.WQ_OXY_OXY_ADJUSTED.Data = snum(:,5) * 1000/32;
DO.Salt_Creek.WQ_OXY_OXY_ADJUSTED.Date = mdate;
DO.Salt_Creek.WQ_OXY_OXY_ADJUSTED.Depth(1:length(mdate),1) = 0;
DO.Salt_Creek.WQ_OXY_OXY_ADJUSTED.X = shp(1).X;
DO.Salt_Creek.WQ_OXY_OXY_ADJUSTED.Y = shp(1).Y;
DO.Salt_Creek.WQ_OXY_OXY_ADJUSTED.Agency = 'UA DO Logger';
DO.Salt_Creek.WQ_OXY_OXY_ADJUSTED.Name = 'Salt_Creek';

DO.Salt_Creek.TEMP.Data = snum(:,4);
DO.Salt_Creek.TEMP.Date = mdate;
DO.Salt_Creek.TEMP.Depth(1:length(mdate),1) = 0;
DO.Salt_Creek.TEMP.X = shp(1).X;
DO.Salt_Creek.TEMP.Y = shp(1).Y;
DO.Salt_Creek.TEMP.Agency = 'UA DO Logger';
DO.Salt_Creek.TEMP.Name = 'Salt_Creek';

DO.Salt_Creek.WQ_OXY_SAT.Data = snum(:,6);
DO.Salt_Creek.WQ_OXY_SAT.Date = mdate;
DO.Salt_Creek.WQ_OXY_SAT.Depth(1:length(mdate),1) = 0;
DO.Salt_Creek.WQ_OXY_SAT.X = shp(1).X;
DO.Salt_Creek.WQ_OXY_SAT.Y = shp(1).Y;
DO.Salt_Creek.WQ_OXY_SAT.Agency = 'UA DO Logger';
DO.Salt_Creek.WQ_OXY_SAT.Name = 'Salt_Creek';


%_________________________________


save('../../../../data/store/ecology/DO_Logger.mat','DO','-mat');



