clear all; close all;

load cllmm_BC.mat;

%thesite = 'EPA2014_Lake_Alexandrina_Off_Point_McLeay';

sites = {...
    'EPA2014_Lake_Alexandrina_Off_Point_McLeay',...
    'EPA2014_Tauwitchere_Mud_Island_1',...
    'EPA2014_Lake_Alexandrina_off_Rat_Island',...
    'EPA2014_Lake_Alexandrina_Goolwa_Barrage_Upstream',...
    'EPA_Goolwa',...
    'EPA_Alex_Middle',...
    };


thetime = datenum(2008,01:01:240,01);
for j = 1:length(sites)
    thesite = sites{j};
    vars = fieldnames(cllmm.(thesite));

    for i = 1:length(vars)
        alldate = cllmm.(thesite).(vars{i}).Date;
        alldata = cllmm.(thesite).(vars{i}).Data;
        
        [thedate,thedata] = calc_monthly_ave(alldate,alldata,thetime);
        
        
        epa.(thesite).(vars{i}).Date(:,1) = thedate;
        epa.(thesite).(vars{i}).Data(:,1) = thedata;
        epa.(thesite).(vars{i}).Depth(1:length(thedate),1) = 0;
        epa.(thesite).(vars{i}).X = cllmm.(thesite).(vars{i}).X;
        epa.(thesite).(vars{i}).Y = cllmm.(thesite).(vars{i}).Y;
        epa.(thesite).(vars{i}).Agency = cllmm.(thesite).(vars{i}).Agency;
        
    end
end
save epa.mat epa -mat;

datafile = 'epa.mat';

summary_folder = 'SAEPA_LongTerm\';

gis_folder = 'C:\Users\00065525\Github\CDM\scripts\dataimport\ecology\SA_EPA\summary_longterm\';

shpname = 'epa.shp';

summerise_data(datafile,summary_folder,gis_folder,shpname)
