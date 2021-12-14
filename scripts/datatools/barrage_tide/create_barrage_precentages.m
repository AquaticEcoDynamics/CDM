clear all;close all;

load('../../../data/store/hydro/dew_barrage.mat');

sites = fieldnames(barrages);

int = 1;
for i = 1:length(sites)
    
   if strcmpi(sites{i},'Total') == 0
       
    bar_prec.(sites{i}).Data = barrages.(sites{i}).Flow.Data ./ barrages.Total.Flow.Data;
    bar_prec.(sites{i}).Date = barrages.(sites{i}).Flow.Date;
    
    bar_prec.(sites{i}).Data(barrages.Total.Flow.Data == 0) = 0;
    stacked_area(:,int) = bar_prec.(sites{i}).Data;
    thesite{int} = sites{i};
    
    int = int + 1;
    
   end
end

save('../../../data/store/hydro/dew_barrage_percentages.mat','bar_prec','-mat');

figure;

area(bar_prec.Goolwa.Date,stacked_area);
legend(thesite);

datetick('x','yyyy');



