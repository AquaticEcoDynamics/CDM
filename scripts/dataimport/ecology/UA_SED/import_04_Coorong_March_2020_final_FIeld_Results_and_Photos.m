clear all; close all;
addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

filepath = '../../../../data/incoming/TandI_1/Sediment/';

filename = 'Coorong_March_2020_final FIeld Results and Photos.xlsx';

sheetname = 'Database';

agency = 'UA Sediment';


thedate = datenum(2020,03,12);


[snum,sstr] = xlsread('04_sed_conversion.xlsx','A2:D100');

thevars = sstr(:,2);
theconv = snum(:,1);

[~,sstr] = xlsread([filepath,filename],sheetname,'A3:A53');

site = sstr(:,1); site = regexprep(site,'-','_');site = regexprep(site,' ','_');


[snum,~] = xlsread([filepath,filename],sheetname,'I3:V53');


data = snum;

[snum,~] = xlsread([filepath,filename],sheetname,'C3:D53');

X = snum(:,1);
Y = snum(:,2);

[~,sstr] = xlsread([filepath,filename],sheetname,'B3:B53');

thedepth = sstr(:,1);

for i = 1:length(site)
    for j = 1:length(thevars)
                
        if strcmpi(thevars{j},'Ignore') == 0
            if ~isnan(data(i,j))
                ua_sediment_field.(site{i}).(thevars{j}).Date = thedate;
                ua_sediment_field.(site{i}).(thevars{j}).Data = data(i,j) * theconv(j);
                ua_sediment_field.(site{i}).(thevars{j}).Depth = 0;
                ua_sediment_field.(site{i}).(thevars{j}).CoreDepth = thedepth{i};
                ua_sediment_field.(site{i}).(thevars{j}).X = X(i);
                ua_sediment_field.(site{i}).(thevars{j}).Y = Y(i);
                ua_sediment_field.(site{i}).(thevars{j}).Agency = agency;
            end
            
        end
    end
end

save('../../../../data/store/ecology/ua_sediment_field.mat','ua_sediment_field','-mat');
