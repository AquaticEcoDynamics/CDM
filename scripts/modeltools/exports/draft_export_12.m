function draft_export_12(filename,output)

addpath(genpath('../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

output_dir = [output,'Export12/'];


export(1).filename = filename;
export(1).shpfile = 'CoorongPolygons_DEW/3-SouthLagoon/ExtendedSouth_Merge.shp';
export(1).CPS = 'Surface water regime';
export(1).Indicator = 'Salinity';
export(1).time = [datenum(2020,01,01) datenum(2021,01,01)];
export(1).var1 = 'SAL';
export(1).var2 = 'D';
export(1).conv1 = 1;
export(1).conv2 = 1;
export(1).trigger_val = 35;
export(1).trigger_val_2 = 0.00;
export(1).type = 'lt';
export(1).matfile = 'site_id.mat';

export(2).filename = filename;
export(2).shpfile = 'CoorongPolygons_DEW/3-SouthLagoon/ExtendedSouth_Merge.shp';
export(2).CPS = 'Surface water regime';
export(2).Indicator = 'Salinity';
export(2).time = [datenum(2020,01,01) datenum(2021,01,01)];
export(2).var1 = 'SAL';
export(2).var2 = 'D';
export(2).conv1 = 1;
export(2).conv2 = 1;
export(2).trigger_val = 45;
export(2).trigger_val_2 = 0.00;
export(2).type = 'lt';
export(2).matfile = 'site_id_cnl.mat';

export(3).filename = filename;
export(3).shpfile = 'CoorongPolygons_DEW/3-SouthLagoon/ExtendedSouth_Merge.shp';
export(3).CPS = 'Surface water regime';
export(3).Indicator = 'Salinity';
export(3).time = [datenum(2020,01,01) datenum(2021,01,01)];
export(3).var1 = 'SAL';
export(3).var2 = 'D';
export(3).conv1 = 1;
export(3).conv2 = 1;
export(3).trigger_val = 60;
export(3).trigger_val_2 = 0.00;
export(3).type = 'lt';
export(3).matfile = 'site_id_csl.mat';


export(4).filename = filename;
export(4).shpfile = 'CoorongPolygons_DEW/3-SouthLagoon/ExtendedSouth_Merge.shp';
export(4).CPS = 'Surface water regime';
export(4).Indicator = 'Salinity';
export(4).time = [datenum(2020,01,01) datenum(2021,01,01)];
export(4).var1 = 'SAL';
export(4).var2 = 'D';
export(4).conv1 = 1;
export(4).conv2 = 1;
export(4).trigger_val = 100;
export(4).trigger_val_2 = 0.00;
export(4).type = 'gt';
export(4).matfile = 'site_id_csl.mat';


if ~exist(output_dir,'dir')
    mkdir(output_dir);
end

fid = fopen([output_dir,'export_12.csv'],'wt');

perc = '%';
fprintf(fid,'CPS,Indicator,Start Time,End Time,Zone,Var,Trigger,Percentage Months\n',perc);

for i = 1:length(export)
    
    export_data(export(i).filename,export(i).shpfile,export(i).CPS,...
    export(i).Indicator,export(i).time,export(i).var1,export(i).var2,...
    export(i).conv1,export(i).conv2,export(i).trigger_val,export(i).trigger_val_2,output_dir,fid,export(i).type,export(i).matfile);
end
fclose(fid);

end

function export_data(filename,shpfile,CPS,Indicator,time,var1,var2,conv1,conv2,trigger_val,trigger_val_2,output_dir,fid,type,matfile)
%_____________________________________________________________________
dat = tfv_readnetcdf(filename,'time',1);
mtime = dat.Time;

rawGeo = tfv_readnetcdf(filename,'timestep',1);

X = rawGeo.cell_X;
Y = rawGeo.cell_Y;

fd = load(matfile);

fdata = fd.(regexprep(matfile,'.mat',''));

sit = fieldnames(fdata);

for i = 1:length(sit)
    sdata(i,1) = fdata.(sit{i}).X;
    sdata(i,2) = fdata.(sit{i}).Y;
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

[~,mt,~] = datevec(double(uTime));

umt = unique(mt);

plotdate = datenum(2020,umt,01);

for i = 1:length(umt)
	sss = find (mt == umt(i));
	monthly_mean(i) = mean(uData(sss));
end


switch type
	case 'gt'
		sss = find(monthly_mean >= trigger_val);
		
		
		
	case 'lt'
		sss = find(monthly_mean <= trigger_val);
end

daily_perc = (length(sss) / length(monthly_mean)) * 100;




fprintf(fid,'%s,%s,%s,%s,%s,%s,%4.4f,%4.4f\n',CPS,Indicator,datestr(time(1),'dd-mm-yyyy'),...
    datestr(time(2),'dd-mm-yyyy'),regexprep(matfile,'.mat',''),var1,trigger_val,daily_perc)
 figure('visible','off');
   
plot(plotdate,monthly_mean);hold on;%datetick('x');hold on
plot([plotdate(1) plotdate(end)],[trigger_val trigger_val],'b');hold on;%datetick('x');hold on

ylabel(var1);
xlim([time(1) time(2)]);darray = [time(1):(time(2)-time(1))/5:time(2)];set(gca,'xtick',darray,'xticklabel',datestr(darray,'mm-yy'));

title(['Trigger Value: ',num2str(trigger_val)]);

legend({var1;'Trigger'},'location','NorthWest');

thimagefile = [datestr(time(1),'yyyymmdd'),'_',datestr(time(2),'yyyymmdd'),'_',num2str(trigger_val),'.png'];

saveas(gcf,[output_dir,thimagefile]);

close;

end
