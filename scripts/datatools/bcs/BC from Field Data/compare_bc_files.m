clear all; close all;

alex = load('BCs_BAR_2012_2021_Monthly_Ave_New/Alex_Mid/data.mat'); 
albert = load('BCs_BAR_2012_2021_Monthly_Ave_New/Albert_Opening/data.mat'); 
Meningie = load('BCs_BAR_2012_2021_Monthly_Ave_New/Albert_Meningie/data.mat'); 
Milang = load('BCs_BAR_2012_2021_Monthly_Ave_New/Milang/data.mat'); 
Tailem = load('BCs_BAR_2012_2021_Monthly_Ave_New/Tailem/data.mat'); 


vars = fieldnames(alex.tfv_data);

mkdir('BCs_BAR_2012_2021_Monthly_Ave_New/Alex_Albert_Compare/');

for i = 1:length(vars)
    
%     plot(alex.ISOTime,alex.tfv_data.(vars{i}));hold on
    plot(Meningie.ISOTime,Meningie.tfv_data.(vars{i}));hold on
    plot(Milang.ISOTime,Milang.tfv_data.(vars{i}));hold on
    plot(Tailem.ISOTime,Tailem.tfv_data.(vars{i}));hold on

    datetick('x');
    
    legend({'Meningie';'Milang';'Tailem Bend'});
    
    ylabel(regexprep(vars{i},'_',' '));
    xlabel('Date');
    
    saveas(gcf,['BCs_BAR_2012_2021_Monthly_Ave_New/Alex_Albert_Compare/',vars{i},'.png']);
    
    close;
end

 create_html_for_directory('BCs_BAR_2012_2021_Monthly_Ave_New/');
