# Coorong Water Quality Data from DataSA

This repository contains scripts for importing water quality data from DataSA into MATLAB.

## Prerequisites

- MATLAB
- Python
- Access to data.sa.gov.au

## Data Processing

### Import Raw Data into .mat File
1. Run the Python script:
   ```
   CDM/scripts/dataimport/ecology/DataSA_WQ/import_DataSA.py
   ```

   This script will:
   - Process and convert raw data from DataSA into a MATLAB .mat file
   - Save the output as:
     ```
     CDM/data/store/ecology/wq_hchb_2024.mat
     ```

2. Run the Python script:
   ```
   CDM/scripts/dataimport/ecology/DataSA_WQ/import_DataSA_agency.py
   ```

   This script will:
   - Process and convert raw data from DataSA into two separate MATLAB .mat files for ALS and AWQC
   - Save the output as:
     ```
     CDM/data/store/ecology/ALS_wq_hchb_2024.mat
     CDM/data/store/ecology/AWQC_wq_hchb_2024.mat
     ```

> [!IMPORTANT]
> Adjustment made to downloaded data before converted into tfv_unit:
> - Ammonia_as_N_mg_L / 2000
> - Nitrate_Nitrite_as_N_mg_L / 2000
> - Silica_Reactive_mg_L / 3.15
> - Dissolved_Organic_Carbon_mg_L * 2.4
> - Total_Organic_Carbon_mg_L * 2.9
> - Nitrogen_Total_as_N_mg_L * 2
>
> Then, variables are renamed to match TFV standards, and converted to TFV units using the conversion factors listed in the table ```CDM/scripts/dataimport/ecology/DataSA_WQ/Var_Conv.csv```.
