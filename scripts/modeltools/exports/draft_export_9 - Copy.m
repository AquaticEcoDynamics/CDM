function draft_export_9(filename,output)

addpath(genpath('../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

output_dir = [output,'Export3/'];

export(1).filename = filename;
export(1).shpfile = 'CoorongPolygons_DEW/7-CoorongSystem/CoorongSystem.shp';
export(1).CPS = 'Waterbirds (Shorebirds)';
export(1).Indicator = 'Water depth';
export(1).time = [datenum(2020,09,01) datenum(2021,04,01)];
export(1).var1 = 'D';
export(1).var2 = 'D';
export(1).conv1 = 1;
export(1).conv2 = 1;
export(1).trigger_val = 0.10;
export(1).trigger_val_2 = 0.00;
export(1).type = 'lt';

export(1).filename = filename;
export(1).shpfile = 'CoorongPolygons_DEW/7-CoorongSystem/CoorongSystem.shp';
export(1).CPS = 'Waterbirds (Shorebirds)';
export(1).Indicator = 'Water depth';
export(1).time = [datenum(2020,09,01) datenum(2021,04,01)];
export(1).var1 = 'D';
export(1).var2 = 'D';
export(1).conv1 = 1;
export(1).conv2 = 1;
export(1).trigger_val = 0.20;
export(1).trigger_val_2 = 0.00;
export(1).type = 'lt';




%_____________________________________________________________________



if ~exist(output_dir,'dir')
    mkdir(output_dir);
end

fid = fopen([output_dir,'export_9.csv'],'wt');
fprintf(fid,'CPS,Indicator,Start Time,End Time,Var,Trigger,Area (Ha),Total Area (Ha)\n');

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
    switch type
        case 'lt'
            sss = find(data1_1(:,i) <= trigger_val);
        case gt
            sss = find(data1_1(:,i) >= trigger_val); 
    end
    
    total_area(i) = sum(area(sss)) * 1e-6;
end
    
total_area = total_area * 100;

%fprintf(fid,'CPS,Indicator,Start Time,End Time,Var,Trigger,Value\n');

fprintf(fid,'%s,%s,%s,%s,%s,%4.4f,%4.4f,%5.5f\n',CPS,Indicator,datestr(time(1),'dd-mm-yyyy'),...
    datestr(time(2),'dd-mm-yyyy'),var1,trigger_val,mean(total_area),(sum(area) * 1e-6) * 100)
    
plot(utime,total_area);datetick('x');hold on
plot([utime(1) utime(end)],[mean(total_area) mean(total_area)],'b');datetick('x');hold on

ylabel('Area (km^2)');

title(['Trigger Value: ',num2str(trigger_val)]);

legend({'Daily Area';'Mean'},'location','NorthWest');

thimagefile = [datestr(time(1),'yyyymmdd'),'_',datestr(time(2),'yyyymmdd'),'_',num2str(trigger_val),'.png'];

saveas(gcf,[output_dir,thimagefile]);

close;

end





