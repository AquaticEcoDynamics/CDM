function draft_export_9(filename,output)

addpath(genpath('../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

output_dir = [output,'Export9/'];

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
export(1).System = 'System-Wide';


export(2).filename = filename;
export(2).shpfile = 'CoorongPolygons_DEW/7-CoorongSystem/CoorongSystem.shp';
export(2).CPS = 'Waterbirds (Shorebirds)';
export(2).Indicator = 'Water depth';
export(2).time = [datenum(2020,09,01) datenum(2021,04,01)];
export(2).var1 = 'D';
export(2).var2 = 'D';
export(2).conv1 = 1;
export(2).conv2 = 1;
export(2).trigger_val = 0.20;
export(2).trigger_val_2 = 0.00;
export(2).type = 'lt';
export(2).System = 'System-Wide';

export(3).filename = filename;
export(3).shpfile = 'CoorongPolygons_DEW/2-NorthLagoon/ExtendedNorth3_Merge.shp';
export(3).CPS = 'Trophic status (threat: eutrophication)';
export(3).Indicator = 'Dissolved oxygen';
export(3).time = [datenum(2020,04,01) datenum(2020,10,01)];
export(3).var1 = 'WQ_OXY_OXY';
export(3).var2 = 'D';
export(3).conv1 = 32/1000;
export(3).conv2 = 1;
export(3).trigger_val = 6.5;
export(3).trigger_val_2 = 0.00;
export(3).type = 'gt';
export(3).System = 'CNL';

export(4).filename = filename;
export(4).shpfile = 'CoorongPolygons_DEW/2-NorthLagoon/ExtendedNorth3_Merge.shp';
export(4).CPS = 'Trophic status (threat: eutrophication)';
export(4).Indicator = 'Dissolved oxygen';
export(4).time = [datenum(2020,10,01) datenum(2021,04,01)];
export(4).var1 = 'WQ_OXY_OXY';
export(4).var2 = 'D';
export(4).conv1 = 32/1000;
export(4).conv2 = 1;
export(4).trigger_val = 6.5;
export(4).trigger_val_2 = 0.00;
export(4).type = 'gt';
export(4).System = 'CNL';

export(5).filename = filename;
export(5).shpfile = 'CoorongPolygons_DEW/1-Estuary/Estuary.shp';
export(5).CPS = 'Trophic status (threat: eutrophication)';
export(5).Indicator = 'Dissolved oxygen';
export(5).time = [datenum(2020,04,01) datenum(2020,10,01)];
export(5).var1 = 'WQ_OXY_OXY';
export(5).var2 = 'D';
export(5).conv1 = 32/1000;
export(5).conv2 = 1;
export(5).trigger_val = 6.5;
export(5).trigger_val_2 = 0.00;
export(5).type = 'gt';
export(5).System = 'ME';

export(6).filename = filename;
export(6).shpfile = 'CoorongPolygons_DEW/1-Estuary/Estuary.shp';
export(6).CPS = 'Trophic status (threat: eutrophication)';
export(6).Indicator = 'Dissolved oxygen';
export(6).time = [datenum(2020,10,01) datenum(2021,04,01)];
export(6).var1 = 'WQ_OXY_OXY';
export(6).var2 = 'D';
export(6).conv1 = 32/1000;
export(6).conv2 = 1;
export(6).trigger_val = 6.5;
export(6).trigger_val_2 = 0.00;
export(6).type = 'gt';
export(6).System = 'ME';







export(7).filename = filename;
export(7).shpfile = 'CoorongPolygons_DEW/3-SouthLagoon/ExtendedSouth_Merge.shp';
export(7).CPS = 'Trophic status (threat: eutrophication)';
export(7).Indicator = 'Dissolved oxygen';
export(7).time = [datenum(2020,04,01) datenum(2020,10,01)];
export(7).var1 = 'WQ_OXY_OXY';
export(7).var2 = 'D';
export(7).conv1 = 32/1000;
export(7).conv2 = 1;
export(7).trigger_val = 4;
export(7).trigger_val_2 = 0.00;
export(7).type = 'gt';
export(7).System = 'CSL';

export(8).filename = filename;
export(8).shpfile = 'CoorongPolygons_DEW/3-SouthLagoon/ExtendedSouth_Merge.shp';
export(8).CPS = 'Trophic status (threat: eutrophication)';
export(8).Indicator = 'Dissolved oxygen';
export(8).time = [datenum(2020,10,01) datenum(2021,04,01)];
export(8).var1 = 'WQ_OXY_OXY';
export(8).var2 = 'D';
export(8).conv1 = 32/1000;
export(8).conv2 = 1;
export(8).trigger_val = 4;
export(8).trigger_val_2 = 0.00;
export(8).type = 'gt';
export(8).System = 'CSL';



%_____________________________________________________________________



if ~exist(output_dir,'dir')
    mkdir(output_dir);
end

fid = fopen([output_dir,'export_9.csv'],'wt');
fprintf(fid,'CPS,Indicator,System,Start Time,End Time,Var,Trigger,Area (Ha),Total Area (Ha)\n');

for i = 1:length(export)
    
    export_data(export(i).filename,export(i).shpfile,export(i).CPS,...
    export(i).Indicator,export(i).time,export(i).var1,export(i).var2,...
    export(i).conv1,export(i).conv2,export(i).trigger_val,export(i).trigger_val_2,output_dir,fid,export(i).type,export(i).System);
end
fclose(fid);

end

function export_data(filename,shpfile,CPS,Indicator,time,var1,var2,conv1,conv2,trigger_val,trigger_val_2,output_dir,fid,type,system)
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
        case 'gt'
            sss = find(data1_1(:,i) >= trigger_val); 
    end
    
    total_area(i) = sum(area(sss)) * 1e-6;
end
    
total_area = total_area * 100;

%fprintf(fid,'CPS,Indicator,Start Time,End Time,Var,Trigger,Value\n');

fprintf(fid,'%s,%s,%s,%s,%s,%s,%4.4f,%4.4f,%5.5f\n',CPS,Indicator,system,datestr(time(1),'dd-mm-yyyy'),...
    datestr(time(2),'dd-mm-yyyy'),var1,trigger_val,mean(total_area),(sum(area) * 1e-6) * 100)
    
plot(utime,total_area);darray = [time(1):(time(2)-time(1))/5:time(2)];set(gca,'xtick',darray,'xticklabel',datestr(darray,'mm-yy'));hold on
plot([utime(1) utime(end)],[mean(total_area) mean(total_area)],'b');darray = [time(1):(time(2)-time(1))/5:time(2)];set(gca,'xtick',darray,'xticklabel',datestr(darray,'mm-yy'));hold on

ylabel('Area (km^2)');

title(['Trigger Value: ',num2str(trigger_val)]);

legend({'Daily Area';'Mean'},'location','NorthWest');

thimagefile = [datestr(time(1),'yyyymmdd'),'_',datestr(time(2),'yyyymmdd'),'_',num2str(trigger_val),'.png'];

saveas(gcf,[output_dir,thimagefile]);

close;

end





