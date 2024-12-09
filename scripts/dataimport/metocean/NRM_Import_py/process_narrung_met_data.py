import pandas as pd
import os
import numpy as np

downloaded_data_dir = "narrung_met_raw_data"
incoming_data_dir = "../../../../data/incoming/NRM/Narrung"

# Add Wellington East data processing before historical data processing
wellington_data_lst = []
for year in [2023, 2024]:
    wellington_file = f"../NRM_API_py/WellingtonEast_{year}.csv"
    print(f"\nTrying to load Wellington file: {wellington_file}")
    if os.path.exists(wellington_file):
        print(f"File exists, loading {wellington_file}")
        well_df = pd.read_csv(wellington_file)
        well_df["time"] = pd.to_datetime(well_df["time"])
        # Filter Wellington data to only include dates after 2022-11-07 01:30:00
        well_df = well_df[well_df["time"] > pd.to_datetime("2022-11-07 01:30:00")]
        wellington_data_lst.append(well_df)
        print(f"Loaded columns: {well_df.columns.tolist()}")
    else:
        print(f"File not found: {wellington_file}")

wellington_data_df = pd.concat(wellington_data_lst) if wellington_data_lst else None

historical_data_lst = []
for file in os.listdir(incoming_data_dir):
    if file.endswith(".csv") and "py_" not in file:
        hist_sr_df = pd.read_csv(os.path.join(incoming_data_dir, file),usecols=[0,8])
        hist_sr_df["time"] = pd.to_datetime(hist_sr_df["time"],format="%Y-%m-%d %H:%M:%S")
        historical_data_lst.append(hist_sr_df)
historical_data_df = pd.concat(historical_data_lst)
historical_data_df = historical_data_df.sort_values(by="time")

# Extract month, day, hour, minute, second
historical_data_df["time_of_year"] = historical_data_df["time"].dt.strftime("%m-%d %H:%M:%S")

# Group by time_of_year and calculate median solar radiation, skipping NaN values
median_sr_df = historical_data_df.groupby("time_of_year").agg({historical_data_df.columns[1]: lambda x: x.median(skipna=True)}).reset_index()
median_sr_df = median_sr_df.rename(columns={historical_data_df.columns[1]: "solar_radiation"})
print(median_sr_df)

dfs = []

for file in os.listdir(downloaded_data_dir):
    if file.endswith(".csv"):
        variable = file.split("DataSetExport-")[1].split(".Best Available")[0] + " " + file.split("--")[1].split("@")[0].replace("Avg","average").replace("Max","maximum").replace("Min","minimum")
        df = pd.read_csv(os.path.join(downloaded_data_dir, file), skiprows=1, usecols=[0,2])
        
        # Convert to datetime and subtract 10.5 hours to go from UTC+10:30 to UTC+0:00
        df["time"] = pd.to_datetime(df["Timestamp (UTC+09:30)"], format="%Y-%m-%d %H:%M:%S") - pd.Timedelta(hours=10, minutes=30)
        
        # Round to nearest 15 minutes
        df['time'] = df['time'].dt.round('15min')
        
        unit = df.columns[1].split("(")[1].split(")")[0]
        var_unit = variable.replace(" ","_") + "_" + unit
        df[var_unit] = df[df.columns[1]]
        
        # Group by rounded time and calculate mean for duplicate timestamps
        df = df.groupby('time')[var_unit].mean().reset_index()
        
        dfs.append(df)

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

# After renaming columns but before filling NaN values, add Wellington East data filling
if wellington_data_df is not None:
    print("\nColumns in Wellington East data:", wellington_data_df.columns.tolist())
    # For each column in required columns
    for col in required_columns:
        if col != 'time':
            if col in wellington_data_df.columns:
                print(f"Filling NaN values in {col} with Wellington East data")
                # Create a time-based mapping from Wellington East data
                well_values = dict(zip(wellington_data_df['time'], wellington_data_df[col]))
                # Only fill NaN values with Wellington East data
                merged_df[col] = merged_df[col].fillna(merged_df['time'].map(well_values))

# Reorder columns to match required format
merged_df = merged_df[required_columns]
print(merged_df)

# Save to incoming data directory
# Extract year from timestamp and group data by year
merged_df['year'] = pd.to_datetime(merged_df['time']).dt.year

# Remove rows where all columns except time are missing
value_columns = [col for col in merged_df.columns if col not in ['time', 'year']]
merged_df = merged_df.dropna(subset=value_columns, how='all')

# Filter merged_df to only include dates after 2022-11-07 01:30:00
merged_df = merged_df[merged_df["time"] > pd.to_datetime("2022-11-07 01:30:00")]

# Iterate through unique years and save separate files
for year in merged_df['year'].unique():
    # Get data for current year
    year_df = merged_df[merged_df['year'] == year].copy()
    
    # Drop the temporary year column
    year_df = year_df.drop('year', axis=1)
    
    # Create a datetime index without year for year_df, rounding to the nearest minute
    year_df['datetime_no_year'] = pd.to_datetime(year_df['time']).dt.strftime('%m-%d %H:%M:00')
    
    # Create a mapping from datetime_no_year to solar radiation values
    sr_mapping = dict(zip(median_sr_df['time_of_year'], median_sr_df['solar_radiation']))
    
    # Only fill solar radiation values that are still NaN after Wellington data filling
    mask = (pd.to_datetime(year_df['time']) > pd.to_datetime('2022-11-07 01:30:00')) & \
           (year_df['Solar Radiation_average_W/m^2'].isna())
           
    if year == 2024:
        print("DEBUG:sr_mapping",list(sr_mapping.items())[:10])
        print("Sample datetime_no_year values:")
        print(year_df.loc[mask, 'datetime_no_year'].head(10))
        print("\nCorresponding mapped values:")
        print(year_df.loc[mask, 'datetime_no_year'].map(sr_mapping).head(10))
    
    year_df.loc[mask, 'Solar Radiation_average_W/m^2'] = year_df.loc[mask, 'datetime_no_year'].map(sr_mapping)
    
    # Remove the temporary datetime_no_year column
    year_df = year_df.drop('datetime_no_year', axis=1)
    
    # Perform linear interpolation only on data after 2022-11-07 01:30:00
    year_df = year_df.set_index('time')
    cutoff_date = pd.to_datetime('2022-11-07 01:30:00')
    mask = year_df.index > cutoff_date
    
    # Only interpolate rows after cutoff date
    year_df.loc[mask] = year_df.loc[mask].interpolate(method='linear')
    
    year_df = year_df.reset_index()
    
    # Create output filename
    output_filename = f'py_Narrung_{year}.csv'
    output_path = os.path.join(incoming_data_dir, output_filename)
    
    # Save to CSV
    year_df.to_csv(output_path, index=False)
    print(f'Saved data for year {year} to {output_filename}')

# Drop temporary year column from main dataframe
merged_df = merged_df.drop('year', axis=1)

