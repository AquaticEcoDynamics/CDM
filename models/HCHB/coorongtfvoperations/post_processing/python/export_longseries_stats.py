"""
Script to generate longsection figures from model runs 
A Waterhouse
"""

from pathlib import Path
from py_utils.extraction_functions import *
from py_utils.utilities import *
import os


# Path to this script inside git
file_path = Path(__file__).parent.absolute()

# -------------------------------------------------------------------
# User Input
# -------------------------------------------------------------------
# Key inputs
#results_folder = Path("D:\\A11650_Coorong_Release\\coorong-barrage-release\\results\\scenarios")
results_folder = Path("/scratch2/A11650/TUFLOWFV/scenarios")

# Line file to extract long-section along. Assumed saved in same directory as this script
line_file = file_path / "resources/Coorong_chainage_003v2_P_nochainage.csv"
polyline = np.loadtxt(line_file, skiprows=1, delimiter=',').tolist()

# Periods by water-year
seasons = {
    'Jan_Mar': (1, 4),
    'Apr_Jul': (4, 8), 
    'Aug_Dec': (8, 1),
}
years = (2018, 2020)
#seasons = gen_periods_dict(years[0], years[1], seasons)
seasons = {
    '2018_Jan_Mar' : (pd.Timestamp(2018,1,1), pd.Timestamp(2018,4,1)),
    '2018_Apr_Jul' : (pd.Timestamp(2018,4,1), pd.Timestamp(2018,8,1)),
    '2018_Aug_Dec' : (pd.Timestamp(2018,8,1), pd.Timestamp(2019,1,1)),
    '2019_Jan_Mar' : (pd.Timestamp(2019,1,1), pd.Timestamp(2019,4,1))
}

# Variables to process {"Name as in TFV netcdf": "Variable name for xlsx"}
variables = {
    "H": "Water Level [m]",
    "SAL": "Salinity [g/L]"
}

# Save data below this script in output directory
xls_output_file = 'Coorong_Release_Export_longseries_SaltExportScns.xlsx'
xls_output_folder = file_path / "../results/longseries"

# Scenarios to process {"TFV result id" : "Scenario name for xlsx"}
scns_to_process = {
    #'BASE_001_20180101_20190301' : '6.0 Base',
    #'SCN6p1_001' : '6.1 Salt Export Ext.',
    #'SCN6p2_001' : '6.2 Summer Mundoo + Goolwa',
    #'SCN6p3_001' : '6.3 Additional Autumn Release',
    #'SCN6p4_001' : '6.4 No Dredging Jun - Aug',
    #'SCN6p5_001' : '6.5 No Dredging Jun - Oct'
    
    #'BASE_001_20180101_20190301' : 'Base',
    #'SCN1p1a_002_Combined' : '1a 80% Tau, 20% Goo',
    #'SCN1p1b_002_Combined' : '1b 20% Tau, 80% Goo',
    #'SCN1p1c_002_Combined' : '1c 60% Tau, 10% Goo, 30% Ewe',
    #'SCN1p1d_001' : '1d 80% Tau, 20% Goo Pulsed'
    
    'BASE_001_20180101_20190301' : 'Base',
    'SCN2p1_001' : '2.1 No Barrage',
    'SCN2p2_001' : '2.2 No Barrage Sept - Dec',
    'SCN2p3_001' : '2.3a Wind Disabled',
    'SCN2p3_002' : '2.3b No Wind Drag',
    'SCN6p1_001' : '6.1 Salt Export Ext.',
    'SCN6p2_001' : '6.2 Summer Mundoo + Goolwa',
    'SCN6p3_001' : '6.3 Additional Autumn Release',
    'SCN6p4_001' : '6.4 No Dredging Jun - Aug',
    'SCN6p5_001' : '6.5 No Dredging Jun - Oct'
    
    #'BASE_001_20180801_20190301' : 'Base',
    #'SCN4p1a_002' : '4.1a 2 Months Starting Aug',
    #'SCN4p1b_002' : '4.1b 2 Months Starting Nov',
    #'SCN4p2_002' : '4.2 5 Months Starting Aug',
    #'SCN4p3_002' : '4.3 8 Months Starting Nov'
}
# -------------------------------------------------------------------
# Go Time
# -------------------------------------------------------------------

xls_output_folder.mkdir(exist_ok=True, parents=True)
try:
    os.remove(xls_output_folder / xls_output_file)
except OSError:
    pass
# writer = pd.ExcelWriter(xls_output_folder / xls_output_file, engine='openpyxl')
for c, (id, scn_name) in enumerate(scns_to_process.items()):
    flist = list(results_folder.glob(f'*{id}*_hd.nc'))

    file = flist[0]  # Convienence for geo and naming
    print(f'Processing {file.name}')
    # Load results in an out-of-mem xarray fella
    ds, time_vec= load_mftfv_nc(flist)

    # Get polyline intersection - Use TFV for this
    xtr = FvExtractor(file)
    x_data = xtr.get_intersection_data(polyline)
    chainage = np.cumsum(np.hypot(np.diff(x_data[0]), np.diff(
        x_data[1]))) / 1000
    idx = x_data[2]

    # Extract all the variable data once. (efficient for 2D! )
    print('Loading all data - this will take a few mins')
    data = {}
    for tfvar in variables.keys():
        data[tfvar] = ds[tfvar].values

    df = pd.DataFrame()
    df["X"] = np.mean((x_data[0][:-1], x_data[0][1:]),
                      axis=0)  # X_data returns edges, so take mean.
    df["Y"] = np.mean((x_data[1][:-1], x_data[1][1:]), axis=0)
    df["Chainage"] = chainage

    # Loop through seasons
    for season, (time_start, time_end) in seasons.items():
        print(f"loading results for {season}")
        time_idx = (time_vec >= time_start) & (time_vec < time_end)

        # Extract all the variable data once. (efficient for 2D! )
        for tfvar, variable in variables.items():
            unit = xtr.nc[tfvar].units
            data_seasonal_avg = (data[tfvar][time_idx, :][:, idx]).mean(axis=0)

            df[f"{season} {variable}"] = data_seasonal_avg

    if (xls_output_folder / xls_output_file).exists():
        with pd.ExcelWriter(xls_output_folder / xls_output_file, mode='a') as writer:
            df.to_excel(writer, sheet_name=scn_name, index=False)
    else:
        with pd.ExcelWriter(xls_output_folder / xls_output_file, mode='w') as writer:
            df.to_excel(writer, sheet_name=scn_name, index=False)
