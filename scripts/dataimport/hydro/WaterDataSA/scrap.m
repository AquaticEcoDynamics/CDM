clear all; close all;

maindir = 'Output/';

dirlist = dir(maindir);

allvars = [];

for i = 3:length(dirlist)
    
    thesite = dirlist(i).name;
    
    sitedir = [maindir,thesite,'/'];
    
    thefiles = dir([sitedir,'*.csv']);
    
    for j = 1:length(thefiles)
        
        allvars = [allvars;{thefiles(j).name}];
        
    end
end
    
    
uvars = unique(allvars);

uvars = regexprep(uvars,'.csv','');

fid = fopen('Vars.csv','wt');

for i = 1:length(uvars)
    
    fprintf(fid,'%s\n',uvars{i});
    
end
fclose(fid);

    