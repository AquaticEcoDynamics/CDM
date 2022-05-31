
clear; close all;

ncfile='../../../../../Scratch/CDM/eWater2021_basecase_t3_all.nc';
sal0=ncread(ncfile,'SAL');
data = tfv_readnetcdf(ncfile,'names',{'cell_X';'cell_Y';'cell_A'});clear functions;
names = tfv_infonetcdf(ncfile);
mdata = tfv_readnetcdf(ncfile,'time',1);clear functions;
Time = mdata.Time;

shpfile='CoorongPolygons_DEW/7-CoorongSystem/CoorongSystem.shp';
shp = shaperead(shpfile);

pgon=polyshape(shp.X,shp.Y);
plot(pgon);

disp(['reading GIS']);

%%
for i = 1:length(shp)

    inpol = inpolygon(data.cell_X,data.cell_Y,shp(i).X,shp(i).Y);

    ttt = find(inpol == 1);
    fsite(i).theID = ttt;
   % fsite(i).Name = shp(i).Name;

end

%%
t1=datenum(2020,1,1);
t2=datenum(2021,1,1);

%ind1=find(abs(Time-t1)==min(abs(Time-t1)));
[~,ind1] = min(abs(Time-t1));
%ind2=find(abs(Time-t2)==min(abs(Time-t2)));
[~,ind2] = min(abs(Time-t2));

sal=sal0(fsite(1).theID,ind1:ind2);
area = data.cell_A(fsite(1).theID)

TA=[];
for ii=1:size(sal,2)
    tmpsal=sal(:,ii);
    tmpind=find(tmpsal<=25);
    TA(ii)=sum(area(tmpind));
end

datearray=datenum(2020,1:3:13,1);
plot(Time(ind1:ind2),TA/1e6);
set(gca,'XTick',datearray,'XTickLabel',datestr(datearray,'mmm'));
