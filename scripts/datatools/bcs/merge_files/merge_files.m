clear all; close all;

addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));


dirlist = dir(['master/','*.csv']);
dirlist2 = dir(['second/','*.csv']);

outdir = 'Images/';

mkdir(outdir);

for i = 1:length(dirlist)
    
    mfile = [dirlist(i).folder,'\',dirlist(i).name];
    sfile = [dirlist2(i).folder,'\',dirlist(i).name];
    
    mdata = tfv_readBCfile(mfile);
    sdata = tfv_readBCfile(sfile);
    
    outfile = dirlist(i).name;
    fid = fopen(outfile,'wt');
    
    fprintf(fid,'ISOTime,FLOW,SAL,TEMP\n');
    
    
    for k = 1:length(mdata.Date)
        fprintf(fid,'%s,',datestr(mdata.Date(k),'dd/mm/yyyy HH:MM'));
        if mdata.FLOW(k) == 0 & sdata.FLOW(k) > 0
            fprintf(fid,'%4.4f,%4.4f,%4.4f\n',sdata.FLOW(k),sdata.SAL(k),sdata.TEMP(k));
        else
            fprintf(fid,'%4.4f,%4.4f,%4.4f\n',mdata.FLOW(k),mdata.SAL(k),mdata.TEMP(k));
        end
    end
    
    fclose(fid);
    
    ndata = tfv_readBCfile(outfile);
    
    vars = fieldnames(ndata);
    
    for k = 1:length(vars)
        if strcmpi(vars{k},'Date') == 0
                    plot(ndata.Date,ndata.(vars{k}));hold on
                    

                    datearray = datenum(2010:02:2022,01,01);
                    
                    xlim([datearray(1) datearray(end)]);
                    
                    ylabel(regexprep(vars{k},'_',' '));
                    xlabel('Date');
                    
                    grid on
                    
                    set(gca,'xtick',datearray,'xticklabel',datestr(datearray,'mm-yyyy'));
    
    
                    set(gcf, 'PaperPositionMode', 'manual');
                    set(gcf, 'PaperUnits', 'centimeters');
                    xSize = 16;
                    ySize = 8;
                    xLeft = (21-xSize)/2;
                    yTop = (30-ySize)/2;
                    set(gcf,'paperposition',[0 0 xSize ySize])
                    
                    filename = [outdir,regexprep(dirlist(i).name,'csv','_'),vars{k},'.png'];
                    
                    
                    print(gcf,'-dpng',filename,'-opengl');
                    
                    close
    
            
        end
    end
        
  
end