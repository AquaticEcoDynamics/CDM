clear all; close all;

filename = '../../../../data/incoming/DEW/hydrology/compiled/FINAL_compiledTideData_1990-2021.xlsx';

[snum,sstr] = xlsread(filename,'A2:B762626');


for i = 1:length(sstr)
    
    dd = sstr{i,1};
    
    if length(dd)>10
    
        mdate(i,1) = datenum(sstr(i,1),'dd/mm/yyyy HH:MM');
        
    else
        
        mdate(i,1) = datenum(sstr(i,1),'dd/mm/yyyy');
        
    end
end

tide.VH.H.Date = mdate;

tide.VH.H.Data = snum(:,1);


tide.VH.H.Lat = -35.562481;
tide.VH.H.Lon = 138.635403;

[tide.VH.H.X,tide.VH.H.Y]= ll2utm(tide.VH.H.Lat,tide.VH.H.Lon);




tide.VH.H.Agency = 'DEW Tide';


plot(tide.VH.H.Date,tide.VH.H.Data);hold on


legend('VH Tide');

datetick('x');

xlabel('Date');
ylabel('Height (mAHD)');
title('VH Tidal Height: 1990 - 2021 (DATUM Uncorrected');


save('../../../../data/store/hydro/dew_tide_VH_uncorrected.mat','tide','-mat');
