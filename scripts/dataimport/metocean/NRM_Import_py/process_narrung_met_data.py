import pandas as pd
import os
import numpy as np

downloaded_data_dir = "narrung_met_raw_data"
incoming_data_dir = "../../../../data/incoming/NRM/Narrung"

dfs = []

for file in os.listdir(downloaded_data_dir):
    if file.endswith(".csv"):
        # print(file)
        variable = file.split("DataSetExport-")[1].split(".Best Available")[0] + " " + file.split("--")[1].split("@")[0].replace("Avg","average").replace("Max","maximum").replace("Min","minimum")
        df = pd.read_csv(os.path.join(downloaded_data_dir, file),skiprows=1, usecols=[0,2])
        # Convert to datetime and subtract 10.5 hours to go from UTC+10:30 to UTC+0:00
        df["time"] = pd.to_datetime(df["Timestamp (UTC+09:30)"],format="%Y-%m-%d %H:%M:%S") - pd.Timedelta(hours=10, minutes=30)
        unit = df.columns[1].split("(")[1].split(")")[0]
        var_unit = variable.replace(" ","_") + "_" + unit
        df[var_unit] = df[df.columns[1]]
        df = df[["time",var_unit]]
        dfs.append(df)
        # print(df)

# Merge all dataframes on time column
merged_df = pd.concat([df.set_index('time') for df in dfs], axis=1)
merged_df = merged_df.reset_index()
print(merged_df)
# Rename columns to match required format
column_mapping = {
    'Air_Temp_average_°C': 'Air Temperature_average_ºC',
    'Dew_Point_Temp_Continuous_°C': 'Dew Point_average_ºC',
    'Rainfall_Continuous_mm': 'Rainfall_raw_mm',
    'Rel_Humidity_average_%': 'Relative Humidity_average_%RH',
    'Soil_Temperature_Continuous_°C': 'Soil Temperature_average_ºC',
    'Solar_Rad_Intensity_Continuous_W/m^2': 'Solar Radiation_average_W/m^2',
    'Wind_Dir_average_deg': 'Wind Direction_average_º',
    'Wind_Vel_average_km/hr': 'Wind Speed_average_km/h',
    'Wind_Vel_maximum_km/hr': 'Wind Speed_maximum_km/h',
    'Wind_Vel_minimum_km/hr': 'Wind Speed_minimum_km/h'
}

merged_df = merged_df.rename(columns=column_mapping)

# Ensure all required columns exist
required_columns = ['time', 
                    'Air Temperature_average_ºC',
                    'Apparent Temperature_average_ºC', 
                    'Delta T_average_ºC', 
                    'Dew Point_average_ºC', 
                    'Rainfall_raw_mm',
                    'Relative Humidity_average_%RH', 
                    'Soil Temperature_average_ºC',
                    'Solar Radiation_average_W/m^2', 
                    'Voltage_average_V', 
                    'Wind Direction_average_º',
                    'Wind Speed_average_km/h', 
                    'Wind Speed_maximum_km/h', 
                    'Wind Speed_minimum_km/h']

for col in required_columns:
    if col not in merged_df.columns:
        merged_df[col] = np.nan

# Reorder columns to match required format
merged_df = merged_df[required_columns]
print(merged_df)

# Save to incoming data directory
# Extract year from timestamp and group data by year
merged_df['year'] = pd.to_datetime(merged_df['time']).dt.year

# Remove rows where all columns except time are missing
value_columns = [col for col in merged_df.columns if col not in ['time', 'year']]
merged_df = merged_df.dropna(subset=value_columns, how='all')

# Iterate through unique years and save separate files
for year in merged_df['year'].unique():
    # Get data for current year
    year_df = merged_df[merged_df['year'] == year].copy()
    
    # Drop the temporary year column
    year_df = year_df.drop('year', axis=1)
    
    # Create output filename
    output_filename = f'py_Narrung_{year}.csv'
    output_path = os.path.join(incoming_data_dir, output_filename)
    
    # Save to CSV
    year_df.to_csv(output_path, index=False)
    print(f'Saved data for year {year} to {output_filename}')

# Drop temporary year column from main dataframe
merged_df = merged_df.drop('year', axis=1)
