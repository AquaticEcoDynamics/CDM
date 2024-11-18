clear all; close all;

% load("C:\Users\00065525\Github\CDM\data\store\hydro\dew_WaterDataSA_hourly.mat");
load ../../../../data/store/hydro/dew_WaterDataSA_hourly_backup.mat;

sites = fieldnames(dew);

for i = 1:length(sites)
   vars = fieldnames(dew.(sites{i}));
   sdata.(sites{i}).disc = dew.(sites{i}).(vars{1}).Name;
    sdata.(sites{i}).X = dew.(sites{i}).(vars{1}).X;
    sdata.(sites{i}).Y = dew.(sites{i}).(vars{1}).Y;
end
save siteinfo.mat sdata -mat;