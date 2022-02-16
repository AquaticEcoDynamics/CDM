% Script to recreate the larger files for the CDM repo.

% Join smaller mat files into the cllmm.mat file & cllmm_bc.mat file (both
% >100mb).
 run('datatools/dataprocessing/join_datasources/merge_all_data.m');


% Download & import the Water Data SA hourly data to your local machine.

% run('dataimport/hydro/WaterDataSA/download_datafiles.m');
% run('dataimport/hydro/WaterDataSA/download_datafiles.m');


