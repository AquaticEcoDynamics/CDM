import pandas as pd
import os
import matplotlib.pyplot as plt

data_dir = "Precip_data_2016-2024"
site_data = {}

# Process each file in the directory
for file in os.listdir(data_dir):
    print(f"Processing {file}")
    
    # Extract site name from filename (between first and second dash)
    parts = file.split('-')
    if len(parts) >= 2:
        site = parts[1].strip().replace(" ", "")
        
        # Read only Time and Raw - Rainfall columns
        cols_to_read = ["Time", "Raw - Rainfall (mm)"]
        
        # First read the header to check available columns
        available_cols = pd.read_csv(os.path.join(data_dir, file), nrows=0).columns
        cols_to_use = [col.strip() for col in cols_to_read if col.strip() in available_cols]
        
        # Read CSV with Time column parsed as datetime
        df = pd.read_csv(os.path.join(data_dir, file), usecols=cols_to_use, parse_dates=['Time'])
        
        # Format Time column
        df['Time'] = pd.to_datetime(df['Time'], dayfirst=True)
        # Subtract 10 hours and 30 minutes from timestamps
        df['Time'] = df['Time'] - pd.Timedelta(hours=10, minutes=30)
        df['Time'] = df['Time'].dt.strftime('%Y-%m-%d %H:%M:%S')
        
        # Initialize or merge with existing site data
        if site not in site_data:
            site_data[site] = df
        else:
            # Merge with outer join on Time
            site_data[site] = pd.merge(site_data[site], df, on='Time', how='outer', suffixes=('', '_y'))
            # For any duplicate columns, use coalesce to take the first non-null value
            for col in df.columns:
                if col != 'Time' and f'{col}_y' in site_data[site].columns:
                    site_data[site][col] = site_data[site][col].combine_first(site_data[site][f'{col}_y'])
                    site_data[site] = site_data[site].drop(f'{col}_y', axis=1)

# Save each site's data to a separate CSV file
for site, df in site_data.items():
    # Sort by time
    df = df.sort_values(by='Time')
    
    # Convert Time to datetime for grouping
    df['Time'] = pd.to_datetime(df['Time'])
    
    # Group by Time and calculate mean for rainfall
    df = df.groupby('Time').mean(numeric_only=True).reset_index()
    
    # Convert Time back to string format
    df['ISOTime'] = df['Time'].dt.strftime('%Y-%m-%d %H:%M:%S')
    
    # Remove rows where rainfall is NaN
    df = df.dropna(subset=['Raw - Rainfall (mm)'])

    df['Precip'] = df['Raw - Rainfall (mm)']
    df['Precip'] /= 1000
    df = df.drop(columns=['Time', 'Raw - Rainfall (mm)'])
    print(df)
    
    # Save to CSV
    startdate = pd.to_datetime(df['ISOTime'].min()).strftime('%Y-%m-%d')
    enddate = pd.to_datetime(df['ISOTime'].max()).strftime('%Y-%m-%d')
    output_filename = f"../../../../data/store/metocean/{site}_rain_{startdate.replace('-', '')}_{enddate.replace('-', '')}.csv"
    df.to_csv(output_filename, index=False)
    print(f"Saved {output_filename}")

    # Plot
    plt.plot(pd.to_datetime(df['ISOTime']), df['Precip'])
    plt.show()
