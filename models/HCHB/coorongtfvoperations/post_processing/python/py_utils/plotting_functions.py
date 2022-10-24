"""
A collection of plotting functions written for the coorong project
Generally, these functions rely on data that has been extracted and pre-loaded.
A10780
A Waterhouse
"""

import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
from pathlib import Path
import matplotlib.ticker as mticker
import numpy as np
from tfv.extractor import FvExtractor
from typing import Union
from .excel_functions import *
import json
from scipy import integrate
#from utilities import *

# sns.set(style="white", font_scale=0.75)
sns.set_theme(style="white", font_scale=0.75)
sns.set_context("paper")

def ts_plot_from_xlsx(ts_cfg_file)-> None:

    # load ts_cfg_file into ts_cfg dictionary
    with open(ts_cfg_file) as f:
        ts_cfg = json.load(f)
        f.close()
    print(ts_cfg)
    respath = Path(ts_cfg.get('respath'))
    resfile = ts_cfg.get('resfile')
    scenarios = ts_cfg.get('scenarios')
    sheets = get_sheetnames_xlsx(respath / resfile)
    sheets = [x for x in sheets if any([y in x for y in scenarios])]
    variable = ts_cfg.get('variable')
    outpath = Path(ts_cfg.get('outpath'))
    outpath.mkdir(exist_ok=True)
    outfile = ts_cfg.get('resfile').replace('.xlsx','') + '_' + variable.replace(' ','_') + '.png'

    # read resfile
    dat = pd.read_excel(respath / resfile,sheet_name=sheets)

    # loop through scenarios and plot timeseries
    fig, ax = plt.subplots()
    for scenario, df in dat.items():
        df['TIME'] = pd.to_datetime(df['TIME'], dayfirst=True)
        df = df.set_index('TIME')
        columns = df.columns
        columns = [x for x in columns if variable in x]
        for col in columns:
            label_ = scenario
            #label_ = scenario.split(' ')[0]
            if ts_cfg.get('cumulative'):
                df[col+'_cum'] = integrate.cumtrapz(df[col].values.astype(float), df.index.values.astype(float) / 10**9, initial=0.)
                df[col+'_cum'].plot(ax=ax,label=label_,ylim=ts_cfg.get('ylim'))
            else:
                df[col].plot(ax=ax,label=label_,ylim=ts_cfg.get('ylim'))

    # format and save figure
    box = ax.get_position()
    ax.set_position([box.x0, box.y0 + box.height * 0.20,
                    box.width * 1.0, box.height * 0.80])
    ax.legend(loc='upper center', bbox_to_anchor=(0.5, -0.15),
            ncol=2, fontsize=8)
    ax.set_title(variable)
    ax.grid()
    plt.ylabel(ts_cfg.get('ylabel'))
    plt.xlabel('')
    plt.savefig(outpath / outfile, dpi=200, facecolor='white', edgecolor='none')
    #plt.close()


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


