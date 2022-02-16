clear all; close all;

addpath(genpath('Functions'));

load ../../../../data/store/archive/saepa/epa_2016.mat;

sites = fieldnames(epa_2016);

for i = 1:length(sites)
    cllmm.(['EPA_',sites{i}]) = epa_2016.(sites{i});
    cllmm.(['EPA_',sites{i}]) = add_agency(cllmm.(['EPA_',sites{i}]),'SA EPA');
end

load ../../../../data/store/archive/saepa/epa_2014.mat;

sites = fieldnames(epa_2014);

for i = 1:length(sites)
    cllmm.(['EPA2014_',sites{i}]) = epa_2014.(sites{i});
    cllmm.(['EPA2014_',sites{i}]) = add_agency(cllmm.(['EPA2014_',sites{i}]),'SA EPA');
end

cllmm = check_XY(cllmm);

cllmm = add_offset(cllmm);

%datearray(:,1) = datenum(2008,01:180,01);
datearray(:,1) = [datenum(2008,01,01):01:datenum(2022,0,01)];
cllmm = cleanse_sites(cllmm);




cllmm_sec = add_secondary_data(cllmm,datearray);


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

save cllmm_BC.mat cllmm -mat;
