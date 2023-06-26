clear all; close all;

load cllmm_sec.mat;

fdata = cllmm_sec;

clear cllmm_sec;


distance = 5; % in m;

sites = fieldnames(fdata);

cllmm = [];

for i = 1:length(sites)
    vars = fieldnames(fdata.(sites{i}));
    XX(i) = fdata.(sites{i}).(vars{1}).X;
    YY(i) = fdata.(sites{i}).(vars{1}).Y;
end


for i = 1:length(sites)
    
    vars = fieldnames(fdata.(sites{i}));
    
    X = fdata.(sites{i}).(vars{1}).X;
    Y = fdata.(sites{i}).(vars{1}).Y;
    
    T = nsidedpoly(360,'Center',[X Y],'Radius',distance);
    
    pol.X = T.Vertices(:,1);
    pol.Y = T.Vertices(:,2);
    
    for j = 1:length(vars)
        cllmm.(sites{i}).(vars{j}) = fdata.(sites{i}).(vars{j});
        
        for k = 1:length(sites)
            
            if inpolygon(XX(k),YY(k),pol.X,pol.Y)
                if isfield(fdata.(sites{k}),vars{j})
                    disp('yep');
                    cllmm.(sites{i}).(vars{j}).Data = [cllmm.(sites{i}).(vars{j}).Data;...
                        fdata.(sites{k}).(vars{j}).Data];
                    cllmm.(sites{i}).(vars{j}).Date = [cllmm.(sites{i}).(vars{j}).Date;...
                        fdata.(sites{k}).(vars{j}).Date + (rand/100)];
                    cllmm.(sites{i}).(vars{j}).Depth = [cllmm.(sites{i}).(vars{j}).Depth;...
                        fdata.(sites{k}).(vars{j}).Depth];
                end
            end
        end
        
        
        [cllmm.(sites{i}).(vars{j}).Date,ind] = unique(cllmm.(sites{i}).(vars{j}).Date);
        cllmm.(sites{i}).(vars{j}).Data = cllmm.(sites{i}).(vars{j}).Data(ind);
        cllmm.(sites{i}).(vars{j}).Depth = cllmm.(sites{i}).(vars{j}).Depth(ind);
    end
end

save cllmm_BC.mat cllmm -mat -v7.3;