def plot_longseries_figures(
    results: dict,
    variables: dict,
    periods: list,
    figure_output_folder: Path,
    suffix: str,
    limits: Union[dict, None] = None,
) -> None:
    """Generate longseries figures from pre-loaded model results dict

    Args:
        results (dict): Model results dictionary. Format: Results[SEASON][RES_NAME] = Pd.DataFrame
        variables (dict): Variables to plot. Keys: TUFLOWFV Var Name, Values: Desired label
        periods (list): List containing the periods that will be plotted
        figure_output_folder (Path): Location to save figures
        suffix (str): Suffix to attach to output filename
        limits (dict, optional): Optional dict containing plot limits (value: list) by variable (key)
    """
    label_format = "{:,.2f}"
    N_max_ticks = 5

    # Plot mask - saved externally. Yucky but it works
    ids = np.loadtxt(
        (Path(__file__).parent / "longsection_mask.txt"), delimiter=",", dtype=int
    )
    remove = []
    for col in range(ids.shape[1]):
        remove.extend([x for x in range(ids[0, col], ids[1, col] + 1)])

    # Ensure that results are ordered correctly
    scns = list(results.keys())
    scns.sort()

    # Loop through variables we're going to plot
    for variable, ax_label in variables.items():
        if len(periods) % 9 == 0:
            ncols = 3
            nrows = int(len(periods)/3)
            height = 14
            width = 26
        elif (len(periods) % 9 == 0) & (len(periods) > 9):
            ncols = 3
            nrows = int(len(periods)/3)
            height = 24
            width = 35
        else:
            ncols = 1
            nrows = len(periods)
            height = 8  + 2/3 * len(periods)
            width = 17

        fig, axes = plt.subplots(
            ncols=ncols,
            nrows=nrows,
            figsize=(width / 2.54, height / 2.54),
            sharey=True,
            sharex=True,
        )

        # Find nice y scaling limits
        ymax = -99
        ymin = 99

        # Make a subplot for each location season
        for k, season_name in enumerate(periods):
            if len(periods) % 9 == 0:
                r = k // 3  # subplot row
                c = k % 3  # subplot col
                ax = axes[r][c]
            else:
                ax = axes[k]

            ax.set_prop_cycle("color", sns.color_palette("Dark2", len(results)))
            ax.set_title(season_name)
            ax.grid("on")

            # Now plot the actual values from each result we have loaded
            for scn in scns:
                df = results[scn]
                col = [x for x in df.columns if season_name in x if variable in x][0]
                if k == 0:
                    chainage = df["Chainage"]
                arr = df[col]
                idx = [x for x in range(len(arr)) if x not in remove]

                scn_id = scn.split("_")[0]
                if (scn_id == "SC01") | (scn_id == "SC14"):
                    ax.fill_between(
                        chainage[idx], arr[idx], -99, color="grey", alpha=0.5
                    )
                    ax.plot(
                        chainage[idx],
                        arr[idx],
                        label=scn_id,
                        color="black",
                        linewidth=0.75,
                    )
                else:
                    ax.plot(chainage[idx], arr[idx], label=scn_id, linewidth=0.75)

                ymax = max(ymax, arr[idx].max())
                ymin = min(ymin, arr[idx].min())

            # Get legend lables/handles once
            if k == 0:
                handles, labels = ax.get_legend_handles_labels()

        fig.legend(
            handles,
            labels,
            loc="upper center",
            ncol=4,
            frameon=False,
            bbox_to_anchor=(0.5, 1.07),
        )

        ax.set_xlim([0, chainage.max()])

        # Pretty up the tick labels
        if limits:  # Specified lims
            ax.set_ylim(limits[variable])
        else:
            ax.set_ylim(
                [
                    np.round(ymin - 0.15 * abs(ymin), 2),
                    np.round(ymax + 0.15 * abs(ymax), 2),
                ]
            )
        ax.yaxis.set_major_locator(mticker.MaxNLocator(N_max_ticks))
        ticks_loc = ax.get_yticks().tolist()
        ax.yaxis.set_major_locator(mticker.FixedLocator(ticks_loc))
        ax.set_yticklabels([label_format.format(x) for x in ticks_loc])

        # Axis label styling
        fig.text(0.5, 0.00, "Chainage [km]", ha="center")
        fig.text(0.00, 0.5, ax_label, va="center", rotation="vertical")

        # Export figures
        print(f"Exporting figure - {variable}")
        plt.tight_layout()
        # plt.savefig(
        #     f"{figure_output_folder}/CoorongBGC_Longsection_{suffix}_{variable}.pdf",
        #     bbox_inches="tight",
        #     pad_inches=0.1,
        # )

        plt.savefig(
            f"{figure_output_folder}/CoorongBGC_Longsection_{suffix}_{variable}.png",
            bbox_inches="tight",
            pad_inches=0.1,
            dpi=300,
        )
        plt.close()


