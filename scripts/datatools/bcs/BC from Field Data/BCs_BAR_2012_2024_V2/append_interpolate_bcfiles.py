import pandas as pd

# Read barrage data
barrage_df = pd.read_csv('../../../../../data/incoming/DEW/barrages/barrage_daily_total_2023.csv', skiprows=4)  # Skip header rows
barrage_df['Timestamp (UTC+09:30)'] = pd.to_datetime(barrage_df['Timestamp (UTC+09:30)'])
barrage_df.columns = ['Timestamp (UTC+09:30)', 'Goolwa','Tauwitchere','Mundoo','Boundary','Ewe']

# Convert ISOTime to datetime in combined dataframe - handle both formats
def parse_datetime(x):
    try:
        # Try the original format (dd/mm/yyyy HH:MM:SS)
        return pd.to_datetime(x, format="%d/%m/%Y %H:%M:%S", dayfirst=True)
    except:
        # If that fails, try ISO format (yyyy-mm-dd)
        return pd.to_datetime(x)

## merge historical and recent data
df1 = pd.read_csv('Salt_Creek_20120101_20230701_appended.csv')
df2 = pd.read_csv('Salt_Creek_20230701_20241114.csv')
df_combined = pd.concat([df1, df2], ignore_index=True)
df_combined.to_csv('Salt_Creek_20120101_20241114.csv', index=False)

df1_BK = pd.read_csv('BK_20160101_20230701.csv')
df2_BK = pd.read_csv('BK_20230701_20241114.csv')
df_combined_BK = pd.concat([df1_BK, df2_BK], ignore_index=True)
df_combined_BK.to_csv('BK_20160101_20241114.csv', index=False)

barrage_sites = ['Goolwa', 'Tauwitchere', 'Mundoo', 'Boundary', 'Ewe']
for site in barrage_sites:
    df1_barrage = pd.read_csv(f'{site}_20120101_20230701.csv')
    df2_barrage = pd.read_csv(f'{site}_20230701_20241114.csv')
    df_combined_barrage = pd.concat([df1_barrage, df2_barrage], ignore_index=True)
    
    # Get flow column from barrage data
    flow = barrage_df[['Timestamp (UTC+09:30)', site]]
    flow.columns = ['ISOTime', 'FLOW']
    df_combined_barrage['ISOTime'] = df_combined_barrage['ISOTime'].apply(parse_datetime)
    
    # Replace all FLOW values before July 2nd, 2023
    mask = df_combined_barrage['ISOTime'] < '2023-07-02'
    df_combined_barrage = df_combined_barrage.merge(flow, on='ISOTime', how='left', suffixes=('', '_barrage'))
    df_combined_barrage.loc[mask, 'FLOW'] = df_combined_barrage.loc[mask, 'FLOW_barrage']
    # Fill any remaining NaN values with 0
    df_combined_barrage['FLOW'] = df_combined_barrage['FLOW'].fillna(0)
    df_combined_barrage = df_combined_barrage.drop('FLOW_barrage', axis=1)
    
    df_combined_barrage.to_csv(f'{site}_20120101_20241114.csv', index=False)

