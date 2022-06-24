function draft_export_6(filename,output)

addpath(genpath('../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

output_dir = [output,'Export6/'];

export(1).filename = filename;
export(1).shpfile = 'CoorongPolygons_DEW/1-Estuary/Estuary.shp';
export(1).CPS = 'Fish diversity (species richness/biodisparity';
export(1).Indicator = 'Murray Mouth morphology';
export(1).time = [datenum(2020,01,01) datenum(2021,01,01)];
export(1).var1 = 'D';
export(1).var2 = 'D';
export(1).conv1 = 1;
export(1).conv2 = 1;
export(1).trigger_val = 1;
export(1).trigger_val_2 = 0.00;
export(1).type = 'gt';
export(1).System = 'Estuary';


export(2).filename = filename;
export(2).shpfile = 'CoorongPolygons_DEW/1-Estuary/Estuary.shp';
export(2).CPS = 'Fish movement and recruitment (congolli and common galaxias)';
export(2).Indicator = 'Murray Mouth morphology';
export(2).time = [datenum(2020,05,01) datenum(2021,02,01)];
export(2).var1 = 'D';
export(2).var2 = 'D';
export(2).conv1 = 1;
export(2).conv2 = 1;
export(2).trigger_val = 0.3;
export(2).trigger_val_2 = 0.00;
export(2).type = 'gt';
export(2).System = 'Estuary';


export(3).filename = filename;
export(3).shpfile = 'CoorongPolygons_DEW/3-SouthLagoon/ExtendedSouth_Merge.shp';
export(3).CPS = 'Waterbirds (Shorebirds)';
export(3).Indicator = 'Water level';
export(3).time = [datenum(2020,09,01) datenum(2021,04,01)];
export(3).var1 = 'H';
export(3).var2 = 'D';
export(3).conv1 = 1;
export(3).conv2 = 1;
export(3).trigger_val = 0.4;
export(3).trigger_val_2 = 0.00;
export(3).type = 'gt';
export(3).System = 'CSL';


export(4).filename = filename;
export(4).shpfile = 'CoorongPolygons_DEW/3-SouthLagoon/ExtendedSouth_Merge.shp';
export(4).CPS = 'Waterbirds (Waterfowl)';
export(4).Indicator = 'Water level';
export(4).time = [datenum(2020,09,01) datenum(2021,04,01)];
export(4).var1 = 'H';
export(4).var2 = 'D';
export(4).conv1 = 1;
export(4).conv2 = 1;
export(4).trigger_val = 0.35;
export(4).trigger_val_2 = 0.00;
export(4).type = 'gt';
export(4).System = 'CSL';

export(5).filename = filename;
export(5).shpfile = 'CoorongPolygons_DEW/3-SouthLagoon/ExtendedSouth_Merge.shp';
export(5).CPS = 'Waterbirds (Piscivores)';
export(5).Indicator = 'Water level';
export(5).time = [datenum(2020,09,01) datenum(2021,04,01)];
export(5).var1 = 'H';
export(5).var2 = 'D';
export(5).conv1 = 1;
export(5).conv2 = 1;
export(5).trigger_val = -0.5;
export(5).trigger_val_2 = 0.00;
export(5).type = 'lt';
export(5).System = 'CSL';

export(6).filename = filename;
export(6).shpfile = 'CoorongPolygons_DEW/1-Estuary/Estuary.shp';
export(6).CPS = 'Fish movement and recruitment (congolli and common galaxias)';
export(6).Indicator = 'Salinity';
export(6).time = [datenum(2020,10,01) datenum(2021,02,01)];
export(6).var1 = 'SAL';
export(6).var2 = 'D';
export(6).conv1 = 1;
export(6).conv2 = 1;
export(6).trigger_val = 35;
export(6).trigger_val_2 = 0.00;
export(6).type = 'lt';
export(6).System = 'CSL';




%_____________________________________________________________________



if ~exist(output_dir,'dir')
    mkdir(output_dir);
end

fid = fopen([output_dir,'export_6.csv'],'wt');

perc = '%';
fprintf(fid,'CPS,Indicator,System,Start Time,End Time,Var,Trigger,Days (%s)\n',perc);

for i = 1:length(export)
    
    export_data(export(i).filename,export(i).shpfile,export(i).CPS,...
    export(i).Indicator,export(i).time,export(i).var1,export(i).var2,...
    export(i).conv1,export(i).conv2,export(i).trigger_val,export(i).trigger_val_2,output_dir,fid,export(i).type,export(i).System);
end
fclose(fid);

end

function export_data(filename,shpfile,CPS,Indicator,time,var1,var2,conv1,...
    conv2,trigger_val,trigger_val_2,output_dir,fid,type,System)
%_____________________________________________________________________
dat = tfv_readnetcdf(filename,'time',1);
mtime = dat.Time;

rawGeo = tfv_readnetcdf(filename,'timestep',1);

X = rawGeo.cell_X;
Y = rawGeo.cell_Y;


data = tfv_readnetcdf(filename,'names',{var1;var2;});

shp = shaperead(shpfile);

thetime = find(mtime >= time(1) & mtime < time(2));
mtime_clip = mtime(thetime);


utime = unique(floor(mtime_clip));

inpol = inpolygon(X,Y,shp.X,shp.Y);

pt_id = find(inpol == 1);

data1 = data.(var1)(pt_id,thetime) * conv1;
data2 = data.(var2)(pt_id,thetime) * conv2;

area = rawGeo.cell_A(pt_id);

total_wl(1:length(utime),1) = 0;

for i = 1:length(utime)
    ttt = find(floor(mtime_clip) == utime(i));
    
    %Calculate daily mean
    data1_1(:,i) = mean(data1(:,ttt),2);
    data2_1(:,i) = mean(data2(:,ttt),2);
   
    %Do the export calc.
    daily_wl(i) = mean(data1_1(:,i));
    
end

switch type
    case 'gt'

    sss = find(daily_wl >= trigger_val);
    
    case 'lt'
    sss = find(daily_wl <= trigger_val);
    otherwise
    
end
perc_days = (length(sss) / length(utime)) * 100;


%fprintf(fid,'CPS,Indicator,Start Time,End Time,Var,Trigger,Value\n');

fprintf(fid,'%s,%s,%s,%s,%s,%s,%4.4f,%4.4f\n',CPS,Indicator,System,datestr(time(1),'dd-mm-yyyy'),...
    datestr(time(2),'dd-mm-yyyy'),var1,trigger_val,perc_days)
   figure('visible','off');
  
plot(utime,daily_wl);hold on;%datetick('x');hold on
plot([utime(1) utime(end)],[trigger_val trigger_val],'b');hold on;%datetick('x');hold on

ylabel(var1);
xlim([time(1) time(2)]);darray = [time(1):(time(2)-time(1))/5:time(2)];set(gca,'xtick',darray,'xticklabel',datestr(darray,'mm-yy'));

title(['Trigger Value: ',num2str(trigger_val),', System: ',System]);

legend({var1;'Trigger'},'location','NorthWest');

thimagefile = [datestr(time(1),'yyyymmdd'),'_',datestr(time(2),'yyyymmdd'),'_',num2str(trigger_val),'.png'];

saveas(gcf,[output_dir,thimagefile]);

close;

end





