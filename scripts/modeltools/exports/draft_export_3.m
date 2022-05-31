function draft_export_3

addpath(genpath('../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

output_dir = 'Output/Export3/';

export(1).filename = '../../../../../Scratch/CDM/eWater2021_basecase_t3_all.nc';
export(1).shpfile = 'CoorongPolygons_DEW/7-CoorongSystem/CoorongSystem.shp';
export(1).CPS = 'Macroinvertebrates';
export(1).Indicator = 'Macroalgae';
export(1).time = [datenum(2020,04,01) datenum(2020,10,01)];
export(1).var1 = 'WQ_DIAG_MA2_HSI';
export(1).var2 = 'D';
export(1).conv1 = 1;
export(1).conv2 = 1;
export(1).trigger_val = 0.25;
export(1).trigger_val_2 = 0.00;


export(2).filename = '../../../../../Scratch/CDM/eWater2021_basecase_t3_all.nc';
export(2).shpfile = 'CoorongPolygons_DEW/7-CoorongSystem/CoorongSystem.shp';
export(2).CPS = 'Macroinvertebrates';
export(2).Indicator = 'Macroalgae';
export(2).time = [datenum(2020,10,01) datenum(2021,04,01)];
export(2).var1 = 'WQ_DIAG_MA2_HSI';
export(2).var2 = 'D';
export(2).conv1 = 1;
export(2).conv2 = 1;
export(2).trigger_val = 0.25;
export(2).trigger_val_2 = 0.00;




%_____________________________________________________________________



if ~exist(output_dir,'dir')
    mkdir(output_dir);
end

fid = fopen([output_dir,'export_3.csv'],'wt');
fprintf(fid,'CPS,Indicator,Start Time,End Time,Var,Trigger,Area (km2),Total Area (km2)\n');

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

total_area(1:length(utime),1) = 0;

for i = 1:length(utime)
    ttt = find(floor(mtime_clip) == utime(i));
    
    %Calculate daily mean
    data1_1(:,i) = mean(data1(:,ttt),2);
    data2_1(:,i) = mean(data2(:,ttt),2);
   
    %Do the export calc.
    sss = find(data1_1(:,i) >= trigger_val& ...
        data2_1(:,i) >= trigger_val_2);
    
    total_area(i) = sum(area(sss)) * 1e-6;
end
    
%fprintf(fid,'CPS,Indicator,Start Time,End Time,Var,Trigger,Value\n');

fprintf(fid,'%s,%s,%s,%s,%s,%4.4f,%4.4f,%5.5f\n',CPS,Indicator,datestr(time(1),'dd-mm-yyyy'),...
    datestr(time(2),'dd-mm-yyyy'),var1,trigger_val,mean(total_area),sum(area) * 1e-6)
    
plot(utime,total_area);datetick('x');hold on
plot([utime(1) utime(end)],[mean(total_area) mean(total_area)],'b');datetick('x');hold on

ylabel('Area (km^2)');

title(['Trigger Value: ',num2str(trigger_val)]);

legend({'Daily Area';'Mean'},'location','NorthWest');

thimagefile = [datestr(time(1),'yyyymmdd'),'_',datestr(time(2),'yyyymmdd'),'_',num2str(trigger_val),'.png'];

saveas(gcf,[output_dir,thimagefile]);

close;

end





