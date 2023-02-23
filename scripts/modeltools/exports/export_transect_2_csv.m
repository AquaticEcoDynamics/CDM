function export_transect_2_csv
%clear all; close all;
addpath(genpath('../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

output_dir = ['Transects/'];

export(1).filename = 'Y:\CDM\HCHB_scenario_assessment\HCHB_GEN2_4yrs_20220620\output_basecase_hd_v2/hchb_Gen2_201707_202201_hd.nc';
export(1).shpfile = '../../../gis/supplementary/Coorong_Transect_Pnt.shp';
export(1).time = [datenum(2020,4,01) datenum(2020,10,01)];
export(1).var1 = 'SAL';
export(1).conv = 1; % Use to convert units
export(1).increment = 0.5;% Distance in KM to increment the output

export(2).filename = 'Y:\CDM\HCHB_scenario_assessment\HCHB_GEN2_4yrs_20220620\output_basecase_hd_v2/hchb_Gen2_201707_202201_hd.nc';
export(2).shpfile = '../../../gis/supplementary/Coorong_Transect_Pnt.shp';
export(2).time = [datenum(2020,4,01) datenum(2020,10,01)];
export(2).var1 = 'TEMP';
export(2).conv = 1;
export(2).increment = 0.5;

if ~exist(output_dir,'dir')
    mkdir(output_dir);
end

for gg = 1:length(export)

    
    filename = export(gg).filename;
    
    outfile = [output_dir,export(gg).var1,'.csv'];
    
    data = tfv_readnetcdf(filename,'names',{export(gg).var1});
    
    data.(export(gg).var1) = data.(export(gg).var1) * export(gg).conv;
    
    time = export(gg).time;
    
    rawGeo = tfv_readnetcdf(filename,'timestep',1);
    mtime = tfv_readnetcdf(filename,'time',1);
    
    X = rawGeo.cell_X;
    Y = rawGeo.cell_Y;
    
    shp = shaperead(export(gg).shpfile);

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
    
    pt_id_all = nearestNeighbor(dtri,query_points);
    
    [pt_id,ind] = unique(pt_id_all,'stable');
    
    
    
    dist_unique = dist(ind);
    
    dist_interp = [dist_unique(1):export(gg).increment:floor(dist_unique(end))];
        
    
    
    for i = 1:length(pt_id)
        Cell_3D_IDs = find(rawGeo.idx2==pt_id(i));
        surfIndex(i) = min(Cell_3D_IDs);
    end
    
    thetime = find(mtime.Time >= time(1) & ...
        mtime.Time < time(end));
    
    uData =  data.(export(gg).var1)(surfIndex,thetime);
    uTime = mtime.Time(thetime);
    extent(1:length(thetime),1) = 0;
    
    fid = fopen(outfile,'wt');
    fprintf(fid,'Time,Distance (km)\n');
    fprintf(fid,' ,');
    for i = 1:length(dist_interp)
        fprintf(fid,'%4.4f,',dist_interp(i));
    end
    fprintf(fid,'\n');
    for i = 1:length(uTime)
        
        fprintf(fid,'%s,',datestr(uTime(i),'dd/mm/yyyy HH:MM:SS'));
        data_interp = interp1(dist_unique,uData(:,i),dist_interp);
        
        for j = 1:length(dist_interp)
            
            
            
            fprintf(fid,'%4.4f,',data_interp(j));
        end
        fprintf(fid,'\n');
    end
    fclose(fid);
    
    

    
    clear data dist surfIndex thetime extent;
end