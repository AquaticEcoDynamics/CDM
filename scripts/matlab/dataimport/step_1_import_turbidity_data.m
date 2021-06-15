clear all; close all;

filename = 'F:\AED Dropbox\AED_Coorong_db\3_data\Lagoon_Hydrology\turbidity\Sonde\BulkExport-6 Locations-20210608160903.csv';

[~,sites] = xlsread(filename,'B2:G2');
[~,sDates] = xlsread(filename,'A6:A700000');
disp('Started Dates') 
for i = 1:length(sDates)
    tt = strsplit(sDates{i},' ');
    
    if length(tt) == 1
        nDates(i) = datenum(tt{1},'dd/mm/yyyy');
    else
        switch tt{3}
            case 'AM'
                nDates(i) = datenum([tt{1},' ',tt{2},' ',tt{3}],'dd/mm/yyyy HH:MM:SS AM');
            case 'PM'
                nDates(i) = datenum([tt{1},' ',tt{2},' ',tt{3}],'dd/mm/yyyy HH:MM:SS PM');
            otherwise
                stop;
        end
    end
end
disp('Finished Dates')    
 
numcols = length(nDates);

[~,~,rawdata] = xlsread(filename,['B6:','G',num2str(numcols+5)]);

turb = [];

for i = 1:length(sites)
    turb.(sites{i}).WQ_DIAG_TOT_TURBIDITY.Data = [];
    turb.(sites{i}).WQ_DIAG_TOT_TURBIDITY.Date = [];
    turb.(sites{i}).WQ_DIAG_TOT_TURBIDITY.Depth = [];
end
disp('Started data import')    

for i = 1:length(sites)
    for j = 1:length(nDates)
        thedata = rawdata{j,i};
        if ~isnan(thedata)
            turb.(sites{i}).WQ_DIAG_TOT_TURBIDITY.Data = [turb.(sites{i}).WQ_DIAG_TOT_TURBIDITY.Data;thedata];
            turb.(sites{i}).WQ_DIAG_TOT_TURBIDITY.Date = [turb.(sites{i}).WQ_DIAG_TOT_TURBIDITY.Date;nDates(j)];
            turb.(sites{i}).WQ_DIAG_TOT_TURBIDITY.Depth = [turb.(sites{i}).WQ_DIAG_TOT_TURBIDITY.Depth;0];
        end
    end
end

save turb.mat turb -mat;


