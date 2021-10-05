clear all; close all;

addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

outdir = 'Images/COMP/'; mkdir(outdir);

albert_old = tfv_readBCfile(['Phase2\',...
    'LAC_BC_20140101_20200701_800GLy-1_realistic.csv']);

albert_new = tfv_readBCfile(['Phase2\',...
    'Albert_Phase_II_20140101_20200701.csv']);

alex_new = tfv_readBCfile(['Phase2\',...
    'Alex_Phase_II_20140101_20200701.csv']);

river_new = tfv_readBCfile(['Phase2\',...
    'River_Phase_II_20140101_20200701.csv']);

vars = fieldnames(river_new);

for i = 1:length(vars)
    
    if  strcmpi(vars{i},'Date') == 0 
        
        
        fig1 = figure('visible','off');
        set(fig1,'defaultTextInterpreter','latex')
        set(0,'DefaultAxesFontName','Times')
        set(0,'DefaultAxesFontSize',6)
        
        plot(albert_old.Date,albert_old.(vars{i}));hold on
        
        plot(albert_new.Date,albert_new.(vars{i}));hold on
        
        plot(alex_new.Date,alex_new.(vars{i}));hold on
        
        plot(river_new.Date,river_new.(vars{i}));hold on
        
        
        
        datearray = datenum(2015:01:2021,01,01);
        
        
        xlim([datearray(1) datearray(end)]);
        
        ylabel(regexprep(vars{i},'_',' '));
        xlabel('Date');
                
        grid on
        
        set(gca,'xtick',datearray,'xticklabel',datestr(datearray,'yyyy'));
        
        legend({'Albert ph.1';'Albert ph.2';'Alex ph.2';'River ph.2'});
        
        set(gcf, 'PaperPositionMode', 'manual');
        set(gcf, 'PaperUnits', 'centimeters');
        xSize = 16;
        ySize = 8;
        xLeft = (21-xSize)/2;
        yTop = (30-ySize)/2;
        set(gcf,'paperposition',[0 0 xSize ySize])
        
        filename = [outdir,vars{i},'.png'];
        
        
        print(gcf,'-dpng',filename,'-opengl');
        
        close
        
    end
    
end
        
 create_html_for_directory('Images/');
        