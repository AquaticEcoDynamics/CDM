clear all; close all;

filename = 'ALS_Data.csv';
fid = fopen(filename,'rt');

x  = 7;
textformat = [repmat('%s ',1,x)];
% read single line: number of x-values
datacell = textscan(fid,textformat,'Headerlines',1,'Delimiter',',');
fclose(fid);

sites = datacell{3};
vars = datacell{4};
units = datacell{5};
dates = datacell{6};

usites = unique(sites);

[uvars,ind] = unique(vars);
uunits = units(ind);

fid = fopen('ALS_Sites.csv','wt');
for i = 1:length(usites)
    fprintf(fid,'%s\n',usites{i});
end
fclose(fid);

fid = fopen('ALS_Vars.csv','wt');
for i = 1:length(uvars)
    fprintf(fid,'%s,%s\n',uvars{i},uunits{i});
end
fclose(fid);
%________________
filename = 'AWQC_Data.csv';
fid = fopen(filename,'rt');

x  = 7;
textformat = [repmat('%s ',1,x)];
% read single line: number of x-values
datacell = textscan(fid,textformat,'Headerlines',1,'Delimiter',',');
fclose(fid);

sites = datacell{3};
vars = datacell{4};
units = datacell{5};
dates = datacell{6};

usites = unique(sites);

[uvars,ind] = unique(vars);
uunits = units(ind);

fid = fopen('AWQC_Sites.csv','wt');
for i = 1:length(usites)
    fprintf(fid,'%s\n',usites{i});
end
fclose(fid);

fid = fopen('AWQC_Vars.csv','wt');
for i = 1:length(uvars)
    fprintf(fid,'%s,%s\n',uvars{i},uunits{i});
end
fclose(fid);





