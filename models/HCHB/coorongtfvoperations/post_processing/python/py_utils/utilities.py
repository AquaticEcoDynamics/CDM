from pathlib import Path
import pandas as pd
#from py_utils.plotting_functions import *
import csv 
import numpy as np
from typing import *
import re


def get_flist_phase1(results_folder, revision_number, wildcard):
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


def get_flist_phase2(results_folder, revision_number, wildcard):
    """
    Load a list of file Path objects inside a result data folder.
    Use revision and wildcard to query
    Returns a list of dry and typ filenames (1-13 and 14-27)
    """
    flist = list(results_folder.glob(f"*{revision_number}*{wildcard}"))

    # Get scn ids. Sometimes it's out of order, no idea why
    scn_ids = [x.name.split("PH2_")[1].split("_")[0] for x in flist]
    scn_names = [x.name.split("PH2_")[1].split("_" + revision_number)[0] for x in flist]

    return [x for idx, x in enumerate(flist)], scn_ids, scn_names



def get_flist_phase2_dry(results_folder, revision_number, wildcard):
    """
    Load a list of file Path objects inside a result data folder.
    Use revision and wildcard to query
    Returns a list of dry and typ filenames (1-13 and 14-27)
    """
    flist = list(results_folder.glob(f"CoorongBGC_PH2_*{revision_number}*{wildcard}"))

    # Get scn ids. Sometimes it's out of order, no idea why
    scn_ids = [x.name.split("PH2_")[1].split("_")[0] for x in flist]
    scn_names = [x.name.split("PH2_")[1].split("_" + revision_number)[0] for x in flist]

    return [x for idx, x in enumerate(flist)], scn_ids, scn_names


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

def get_wq_flist_PH2_dry(results_folder):
    """
    Load a list of file Path objects inside a WQ result data folder.
    Assumed convention "SCxx.csv" where xx is a padded number (e.g. 02, 12)
    Returns a list of dry and typ filenames (1-13 and 14-27)
    """
    flist = list(results_folder.glob(f"*.csv"))

    # Get scn ids.
    scn_ids = [x.name.split("_")[0] for x in flist]
    scn_ids = list(set(scn_ids))    # Get unique elements
    scn_ids = sorted(scn_ids)       # Set changes order, fix it

    return flist, scn_ids

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


def concat_csv_results(file_list, rev_num):
    ''' PHase 2 concat csv results loader.
    Quick and dirty, get me out'''
    scn_ids = [x.name.split("_")[2] for x in file_list]
    scn_names = [x.name.split("PH2_")[1].split("_" + rev_num)[0] for x in file_list]
    unq_ids = np.unique(scn_ids)
    results = {}
    for id in unq_ids:
        df_set = []
        for idx in np.where([x == id for x in scn_ids])[0]:
            file = file_list[idx]
            df = read_and_extract_data(file)
            df["TIME"] = pd.to_datetime(df["TIME"], dayfirst=True)
            df = df.set_index("TIME", drop=False)
            df.index = df.index.round('T')  # Better safe than sorry...
            df_set.append(df)
        results[id] = pd.concat(df_set)
    scn_names = [str(x) for x in np.unique(scn_names)]

    return results, scn_names


def concat_csv_results_PH2(file_list):
    ''' Phase 2 dry concat csv results loader.'''
    scn_names = ["_".join(x.name.split("_")[0:-4]) for x in file_list]
    scn_names = list(set(scn_names))    # Get unique elements
    scn_names = sorted(scn_names)       # Set changes order, fix it

    scn_ids = [scn.split("_")[2] for scn in scn_names]

    results = {}
    for c, scn in enumerate(scn_names):
        scn_files = [f for f in file_list if scn in f.name]
        scn_files = sorted(scn_files)
        scn_id = scn_ids[c]

        # Read and concatenate files
        df_l = []
        for f in scn_files:
            df = pd.read_csv(f)
            df['TIME'] = pd.to_datetime(df['TIME'], dayfirst=True).round('1T')
            df = df.set_index('TIME')
            df_l.append(df)
        dfx = pd.concat(df_l)

        # Omit duplicate first timestep at concatenated file
        idxu = np.unique(dfx.index.values, return_index = True )[1]
        dfx = dfx.iloc[idxu]

        results[scn_id] = dfx

    return results, scn_ids


def concat_csv_results_PH2_dry(file_list):
    ''' Phase 2 dry concat csv results loader.'''
    scn_names = ["_".join(x.name.split("_")[0:-4]) for x in file_list]
    scn_names = list(set(scn_names))    # Get unique elements
    scn_names = sorted(scn_names)       # Set changes order, fix it

    scn_ids = [scn.split("_")[2] for scn in scn_names]

    results = {}
    for c, scn in enumerate(scn_names):
        scn_files = [f for f in file_list if scn in f.name]
        scn_files = sorted(scn_files)
        scn_id = scn_ids[c]

        # Read and concatenate files
        df_l = []
        for f in scn_files:
            df = pd.read_csv(f)
            df['TIME'] = pd.to_datetime(df['TIME'], dayfirst=True).round('1T')
            df = df.set_index('TIME')
            df_l.append(df)
        dfx = pd.concat(df_l)

        # Update time vector to be monotonically increasing
        tvec = dfx.index
        idx = int(np.where(tvec[2:-1] == tvec[0])[0]) + 2  # Index where time jumps back to beginning
        t_gap = tvec[idx-1]-tvec[idx]
        t_gap = t_gap.ceil('1D')
        tvec = tvec.to_numpy()  # annoying conversion to avoid issue on next line
        tvec[idx:] = tvec[idx:]+t_gap
        tvec = pd.to_datetime(tvec) # convert back
        dfx.index = tvec

        # Omit duplicate first timestep at concatenated file
        idxu = np.unique(dfx.index.values, return_index = True )[1]
        dfx = dfx.iloc[idxu]

        results[scn_id] = dfx

    return results, scn_ids