def plot_longseries_figures_PH2(
    results: dict,
    variables: dict,
    periods: list,
    figure_output_folder: Path,
    suffix: str,
    limits: Union[dict, None] = None,
) -> None:
    """Generate longseries figures from pre-loaded model results dict

    Args:
        results (dict): Model results dictionary. Format: Results[SEASON][RES_NAME] = Pd.DataFrame
        variables (dict): Variables to plot. Keys: TUFLOWFV Var Name, Values: Desired label
        periods (list): List containing the periods that will be plotted
        figure_output_folder (Path): Location to save figures
        suffix (str): Suffix to attach to output filename
        limits (dict, optional): Optional dict containing plot limits (value: list) by variable (key)
    """
    label_format = "{:,.2f}"
    N_max_ticks = 5

    # Plot mask - saved externally. Yucky but it works
    ids = np.loadtxt(
        (Path(__file__).parent / "longsection_mask.txt"), delimiter=",", dtype=int
    )
    remove = []
    for col in range(ids.shape[1]):
        remove.extend([x for x in range(ids[0, col], ids[1, col] + 1)])

    # Ensure that results are ordered correctly
    scns = list(results.keys())
    scns.sort()

    # Loop through variables we're going to plot
    for variable, ax_label in variables.items():
        if len(periods) % 9 == 0:
            ncols = 3
            nrows = int(len(periods)/3)
            height = 14
            width = 26
        elif (len(periods) % 9 == 0) & (len(periods) > 9):
            ncols = 3
            nrows = int(len(periods)/3)
            height = 24
            width = 35
        else:
            ncols = 1
            nrows = len(periods)
            height = 8  + 2/3 * len(periods)
            width = 17

        fig, axes = plt.subplots(
            ncols=ncols,
            nrows=nrows,
            figsize=(width / 2.54, height / 2.54),
            sharey=True,
            sharex=True,
        )

        # Find nice y scaling limits
        ymax = -99
        ymin = 99

        # Make a subplot for each location season
        for k, season_name in enumerate(periods):
            if len(periods) % 9 == 0:
                r = k // 3  # subplot row
                c = k % 3  # subplot col
                ax = axes[r][c]
            else:
                ax = axes[k]
            
            # ax.set_prop_cycle("color", sns.color_palette("Dark2", len(results)))
            colour_palette = sns.color_palette("Dark2")
            colour_palette.extend([sns.color_palette("Paired", 2)[1]])
            ax.set_prop_cycle("color", colour_palette)

            ax.set_title(season_name)
            ax.grid("on")

            # Now plot the actual values from each result we have loaded
            for scn in scns:
                df = results[scn]
                col = [x for x in df.columns if season_name in x if variable == x.split(f'{season_name}'+'_')[1].split(' ')[0]][0]
                if k == 0:
                    chainage_key = [x for x in list(df.keys()) if 'Chainage' in x]
                    chainage = df[chainage_key[0]]
                arr = df[col]
                idx = [x for x in range(len(arr)) if x not in remove]

                scn_id = scn.split("_")[0]
                if (scn_id == "Basecase"):
                    ax.fill_between(
                        chainage[idx], arr[idx], -99, color="grey", alpha=0.5
                    )
                    ax.plot(
                        chainage[idx],
                        arr[idx],
                        label=scn_id,
                        color="black",
                        linewidth=0.75,
                    )
                else:
                    ax.plot(chainage[idx], arr[idx], label=scn_id, linewidth=0.75)

                ymax = max(ymax, arr[idx].max())
                ymin = min(ymin, arr[idx].min())

            # Get legend lables/handles once
            if k == 0:
                handles, labels = ax.get_legend_handles_labels()
                labels2 = results.keys()

        fig.legend(
            handles,
            labels2,
            loc="upper center",
            ncol=5,
            frameon=False,
            bbox_to_anchor=(0.5, 1.07),
        )

        ax.set_xlim([0, chainage.max()])

        # Pretty up the tick labels
        if limits:  # Specified lims
            ax.set_ylim(limits[variable])
        else:
            ax.set_ylim(
                [
                    np.round(ymin - 0.15 * abs(ymin), 2),
                    np.round(ymax + 0.15 * abs(ymax), 2),
                ]
            )
        ax.yaxis.set_major_locator(mticker.MaxNLocator(N_max_ticks))
        ticks_loc = ax.get_yticks().tolist()
        ax.yaxis.set_major_locator(mticker.FixedLocator(ticks_loc))
        ax.set_yticklabels([label_format.format(x) for x in ticks_loc])

        # Axis label styling
        fig.text(0.5, 0.00, "Chainage [km]", ha="center")
        fig.text(0.00, 0.5, ax_label, va="center", rotation="vertical")

        # Export figures
        print(f"Exporting figure - {variable}")
        plt.tight_layout()
        # plt.savefig(
        #     f"{figure_output_folder}/CoorongBGC_Longsection_{suffix}_{variable}.pdf",
        #     bbox_inches="tight",
        #     pad_inches=0.1,
        # )

        plt.savefig(
            f"{figure_output_folder}/CoorongBGC_Longsection_{suffix}_{variable}.png",
            bbox_inches="tight",
            pad_inches=0.1,
            dpi=300,
        )
        plt.close()


