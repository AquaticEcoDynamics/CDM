import pandas as pd
import os

## Process the raw data from Claire
dir = "../../../../data/incoming/DEW/hydrology/compiled/Tide_Level_Prediction_Jan2023-Jun2024"
df_list = []

for file in os.listdir(dir):
    df = pd.read_csv(os.path.join(dir, file),skiprows=1,header=None)
    print("Sample of raw data:")
    print(df.head())
    df_list.append(df)

combined_df = pd.concat(df_list)
combined_df.columns = ["datetime","tide_level"]
combined_df["datetime"] = pd.to_datetime(combined_df["datetime"], dayfirst=True, format='mixed')
combined_df = combined_df.sort_values(by="datetime")
# Drop duplicate rows where all columns have the same values
combined_df = combined_df.drop_duplicates()

print(combined_df)

combined_df.to_csv("../../../../data/incoming/DEW/hydrology/compiled/Tide_Level_Prediction_Jan2023-Jun2024_from_Claire.csv", index=False)

## Fill up the data gaps in VH_Tide_2024.csv
vh_tide_2024 = pd.read_csv("../../../../data/incoming/DEW/hydrology/compiled/VH_Tide_2024.csv",skiprows=1)
print(vh_tide_2024.head())
vh_tide_2024["Timestamp (UTC+09:30)"] = pd.to_datetime(vh_tide_2024["Timestamp (UTC+09:30)"], dayfirst=True, format='mixed')
vh_tide_2024 = vh_tide_2024.sort_values(by="Timestamp (UTC+09:30)")

# Define all gap periods
gap_periods = [
    (pd.Timestamp('2023-07-27 15:15:00'), pd.Timestamp('2023-12-07 11:40:00')),
    (pd.Timestamp('2024-01-05 19:10:00'), pd.Timestamp('2024-01-12 08:05:00')),
    (pd.Timestamp('2024-01-26 00:10:00'), pd.Timestamp('2024-01-29 07:20:00'))
]

vh_tide_2024_filled = vh_tide_2024.copy()

for gap_start, gap_end in gap_periods:
    # Find data from Claire's predictions for the gap period
    gap_data = combined_df[(combined_df['datetime'] >= gap_start) & 
                          (combined_df['datetime'] <= gap_end)].copy()
    gap_data = gap_data.rename(columns={'datetime': 'Timestamp (UTC+09:30)', 'tide_level': 'Value (m)'})
    
    # Resample gap_data to 1-minute frequency using linear interpolation
    gap_data = gap_data.set_index('Timestamp (UTC+09:30)')
    gap_data = gap_data.resample('1min').interpolate(method='linear')
    gap_data = gap_data.reset_index()

    # Add empty Event Timestamp column to match original format
    gap_data['Event Timestamp (UTC+09:30)'] = ''

    # Reorder columns to match original format
    gap_data = gap_data[['Timestamp (UTC+09:30)', 'Event Timestamp (UTC+09:30)', 'Value (m)']]

    # Remove existing data in the gap period
    vh_tide_2024_filled = vh_tide_2024_filled[
        ~((vh_tide_2024_filled['Timestamp (UTC+09:30)'] >= gap_start) & 
          (vh_tide_2024_filled['Timestamp (UTC+09:30)'] <= gap_end))
    ]

    # Add the gap data
    vh_tide_2024_filled = pd.concat([vh_tide_2024_filled, gap_data])
    
    print(f"Filled gap from {gap_start} to {gap_end}")

vh_tide_2024_filled = vh_tide_2024_filled.sort_values(by="Timestamp (UTC+09:30)")

# Save the filled data
vh_tide_2024_filled.to_csv("../../../../data/incoming/DEW/hydrology/compiled/VH_Tide_2024_filled.csv", index=False)

print(f"Total records in filled dataset: {len(vh_tide_2024_filled)}")

## Compare the filled data with the original data
vh_tide_2024_filled = pd.read_csv("../../../../data/incoming/DEW/hydrology/compiled/VH_Tide_2024_filled.csv")
vh_tide_2024_filled["Timestamp (UTC+09:30)"] = pd.to_datetime(vh_tide_2024_filled["Timestamp (UTC+09:30)"], dayfirst=True, format='mixed')
vh_tide_2024_filled = vh_tide_2024_filled.sort_values(by="Timestamp (UTC+09:30)")

import matplotlib.pyplot as plt
# Filter data for July 2023 to Dec 2024
start_date = pd.Timestamp('2023-07-01')
end_date = pd.Timestamp('2024-12-01')

mask_filled = (vh_tide_2024_filled["Timestamp (UTC+09:30)"] >= start_date) & (vh_tide_2024_filled["Timestamp (UTC+09:30)"] <= end_date)
mask_orig = (vh_tide_2024["Timestamp (UTC+09:30)"] >= start_date) & (vh_tide_2024["Timestamp (UTC+09:30)"] <= end_date)
mask_combined = (combined_df["datetime"] >= start_date) & (combined_df["datetime"] <= end_date)
plt.plot(combined_df[mask_combined]["datetime"],
         combined_df[mask_combined]["tide_level"],
         label="Claire's predictions", linewidth=0.3, color="green")
plt.plot(vh_tide_2024_filled[mask_filled]["Timestamp (UTC+09:30)"], 
         vh_tide_2024_filled[mask_filled]["Value (m)"], 
         label="Filled", linewidth=0.3, color="red")
plt.plot(vh_tide_2024[mask_orig]["Timestamp (UTC+09:30)"],
         vh_tide_2024[mask_orig]["Value (m)"],
         label="Original", linewidth=0.3, color="blue")

plt.ylabel("tidal elevations (m)")
plt.legend()
plt.show()