def concat_csv_results_PH2_WQ_timeseries(file_list, scn_ids):
    results = {}
    for scn in scn_ids:
        scn_files = [f for f in file_list if scn in f.name]
        scn_files = sorted(scn_files)

        # Read and concatenate files
        df_l = []
        for f in scn_files:
            df = pd.read_csv(f)
            df['TIME'] = pd.to_datetime(df['TIME'], dayfirst=True).round('1T')
            df = df.set_index('TIME', drop=False)
            df_l.append(df)
        dfx = pd.concat(df_l)        

        # Update time vector to be monotonically increasing
        tvec = dfx.index
        idx = int(np.where(tvec[2:-1] == tvec[0])[0]) + 2  # Index where time jumps back to beginning
        t_gap = tvec[idx-1]-tvec[idx]
        t_gap = t_gap.ceil('1D')
        tvec = tvec.to_numpy()  # annoying conversion to avoid issue on next line
        tvec[idx:] = tvec[idx:]+t_gap
        tvec = pd.to_datetime(tvec) # convert back
        dfx.index = tvec
        dfx['TIME'] = tvec

        # Omit duplicate first timestep at concatenated file
        idxu = np.unique(dfx.index.values, return_index = True )[1]
        dfx = dfx.iloc[idxu]

        results[scn] = dfx

    return results


def concat_csv_results_PH2_WQ_timeseries_PH2_wet(file_list, scn_ids):
    results = {}
    for scn in scn_ids:
        scn_files = [f for f in file_list if scn in f.name]
        scn_files = sorted(scn_files)

        # Read and concatenate files
        df_l = []
        for f in scn_files:
            df = pd.read_csv(f)
            df['TIME'] = pd.to_datetime(df['TIME'], dayfirst=True).round('1T')
            df = df.set_index('TIME', drop=False)
            df_l.append(df)
        dfx = pd.concat(df_l)        

        # Omit duplicate first timestep at concatenated file
        idxu = np.unique(dfx.index.values, return_index = True )[1]
        dfx = dfx.iloc[idxu]

        results[scn] = dfx

    return results


def concat_WQ_transect_results_PH2_dry(file_list, scn_ids):
    results = {}
    for scn in scn_ids:
        scn_files = [f for f in file_list if scn in f.name]
        scn_files = sorted(scn_files)

        # Read and horizontally concatenate files    
        for c, f in enumerate(scn_files):
            df = pd.read_csv(f)
            if c == 0:
                dfj = df
            else:             
                dfj = dfj.join(df[df.columns[3:]], rsuffix='_j')

        # Fix column header for phase 2 dry runs
        years = [int(x.split("_")[0]) for x in dfj.columns[3:]] #array
        idx = int(np.where(np.diff(years) < 0)[0]) + 1
        years[idx:] = list(np.array(years[idx:]) + abs(years[idx] - years[idx-1]))
        cols = []
        for c, col in enumerate(dfj.columns[3:]):
            col_new = f'{years[c]}_' + "_".join(col.split("_")[1:])
            cols.append(col_new)
        [col for col in cols if '_j' in col.split("]")[-1]]
        for c, col in enumerate(cols):
            if '_j' in col.split("]")[-1]:
                cols[c] = col.split("]")[0] + "]"
        dfj.rename(columns=dict(zip(dfj.columns[3:], cols)), inplace=True)

        # Append result for output
        results[scn] = dfj

    return results


def concat_WQ_transect_results_PH2_wet(file_list, scn_ids):
    results = {}
    for scn in scn_ids:
        scn_files = [f for f in file_list if scn in f.name]
        scn_files = sorted(scn_files)

        # Read and horizontally concatenate files    
        for c, f in enumerate(scn_files):
            df = pd.read_csv(f)
            if c == 0:
                dfj = df
            else:             
                dfj = dfj.join(df[df.columns[3:]])

        # Append result for output
        results[scn] = dfj

    return results


def gen_periods_dict(start_year, end_year, seasons_dict):
    seasons = {}
    year = start_year
    while year < end_year:
        for lbl, months in seasons_dict.items():
            if months[1] < months[0]:
                year_1 = year
                year_2 = year+1
                year +=1
            else:
                year_1 = year
                year_2 = year
            seasons[f'{year_1}_{lbl}'] = (
                pd.Timestamp(year_1, months[0], 1), 
                pd.Timestamp(year_2, months[1], 1)
                )
    return seasons