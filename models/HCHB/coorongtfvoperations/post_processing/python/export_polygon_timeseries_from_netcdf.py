"""
Extract polygon from tuflowfv and convert to area-averaged timeseries CSV
Script will output a csv in the same format as a normal TUFLOWFV CSV output
A Waterhouse
"""

import pandas as pd
from pathlib import Path
from matplotlib import path
import numpy as np
import json
from py_utils.extraction_functions import *
from py_utils.utilities import *


# Path to this script inside git
file_path = Path(__file__).parent.absolute()

# -------- User Input ------------
# results_folder = Path(r"\\blaydos\scratch2\A11650\TUFLOWFV\scenarios")
results_folder = Path(r"/scratch2/A11650/TUFLOWFV/scenarios")
# results_folder = Path(r"E:\projects_E\A11650\output")
wildcard = "001"  # Used to query results in the folder

# Polygons to be extracted
polygons_file_path = file_path / "resources/Coorong_regions_001_R.geojson"

# Alternative polygon for Surface Elevation!
polygons_file_path_alt = file_path / "resources/Coorong_regions_connected_001_R.geojson"

# Variables to extract
variables = ["H", "SAL", "TEMP"]

# Data output directory
output_root = Path(r'/mnt/coastal/A11650.L.iat.CoorongRelease/05_modelling/post_processing/output/python/polygon_timeseries')
# output_root = Path(r"L:\A11650.L.iat.CoorongRelease\05_modelling\post_processing\output\python\polygon_timeseries")
# csv_output_folder = file_path / "output/timeseries_data"
csv_output_folder = output_root
csv_output_folder.mkdir(parents=True, exist_ok=True)
suffix = "polygon_timeseries"


# -------- GO time ------------
# Load polygons
with open(polygons_file_path) as f:
    polygons = json.load(f)
    
# Load polygons
with open(polygons_file_path_alt) as f:
    polygons_alt = json.load(f)
    alt_feats = polygons_alt['features']

nregions = len(polygons['features'])


wildcard_file_list = list(results_folder.glob(f"*{wildcard}*_hd.nc"))
scn_names = [x.name.split("CoorongRelease_SCN_")[1].split("_")[0] for x in wildcard_file_list]

# for file in result_file_list:
results = {}
for c, scn in enumerate(scn_names):            
    file = list(results_folder.glob(f'*{scn}*{wildcard}*_hd.nc'))[0]
    print(f'Processing {scn}: {file.name}')

    # Load data
    ds = xr.open_dataset(file, chunks={'Time': 100}, decode_cf=False)

    # Fix time vector
    tvec = pd.to_timedelta(ds['ResTime'].values, unit='H') + pd.Timestamp(1990,1,1)
    tvec = tvec.round('1T')
    ds['ResTime'] = (('Time',), tvec)

    # Depth required for all extractions, may as well get it now once
    H_full = ds["H"].values
    cell_Zb = ds["cell_Zb"].values

    df = pd.DataFrame()
    df["TIME"] = tvec
    
    for c, var in enumerate(variables):
        print(f"...extracting {var}")
        var_data = ds[var].values

        for k, feat in enumerate(polygons['features']):
            if var == "H":
                coords = alt_feats[k]['geometry']['coordinates'][0][0]
            else:
                coords = feat['geometry']['coordinates'][0][0]  # only 1 part per feat, so 0, 0
                
            props = feat['properties']
            print(f"Extracting data at {props['Descriptio']}")
            loc_label = props["Label"]

            # Find model cells that fall inside the region polygon
            poly = path.Path(coords)
            idx = poly.contains_points(list(zip(ds["cell_X"].values, ds["cell_Y"].values)))

            H = H_full[:, idx]
            depth = H - cell_Zb[idx]

            # Remove anything <1cm deep
            # Generate new idx that incorp depth over time
            idx_checked = (depth>=0.01).reshape((ds.dims['Time'], sum(idx)))
            
            area = ds["cell_A"].values[idx]  * idx_checked
            vol = area * depth

            geo_dim = ds[var].dims[1]

            if var == "H":
                data = np.sum(H * area, axis=1) / np.sum(area, axis=1)

            elif geo_dim == "NumCells2D":  # If a 2D variable, average via area.
                data = np.sum(var_data[:, idx] * area, axis=1) / np.sum(area, axis=1)

            elif geo_dim == "NumCells3D":   # If a 3D variable, average via volume.
                data = np.sum(var_data[:, idx] * vol, axis=1) / np.sum(vol, axis=1)
            
            units = ds[var].attrs['units']

            # Average Data! 
            df[f"{loc_label}_{var} [{units}]"] = data

    # Export Data
    output_name = file.name.replace('.nc', f'_{suffix}.csv')
    df.to_csv(csv_output_folder / output_name, index=False)