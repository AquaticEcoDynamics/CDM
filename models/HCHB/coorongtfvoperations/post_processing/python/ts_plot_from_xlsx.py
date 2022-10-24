"""
Script to generate timeseries plot for Coorong-Release scenarios compiled in an xlsx file.
Plot inputs and configuration are defined in ts_cfg.json.
>>python ts_plot_from_xlsx.py ts_cfg.json
I Teakle
"""

import sys
from pathlib import Path
#sys.path.insert(0, (Path(__file__).parent / 'py_utils').as_posix())
import argparse 
from py_utils.plotting_functions import ts_plot_from_xlsx

parser = argparse.ArgumentParser(description='plot some stuff')
parser.add_argument('ts_cfg_file', type=str,
                    help='Which json config to use')
args = parser.parse_args()
ts_cfg_file = args.ts_cfg_file

ts_plot_from_xlsx(ts_cfg_file)