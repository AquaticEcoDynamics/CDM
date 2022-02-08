clear all; close all;

addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));


dirlist = dir(['2020/','*.csv']);

aTot = 0;
bTot = 0;
cTot = 0;

aSTot = 0;
bSTot = 0;
cSTot = 0;

for bb = [5]%1:length(dirlist)
    
    bar_name = regexprep(dirlist(bb).name,'.csv','');
    outdir = ['Images/',bar_name,'/']; %mkdir(outdir);
    
    s2020 = tfv_readBCfile(['2020/',dirlist(bb).name]);
    s2021 = tfv_readBCfile(['2021/',dirlist(bb).name]);
    s2022 = tfv_readBCfile(['2022/',dirlist(bb).name]);
    sCIIP = tfv_readBCfile(['CIIP/',dirlist(bb).name]);
    
    vars = fieldnames(s2020);
    vars_comp = fieldnames(s2021);
    
    sss = find(s2020.Date >= datenum(2019,01,01) & s2020.Date <= datenum(2020,01,01));
    ttt = find(s2021.Date >= datenum(2019,01,01) & s2021.Date <= datenum(2020,01,01));
    www = find(s2022.Date >= datenum(2019,01,01) & s2022.Date <= datenum(2020,01,01));
   
    
    aFlow = s2020.FLOW(sss) * 86400;
    bFlow = s2021.FLOW(ttt) * 86400;
    cFlow = s2022.FLOW(www) * 86400;
    
    aSal = sum(aFlow .* s2020.SAL(sss));
    bSal = sum(bFlow .* s2021.SAL(ttt));
    cSal = sum(cFlow .* s2022.SAL(www));
    
    aTot = aTot + sum(aFlow);
    bTot = bTot + sum(bFlow);
    cTot = cTot + sum(cFlow);
 
    aSTot = aSTot + aSal;
    bSTot = bSTot + bSal;
    cSTot = cSTot + cSal;
    
    
    disp([bar_name,' 2020: ',num2str(aSal)]);
    disp([bar_name,' 2021: ',num2str(bSal)]);
    disp([bar_name,' 2022: ',num2str(cSal)]);
    
    disp([bar_name,' 2020: ',num2str(sum(aFlow))]);
    disp([bar_name,' 2021: ',num2str(sum(bFlow))]);
    disp([bar_name,' 2022: ',num2str(sum(cFlow))]);
    
    
end
    
    
    
    
%     for i = 1:length(vars)
%         
%         if  strcmpi(vars{i},'Date') == 0
%             
%             
%             if ismember(vars{i},vars_comp)
%                 
%                 
%                 fig1 = figure('visible','off');
%                 set(fig1,'defaultTextInterpreter','latex')
%                 set(0,'DefaultAxesFontName','Times')
%                 set(0,'DefaultAxesFontSize',6)
%                 
%                 plot(s2020.Date,s2020.(vars{i}));hold on
%                 
%                 plot(s2021.Date,s2021.(upper(vars{i})));hold on
%                 
%                 plot(s2022.Date,s2022.(upper(vars{i})));hold on
%                 
%                 %plot(sCIIP.Date,sCIIP.(upper(vars{i})));hold on
%                 
%                 
%                 
%                 datearray = datenum(2019,01:06:24,01);
%                 
%                 
%                 xlim([datearray(1) datearray(end)]);
%                 
%                 ylabel(regexprep(vars{i},'_',' '));
%                 xlabel('Date');
%                 
%                 grid on
%                 
%                 set(gca,'xtick',datearray,'xticklabel',datestr(datearray,'mm-yyyy'));
%                 
%                 legend({'eWater 2020';'eWater 2021';'2022';'CIIP'});
%                 
%                 set(gcf, 'PaperPositionMode', 'manual');
%                 set(gcf, 'PaperUnits', 'centimeters');
%                 xSize = 16;
%                 ySize = 8;
%                 xLeft = (21-xSize)/2;
%                 yTop = (30-ySize)/2;
%                 set(gcf,'paperposition',[0 0 xSize ySize])
%                 
%                 filename = [outdir,vars{i},'.png'];
%                 
%                 
%                 print(gcf,'-dpng',filename,'-opengl');
%                 
%                 close
%             end
%         end
%         
%     end
% end
% create_html_for_directory('Images/','Images/');


