clear all; close all;

load temp.mat;

load turb.mat;

load ../modeltools/matfiles/lowerlakes.mat;
load ../modeltools/matfiles/coorong.mat;

sites = fieldnames(temp);

for i = 1:length(sites)
    lowerlakes.(sites{i}) = temp.(sites{i});
end

for i = 1:length(sites)
    coorong.(sites{i}) = temp.(sites{i});
end

sites = fieldnames(turb);
% lsites = fieldnames(lowerlakes);
% csites = fieldnames(coorong);

for i = 1:length(sites)
    
    
    
    if isfield(lowerlakes,sites{i})
        lowerlakes.(sites{i}).WQ_DIAG_TOT_TURBIDITY = turb.(sites{i}).WQ_DIAG_TOT_TURBIDITY;
        
        vars = fieldnames(lowerlakes.(sites{i}));
        lowerlakes.(sites{i}).WQ_DIAG_TOT_TURBIDITY.X = lowerlakes.(sites{i}).(vars{1}).X;
        lowerlakes.(sites{i}).WQ_DIAG_TOT_TURBIDITY.Y = lowerlakes.(sites{i}).(vars{1}).Y;
    else
        stop;
    end
    
    if isfield(coorong,sites{i})
        coorong.(sites{i}).WQ_DIAG_TOT_TURBIDITY = turb.(sites{i}).WQ_DIAG_TOT_TURBIDITY;
        
        vars = fieldnames(lowerlakes.(sites{i}));
        coorong.(sites{i}).WQ_DIAG_TOT_TURBIDITY.X = coorong.(sites{i}).(vars{1}).X;
        coorong.(sites{i}).WQ_DIAG_TOT_TURBIDITY.Y = coorong.(sites{i}).(vars{1}).Y;
    else
        coorong.(sites{i}) = lowerlakes.(sites{i});
    end
    
end

save('../modeltools/matfiles/lowerlakes.mat','lowerlakes','-mat');
save('../modeltools/matfiles/coorong.mat','coorong','-mat');

    
        

