function draft_export_4

addpath(genpath('../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

output_dir = 'Output/Export4/';

export(1).filename = '../../../../../Scratch/CDM/eWater2021_basecase_t3_all.nc';
export(1).shpfile = '../../../gis/supplementary/Coorong_Transect_Pnt.shp';
export(1).CPS = 'Fish diversity (species richness/biodisparity';
export(1).Indicator = 'Salinity';
export(1).time = [datenum(2020,4,01) datenum(2020,10,01)];
export(1).var1 = 'SAL';
export(1).var2 = 'D';
export(1).conv1 = 1;
export(1).conv2 = 1;
export(1).trigger_val = 30;
export(1).trigger_val_2 = 0.00;
export(1).type = 'lt';
export(1).System = 'Transect';

export(2).filename = '../../../../../Scratch/CDM/eWater2021_basecase_t3_all.nc';
export(2).shpfile = '../../../gis/supplementary/Coorong_Transect_Pnt.shp';
export(2).CPS = 'Fish diversity (species richness/biodisparity';
export(2).Indicator = 'Salinity';
export(2).time = [datenum(2020,10,01) datenum(2021,03,01)];
export(2).var1 = 'SAL';
export(2).var2 = 'D';
export(2).conv1 = 1;
export(2).conv2 = 1;
export(2).trigger_val = 30;
export(2).trigger_val_2 = 0.00;
export(2).type = 'lt';
export(2).System = 'Transect';

export(3).filename = '../../../../../Scratch/CDM/eWater2021_basecase_t3_all.nc';
export(3).shpfile = '../../../gis/supplementary/Coorong_Transect_Pnt.shp';
export(3).CPS = 'Fish diversity (species richness/biodisparity';
export(3).Indicator = 'Salinity';
export(3).time = [datenum(2020,4,01) datenum(2020,10,01)];
export(3).var1 = 'SAL';
export(3).var2 = 'D';
export(3).conv1 = 1;
export(3).conv2 = 1;
export(3).trigger_val = 60;
export(3).trigger_val_2 = 0.00;
export(3).type = 'lt';
export(3).System = 'Transect';

export(4).filename = '../../../../../Scratch/CDM/eWater2021_basecase_t3_all.nc';
export(4).shpfile = '../../../gis/supplementary/Coorong_Transect_Pnt.shp';
export(4).CPS = 'Fish diversity (species richness/biodisparity';
export(4).Indicator = 'Salinity';
export(4).time = [datenum(2020,10,01) datenum(2021,03,01)];
export(4).var1 = 'SAL';
export(4).var2 = 'D';
export(4).conv1 = 1;
export(4).conv2 = 1;
export(4).trigger_val = 60;
export(4).trigger_val_2 = 0.00;
export(4).type = 'lt';
export(4).System = 'Transect';

export(5).filename = '../../../../../Scratch/CDM/eWater2021_basecase_t3_all.nc';
export(5).shpfile = '../../../gis/supplementary/Coorong_Transect_Pnt.shp';
export(5).CPS = 'Fish diversity (species richness/biodisparity';
export(5).Indicator = 'Salinity';
export(5).time = [datenum(2020,4,01) datenum(2020,10,01)];
export(5).var1 = 'SAL';
export(5).var2 = 'D';
export(5).conv1 = 1;
export(5).conv2 = 1;
export(5).trigger_val = 100;
export(5).trigger_val_2 = 0.00;
export(5).type = 'lt';
export(5).System = 'Transect';

export(6).filename = '../../../../../Scratch/CDM/eWater2021_basecase_t3_all.nc';
export(6).shpfile = '../../../gis/supplementary/Coorong_Transect_Pnt.shp';
export(6).CPS = 'Fish diversity (species richness/biodisparity';
export(6).Indicator = 'Salinity';
export(6).time = [datenum(2020,10,01) datenum(2021,03,01)];
export(6).var1 = 'SAL';
export(6).var2 = 'D';
export(6).conv1 = 1;
export(6).conv2 = 1;
export(6).trigger_val = 100;
export(6).trigger_val_2 = 0.00;
export(6).type = 'lt';
export(6).System = 'Transect';

export(7).filename = '../../../../../Scratch/CDM/eWater2021_basecase_t3_all.nc';
export(7).shpfile = '../../../gis/supplementary/Coorong_Transect_Pnt.shp';
export(7).CPS = 'Waterbirds (Shorebirds)';
export(7).Indicator = 'Salinity';
export(7).time = [datenum(2020,09,01) datenum(2021,05,01)];
export(7).var1 = 'SAL';
export(7).var2 = 'D';
export(7).conv1 = 1;
export(7).conv2 = 1;
export(7).trigger_val = 140;
export(7).trigger_val_2 = 0.00;
export(7).type = 'lt';
export(7).System = 'Transect';

export(8).filename = '../../../../../Scratch/CDM/eWater2021_basecase_t3_all.nc';
export(8).shpfile = '../../../gis/supplementary/Coorong_Transect_Pnt.shp';
export(8).CPS = 'Waterbirds (Piscivores)';
export(8).Indicator = 'Salinity';
export(8).time = [datenum(2020,09,01) datenum(2021,05,01)];
export(8).var1 = 'SAL';
export(8).var2 = 'D';
export(8).conv1 = 1;
export(8).conv2 = 1;
export(8).trigger_val = 45;
export(8).trigger_val_2 = 0.00;
export(8).type = 'lt';
export(8).System = 'Transect';

export(9).filename = '../../../../../Scratch/CDM/eWater2021_basecase_t3_all.nc';
export(9).shpfile = '../../../gis/supplementary/Coorong_Transect_Pnt.shp';
export(9).CPS = 'Waterbirds (Piscivores)';
export(9).Indicator = 'Salinity';
export(9).time = [datenum(2020,09,01) datenum(2021,05,01)];
export(9).var1 = 'SAL';
export(9).var2 = 'D';
export(9).conv1 = 1;
export(9).conv2 = 1;
export(9).trigger_val = 100;
export(9).trigger_val_2 = 0.00;
export(9).type = 'lt';
export(9).System = 'Transect';

export(10).filename = '../../../../../Scratch/CDM/eWater2021_basecase_t3_all.nc';
export(10).shpfile = '../../../gis/supplementary/Coorong_Transect_Pnt.shp';
export(10).CPS = 'Waterbirds (Piscivores)';
export(10).Indicator = 'Salinity';
export(10).time = [datenum(2020,01,01) datenum(2021,01,01)];
export(10).var1 = 'SAL';
export(10).var2 = 'D';
export(10).conv1 = 1;
export(10).conv2 = 1;
export(10).trigger_val = 60;
export(10).trigger_val_2 = 0.00;
export(10).type = 'lt';
export(10).System = 'Transect';



if ~exist(output_dir,'dir')
    mkdir(output_dir);
end

fid = fopen([output_dir,'export_4.csv'],'wt');

perc = '%';
fprintf(fid,'CPS,Indicator,System,Start Time,End Time,Var,Trigger,Extent (km)\n',perc);

for i = 1:length(export)
    
    export_data(export(i).filename,export(i).shpfile,export(i).CPS,...
    export(i).Indicator,export(i).time,export(i).var1,export(i).var2,...
    export(i).conv1,export(i).conv2,export(i).trigger_val,export(i).trigger_val_2,output_dir,fid,export(i).type,export(i).System);
end
fclose(fid);

end




%_______________________________________________________________________
function export_data(filename,shpfile,CPS,Indicator,time,var1,var2,conv1,...
    conv2,trigger_val,trigger_val_2,output_dir,fid,type,System)

data = tfv_readnetcdf(filename,'names',{var1;var2;});


rawGeo = tfv_readnetcdf(filename,'timestep',1);
mtime = tfv_readnetcdf(filename,'time',1);

X = rawGeo.cell_X;
Y = rawGeo.cell_Y;

shp = shaperead(shpfile);

for i = 1:length(shp)
    sdata(i,1) = shp(i).X;
    sdata(i,2) = shp(i).Y;
end

dist(1,1) = 0;

for i = 2:length(shp)
    dist(i,1) = sqrt(power((sdata(i,1) - sdata(i-1,1)),2) + power((sdata(i,2)- sdata(i-1,2)),2)) + dist(i-1,1);
end

dist = dist / 1000;


dtri = DelaunayTri(double(X),double(Y));

query_points(:,1) = sdata(~isnan(sdata(:,1)),1);
query_points(:,2) = sdata(~isnan(sdata(:,2)),2);

pt_id = nearestNeighbor(dtri,query_points);

for i = 1:length(pt_id)
    Cell_3D_IDs = find(rawGeo.idx2==pt_id(i));
    surfIndex(i) = min(Cell_3D_IDs);
end

thetime = find(mtime.Time >= time(1) & ...
    mtime.Time < time(end));

uData =  data.(var1)(surfIndex,thetime);
uTime = mtime.Time(thetime);
extent(1:length(thetime),1) = 0;

for i = 1:length(uTime)
    
    switch type
        case 'gt'

        sss = find(uData(:,i) >= trigger_val);

        case 'lt'
        sss = find(uData(:,i) <= trigger_val);
        otherwise
    
    end
    
    extent(i) = dist(sss(end));
    
end



fprintf(fid,'%s,%s,%s,%s,%s,%s,%4.4f,%4.4f\n',CPS,Indicator,System,datestr(time(1),'dd-mm-yyyy'),...
    datestr(time(2),'dd-mm-yyyy'),var1,trigger_val,mean(extent))
    

    
plot(uTime,extent);datetick('x','mmm');hold on
plot([uTime(1) uTime(end)],[mean(extent) mean(extent)],'b');datetick('x');hold on

ylabel('Extent (km)');

title(['Trigger Value: ',num2str(trigger_val),', System: ',System]);

legend({'Extent (km)','Mean (km)'},'location','NorthWest');

thimagefile = [datestr(time(1),'yyyymmdd'),'_',datestr(time(2),'yyyymmdd'),'_',num2str(trigger_val),'.png'];

saveas(gcf,[output_dir,thimagefile]);

close;




end