def plot_timeseries_figures(
    results_dict: dict,
    variables_dict: dict,
    stations_dict: dict,
    figure_output_folder: Path,
    suffix: str,
    limits: Union[dict, None] = None,
) -> None:
    """Generate timeseries figures from pre-loaded model results dict

    Args:
        results_dict (dict): Model results dictionary. Keys -> Scenario name, Value = Pd.DataFrame with "{Location}_{Var} [units]" column format
        variables_dict (dict): Variables to plot. Keys -> var name as in df, values = y axis label
        stations_dict (dict): Locations to plot. Keys -> Location name as in df, Value -> Subplot Plot title
        figure_output_folder (Path): Location to save figures
        suffix (str): Suffix to attach to output filename
        limits (dict, optional): Optional dict containing plot limits (value: list) by variable (key)
    """

    label_format = "{:,.1f}"
    N_max_ticks = 5

    # Make output folder if it doesn't already exist
    figure_output_folder.mkdir(parents=True, exist_ok=True)

    scns = list(results_dict.keys())

    # Loop through variables we're going to plot
    for variable, ax_label in variables_dict.items():
        fig, axes = plt.subplots(
            nrows=len(stations_dict),
            figsize=(17 / 2.54, 8 / 2.54),
            sharey=True,
            sharex=True,
        )

        # Find nice y scaling limits
        ymax = -99
        ymin = 99

        # Make a subplot for each location ("station")
        for c, (station, station_name) in enumerate(stations_dict.items()):
            if len(stations_dict) > 1:
                ax = axes[c]
            else:
                ax = axes
            ax.set_prop_cycle(
                "color", sns.color_palette("Dark2", len(results_dict.keys()))
            )
            ax.set_title(station_name)
            ax.grid("on")

            # Now plot the actual values from each result we have loaded
            for k, scn in enumerate(scns):

                df = results_dict[scn]
                col = [x for x in df.columns if station in x if variable in x][0]

                scn_id = scn.split("_")[0]
                if (scn_id == "SC01") | (scn_id == "SC14"):
                    ax.fill_between(df["TIME"], df[col], -99, color="grey", alpha=0.5)
                    ax.plot(
                        df["TIME"],
                        df[col],
                        label=scn_id,
                        color="black",
                        linewidth=1.25,
                    )
                else:
                    ax.plot(df["TIME"], df[col], label=scn_id, linewidth=0.75)

                ymax = max(ymax, df[col].max())
                ymin = min(ymin, df[col].min())

            if c == 0:
                handles, labels = ax.get_legend_handles_labels()

        fig.legend(
            handles,
            labels,
            loc="upper center",
            ncol=4,
            frameon=False,
            bbox_to_anchor=(0.5, 1.1),
        )

        # Pretty up the tick labels
        if limits:  # Specified lims
            ax.set_ylim(limits[variable])
        else:  # Auto predict some nice lims
            ax.set_ylim(
                [
                    np.round(ymin - 0.15 * abs(ymin), 2),
                    np.round(ymax + 0.15 * abs(ymax), 2),
                ]
            )

        ax.yaxis.set_major_locator(mticker.MaxNLocator(N_max_ticks))
        ticks_loc = ax.get_yticks().tolist()
        ax.yaxis.set_major_locator(mticker.FixedLocator(ticks_loc))
        ax.set_yticklabels([label_format.format(x) for x in ticks_loc])

        # Set X axis
        # ax.set_xlim([df["TIME"].iloc[0], df["TIME"].iloc[-1]])
        ax.set_xlim([pd.Timestamp(x) for x in ['2013-03-01', '2019-03-01']])

        # Concise Fmt
        locator = mdates.AutoDateLocator(minticks=4, maxticks=9)
        formatter = mdates.ConciseDateFormatter(locator)
        ax.xaxis.set_major_locator(locator)
        ax.xaxis.set_major_formatter(formatter)

        # Axis label styling
        # fig.text(0.5, 0.00, "Date", ha="center")
        fig.text(0.00, 0.5, ax_label, va="center", rotation="vertical")
        fig.autofmt_xdate()

        # Export figures
        print(f"Exporting figure - {variable}")
        plt.tight_layout()

        # plt.savefig(
        #     f"{figure_output_folder}/CoorongBGC_Timeseries_{suffix}_{variable}.pdf",
        #     bbox_inches="tight",
        #     pad_inches=0.1,
        # )
        plt.savefig(
            f"{figure_output_folder}/CoorongBGC_Timeseries_{suffix}_{variable}.png",
            bbox_inches="tight",
            pad_inches=0.1,
            dpi=300,
        )
        plt.close()


