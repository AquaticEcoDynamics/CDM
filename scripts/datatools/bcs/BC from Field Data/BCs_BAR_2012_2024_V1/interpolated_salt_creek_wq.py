import pandas as pd

df = pd.read_csv('Salt_Creek_20120101_20241114_appended.csv')
df['ISOTime'] = pd.to_datetime(df['ISOTime'], format="%d/%m/%Y %H:%M", dayfirst=True)

col_name = ['FLOW', 'SAL', 'TEMP', 'OXY']
avg_df = df.copy()
avg_df = avg_df.drop(columns=col_name)

# avg_df['ISOTime'] = pd.to_datetime(avg_df['ISOTime'], format="%d/%m/%Y %H:%M", dayfirst=True)
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
# print(avg_df)

# Create a datetime index without year for df
df['datetime_no_year'] = pd.to_datetime(df['ISOTime']).dt.strftime('%m-%d %H:%M:%S')

# Get matching column names between df and avg_df (excluding ISOTime/datetime columns)
matching_cols = [col for col in df.columns if col.lower() in avg_df.columns and col not in ['ISOTime', 'datetime_no_year']]

# Create mask for date range
# mask = (df['ISOTime'] >= '2023-07-01 00:00:00') | (df['ISOTime'] <= '2012-01-14 00:00:00')
mask = (df['ISOTime'] > '2023-07-01 00:00:00')

# Create mapping from datetime_no_year to values for each matching column
for col in matching_cols:
    # Create mapping from avg_df using lowercase column name
    col_mapping = dict(zip(avg_df['ISOTime'], avg_df[col.lower()]))
    
    # Fill values only where mask is True using the datetime_no_year mapping
    df.loc[mask, col] = df.loc[mask, 'datetime_no_year'].map(col_mapping)

df = df.drop(columns=['datetime_no_year'])
df.to_csv('Salt_Creek_20120101_20241114_interpolated.csv', index=False)

print(df)