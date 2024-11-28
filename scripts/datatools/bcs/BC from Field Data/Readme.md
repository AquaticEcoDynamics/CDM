# Coorong BC Files Update Process

This repository contains scripts for creating boundary condition (BC) files from field data for the Coorong region.

## Prerequisites

- MATLAB
- Python
- Microsoft Excel

## Data Processing
### Salt Creek and Barker Knoll BC Files - BCs_BAR_2012_2024_V2
(consider WaterData SA and DataSA data)

1. Run the MATLAB script:
   ```
   CDM/scripts/datatools/dataprocessing/join_datasources/merge_bc_inflow_files.m
   ```

   This script will:
   - Merge the WaterData SA and DataSA data into a single mat file.
   - Save the merged data to:
     ```
     CDM/data/store/merged/bc_inflow.mat
     ```

> [!IMPORTANT]
> - To run this script, please ensure that the mat file containing the hourly water data (`CDM/data/store/hydro/dew_WaterDataSA_hourly.mat`) for the Coorong region is in the correct format and is up to date. If not, please refer to the [Readme](../../../dataimport/hydro/WaterDataSA/Readme.md) for the process to update the mat file.
> - Also for the DataSA water quality data (`CDM/data/store/ecology/wq_hchb_2024.mat`). If not, please refer to the [Readme](../../../dataimport/ecology/DataSA_WQ/Readme.md) for the process to update the data.

2. Run the MATLAB script:
   ```
   CDM/scripts/datatools/bcs/BC from Field Data/create_bc_files.m
   ```

   This script will:
   - Read the bc_inflow mat file created in step 1.
   - Create a csv file combining all sites with the date range specified:
     ```
     CDM/scripts/datatools/bcs/BC from Field Data/BCs_BAR_2012_2024_V2/Salt_Creek_20230701_20241114.csv
     CDM/scripts/datatools/bcs/BC from Field Data/BCs_BAR_2012_2024_V2/BK_20230701_20241114.csv
     ```

3. Run the python script (remember to navigate to the respective directory before running the code):
   ```
   CDM/scripts/datatools/bcs/BC from Field Data/BCs_BAR_2012_2024_V2/append_interpolate_bcfiles.py
   ```

   This script will:
   - Append the recent data to the existing historical data.
   - Calculate derived variables, additional adjustments made to match up with historical data:
     - FRP = (AMM + NIT) / 16
     - FRP_ADS = 0.1 * FRP
     - POC = (1/4) * DOC
     - DON = (TOT_TN - NIT - AMM) * 0.8
     - PON = (TOT_TN - NIT - AMM) * 0.2
     - DOP = (1/16) * DON
     - POP = (1/16) * PON
   - Interpolate the water quality data from 2023-07-01 00:00:00 onwards using the median water quality data for each datetime from historical data.
   - Save the interpolated data to:
     ```
     CDM/scripts/datatools/bcs/BC from Field Data/BCs_BAR_2012_2024_V2/Salt_Creek_20120101_20241114_interpolated.csv
     CDM/scripts/datatools/bcs/BC from Field Data/BCs_BAR_2012_2024_V2/BK_20160101_20241114_interpolated.csv
     ```

> [!IMPORTANT]
> Additional adjustments made to derived variables to match up with historical data:
> - FRP_ADS * 4.9
> - PON * 2
> - DOP / 3
> - POP / 2

### Salt Creek BC File - BCs_BAR_2012_2024_V1
(consider only dew_WaterDataSA_hourly data)

1. Run the MATLAB script:
   ```
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

3. Run the python script (remember to navigate to the respective directory before running the code):
   ```
   CDM/scripts/datatools/bcs/BC from Field Data/BCs_BAR_2012_2024_V1/interpolated_salt_creek_wq.py
   ```

   This script will:
   - Interpolate the water quality data for the Salt Creek from 2023-07-01 00:00:00 onwards using the median water quality data for each datetime from historical data.
   - Save the interpolated data to:
     ```
     CDM/scripts/datatools/bcs/BC from Field Data/BCs_BAR_2012_2024_V1/Salt_Creek_20120101_20241114_interpolated.csv
     ```

> [!WARNING]
> Stop on step 2 if you do not need to interpolate the water quality data.