def plot_timeseries_figures_PH2_dry(
    results_dict: dict,
    variables_dict: dict,
    stations_dict: dict,
    figure_output_folder: Path,
    suffix: str,
    limits: Union[dict, None] = None,
) -> None:
    """Generate timeseries figures from pre-loaded model results dict

    Args:
        results_dict (dict): Model results dictionary. Keys -> Scenario name, Value = Pd.DataFrame with "{Location}_{Var} [units]" column format
        variables_dict (dict): Variables to plot. Keys -> var name as in df, values = y axis label
        stations_dict (dict): Locations to plot. Keys -> Location name as in df, Value -> Subplot Plot title
        figure_output_folder (Path): Location to save figures
        suffix (str): Suffix to attach to output filename
        limits (dict, optional): Optional dict containing plot limits (value: list) by variable (key)
    """

    label_format = "{:,.1f}"
    N_max_ticks = 5

    # Make output folder if it doesn't already exist
    figure_output_folder.mkdir(parents=True, exist_ok=True)

    scns = list(results_dict.keys())

    # Loop through variables we're going to plot
    for variable, ax_label in variables_dict.items():
        fig, axes = plt.subplots(
            nrows=len(stations_dict),
            figsize=(17 / 2.54, 8 / 2.54),
            sharey=True,
            sharex=True,
        )

        # Find nice y scaling limits
        ymax = -99
        ymin = 99

        # Make a subplot for each location ("station")
        for c, (station, station_name) in enumerate(stations_dict.items()):
            if len(stations_dict) > 1:
                ax = axes[c]
            else:
                ax = axes
            # ax.set_prop_cycle(
            #     "color", sns.color_palette("Dark2", len(results_dict.keys()))
            # )
            colour_palette = sns.color_palette("Dark2")
            colour_palette.extend([sns.color_palette("Paired", 2)[1]])
            ax.set_prop_cycle("color", colour_palette)
            ax.set_title(station_name)
            ax.grid("on")

            # Now plot the actual values from each result we have loaded
            for k, scn in enumerate(scns):

                df = results_dict[scn]
                col = [x for x in df.columns if station in x if variable in x][0]

                scn_id = scn.split("_")[0]
                if (scn_id == "Basecase"):
                    ax.fill_between(df["TIME"], df[col], -99, color="grey", alpha=0.5)
                    ax.plot(
                        df["TIME"],
                        df[col],
                        label=scn_id,
                        color="black",
                        linewidth=1.25,
                    )
                else:
                    ax.plot(df["TIME"], df[col], label=scn_id, linewidth=0.75)

                ymax = max(ymax, df[col].max())
                ymin = min(ymin, df[col].min())

            if c == 0:
                handles, labels = ax.get_legend_handles_labels()

        fig.legend(
            handles,
            scns,
            loc="upper center",
            ncol=5,
            frameon=False,
            bbox_to_anchor=(0.5, 1.1),
        )

        # Pretty up the tick labels
        if limits:  # Specified lims
            ax.set_ylim(limits[variable])
        else:  # Auto predict some nice lims
            ax.set_ylim(
                [
                    np.round(ymin - 0.15 * abs(ymin), 2),
                    np.round(ymax + 0.15 * abs(ymax), 2),
                ]
            )

        ax.yaxis.set_major_locator(mticker.MaxNLocator(N_max_ticks))
        ticks_loc = ax.get_yticks().tolist()
        ax.yaxis.set_major_locator(mticker.FixedLocator(ticks_loc))
        ax.set_yticklabels([label_format.format(x) for x in ticks_loc])

        # Set X axis
        ax.set_xlim([df["TIME"].iloc[0], df["TIME"].iloc[-1]])
        # ax.set_xlim([pd.Timestamp(x) for x in ['2013-03-01', '2019-03-01']])

        # Concise Fmt
        locator = mdates.AutoDateLocator(minticks=4, maxticks=9)
        formatter = mdates.ConciseDateFormatter(locator)
        ax.xaxis.set_major_locator(locator)
        ax.xaxis.set_major_formatter(formatter)

        # Axis label styling
        # fig.text(0.5, 0.00, "Date", ha="center")
        fig.text(0.00, 0.5, ax_label, va="center", rotation="vertical")
        fig.autofmt_xdate()

        # Export figures
        print(f"Exporting figure - {variable}")
        plt.tight_layout()

        # plt.savefig(
        #     f"{figure_output_folder}/CoorongBGC_Timeseries_{suffix}_{variable}.pdf",
        #     bbox_inches="tight",
        #     pad_inches=0.1,
        # )
        plt.savefig(
            f"{figure_output_folder}/CoorongBGC_Timeseries_{suffix}_{variable}.png",
            bbox_inches="tight",
            pad_inches=0.1,
            dpi=300,
        )
        plt.close()


