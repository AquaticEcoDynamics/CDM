function draft_export_8(filename,output)

addpath(genpath('../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

output_dir = [output,'Export8/'];

export(1).filename = filename;
export(1).shpfile = 'CoorongPolygons_DEW/3-SouthLagoon/ExtendedSouth_Merge.shp';
export(1).CPS = 'Smallmouth hardyhead (Foodweb)';
export(1).Indicator = 'Water level';
export(1).time = [datenum(2020,04,01) datenum(2020,10,01)];
export(1).var1 = 'H';
export(1).var2 = 'D';
export(1).conv1 = 1;
export(1).conv2 = 1;
export(1).trigger_val = 0.4;
export(1).trigger_val_2 = 3;

export(2).filename = filename;
export(2).shpfile = 'CoorongPolygons_DEW/3-SouthLagoon/ExtendedSouth_Merge.shp';
export(2).CPS = 'Smallmouth hardyhead (Foodweb)';
export(2).Indicator = 'Water level';
export(2).time = [datenum(2020,04,01) datenum(2020,10,01)];
export(2).var1 = 'H';
export(2).var2 = 'D';
export(2).conv1 = 1;
export(2).conv2 = 1;
export(2).trigger_val = 0.8;
export(2).trigger_val_2 = 2;



export(3).filename = filename;
export(3).shpfile = 'CoorongPolygons_DEW/3-SouthLagoon/ExtendedSouth_Merge.shp';
export(3).CPS = 'Smallmouth hardyhead (Foodweb)';
export(3).Indicator = 'Water level';
export(3).time = [datenum(2020,10,01) datenum(2021,04,01)];
export(3).var1 = 'H';
export(3).var2 = 'D';
export(3).conv1 = 1;
export(3).conv2 = 1;
export(3).trigger_val = 0.4;
export(3).trigger_val_2 = 3;

export(4).filename = filename;
export(4).shpfile = 'CoorongPolygons_DEW/3-SouthLagoon/ExtendedSouth_Merge.shp';
export(4).CPS = 'Smallmouth hardyhead (Foodweb)';
export(4).Indicator = 'Water level';
export(4).time = [datenum(2020,10,01) datenum(2021,04,01)];
export(4).var1 = 'H';
export(4).var2 = 'D';
export(4).conv1 = 1;
export(4).conv2 = 1;
export(4).trigger_val = 0.8;
export(4).trigger_val_2 = 2;




%_____________________________________________________________________



if ~exist(output_dir,'dir')
    mkdir(output_dir);
end

fid = fopen([output_dir,'export_8.csv'],'wt');

perc = '%';
fprintf(fid,'CPS,Indicator,Start Time,End Time,Var,Trigger,Days (%s)\n',perc);

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

load salt.mat;

data = tfv_readnetcdf(filename,'names',{var1;var2;});

shp = shaperead(shpfile);

thetime = find(mtime >= time(1) & mtime < time(2));
mtime_clip = mtime(thetime);

bctime = find(salt.Date >= time(1) & salt.Date < time(2));
saltflow = salt.ML(bctime);
salttime = salt.Date(bctime);

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
    daily_wl(i,1) = mean(data1_1(:,i));
    
end
sss = find(daily_wl >= trigger_val & saltflow > trigger_val_2);



perc_days = (length(sss) / length(utime)) * 100;


%fprintf(fid,'CPS,Indicator,Start Time,End Time,Var,Trigger,Value\n');

fprintf(fid,'%s,%s,%s,%s,%s,%4.4f,%4.4f\n',CPS,Indicator,datestr(time(1),'dd-mm-yyyy'),...
    datestr(time(2),'dd-mm-yyyy'),var1,trigger_val,perc_days)
 figure('visible','off');
    
plot(utime,daily_wl);hold on;
plot(salttime,saltflow);hold on;%datetick('x');hold on
plot([utime(1) utime(end)],[trigger_val trigger_val],'b');hold on;%datetick('x');hold on

ylabel({'WL (mAHD)';'Salt Creek'});
xlim([time(1) time(2)]);darray = [time(1):(time(2)-time(1))/5:time(2)];set(gca,'xtick',darray,'xticklabel',datestr(darray,'mm-yy'));

title(['Trigger Value: ',num2str(trigger_val)]);

legend({'WL';'Trigger'},'location','NorthWest');

thimagefile = [datestr(time(1),'yyyymmdd'),'_',datestr(time(2),'yyyymmdd'),'_',num2str(trigger_val),'.png'];

saveas(gcf,[output_dir,thimagefile]);

close;

end





