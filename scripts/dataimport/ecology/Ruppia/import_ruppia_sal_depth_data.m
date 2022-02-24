clear all; close all;

addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

filename = '../../../../data/incoming/TandI_2/UA_Ruppia/Ruppia_2-2-4_Database/Baseline aquatic plant 4 x surveys 2020-2021_100.xlsx';

sheetname = 'data';

[snum,sstr,sraw] = xlsread(filename,sheetname,'C2:J4848');

mdate = datenum(sstr(:,2),'dd/mm/yyyy') + snum(:,1);

sites = sstr(:,1);

lat = snum(:,2);
lon = snum(:,3);
sal = snum(:,5);
dep = snum(:,6);

usites = unique(sites);

for i = 1:length(usites)
    
    sss = find(strcmpi(sites,usites{i}) == 1);
    
    [X,Y] = ll2utm(lat(sss(1)),lon(sss(1)));
    
    thename = regexprep(usites{i},'\–','_');
    thename = regexprep(thename,'\-','_');
    
    
    thesal = sal(sss);
    thedepth = dep(sss);
    
    ttt = find(~isnan(mdate(sss)));
    thesal = sal(sss(ttt));
    thedepth = dep(sss(ttt));    
    
    
    ruppia.(thename).SAL.Date = mdate(sss(ttt));
    ruppia.(thename).SAL.Data = thesal;
    ruppia.(thename).SAL.Depth = thedepth * -1;
    ruppia.(thename).SAL.X = X;
    ruppia.(thename).SAL.Y = Y;
    ruppia.(thename).SAL.Agency = 'UA HCHB';
    ruppia.(thename).SAL.Name = thename;
    ruppia.(thename).SAL.Units = 'PSU';
    
end

save('../../../../data/store/ecology/ruppia.mat','ruppia','-mat');
    
    
    
    
    
    

