clear all; close all;

load UA.mat;

load ../modeltools/matfiles/lowerlakes.mat;

sites = fieldnames(UA);

for i = 1:length(sites)
    lowerlakes.(sites{i}) = UA.(sites{i});
end

save('../modeltools/matfiles/lowerlakes.mat','lowerlakes','-mat');

load ../modeltools/matfiles/coorong.mat;

for i = 1:length(sites)
    coorong.(sites{i}) = UA.(sites{i});
end

save('../modeltools/matfiles/coorong.mat','coorong','-mat');
