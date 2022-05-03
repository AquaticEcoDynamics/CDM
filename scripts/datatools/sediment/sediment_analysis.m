clear all; close all;

addpath(genpath('../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

load('../../../data/store/ecology/sed.mat');
%load('../../../data/store/ecology/phenology.mat');

phenology = sed;

shp = shaperead('31_material_zones.shp');

startdate = datenum(2019,01,01);
enddate = datenum(2022,12,31);


outfile = ['Sediment_Analysis_',datestr(startdate,'yyyymmdd'),'_',datestr(enddate,'yyyymmdd'),'.csv'];
%outfile = ['Ruppia_Analysis_phenology_MAX_',datestr(startdate,'yyyymmdd'),'_',datestr(enddate,'yyyymmdd'),'.csv'];

sites = fieldnames(phenology);

vars = [];

for i = 1:length(sites)
    V = fieldnames(phenology.(sites{i}));
    vars = [vars;V];
end

uvars = unique(vars);

fid = fopen(outfile,'wt');
fprintf(fid,'Mean\n');
fprintf(fid,'Zone,');


for i = 1:length(uvars)
    fprintf(fid,'%s,',uvars{i});
end
fprintf(fid,'\n');


for i = 1:length(shp)
    
    fprintf(fid,'%d,',shp(i).Mat);
    
    
    for j = 1:length(uvars)
        data.(uvars{j}) = [];
    end
    
    for j = 1:length(sites)
        
        for k = 1:length(uvars)
            
            if isfield(phenology.(sites{j}),uvars{k})
                
                if inpolygon(phenology.(sites{j}).(uvars{k}).X,phenology.(sites{j}).(uvars{k}).Y,shp(i).X,shp(i).Y)
                    
                    sss = find(phenology.(sites{j}).(uvars{k}).Date >= startdate & ...
                        phenology.(sites{j}).(uvars{k}).Date <= enddate);
                    
                    if ~isempty(sss)
                        data.(uvars{k}) = [data.(uvars{k});phenology.(sites{j}).(uvars{k}).Data(sss)];
                    end
                    
                end
            end
        end
    end
    
    for j = 1:length(uvars)
        fprintf(fid,'%4.4f,',mean(data.(uvars{j})));
    end
    fprintf(fid,'\n');
end
fprintf(fid,'\n');
fprintf(fid,'\n');

fprintf(fid,'Max\n');
fprintf(fid,'Zone,');


for i = 1:length(uvars)
    fprintf(fid,'%s,',uvars{i});
end
fprintf(fid,'\n');


for i = 1:length(shp)
    
    fprintf(fid,'%d,',shp(i).Mat);
    
    
    for j = 1:length(uvars)
        data.(uvars{j}) = [];
    end
    
    for j = 1:length(sites)
        
        for k = 1:length(uvars)
            
            if isfield(phenology.(sites{j}),uvars{k})
                
                if inpolygon(phenology.(sites{j}).(uvars{k}).X,phenology.(sites{j}).(uvars{k}).Y,shp(i).X,shp(i).Y)
                    
                    sss = find(phenology.(sites{j}).(uvars{k}).Date >= startdate & ...
                        phenology.(sites{j}).(uvars{k}).Date <= enddate);
                    
                    if ~isempty(sss)
                        data.(uvars{k}) = [data.(uvars{k});phenology.(sites{j}).(uvars{k}).Data(sss)];
                    end
                    
                end
            end
        end
    end
    
    for j = 1:length(uvars)
        fprintf(fid,'%4.4f,',max(data.(uvars{j})));
    end
    fprintf(fid,'\n');
end
        
        
fclose(fid);close all; fclose all;        
        
        
        
        
        
        
        
        
        
        
        
        
