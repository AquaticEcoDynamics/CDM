clear all; close all;

load UA.mat;

shp = shaperead('GIS/Ruppia_Zones.shp');

outdir = 'Regions/'; 

lowerlakes = UA;

sites = fieldnames(lowerlakes);

vars = [];
all_vars = [];

for i = 1:length(sites)
    all_vars = [all_vars;fieldnames(lowerlakes.(sites{i}))];
end
vars = unique(all_vars);




if ~exist(outdir,'dir')
    mkdir(outdir);
end



for i = 1:length(vars)
    
    vardir = [outdir,vars{i},'/'];
    
    if ~exist(vardir,'dir')
        mkdir(vardir);
    end
    
    for j = 1:length(shp)
        
        filename = [vardir,shp(j).Name,'.png'];
        
        figure('visible','off');
        
        for k = 1:length(sites)
            if isfield(lowerlakes.(sites{k}),vars{i})
                
                X = lowerlakes.(sites{k}).(vars{i}).X;
                Y = lowerlakes.(sites{k}).(vars{i}).Y;
                
                if inpolygon(X,Y,shp(j).X,shp(j).Y)
                    
                    scatter(lowerlakes.(sites{k}).(vars{i}).Date,lowerlakes.(sites{k}).(vars{i}).Data,'.k');hold on
                    
                end
            end
        end
        
        box on
        grid on
        
        xarray = datenum(1970:05:2020,01,01);
        
        set(gca,'xtick',xarray,'xticklabel',datestr(xarray,'yyyy'));
        
        xlim([xarray(1) xarray(end)]);
        
        ylabel(regexprep(vars{i},'_','-'));
        
        title(shp(j).Name);
        
        
        saveas(gcf,filename);
        
        close;
        
    end
end
        
 create_html_for_directory('Regions\','Regions_HTML\');       
        
        
        
                    
                    
                    
                
                
        
        
        
        
        
    
