"""
Collection of extraction functions written for the Coorong project
A10780
A Waterhouse
"""

import pandas as pd
from pathlib import Path
import numpy as np
from tfv.extractor import FvExtractor
from typing import Union, List
import csv
from .excel_functions import *
import xarray as xr



def load_mftfv_nc(flist: List[Path]) -> (xr.Dataset, pd.DatetimeIndex):
    """Load tuflowfv resutls into xarray dataset
    multiple files are concatenated by time.

    Args:
        flist (List[Path]): List of file Path objs to load

    Returns:
        [xr.Dataset]: TFV Result Dataset
    """
    set = []

    for f in flist:
        ds = xr.open_dataset(f, chunks={'Time': 100}, decode_cf=False)
        set.append(ds)
    ds = xr.concat(set, dim='Time', data_vars='minimal')
    
    # Fix time vector
    tvec = pd.to_timedelta(ds['ResTime'].values, unit='H') + pd.Timestamp(1990,1,1)
    tvec = tvec.round('1T')
    ds['ResTime'] = (('Time',), tvec)
    
    return ds, tvec


def load_mftfv_nc_ph2_dry(flist: List[Path]) -> (xr.Dataset, pd.DatetimeIndex):
    """Load tuflowfv resutls into xarray dataset
    multiple files are concatenated by time.

    Args:
        flist (List[Path]): List of file Path objs to load

    Returns:
        [xr.Dataset]: TFV Result Dataset
    """
    set = []

    for f in flist:
        ds = xr.open_dataset(f, chunks={'Time': 100}, decode_cf=False)

        if "part1" not in f.as_posix():
            ds = ds.isel(Time=slice(1, ds.dims['Time']))    # ignore what would be a duplication of the first timestep

        set.append(ds)
    ds = xr.concat(set, dim='Time', data_vars='minimal')
    
    # Fix time vector
    tvec = pd.to_timedelta(ds['ResTime'].values, unit='H') + pd.Timestamp(1990,1,1)
    tvec = tvec.round('1T')
    tvec = tvec.to_numpy()

    idx = int(np.where(tvec[2:-1] == tvec[1])[0]) + 2  # Index where time jumps back to beginning
    t_gap = tvec[idx-1]-tvec[idx]
    t_step = tvec[1]-tvec[0]
    tvec[idx:] = tvec[idx:]+t_gap+t_step
    tvec = pd.to_datetime(tvec)

    ds['ResTime'] = (('Time',), pd.to_datetime(tvec))
    
    return ds, tvec


def get_flist(results_folder, revision_number, wildcard):
    """
    Load a list of file Path objects inside a result data folder.
    Use revision and wildcard to query
    Returns a list of dry and typ filenames (1-13 and 14-27)
    """
    flist = list(results_folder.glob(f"*{revision_number}*{wildcard}"))

    # Get scn ids. Sometimes it's out of order, no idea why
    scn_ids = [x.name.split("BGC_")[1].split("_")[0] for x in flist]
    ids = np.asarray([int(re.findall("(\d+)", x)[0]) for x in scn_ids])

    dry_case = (ids >= 1) & (ids < 14)
    typ_case = ~dry_case

    flist = {
        "dry": [x for idx, x in enumerate(flist) if dry_case[idx] == True],
        "typ": [x for idx, x in enumerate(flist) if typ_case[idx] == True],
    }

    return flist


def get_wq_flist(results_folder):
    """
    Load a list of file Path objects inside a WQ result data folder.
    Assumed convention "SCxx.csv" where xx is a padded number (e.g. 02, 12)
    Returns a list of dry and typ filenames (1-13 and 14-27)
    """
    flist = list(results_folder.glob(f"*.csv"))

    # Get scn ids. Sometimes it's out of order, no idea why
    scn_ids = [x.name.split(".csv")[0] for x in flist]
    ids = np.asarray([int(re.findall("(\d+)", x)[0]) for x in scn_ids])

    dry_case = (ids >= 1) & (ids < 14)
    typ_case = ~dry_case

    flist = {
        "dry": [x for idx, x in enumerate(flist) if dry_case[idx] == True],
        "typ": [x for idx, x in enumerate(flist) if typ_case[idx] == True],
    }

    return flist


def read_and_extract_data(
    file_path: Path, wildcards: Union[None, list] = None, add_time_column=True
) -> pd.DataFrame:
    """Load TUFLOWFV CSV Points file and remove columns that don't match the wildcard

    Args:
        file_path (Path): Path to TUFLOWFV CSV File
        wildcards (list): String wildcards to filter columns by (e.g. "Point1")
        add_time_column (bool, optional): Include time column regardless of wildcard.
            Defaults to True.

    Returns:
        [pd.DataFrame]: Pandas dataframe
    """

    # Filter columns before reading csv. They can get large...
    with open(file_path, mode="r", encoding="utf-8") as f:
        cols = csv.DictReader(f).fieldnames

    if wildcards:
        load_cols = [x for wc in wildcards for x in cols if wc in x]
        if add_time_column == True:
            load_cols.insert(0, "TIME")
        df = pd.read_csv(file_path, usecols=load_cols)

    else:  # Load it all
        df = pd.read_csv(file_path)
    return df


def TUFLOW_get_long_section(
    extractor: FvExtractor,
    polyline: list,
    variable: str,
    time1: pd.Timestamp,
    time2: pd.Timestamp,
) -> tuple:
    """Get a long section from TFV result. Adapted from M.Gibb's script

    Args:
        result_path (Path): Path to result file
        polyline (list): list of coordinates [[X1, Y1], [X2, Y2], ..., [Xn, Yn]]
        variable (str): Variable to extract (e.g. "SAL")
        time1 (pd.Timestamp): Start time for averaging
        time2 (pd.Timestamp): End time for averaging

    Returns:
        [tuple]: tuple containing 4 elements (X, Y, Element ID, Averaged Data)
    """

    # Get average long section over time
    time = pd.to_timedelta(xtr.nc["ResTime"][:], unit="H") + pd.Timestamp(1990, 1, 1)
    x_data = xtr.get_intersection_data(polyline)
    index = xtr.get_curtain_cell_index(polyline, x_data)

    t1 = 0
    for ii in range(len(time)):
        if time[ii] >= time1 and time[ii] <= time2:
            if t1 < 1:
                data_av = xtr.get_curtain_cell(variable, ii, polyline, x_data, index)
            else:
                data_ii = xtr.get_curtain_cell(variable, ii, polyline, x_data, index)
                data_av = data_av + data_ii
            t1 = t1 + 1

    if t1 > 0:
        data_av = data_av / t1
        data_av = data_av.filled()

    x = x_data + (data_av,)
    return x