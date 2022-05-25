clear all; close all;

addpath(genpath('../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));
load('../../../data/store/ecology/sed.mat');
shp = shaperead('31_material_zones.shp');

sites = fieldnames(sed);

vars = [];

for i = 1:length(sites)
    V = fieldnames(sed.(sites{i}));
    vars = [vars;V];
end

Markers = {'+','o','*','x','v','d','^','s','>','<'};


uvars = unique(vars);

maindir = 'Images/';

for i = 1:length(uvars)
    
    disp(uvars{i});
    
    
    for j = 1:length(shp)
            fig = figure('visible','off');
    set(fig,'defaultTextInterpreter','latex')
    set(0,'DefaultAxesFontName','Times')
    set(0,'DefaultAxesFontSize',6)
    
    thedates = [];
    theagency = [];
    used_markers = 1;
        for k = 1:length(sites)
            
            if isfield(sed.(sites{k}),uvars{i})
                
                if inpolygon(sed.(sites{k}).(uvars{i}).X,sed.(sites{k}).(uvars{i}).Y,shp(j).X,shp(j).Y)
                    sss = find(strcmpi(theagency,sed.(sites{k}).(uvars{i}).Agency) == 1);
                    

                    
                    if isempty(sss)
                        if isempty(theagency)
                            marker_id = used_markers;
                            used_markers = used_markers + 1;

                            theagency = [theagency;{sed.(sites{k}).(uvars{i}).Agency}];
                        else
                            
                            marker_id = used_markers;
                            used_markers = used_markers + 1;
                            theagency = [theagency;{sed.(sites{k}).(uvars{i}).Agency}];
                            
                        end
                            do_leg = 1;
                    else
                        marker_id = sss;
                        do_leg = 0;
                    end
                    if do_leg
                    plot(sed.(sites{k}).(uvars{i}).Date,sed.(sites{k}).(uvars{i}).Data,Markers{marker_id},...
                        'displayname',sed.(sites{k}).(uvars{i}).Agency);hold on
                    else
                      plot(sed.(sites{k}).(uvars{i}).Date,sed.(sites{k}).(uvars{i}).Data,Markers{marker_id},...
                        'HandleVisibility','off');hold on  
                    end
                    
                    thedates = [thedates;sed.(sites{k}).(uvars{i}).Date];
                    
                end
                
            end
            
        end
        
        if ~isempty(get(fig, 'Children'))
            
            datetick('x');
            
            legend('location','northwest');
            
            ylabel(regexprep(uvars{i},'_',' '));
            
            title(['Zone ',num2str(shp(j).Mat),': ',datestr(min(thedates),'dd-mm-yyyy'),' - ',datestr(max(thedates),'dd-mm-yyyy')]);
            
            axes('position',[0.7 0.6 0.2 0.3])
            
            mapshow(shp,'EdgeColor',[0.4 0.4 0.4],'FaceColor','none');hold on
            mapshow(shp(j),'EdgeColor','r','FaceColor','none');hold on
            
            axis equal;
            axis off;
            
            set(gcf, 'PaperPositionMode', 'manual');
            set(gcf, 'PaperUnits', 'centimeters');
            xSize = 16;
            ySize = 12;
            xLeft = (21-xSize)/2;
            yTop = (30-ySize)/2;
            set(gcf,'paperposition',[0 0 xSize ySize])
            
            outdir = [maindir,uvars{i},'/'];
            
            if ~exist(outdir,'dir')
                mkdir(outdir);
            end
            
            filename = [outdir,num2str(shp(j).Mat),'_',uvars{i},'.png'];
            
            print(gcf,'-dpng',filename,'-opengl');
            
            
        end
                   close;
 
    end
    
end
        
create_html_for_directory('Images/','Images/');        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
