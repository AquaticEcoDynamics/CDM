# Coorong Hydro Data Update Process

This repository contains scripts for automated downloading and processing of hydrological data from WaterData SA for the Coorong region.

## Prerequisites

- MATLAB
- Access to water.data.sa.gov.au

## Data Processing

### Automated Download and Processing
1. Run the MATLAB processing script:
   ```matlab
   CDM/scripts/dataimport/hydro/WaterDataSA/download_datafiles.m
   ```

   This script will:
   - Download all available data directly from the WaterData SA website
   - Create an output directory if it does not exist to save the downloaded data:
     ```
     CDM/scripts/dataimport/hydro/WaterDataSA/Output
     ```
   - With `runsites = 1`, download data for all sites listed in `siteinfo.mat`
  
> [!NOTE]
> - The script is currently adapted for MacOS path structure.
> - On line 30 of import_datafiles_hourly.m, the loop starts from 4 (`for i = 4:length(dirlist)`) to skip `.DS_store`.
> - For other operating systems, modify to start from 3.

2. The script will then process the downloaded data into a MATLAB data file and save the output as:
   ```
   CDM/data/store/hydro/dew_WaterDataSA_hourly.mat
   ```