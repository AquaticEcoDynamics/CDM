clear all; close all;

addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));


dirlist = dir(['BC1/','*.csv']);

for bb = 1:length(dirlist)
    
    bar_name = regexprep(dirlist(bb).name,'.csv','');
    outdir = ['Images/',bar_name,'/']; mkdir(outdir);
    
    old = tfv_readBCfile(['BC1/',dirlist(bb).name]);
    new = tfv_readBCfile(['BC2/',dirlist(bb).name]);
%     s2021 = tfv_readBCfile(['2021/',dirlist(bb).name]);
%     s2022 = tfv_readBCfile(['2022/',dirlist(bb).name]);
    % sCIIP = tfv_readBCfile(['CIIP/',dirlist(bb).name]);
    
    vars = fieldnames(old);
    vars_comp = fieldnames(new);
    
    for i = 1:length(vars)
        
        if  strcmpi(vars{i},'Date') == 0
            
            
            if ismember(vars{i},vars_comp)
                if isfield(new,vars{i})
                    
                    fig1 = figure('visible','off');
                    set(fig1,'defaultTextInterpreter','latex')
                    set(0,'DefaultAxesFontName','Times')
                    set(0,'DefaultAxesFontSize',6)
                    
                    
                    plot(old.Date,old.(vars{i}));hold on
                    
                    
                    plot(new.Date,new.(vars{i}),'--');hold on
                    

                    
                    %plot(sCIIP.Date,sCIIP.(upper(vars{i})));hold on
                    
                    
                    
                    datearray = datenum(2012,01:06:120,01);
                    
                    
                    xlim([datearray(1) datearray(end)]);
                    
                    ylabel(regexprep(vars{i},'_',' '));
                    xlabel('Date');
                    
                    grid on
                    
                    set(gca,'xtick',datearray,'xticklabel',datestr(datearray,'mm-yyyy'));
                    
                    legend({'Old';'New';});
                    
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
        end
        
    end
end
create_html_for_directory('Images/');


