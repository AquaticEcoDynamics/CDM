clear; close all;

yrst = 2019;
yrend = 2020;


infile1 = ['D:\HCHB\Model update trial\Plotting_Ruppia_sep\eWater2021_basecase_all\Sheets\',num2str(yrst),'\'];
infile2 = ['D:\HCHB\Model update trial\Plotting_Ruppia_sep\eWater2021_basecase_all\Sheets\',num2str(yrend),'\'];
outdir = ['D:\HCHB\Model update trial\Plotting_Ruppia_sep\eWater2021_basecase_all\Sheets\',num2str(yrend),'\shp\'];
modname = '_eWater_'; %do not include year in this name

% Combined HSI of start year (whole year) & sexual HSI of end year (till
% Sep) to validate flower in sep
load ([infile1,'\HSI_combined.mat']);
sexual = load ([infile2,'\HSI_sexual.mat']);
sexual_cumul = min(hsi_combined,sexual.min_cdata);
convert_2dm_to_shp('CoorongBGC_mesh_26250cells.2dm',[outdir, 'HSI_sexual_cumul',modname, num2str(yrend),'.shp'],'HSI',sexual_cumul);



% Combined HSI of start year (whole year) & asexual HSI of end year (till
% Sep) to validate turion in sep
load ([infile1,'\HSI_combined.mat']);
asexual = load ([infile2,'\HSI_asexual.mat']);
asexual_cumul = min(hsi_combined,asexual.min_cdata);
convert_2dm_to_shp('CoorongBGC_mesh_26250cells.2dm',[outdir, 'HSI_asexual_cumul',modname, num2str(yrend),'.shp'],'HSI',asexual_cumul);


% Combined HSI of start year (whole year) & germ,spr,adt HSI of end year (till
% Sep) to validate shoots in sep
load ([infile1,'\HSI_combined.mat']);
hsi3 = load ([infile2,'\3_seed_new\HSI_seed.mat']);
hsi5 = load ([infile2,'\5_sprout_new\HSI_sprout.mat']);
hsi1 = load ([infile2,'\1_adult_new\HSI_adult.mat']);
hsi_seed_sprout = max(hsi3.min_cdata, hsi5.min_cdata);
hsi_seed_spr_adt = min(hsi_seed_sprout, hsi1.min_cdata);

adult_cumul = min(hsi_combined,hsi_seed_spr_adt);
convert_2dm_to_shp('CoorongBGC_mesh_26250cells.2dm',[outdir, 'HSI_adult_cumul',modname, num2str(yrend),'.shp'],'HSI',adult_cumul);
