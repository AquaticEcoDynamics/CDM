import pandas as pd
import os
import numpy as np

data_dir_lst = ["GreenBrain_Narrung_2023", "GreenBrain_Narrung_2024",
                "GreenBrain_WellingtonEast_2023", "GreenBrain_WellingtonEast_2024"]

for data_dir in data_dir_lst:
    print(f"Processing {data_dir}")
    df_lst = []
    merged_df = None
    
    for file in os.listdir(data_dir):
        print(f"Processing {file}")
        cols_to_read = ["Time", "Average - Air Temperature (ºC)", "Delta T - (ºC)", "Dew Point - (ºC)", "Rainfall - (mm)", "Average - Relative Humidity (%)", "Average - Soil Temperature (ºC)", "Average - Solar Radiation (W/m^2)", "Average - Supply (V)", "Average - Wind Direction (º)", "Average - Wind Speed (km/h)", "Maximum - Wind Speed (km/h)", "Minimum - Wind Speed (km/h)"]
        
        # First read the header to check available columns
        available_cols = pd.read_csv(os.path.join(data_dir, file), nrows=0).columns
        cols_to_use = [col.strip() for col in cols_to_read if col.strip() in available_cols]
        
        # Read CSV with Time column parsed as datetime
        df = pd.read_csv(os.path.join(data_dir, file), usecols=cols_to_use, parse_dates=['Time'])
        
        # Format Time column to yyyy-mm-dd HH:MM:SS
        df['Time'] = pd.to_datetime(df['Time'], dayfirst=True)
        # Subtract 10 hours and 30 minutes from timestamps
        df['Time'] = df['Time'] - pd.Timedelta(hours=10, minutes=30)
        df['Time'] = df['Time'].dt.strftime('%Y-%m-%d %H:%M:%S')
        
        # Initialize merged_df with the first file
        if merged_df is None:
            merged_df = df
        else:
            # Merge with outer join on Time to keep all timestamps and combine columns
            merged_df = pd.merge(merged_df, df, on='Time', how='outer', suffixes=('', '_y'))
            # For any duplicate columns, use coalesce to take the first non-null value
            for col in df.columns:
                if col != 'Time' and f'{col}_y' in merged_df.columns:
                    merged_df[col] = merged_df[col].combine_first(merged_df[f'{col}_y'])
                    merged_df = merged_df.drop(f'{col}_y', axis=1)
    
    # Sort the final merged dataframe by Time
    merged_df = merged_df.sort_values(by="Time")
    
    # Remove rows where all columns except Time are NaN
    merged_df = merged_df.dropna(subset=[col for col in merged_df.columns if col != 'Time'], how='all')
    
    # Define column mapping dictionary
    column_mapping = {
        'Time': 'time',
        'Average - Air Temperature (ºC)': 'Air Temperature_average_ºC',
        'Delta T - (ºC)': 'Delta T_average_ºC',
        'Dew Point - (ºC)': 'Dew Point_average_ºC',
        'Rainfall - (mm)': 'Rainfall_raw_mm',
        'Average - Relative Humidity (%)': 'Relative Humidity_average_%',
        'Average - Soil Temperature (ºC)': 'Soil Temperature_average_ºC',
        'Average - Solar Radiation (W/m^2)': 'Solar Radiation_average_W/m^2',
        'Average - Supply (V)': 'Voltage_average_V',
        'Average - Wind Direction (º)': 'Wind Direction_average_º',
        'Average - Wind Speed (km/h)': 'Wind Speed_average_km/h',
        'Maximum - Wind Speed (km/h)': 'Wind Speed_maximum_km/h',
        'Minimum - Wind Speed (km/h)': 'Wind Speed_minimum_km/h'
    }

    # Filter mapping to only include existing columns and rename
    filtered_mapping = {k: v for k, v in column_mapping.items() if k in merged_df.columns}
    merged_df = merged_df.rename(columns=filtered_mapping)

    # Define all required columns in order
    required_columns = [
        'time',
        'Air Temperature_average_ºC',
        'Apparent Temperature_average_ºC',
        'Delta T_average_ºC',
        'Dew Point_average_ºC',
        'Rainfall_raw_mm',
        'Relative Humidity_average_%',
        'Soil Temperature_average_ºC',
        'Solar Radiation_average_W/m^2',
        'Voltage_average_V',
        'Wind Direction_average_º',
        'Wind Speed_average_km/h',
        'Wind Speed_maximum_km/h',
        'Wind Speed_minimum_km/h'
    ]

    # Add missing columns with NaN values and reorder
    for col in required_columns:
        if col not in merged_df.columns:
            merged_df[col] = np.nan
    
    merged_df = merged_df[required_columns]
    
    # Save the final dataframe
    merged_df.to_csv(f"{data_dir.split('_')[1]}_{data_dir.split('_')[-1]}.csv", index=False)
    print(merged_df.head())