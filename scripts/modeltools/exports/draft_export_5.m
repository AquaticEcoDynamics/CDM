function draft_export_5(filename,output)

addpath(genpath('../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

output_dir = [output,'Export5/'];


export(1).filename = filename;
export(1).shpfile = 'CoorongPolygons_DEW/3-SouthLagoon/ExtendedSouth_Merge.shp';
export(1).CPS = 'Fish diversity (species richness/biodisparity';
export(1).Indicator = 'Salinity';
export(1).time = [datenum(2020,01,01) datenum(2022,01,01)];
export(1).var1 = 'SAL';
export(1).var2 = 'D';
export(1).conv1 = 1;
export(1).conv2 = 1;
export(1).trigger_val = 40;
export(1).trigger_val_2 = 0.00;




if ~exist(output_dir,'dir')
    mkdir(output_dir);
end

fid = fopen([output_dir,'export_5.csv'],'wt');

perc = '%';
fprintf(fid,'CPS,Indicator,Start Time,End Time,Var,Trigger,Events (#)\n',perc);

for i = 1:length(export)
    
    export_data(export(i).filename,export(i).shpfile,export(i).CPS,...
    export(i).Indicator,export(i).time,export(i).var1,export(i).var2,...
    export(i).conv1,export(i).conv2,export(i).trigger_val,export(i).trigger_val_2,output_dir,fid);
end
fclose(fid);

end

function export_data(filename,shpfile,CPS,Indicator,time,var1,var2,conv1,conv2,trigger_val,trigger_val_2,output_dir,fid)
%_____________________________________________________________________
dat = tfv_readnetcdf(filename,'time',1);
mtime = dat.Time;

rawGeo = tfv_readnetcdf(filename,'timestep',1);

X = rawGeo.cell_X;
Y = rawGeo.cell_Y;

load site_id.mat;

sit = fieldnames(site_id);

for i = 1:length(sit)
    sdata(i,1) = site_id.(sit{i}).X;
    sdata(i,2) = site_id.(sit{i}).Y;
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

thecounter = 0;
event_num = 0;
daily_sal_ind = daily_sal;
daily_sal_ind(daily_sal_ind<trigger_val) = 0;
daily_sal_ind(daily_sal_ind>=trigger_val) = 1;

for i = 1:length(daily_sal_ind)
	if daily_sal_ind(i) == 1;
		thecounter = thecounter + 1;
	end
	
	if thecounter >= 60
		event_num = event_num + 1;
		thecounter = 0;
	end
	
	if daily_sal_ind(i) == 0;
		thecounter = 0;
	end
end


fprintf(fid,'%s,%s,%s,%s,%s,%4.4f,%4.4f\n',CPS,Indicator,datestr(time(1),'dd-mm-yyyy'),...
    datestr(time(2),'dd-mm-yyyy'),var1,trigger_val,event_num)
 figure('visible','off');
   
plot(daily_time,daily_sal);hold on;%datetick('x');hold on
plot([daily_time(1) daily_time(end)],[trigger_val trigger_val],'b');hold on;%datetick('x');hold on

ylabel('Salinity (psu)');
xlim([time(1) time(2)]);darray = [time(1):(time(2)-time(1))/5:time(2)];set(gca,'xtick',darray,'xticklabel',datestr(darray,'mm-yy'));

title(['Trigger Value: ',num2str(trigger_val)]);

legend({'SAL';'Trigger'},'location','NorthWest');

thimagefile = [datestr(time(1),'yyyymmdd'),'_',datestr(time(2),'yyyymmdd'),'_',num2str(trigger_val),'.png'];

saveas(gcf,[output_dir,thimagefile]);

close;

end
