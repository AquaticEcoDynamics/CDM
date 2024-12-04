# Coorong Barrages Flow Data from SA Water

This repository contains scripts for importing barrages flow data from SA Water into MATLAB.

## Prerequisites

- MATLAB

## Data Processing

1. Raw data downloaded were processed in Excel to convert into .csv files with standardised column names and units and saved to:
   ```
   CDM/data/incoming/DEW/barrages/barrage_daily_total_2024.csv
   ```
   
> [!NOTE]
> Flow data in the raw data were in ML/day, which were converted to m3/s using a conversion factor of 1000/86400.

2. Run the MATLAB script:
   ```
   CDM/scripts/dataimport/hydro/Barrages/import_barrage_data_2024.m
   ```

   This script will:
   - Process and convert raw data into a MATLAB .mat file
   - Save the output as:
     ```
     CDM/data/store/hydro/dew_barrage_2024.mat
     ```