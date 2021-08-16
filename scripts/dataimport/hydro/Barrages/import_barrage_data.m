clear all; close all;

filename = '../../../../data/incoming/DEW/barrages/FINAL_compiledBarragesData_1990-2021.xlsx';

[~,barrage_name] = xlsread(filename,'B1:G1');

barrage_name = regexprep(barrage_name,' ','_');




[snum,sstr] = xlsread(filename,'A3:G11508');

mdate = datenum(sstr(:,1),'dd/mm/yyyy');

figure

for i = 1:length(barrage_name)
    
    barrages.(barrage_name{i}).Flow.Date = mdate;
    barrages.(barrage_name{i}).Flow.Data = snum(:,i);
    barrages.(barrage_name{i}).Flow.Agency = 'DEW Barrage';
    
    switch barrage_name{i}
        case 'Total'
            barrages.(barrage_name{i}).Flow.X = 321940.0;
            barrages.(barrage_name{i}).Flow.Y = 6061790.0;
        case 'Goolwa'
            barrages.(barrage_name{i}).Flow.X = 299425.0;
            barrages.(barrage_name{i}).Flow.Y = 6067810.0;    
        case 'Mundoo'
            barrages.(barrage_name{i}).Flow.X = 314110.0;
            barrages.(barrage_name{i}).Flow.Y = 6068270.0;  
        case 'Boundary_Creek'
            barrages.(barrage_name{i}).Flow.X = 315780.0;
            barrages.(barrage_name{i}).Flow.Y = 6067390.0; 
        case 'Ewe_Island'
            barrages.(barrage_name{i}).Flow.X = 317190.0;
            barrages.(barrage_name{i}).Flow.Y = 6063300.0; 
        case 'Tauwitchere'
            barrages.(barrage_name{i}).Flow.X = 321940.0;
            barrages.(barrage_name{i}).Flow.Y = 6061790.0; 
        otherwise
    end
            
            
            
            
            
    plot(barrages.(barrage_name{i}).Flow.Date,barrages.(barrage_name{i}).Flow.Data);hold on

end


legend(regexprep(barrage_name,'_',' '));

datetick('x');

xlabel('Date');
ylabel('Flow (m^3/s)');
title('Barrage Flow: 1990 - 2021');

save('../../../../data/store/hydro/dew_barrage.mat','barrages','-mat');