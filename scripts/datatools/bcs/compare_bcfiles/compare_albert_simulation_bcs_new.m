clear all; close all;

addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

outdir = 'Final_2/Comp/'; mkdir(outdir);

albert_old = tfv_readBCfile(['Phase2\',...
    'LAC_BC_20140101_20200701_800GLy-1_realistic.csv']);

albert_new = tfv_readBCfile(['Phase2\',...
    'Albert_Phase_II_20140101_20200701.csv']);

% alex_new = tfv_readBCfile(['Phase2\',...
%     'Alex_Phase_II_20140101_20200701.csv']);
% 
% river_new = tfv_readBCfile(['Phase2\',...
%     'River_Phase_II_20140101_20200701.csv']);

% 
% albert_new2 = tfv_readBCfile(['Phase2_New\',...
%     'Albert_Phase_II_20130101_20200701.csv']);
% 
% alex_new2 = tfv_readBCfile(['Phase2_New\',...
%     'Alex_Phase_II_20130101_20200701.csv']);
% 
% river_new2 = tfv_readBCfile(['Phase2_New\',...
%     'River_Phase_II_20130101_20200701.csv']);



albert_old.TN = albert_old.don + albert_old.pon + albert_old.amm + albert_old.nit;
albert_new.TN = albert_new.don + albert_new.pon + albert_new.amm + albert_new.nit;
alex_new.TN = alex_new.don + alex_new.pon + alex_new.amm + alex_new.nit;
river_new.TN = river_new.don + river_new.pon + river_new.amm + river_new.nit;

albert_old.TP = albert_old.dop + albert_old.pop + albert_old.frp + albert_old.frp_ads;
albert_new.TP = albert_new.dop + albert_new.pop + albert_new.frp + albert_new.frp_ads;
alex_new.TP = alex_new.dop + alex_new.pop + alex_new.frp + alex_new.frp_ads;
river_new.TP = river_new.dop + river_new.pop + river_new.frp + river_new.frp_ads;

albert_old.TCHLA = albert_old.grn ./ 4.166667;
albert_new.TCHLA = albert_new.grn ./ 4.166667;
alex_new.TCHLA = alex_new.grn ./ 4.166667;
river_new.TCHLA = river_new.grn ./ 4.166667;



%vars = fieldnames(river_new);

vars = {'TN';'TP';'TCHLA';'sal'};
conv = [14/1000, 31/1000, 1,1];
yl = [7.5 0.5 150 2];
ylab = {'Total Nitrogen (mg/L)';'Total Phosphorus (mg/L)';'TChla (ug/L)';'Salinity (PSU)'};

for i = 1:length(vars)
    
    if  strcmpi(vars{i},'Date') == 0 
        
        
        fig1 = figure('visible','off');
        set(fig1,'defaultTextInterpreter','latex')
        set(0,'DefaultAxesFontName','Times')
        set(0,'DefaultAxesFontSize',6)
        
        plot(albert_old.Date,albert_old.(vars{i}) * conv(i));hold on
        
        plot(albert_new.Date,albert_new.(vars{i}) * conv(i));hold on
        %plot(albert_new2.Date,albert_new2.(vars{i}),'--');hold on
        
        plot(alex_new.Date,alex_new.(vars{i}) * conv(i));hold on
        %plot(alex_new2.Date,alex_new2.(vars{i}),'--');hold on

        plot(river_new.Date,river_new.(vars{i}) * conv(i));hold on        
        %plot(river_new2.Date,river_new2.(vars{i}),'--');hold on
        
        
        
        datearray = datenum(2017,07:6:43,01);
        
        
        xlim([datearray(1) datearray(end)]);
        ylim([0 yl(i)]);
        ylabel(ylab{i});
        xlabel('Date');
                
        grid on
        
        set(gca,'xtick',datearray,'xticklabel',datestr(datearray,'mm-yy'));
        
        legend({'Albert Opening';'Meningie';'Milang';'Tailem Bend'});
        
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
        
 create_html_for_directory('Final_2/');
        