def plot_cdf_figures(
    results_dict: dict,
    variables_dict: dict,
    locations: dict,
    seasons: dict,
    figure_output_folder: Path,
    suffix: str,
    limits: Union[dict, None] = None,
) -> None:
    """Generate timeseries figures from pre-loaded model results dict

    Args:
        results_dict (dict): Model results dictionary. Keys -> Scenario name, Value = Pd.DataFrame with "{Location}_{Var} [units]" column format
        variables_dict (dict): Variables to plot. Keys -> var name as in df, values = y axis label
        locations (dict): Locations to plot. Keys -> Location name as in df, Value -> Subplot Plot title
        seasons (dict): Seasons to plot. Keys -> Season name, Values -> (Pd.Timestamp, Pd.Timestamp)
        figure_output_folder (Path): Location to save figures
        suffix (str): Suffix to attach to output filename
        limits (dict, optional): Optional dict containing plot limits (value: list) by variable (key)
    """

    label_format = "{:,.1f}"
    N_max_ticks = 5

    # Make output folder if it doesn't already exist
    figure_output_folder.mkdir(parents=True, exist_ok=True)

    scns = list(results_dict.keys())

    # Loop through variables we're going to plot
    for variable, ax_label in variables_dict.items():
        for loc, loc_label in locations.items():
            # Make a plot for each location, and a subplot for each season
            fig, axes = plt.subplots(
                ncols=3,
                nrows=6,  # Lazy -> Phase 2 has 18 periods to plot
                figsize=(24 / 2.54, 35 / 2.54),
                sharey=True,
                sharex=True,
            )

            k = 0
            for season_name, (time_start, time_end) in seasons.items():
                # Now plot the actual values from each result we have loaded
                r = k // 3  # subplot row
                c = k % 3  # subplot col

                ax = axes[r][c]
                # ax.set_prop_cycle(
                #     "color", sns.color_palette("Dark2", len(results_dict.keys()))
                # )
                colour_palette = sns.color_palette("Dark2")
                colour_palette.extend([sns.color_palette("Paired", 2)[1]])
                ax.set_prop_cycle("color", colour_palette)
                ax.set_title(season_name)
                ax.grid("on")
                for scn_id in scns:

                    df_full = results_dict[scn_id]
                    time_idx = (df_full["TIME"] >= time_start) & (
                        df_full["TIME"] < time_end
                    )
                    df = df_full[time_idx]

                    col = [x for x in df.columns if loc in x if variable in x][0]

                    arr = df[col].values
                    arr.sort()
                    count = arr.shape[0]
                    p = np.divide(list(range(1, count + 1)), count) * 100

                    if (scn_id == "SC01") | (scn_id == "SC14"):
                        ax.plot(
                            arr,
                            p,
                            label=scn_id,
                            color="black",
                            zorder=10,
                            linewidth=1.25,
                        )
                    else:
                        ax.plot(
                            arr,
                            p,
                            label=scn_id,
                            linewidth=1.25,
                        )

                if k == 0:
                    handles, labels = ax.get_legend_handles_labels()

                k += 1

            fig.legend(
                handles,
                labels,
                loc="upper center",
                ncol=4,
                frameon=False,
                bbox_to_anchor=(0.5, 1.05),
            )

            # Set x axis
            if limits:
                ax.set_xlim(limits[variable])
            ax.xaxis.set_major_locator(mticker.MaxNLocator(N_max_ticks))
            ticks_loc = ax.get_xticks().tolist()
            ax.xaxis.set_major_locator(mticker.FixedLocator(ticks_loc))
            ax.set_xticklabels([label_format.format(x) for x in ticks_loc])

            # Set y axis
            ax.set_ylim([0, 100])
            ax.yaxis.set_major_formatter(mticker.PercentFormatter())

            # Axis label styling
            fig.text(0.5, 0.00, ax_label, ha="center")
            fig.text(0.00, 0.5, "Probability [%]", va="center", rotation="vertical")

            # Export figures
            print(f"Exporting figure - {variable}")
            plt.tight_layout()
            # plt.savefig(
            #     f"{figure_output_folder}/CoorongBGC_CDF_{loc}_{variable}.pdf",
            #     bbox_inches="tight",
            #     pad_inches=0.1,
            # )

            plt.savefig(
                f"{figure_output_folder}/CoorongBGC_CDF_{suffix}_{loc}_{variable}.png",
                bbox_inches="tight",
                pad_inches=0.1,
                dpi=300,
            )
            plt.close()


