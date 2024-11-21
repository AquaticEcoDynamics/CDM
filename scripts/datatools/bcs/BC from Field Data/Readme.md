# Coorong Salt Creek BC Files Update Process

This repository contains scripts for creating boundary condition (BC) files from field data for the Coorong region.

## Prerequisites

- MATLAB
- Microsoft Excel

## Data Processing
1. Run the MATLAB script:
   ```matlab
   CDM/scripts/datatools/bcs/BC from Field Data/create_saltCreek_bc_files.m
   ```

   This script will:
   - Read the mat file containing the hourly water data for the Coorong region.
   - Create a csv file combining all sites with the date range specified:
     ```
     CDM/scripts/datatools/bcs/BC from Field Data/BCs_BAR_2012_2024_V1/Salt_Creek_20230702_20241114.csv
     ```

> [!IMPORTANT]
> To run this script, please ensure that the mat file containing the hourly water data (`CDM/data/store/hydro/dew_WaterDataSA_hourly.mat`) for the Coorong region is in the correct format and is up to date. If not, please refer to the [Readme](../../../dataimport/hydro/WaterDataSA/Readme.md) for the process to update the mat file.

2. Append the data in `Salt_Creek_20230702_20241114.csv` to the existing csv file:
   ```
   CDM/scripts/datatools/bcs/BC from Field Data/BCs_BAR_2012_2024_V1/Salt_Creek_20120101_20230701_appended.csv
   ```
   and save it as:
   ```
   CDM/scripts/datatools/bcs/BC from Field Data/BCs_BAR_2012_2024_V1/Salt_Creek_20120101_20241114_appended.csv
   ```

> [!NOTE]
> The existing csv file `Salt_Creek_20120101_20230701_appended.csv` was revised to better calibrate the south Coorong in the simulation. Thus, the data will be different from the raw field data.

3. Run the python script:
   ```
   CDM/scripts/datatools/bcs/BC from Field Data/BCs_BAR_2012_2024_V1/interpolated_salt_creek_wq.py
   ```

   This script will:
   - Interpolate the water quality data for the Salt Creek from 2023-07-01 00:00:00 onwards using the median water quality data for each datetime from historical data.
   - Save the interpolated data to:
     ```
     CDM/scripts/datatools/bcs/BC from Field Data/BCs_BAR_2012_2024_V1/Salt_Creek_20120101_20241114_interpolated.csv
     ```