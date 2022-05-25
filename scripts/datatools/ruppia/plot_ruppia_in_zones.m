clear all; close all;

addpath(genpath('../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));
load('../../../data/store/ecology/ruppia.mat');
shp = shaperead('31_material_zones.shp');

sed = ruppia;

sites = fieldnames(sed);

vars = [];

Markers = {'+','o','*','x','v','d','^','s','>','<'};

theagency_z = [];

for i = 1:length(sites)
    V = fieldnames(sed.(sites{i}));
    vars = [vars;V];
    theagency_z = [theagency_z;{sed.(sites{i}).(V{1}).Agency}];
    
    
end

uvars = unique(vars);

theagency = unique(theagency_z);

maindir = 'Images/';

for i = 1:length(uvars)
    
    disp(uvars{i});
    
    
    for j = 1:length(shp)
            fig = figure('visible','on');
    set(fig,'defaultTextInterpreter','latex')
    set(0,'DefaultAxesFontName','Times')
    set(0,'DefaultAxesFontSize',6)
    
    thedates = [];
    do_leg(1:2,1) = 1;
        for k = 1:length(sites)
            
            if isfield(sed.(sites{k}),uvars{i})
                
                if inpolygon(sed.(sites{k}).(uvars{i}).X,sed.(sites{k}).(uvars{i}).Y,shp(j).X,shp(j).Y)
                    
                    sss = find(strcmpi(theagency,sed.(sites{k}).(uvars{i}).Agency) == 1);
                    marker_id = sss;

                    
                    if do_leg(sss)
                    plot(sed.(sites{k}).(uvars{i}).Date,sed.(sites{k}).(uvars{i}).Data,Markers{marker_id},...
                        'displayname',sed.(sites{k}).(uvars{i}).Agency);hold on
                    
                    do_leg(sss) = 0;
                    else
                      plot(sed.(sites{k}).(uvars{i}).Date,sed.(sites{k}).(uvars{i}).Data,Markers{marker_id},...
                        'HandleVisibility','off');hold on  
                    end
                    thedates = [thedates;sed.(sites{k}).(uvars{i}).Date];
                    
                end
                
            end
            
        end
        
        if ~isempty(get(fig, 'Children'))
            
            xl = get(gca,'xlim');
            
            datearray = min(thedates)-50:((max(thedates)+50)-(min(thedates)-50)) / 5:(max(thedates)+50);
            
            xlim([datearray(1) datearray(end)]);
            
            set(gca,'xtick',datearray,'xticklabel',datestr(datearray,'dd/mm/yyyy'));
            %datetick('x','dd-mm-yy HH:MM');
            
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
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