def plot_cdf_figures_PH2_dry(
    results_dict: dict,
    variables_dict: dict,
    locations: dict,
    seasons: dict,
    figure_output_folder: Path,
    suffix: str,
    limits: Union[dict, None] = None,
) -> None:
    """Generate timeseries figures from pre-loaded model results dict

    Args:
        results_dict (dict): Model results dictionary. Keys -> Scenario name, Value = Pd.DataFrame with "{Location}_{Var} [units]" column format
        variables_dict (dict): Variables to plot. Keys -> var name as in df, values = y axis label
        locations (dict): Locations to plot. Keys -> Location name as in df, Value -> Subplot Plot title
        seasons (dict): Seasons to plot. Keys -> Season name, Values -> (Pd.Timestamp, Pd.Timestamp)
        figure_output_folder (Path): Location to save figures
        suffix (str): Suffix to attach to output filename
        limits (dict, optional): Optional dict containing plot limits (value: list) by variable (key)
    """

    label_format = "{:,.1f}"
    N_max_ticks = 5

    # Make output folder if it doesn't already exist
    figure_output_folder.mkdir(parents=True, exist_ok=True)

    scns = list(results_dict.keys())

    # Loop through variables we're going to plot
    for variable, ax_label in variables_dict.items():
        for loc, loc_label in locations.items():
            # Make a plot for each location, and a subplot for each season
            fig, axes = plt.subplots(
                ncols=3,
                nrows=6,  # Lazy -> Phase 2 has 18 periods to plot
                figsize=(24 / 2.54, 35 / 2.54),
                sharey=True,
                sharex=True,
            )

            k = 0
            for season_name, (time_start, time_end) in seasons.items():
                # Now plot the actual values from each result we have loaded
                r = k // 3  # subplot row
                c = k % 3
                # c = int((k // r) + (k % r))  # subplot col

                ax = axes[r][c]
                # ax.set_prop_cycle(
                #     "color", sns.color_palette("Dark2", len(results_dict.keys()))
                # )
                colour_palette = sns.color_palette("Dark2")
                colour_palette.extend([sns.color_palette("Paired", 2)[1]])
                ax.set_prop_cycle("color", colour_palette)
                ax.set_title(season_name)
                ax.grid("on")
                for scn_id in scns:

                    df_full = results_dict[scn_id]
                    time_idx = (df_full["TIME"] >= time_start) & (
                        df_full["TIME"] < time_end
                    )
                    df = df_full[time_idx]

                    col = [x for x in df.columns if loc in x if variable in x][0]

                    arr = df[col].values
                    arr.sort()
                    count = arr.shape[0]
                    p = np.divide(list(range(1, count + 1)), count) * 100

                    if (scn_id == "Basecase"):
                        ax.plot(
                            arr,
                            p,
                            label=scn_id,
                            color="black",
                            zorder=10,
                            linewidth=1.25,
                        )
                    else:
                        ax.plot(
                            arr,
                            p,
                            label=scn_id,
                            linewidth=1.25,
                        )

                if k == 0:
                    handles, labels = ax.get_legend_handles_labels()

                k += 1

            fig.legend(
                handles,
                labels,
                loc="upper center",
                ncol=5,
                frameon=False,
                bbox_to_anchor=(0.5, 1.05),
            )

            # Set x axis
            if limits:
                ax.set_xlim(limits[variable])
            ax.xaxis.set_major_locator(mticker.MaxNLocator(N_max_ticks))
            ticks_loc = ax.get_xticks().tolist()
            ax.xaxis.set_major_locator(mticker.FixedLocator(ticks_loc))
            ax.set_xticklabels([label_format.format(x) for x in ticks_loc])

            # Set y axis
            ax.set_ylim([0, 100])
            ax.yaxis.set_major_formatter(mticker.PercentFormatter())

            # Axis label styling
            fig.text(0.5, 0.00, ax_label, ha="center")
            fig.text(0.00, 0.5, "Probability [%]", va="center", rotation="vertical")

            # Export figures
            print(f"Exporting figure - {variable}")
            plt.tight_layout()
            # plt.savefig(
            #     f"{figure_output_folder}/CoorongBGC_CDF_{loc}_{variable}.pdf",
            #     bbox_inches="tight",
            #     pad_inches=0.1,
            # )

            plt.savefig(
                f"{figure_output_folder}/CoorongBGC_CDF_{loc}_{variable}.png",
                bbox_inches="tight",
                pad_inches=0.1,
                dpi=300,
            )
            plt.close()


