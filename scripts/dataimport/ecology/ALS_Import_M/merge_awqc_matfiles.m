clear all; close all;

load('../../../../data/store/ecology/AWQC_1.mat');

old = AWQC;clear AWQC;

load('../../../../data/store/ecology/AWQC_1B.mat');

new = AWQC;clear AWQC;


osites = fieldnames(old);
nsites = fieldnames(new);

for i = 1:length(nsites)
    if ~isfield(old,nsites{i})
        old.(nsites{i}) = new.(nsites{i});
    else
        vars = fieldnames(new.(nsites{i}));
        for j = 1:length(vars)
        if ~isfield(old.(nsites{i}),vars{j})
            old.(nsites{i}).(vars{j}) = new.(nsites{i}).(vars{j});
        else
            old.(nsites{i}).(vars{j}).Date = [old.(nsites{i}).(vars{j}).Date;new.(nsites{i}).(vars{j}).Date];
            old.(nsites{i}).(vars{j}).Data = [old.(nsites{i}).(vars{j}).Date;new.(nsites{i}).(vars{j}).Data];
            old.(nsites{i}).(vars{j}).Depth = [old.(nsites{i}).(vars{j}).Date;new.(nsites{i}).(vars{j}).Depth];
        end
        end
    end
end
AWQC = old;

save('../../../../data/store/ecology/AWQC.mat','AWQC','-mat');


