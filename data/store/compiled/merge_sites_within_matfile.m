clear all; close all;

load lowerlakes.mat;

fdata = lowerlakes;

clear lowerlakes;


distance = 5; % in m;

sites = fieldnames(fdata);

lowerlakes = [];

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
        lowerlakes.(sites{i}).(vars{j}) = fdata.(sites{i}).(vars{j});
        
        for k = 1:length(sites)
            
            if inpolygon(XX(k),YY(k),pol.X,pol.Y)
                if isfield(fdata.(sites{k}),vars{j})
                    disp('yep');
                    lowerlakes.(sites{i}).(vars{j}).Data = [lowerlakes.(sites{i}).(vars{j}).Data;...
                        fdata.(sites{k}).(vars{j}).Data];
                    lowerlakes.(sites{i}).(vars{j}).Date = [lowerlakes.(sites{i}).(vars{j}).Date;...
                        fdata.(sites{k}).(vars{j}).Date + (rand/100)];
                    lowerlakes.(sites{i}).(vars{j}).Depth = [lowerlakes.(sites{i}).(vars{j}).Depth;...
                        fdata.(sites{k}).(vars{j}).Depth];
                end
            end
        end
        
        
        [lowerlakes.(sites{i}).(vars{j}).Date,ind] = unique(lowerlakes.(sites{i}).(vars{j}).Date);
        lowerlakes.(sites{i}).(vars{j}).Data = lowerlakes.(sites{i}).(vars{j}).Data(ind);
        lowerlakes.(sites{i}).(vars{j}).Depth = lowerlakes.(sites{i}).(vars{j}).Depth(ind);
    end
end

save lowerlakes_BC.mat lowerlakes -mat;







