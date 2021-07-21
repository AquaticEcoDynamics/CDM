clear all; close all;

load UAraw.mat;

sites = fieldnames(UAraw);

vars = [];

for i = 1:length(sites)
    
    vars = [vars;fieldnames(UAraw.(sites{i}))];
    
end
uvars = unique(vars);

fid = fopen('Conversion.csv','wt');

fprintf(fid,'Old Name,New Name,Units,Conversion\n');

for i = 1:length(uvars)
    fprintf(fid,'%s\n',uvars{i});
end
fclose(fid);