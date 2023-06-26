clear all; close all;

[~,sstr]  =xlsread('AWQC_Data_1B.csv','D2:E10000');

[vars,ind] = unique(sstr(:,1));
units = sstr(ind,2);

fid = fopen('scrap.csv','wt');
for i = 1:length(vars)
    fprintf(fid,'%s,%s\n',vars{i},units{i});
end
fclose(fid);