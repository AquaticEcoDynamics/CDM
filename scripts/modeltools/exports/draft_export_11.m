function draft_export_11(filename,output)

addpath(genpath('../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

output_dir = [output,'Export11/'];


export(1).filename = filename;
export(1).shpfile = 'CoorongPolygons_DEW/3-SouthLagoon/ExtendedSouth_Merge.shp';
export(1).CPS = 'Surface water regime';
export(1).Indicator = 'Water level';
export(1).time = [datenum(2020,06,01) datenum(2020,08,01)];
export(1).var1 = 'H';
export(1).var2 = 'D';
export(1).conv1 = 1;
export(1).conv2 = 1;
export(1).trigger_val = 0.3;
export(1).trigger_val_2 = 0.00;
export(1).type = 'gt';

export(2).filename = filename;
export(2).shpfile = 'CoorongPolygons_DEW/3-SouthLagoon/ExtendedSouth_Merge.shp';
export(2).CPS = 'Surface water regime';
export(2).Indicator = 'Water level';
export(2).time = [datenum(2020,06,01) datenum(2020,08,01)];
export(2).var1 = 'H';
export(2).var2 = 'D';
export(2).conv1 = 1;
export(2).conv2 = 1;
export(2).trigger_val = 0.2;
export(2).trigger_val_2 = 0.00;
export(2).type = 'lt';

export(3).filename = filename;
export(3).shpfile = 'CoorongPolygons_DEW/3-SouthLagoon/ExtendedSouth_Merge.shp';
export(3).CPS = 'Surface water regime';
export(3).Indicator = 'Water level';
export(3).time = [datenum(2020,09,01) datenum(2021,01,01)];
export(3).var1 = 'H';
export(3).var2 = 'D';
export(3).conv1 = 1;
export(3).conv2 = 1;
export(3).trigger_val = 0.2;
export(3).trigger_val_2 = 0.00;
export(3).type = 'gt';

export(4).filename = filename;
export(4).shpfile = 'CoorongPolygons_DEW/3-SouthLagoon/ExtendedSouth_Merge.shp';
export(4).CPS = 'Surface water regime';
export(4).Indicator = 'Water level';
export(4).time = [datenum(2020,09,01) datenum(2021,01,01)];
export(4).var1 = 'H';
export(4).var2 = 'D';
export(4).conv1 = 1;
export(4).conv2 = 1;
export(4).trigger_val = 0.15;
export(4).trigger_val_2 = 0.00;
export(4).type = 'lt';

export(5).filename = filename;
export(5).shpfile = 'CoorongPolygons_DEW/3-SouthLagoon/ExtendedSouth_Merge.shp';
export(5).CPS = 'Surface water regime';
export(5).Indicator = 'Water level';
export(5).time = [datenum(2020,01,01) datenum(2021,01,01)];
export(5).var1 = 'SAL';
export(5).var2 = 'D';
export(5).conv1 = 1;
export(5).conv2 = 1;
export(5).trigger_val = 100;
export(5).trigger_val_2 = 0.00;
export(5).type = 'lt';



if ~exist(output_dir,'dir')
    mkdir(output_dir);
end

fid = fopen([output_dir,'export_11.csv'],'wt');

perc = '%';
fprintf(fid,'CPS,Indicator,Start Time,End Time,Var,Trigger,Percentage\n',perc);

for i = 1:length(export)
    
    export_data(export(i).filename,export(i).shpfile,export(i).CPS,...
    export(i).Indicator,export(i).time,export(i).var1,export(i).var2,...
    export(i).conv1,export(i).conv2,export(i).trigger_val,export(i).trigger_val_2,output_dir,fid,export(i).type);
end
fclose(fid);

end

function export_data(filename,shpfile,CPS,Indicator,time,var1,var2,conv1,conv2,trigger_val,trigger_val_2,output_dir,fid,type)
%_____________________________________________________________________
dat = tfv_readnetcdf(filename,'time',1);
mtime = dat.Time;

rawGeo = tfv_readnetcdf(filename,'timestep',1);

X = rawGeo.cell_X;
Y = rawGeo.cell_Y;

load site_id_csl.mat;

sit = fieldnames(site_id_csl);

for i = 1:length(sit)
    sdata(i,1) = site_id_csl.(sit{i}).X;
    sdata(i,2) = site_id_csl.(sit{i}).Y;
end
data = tfv_readnetcdf(filename,'names',{var1;var2;});

%
thetime = find(mtime >= time(1) & mtime < time(2));
mtime_clip = mtime(thetime);


utime = unique(floor(mtime_clip));

dtri = DelaunayTri(double(X),double(Y));

query_points(:,1) = sdata(~isnan(sdata(:,1)),1);
query_points(:,2) = sdata(~isnan(sdata(:,2)),2);

pt_id = nearestNeighbor(dtri,query_points);

for i = 1:length(pt_id)
    Cell_3D_IDs = find(rawGeo.idx2==pt_id(i));
    surfIndex(i) = min(Cell_3D_IDs);
end


uData =  data.(var1)(surfIndex,thetime);
uTime = mtime_clip;

meanData = mean(uData,1);


daily_time = unique(floor(uTime));
daily_sal(1:length(daily_time),1) = 0;
for i = 1:length(daily_time)
    sss = find(floor(uTime) == daily_time(i));
    daily_sal(i) = mean(meanData(sss));
end

switch type
	case 'gt'
		sss = find(daily_sal >= trigger_val);
		
		
		
	case 'lt'
		sss = find(daily_sal <= trigger_val);
end

daily_perc = (length(sss) / length(daily_time)) * 100;




fprintf(fid,'%s,%s,%s,%s,%s,%4.4f,%4.4f\n',CPS,Indicator,datestr(time(1),'dd-mm-yyyy'),...
    datestr(time(2),'dd-mm-yyyy'),var1,trigger_val,daily_perc)
 figure('visible','off');
   
plot(daily_time,daily_sal);hold on;%datetick('x');hold on
plot([daily_time(1) daily_time(end)],[trigger_val trigger_val],'b');hold on;%datetick('x');hold on

ylabel(var1);
xlim([time(1) time(2)]);darray = [time(1):(time(2)-time(1))/5:time(2)];set(gca,'xtick',darray,'xticklabel',datestr(darray,'mm-yy'));

title(['Trigger Value: ',num2str(trigger_val)]);

legend({var1;'Trigger'},'location','NorthWest');

thimagefile = [datestr(time(1),'yyyymmdd'),'_',datestr(time(2),'yyyymmdd'),'_',num2str(trigger_val),'.png'];

saveas(gcf,[output_dir,thimagefile]);

close;

end
