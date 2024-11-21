# CoorongNarrung Met and Rain BC Files Update Process

This repository contains scripts for creating boundary condition (BC) files of meteorological data for the Narrung region.

## Prerequisites

- MATLAB

## Data Processing

1. Run the MATLAB script:
   ```matlab
   CDM/scripts/datatools/bcs/met/NRM_import/run_create_tfv_mat.m
   ```

   This script will:
   - Generate the met and rain BC files for the Narrung region.
     ```
     CDM/data/store/metocean/Narrung_met_20160201_20241113.csv
     CDM/data/store/metocean/Narrung_rain_20160201_20241113.csv
     ```
   - Generate the image file for the Narrung region.
     ```
     CDM/data/store/metocean/Narrung_20160201_20241113.png
     ```

> [!IMPORTANT]
> To run this script, please ensure that the mat file containing:
> - the hourly water data (`CDM/data/store/hydro/dew_WaterDataSA_hourly.mat`) for the Narrung region is in the correct format and is up to date. If not, please refer to the [Readme](../../../dataimport/hydro/WaterDataSA/Readme.md) for the process to update the mat file.
> - the met data (`CDM/data/store/metocean/NRM_metdata.mat`) for the Narrung region is in the correct format and is up to date. If not, please refer to the [Readme](../../../dataimport/metocean/Readme.md) for the process to update the mat file.