## interpolate data
file_lst = ['Salt_Creek_20120101_20241114.csv', 'BK_20160101_20241114.csv', 'Goolwa_20120101_20241114.csv', 'Tauwitchere_20120101_20241114.csv', 'Mundoo_20120101_20241114.csv', 'Boundary_20120101_20241114.csv', 'Ewe_20120101_20241114.csv']
for file in file_lst:
    df = pd.read_csv(file)
    df['ISOTime'] = df['ISOTime'].apply(parse_datetime)  # Use the same parsing function here
    if file == 'BK_20160101_20241114.csv':
        mask = (df['WL'] > 1) & (df['ISOTime'] > '2023-07-01 00:00:00')
        df.loc[mask, 'WL'] = 0
        mask = (df['ISOTime'] > '2023-04-15 00:00:00') & (df['ISOTime'] < '2023-07-02 00:00:00')
        df.loc[mask, 'WL'] = 0

    mask = (df['AMM'] != 0) & (df['NIT'] != 0) & (df['ISOTime'] > '2023-07-01 00:00:00')  # Only calculate where both values are non-zero and after July 2023
    df.loc[mask, 'FRP'] = (df.loc[mask, 'AMM'] + df.loc[mask, 'NIT'])/16

    mask = (df['FRP'] != 0) & (df['ISOTime'] > '2023-07-01 00:00:00')
    # df.loc[mask, 'FRP_ADS'] = 0.49 * df.loc[mask, 'FRP'] 
    df.loc[mask, 'FRP_ADS'] = 0.1 * df.loc[mask, 'FRP'] 

    mask = (df['DOC'] != 0) & (df['ISOTime'] > '2023-07-01 00:00:00')
    df.loc[mask, 'POC'] = (1/4) * df.loc[mask, 'DOC']

    mask = (df['TOT_TN'] != 0) & (df['NIT'] != 0) & (df['AMM'] != 0) & (df['ISOTime'] > '2023-07-01 00:00:00')
    df.loc[mask, 'DON'] = (df.loc[mask, 'TOT_TN'] - df.loc[mask, 'NIT'] - df.loc[mask, 'AMM'])*0.8

    mask = (df['TOT_TN'] != 0) & (df['NIT'] != 0) & (df['AMM'] != 0) & (df['ISOTime'] > '2023-07-01 00:00:00')
    # df.loc[mask, 'PON'] = (df.loc[mask, 'TOT_TN'] - df.loc[mask, 'NIT'] - df.loc[mask, 'AMM'])*0.2 * 2
    df.loc[mask, 'PON'] = (df.loc[mask, 'TOT_TN'] - df.loc[mask, 'NIT'] - df.loc[mask, 'AMM'])*0.2

    mask = (df['DON'] != 0) & (df['ISOTime'] > '2023-07-01 00:00:00')
    # df.loc[mask, 'DOP'] = (1/16) * df.loc[mask, 'DON'] / 3
    df.loc[mask, 'DOP'] = (1/16) * df.loc[mask, 'DON']

    mask = (df['PON'] != 0) & (df['ISOTime'] > '2023-07-01 00:00:00')
    # df.loc[mask, 'POP'] = (1/16) * df.loc[mask, 'PON'] / 2
    df.loc[mask, 'POP'] = (1/16) * df.loc[mask, 'PON']

    col_name = ['FLOW', 'SAL', 'TEMP', 'OXY']
    avg_df = df.copy()
    
    # if file == 'BK_20160101_20241114.csv':
    #     avg_df = avg_df.drop(columns=['SAL', 'TEMP', 'OXY'])
    # else:
    #     avg_df = avg_df.drop(columns=col_name)

    avg_df = avg_df[avg_df['ISOTime'] < '2023-07-01 00:00:00']
    avg_df = avg_df[avg_df['ISOTime'] > '2012-01-15 00:00:00']
    avg_df['ISOTime'] = avg_df['ISOTime'].dt.strftime("%m-%d %H:%M:%S")

    # Get all columns except ISOTime
    data_columns = [col for col in avg_df.columns if col != 'ISOTime']

    # Calculate avg for all data columns
    avg_df = avg_df.groupby('ISOTime').agg({
        col: 'median' for col in data_columns
    }).reset_index()

    # Rename all columns to lowercase
    avg_df = avg_df.rename(columns={
        col: col.lower() for col in avg_df.columns if col != 'ISOTime'
    })

    # Create a datetime index without year for df
    df['datetime_no_year'] = pd.to_datetime(df['ISOTime']).dt.strftime('%m-%d %H:%M:%S')

    # Get matching column names between df and avg_df (excluding ISOTime/datetime columns)
    matching_cols = [col for col in df.columns if col.lower() in avg_df.columns and col not in ['ISOTime', 'datetime_no_year']]

    # Create mask for date range and zero values
    if file == 'BK_20160101_20241114.csv':
        mask = (df['ISOTime'] > '2023-04-15 00:00:00')
    else:
        mask = (df['ISOTime'] > '2023-07-01 00:00:00')

    # Create mapping from datetime_no_year to values for each matching column
    for col in matching_cols:
        # Create mapping from avg_df using lowercase column name
        col_mapping = dict(zip(avg_df['ISOTime'], avg_df[col.lower()]))
        
        # Fill only zero values where mask is True using the datetime_no_year mapping
        zero_mask = (df[col] == 0) & mask
        df.loc[zero_mask, col] = df.loc[zero_mask, 'datetime_no_year'].map(col_mapping)

    df = df.drop(columns=['datetime_no_year'])
    df.to_csv(f'{file.split(".")[0]}_interpolated.csv', index=False)
    print(f'{file.split(".")[0]}_interpolated.csv saved')

    print(df)