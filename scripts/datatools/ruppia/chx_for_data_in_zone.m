clear all; close all;

addpath(genpath('../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));
load('../../../data/store/ecology/phenology.mat');
shp = shaperead('31_material_zones.shp');

zone_ID = 43;

var = 'WQ_DIAG_MAC_MAC_NSHOOT';


sites = fieldnames(phenology);

thedates = [];
thesites = [];
for i = 1:length(shp)
    
    if shp(i).Mat == zone_ID
        
        theID = i;
        
        
    end
end

figure;

mapshow(shp,'EdgeColor','k','FaceColor','None');hold on
mapshow(shp(theID),'EdgeColor','r','FaceColor','None');


for i = 1:length(sites)
    
    if isfield(phenology.(sites{i}),var)
        
        if inpolygon(phenology.(sites{i}).(var).X,phenology.(sites{i}).(var).Y,...
                shp(theID).X,shp(theID).Y)
            
            thedates = [thedates;phenology.(sites{i}).(var).Date];
            thesites = [thesites;sites(i)];
            
            scatter(phenology.(sites{i}).(var).X,phenology.(sites{i}).(var).Y);
            
            sss = find(phenology.(sites{i}).(var).Date == 738346);
            
            if ~isempty(sss)
                 stop
            end
            
            
            
            
            disp(sites{i});
            
        end
    end
end
            
        

datestr(unique(thedates))