def plot_tracer_composition_figures(
    time_vector, results, variables, regions, figure_output_folder, suffix
):
    colour_palette = sns.color_palette("Dark2", len(variables))

    for scn_id, data in results.items():
        for region in regions.values():
            fig, ax = plt.subplots(figsize=(12 / 2.54, 8 / 2.54))

            ax.set_prop_cycle("color", colour_palette)
            k = 0
            y1 = np.zeros((len(time_vector),))
            for var, var_name in variables.items():
                y2 = y1 + data[region][var]
                ax.fill_between(
                    time_vector,
                    y1,
                    y2,
                    edgecolor="black",
                    linewidth=0.75,
                    label=var_name,
                    alpha=0.8,
                )
                y1 = y2.copy()
                k += 0

            # Concise Date Fmt
            locator = mdates.AutoDateLocator(minticks=3, maxticks=9)
            formatter = mdates.ConciseDateFormatter(locator)
            ax.xaxis.set_major_locator(locator)
            ax.xaxis.set_major_formatter(formatter)

            ax.set_ylabel("Tracer Composition [-]")

            ax.set_xlim([time_vector[0], time_vector[-1]])
            ax.set_ylim([0, 400])

            ax.grid("on")
            ax.legend(loc="upper left")

            fig.autofmt_xdate()

            plt.tight_layout()
            plt.savefig(
                f"{figure_output_folder}/CoorongBGC_TracerComposition_{suffix}_{region}_{scn_id}.png",
                bbox_inches="tight",
                pad_inches=0.1,
                dpi=300,
            )
            plt.close()


def plot_tracer_timeseries(
    time_vector, results, regions, variables, figure_output_folder, suffix
):

    for var, var_info in variables.items():
        var_label = var_info["label"]
        var_name = var_info["name"]
        limits = var_info["limits"]

        # colour_palette = sns.color_palette("Dark2", len(results))
        colour_palette = sns.color_palette("Dark2")
        colour_palette.extend([sns.color_palette("Paired", 2)[1]])
        
        fig, axes = plt.subplots(
            nrows=len(regions), figsize=(16 / 2.54, 8 / 2.54), sharex=True, sharey=True
        )
        k = 0
        for region in regions.values():
            if len(regions) == 1:
                ax = axes
            else:
                ax = axes[k]
            ax.set_prop_cycle("color", colour_palette)
            ax.grid("on")
            ax.set_title(region.replace("_", " "))
            for scn_id, data in results.items():
                if (scn_id == "SC01") | (scn_id == "SC14") | (scn_id == "Basecase"):
                    ax.fill_between(
                        time_vector,
                        data[region][var],
                        -99,
                        color="grey",
                        alpha=0.5,
                    )
                    ax.plot(
                        time_vector,
                        data[region][var],
                        color="black",
                        linewidth=0.75,
                        label=scn_id,
                    )
                else:
                    ax.plot(
                        time_vector,
                        data[region][var],
                        linewidth=0.75,
                        label=scn_id,
                    )
            k += 1

        # Concise Date Fmt
        locator = mdates.AutoDateLocator(minticks=3, maxticks=9)
        formatter = mdates.ConciseDateFormatter(locator)
        ax.xaxis.set_major_locator(locator)
        ax.xaxis.set_major_formatter(formatter)

        ax.set_xlim([time_vector[0], time_vector[-1]])
        ax.set_ylim(limits)

        # centered y-axis label
        fig.text(
            0.00,
            0.5,
            var_label,
            va="center",
            rotation="vertical",
        )

        # Legend
        handles, labels = ax.get_legend_handles_labels()
        fig.legend(
            handles,
            labels,
            loc="upper center",
            ncol=5,
            frameon=False,
            bbox_to_anchor=(0.5, 1.1),
        )

        fig.autofmt_xdate()

        plt.tight_layout()
        plt.savefig(
            f"{figure_output_folder}/CoorongBGC_TracerTimeseries_{var_name}_{suffix}.png",
            bbox_inches="tight",
            pad_inches=0.1,
            dpi=300,
        )
        plt.close()
