clear all; close all;

addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

filepath = '../../../../data/incoming/TandI_1/Sediment/';

filename = 'Macrobenthic_and_sediment_data_Orlando_Sabine.xlsx';

thedate = datenum(2020,11,01);

agency = 'UA Sediment';

thevars =  {...
    'WQ_DIAG_SDG_OPD',...
    'WQ_DIAG_SDG_TP',...
    'WQ_DIAG_SDG_TOC',...
    'WQ_DIAG_SDG_TN',...
    'Ignore',...
    'WQ_DIAG_NCS_SED_d50',...
    'Ignore',...
    'WQ_DIAG_HAB_BMIi_HSI_IND',...
    };

theconv = [
    1
    43274
    1
    1
    1
    1.00E-06
    1
    1];


[snum,sstr] = xlsread([filepath,filename],'C10:N16');

site = sstr(:,2); site = regexprep(site,' ','_');

lat = snum(:,1);
lon = snum(:,2);

[X,Y] = ll2utm(lat,lon);

data = snum(:,3:end);


for i = 1:length(site)
    for j = 1:length(thevars)
        
        if strcmpi(thevars{j},'Ignore') == 0
            
            ua_macben.(site{i}).(thevars{j}).Date = thedate;
            ua_macben.(site{i}).(thevars{j}).Data = data(i,j) * theconv(j);
            ua_macben.(site{i}).(thevars{j}).Depth = 0;
            ua_macben.(site{i}).(thevars{j}).X = X(i);
            ua_macben.(site{i}).(thevars{j}).Y = Y(i);
            ua_macben.(site{i}).(thevars{j}).Agency = agency;
            
        end
    end
end

save('../../../../data/store/ecology/ua_macben.mat','ua_macben','-mat');


