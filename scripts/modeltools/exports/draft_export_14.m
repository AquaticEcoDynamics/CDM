function draft_export_10

addpath(genpath('../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

output_dir = 'Output/Export14/';

export(1).filename = '../../../../../Scratch/CDM/eWater2021_basecase_t3_all.nc';
export(1).shpfile = 'CoorongPolygons_DEW/2-NorthLagoon/ExtendedNorth3_Merge.shp';
export(1).CPS = 'Trophic status (threat: eutrophication)';
export(1).Indicator = 'Total Chlorophyll-a';
export(1).time = [datenum(2020,04,01) datenum(2020,10,01)];
export(1).var1 = 'WQ_DIAG_PHY_TCHLA';
export(1).var2 = 'D';
export(1).conv1 = 1;
export(1).conv2 = 1;
export(1).trigger_val = 5;
export(1).trigger_val_2 = 0.00;
export(1).System = 'CNL';

export(2).filename = '../../../../../Scratch/CDM/eWater2021_basecase_t3_all.nc';
export(2).shpfile = 'CoorongPolygons_DEW/2-NorthLagoon/ExtendedNorth3_Merge.shp';
export(2).CPS = 'Trophic status (threat: eutrophication)';
export(2).Indicator = 'Total Chlorophyll-a';
export(2).time = [datenum(2020,10,01) datenum(2021,04,01)];
export(2).var1 = 'WQ_DIAG_PHY_TCHLA';
export(2).var2 = 'D';
export(2).conv1 = 1;
export(2).conv2 = 1;
export(2).trigger_val = 5;
export(2).trigger_val_2 = 0.00;
export(2).System = 'CNL';

export(3).filename = '../../../../../Scratch/CDM/eWater2021_basecase_t3_all.nc';
export(3).shpfile = 'CoorongPolygons_DEW/3-SouthLagoon/ExtendedSouth_Merge.shp';
export(3).CPS = 'Trophic status (threat: eutrophication)';
export(3).Indicator = 'Total Chlorophyll-a';
export(3).time = [datenum(2020,04,01) datenum(2020,10,01)];
export(3).var1 = 'WQ_DIAG_PHY_TCHLA';
export(3).var2 = 'D';
export(3).conv1 = 1;
export(3).conv2 = 1;
export(3).trigger_val = 10;
export(3).trigger_val_2 = 0.00;
export(3).System = 'CSL';

export(4).filename = '../../../../../Scratch/CDM/eWater2021_basecase_t3_all.nc';
export(4).shpfile = 'CoorongPolygons_DEW/3-SouthLagoon/ExtendedSouth_Merge.shp';
export(4).CPS = 'Trophic status (threat: eutrophication)';
export(4).Indicator = 'Total Chlorophyll-a';
export(4).time = [datenum(2020,10,01) datenum(2021,04,01)];
export(4).var1 = 'WQ_DIAG_PHY_TCHLA';
export(4).var2 = 'D';
export(4).conv1 = 1;
export(4).conv2 = 1;
export(4).trigger_val = 10;
export(4).trigger_val_2 = 0.00;
export(4).System = 'CSL';

% 




%_____________________________________________________________________



if ~exist(output_dir,'dir')
    mkdir(output_dir);
end

fid = fopen([output_dir,'export_14.csv'],'wt');
fprintf(fid,'CPS,Indicator,System,Start Time,End Time,Var,Trigger,Mean TCHLA (ug/L),Diff TCHLA (ug/L)\n');

for i = 1:length(export)
    
    export_data(export(i).filename,export(i).shpfile,export(i).CPS,...
    export(i).Indicator,export(i).time,export(i).var1,export(i).var2,...
    export(i).conv1,export(i).conv2,export(i).trigger_val,export(i).trigger_val_2,output_dir,fid,export(i).System);
end
fclose(fid);

end

function export_data(filename,shpfile,CPS,Indicator,time,var1,var2,conv1,conv2,trigger_val,trigger_val_2,output_dir,fid,System)
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

total_tchla(1:length(utime),1) = 0;

for i = 1:length(utime)
    ttt = find(floor(mtime_clip) == utime(i));
    
    %Calculate daily mean
    data1_1(:,i) = mean(data1(:,ttt),2);
    data2_1(:,i) = mean(data2(:,ttt),2);
   
    %Do the export calc.
    
    
    total_tchla(i) = mean(data1_1(:,i));
end
final_val = mean(total_tchla) - trigger_val;    
%fprintf(fid,'CPS,Indicator,Start Time,End Time,Var,Trigger,Value\n');

fprintf(fid,'%s,%s,%s,%s,%s,%s,%4.4f,%4.4f,%5.5f\n',CPS,Indicator,System,datestr(time(1),'dd-mm-yyyy'),...
    datestr(time(2),'dd-mm-yyyy'),var1,trigger_val,mean(total_tchla),final_val)
    
plot(utime,total_tchla);datetick('x');hold on
plot([utime(1) utime(end)],[mean(total_tchla) mean(total_tchla)],'b');datetick('x');hold on

ylabel('Daily Ave TCLHA (ug/L)');

title(['Trigger Value: ',num2str(trigger_val),', SYSTEM: ',System]);

legend({'Daily TCHLA';'Mean'},'location','NorthWest');

thimagefile = [datestr(time(1),'yyyymmdd'),'_',datestr(time(2),'yyyymmdd'),'_',num2str(trigger_val),'.png'];

saveas(gcf,[output_dir,thimagefile]);

close;

end





