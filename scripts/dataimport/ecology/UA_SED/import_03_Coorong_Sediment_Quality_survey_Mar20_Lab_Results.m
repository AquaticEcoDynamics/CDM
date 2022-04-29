clear all; close all;
addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

filepath = '../../../../data/incoming/TandI_1/Sediment/';

filename = 'Coorong Sediment Quality survey Mar20 Lab Results.xlsx';

sheetname = 'All_Data';

agency = 'UA Sediment';


thedate = datenum(2020,03,12);


[snum,sstr] = xlsread('03_sed_conversion.xlsx','A2:D100');

thevars = sstr(:,3);
theconv = snum(:,1);


[snum,sstr] = xlsread([filepath,filename],sheetname,'A3:A28');

site1 = sstr(:,1); 

spt = split(site1,' ');

site = spt(:,1);

site = regexprep(site,'\.','_');
site = regexprep(site,'-','_');

thedepth = spt(:,2);

[snum,~] = xlsread([filepath,filename],sheetname,'G3:BB28');

data = snum;


[snum,~] = xlsread([filepath,filename],sheetname,'B3:C28');

X = snum(:,1);
Y = snum(:,2);

for i = 1:length(site)
    for j = 1:length(thevars)
                
        if strcmpi(thevars{j},'Ignore') == 0
            
            ua_sediment_quality.(site{i}).(thevars{j}).Date = thedate;
            ua_sediment_quality.(site{i}).(thevars{j}).Data = data(i,j) * theconv(j);
            ua_sediment_quality.(site{i}).(thevars{j}).Depth = 0;
            ua_sediment_quality.(site{i}).(thevars{j}).CoreDepth = thedepth{i};
            ua_sediment_quality.(site{i}).(thevars{j}).X = X(i);
            ua_sediment_quality.(site{i}).(thevars{j}).Y = Y(i);
            ua_sediment_quality.(site{i}).(thevars{j}).Agency = agency;
            
        end
    end
end

save('../../../../data/store/ecology/ua_sediment_quality.mat','ua_sediment_quality','-mat');
