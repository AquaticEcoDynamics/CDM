# Import modules, functions & classes
from tfv.extractor import FvExtractor
from tfv.visual import *
import os

# -------------------------------------------------- User  Input -------------------------------------------------------
def TUFLOW_get_long_section(res_folder,res_name,variable,line_file,time1,time2):
    # Result file folder and name
  #  res_folder = r'C:\TUFLOW\CoorongParticles\TUFLOWFV\output'
  #  res_name = '01_Barrage_Obs_SE_Obs_ParnkaD_Orig_PelicanD_Orig_PoliceP_0const_RoundP_0const_LAC_0.nc'
    
    # Variable to plot
   # variable = 'SAL'
    
    # Polyline file folder and name
 #   line_folder = r'C:\TUFLOW\pyTFV'
 #   line_name = 'centerline2.csv'
    
    # convert from date to seconds since 1970. Not sure, do it in R.
#    time1=(time1-np.datetime64('1970-01-01')).item().total_seconds()
  #  time2=(time2-np.datetime64('1970-01-01')).item().total_seconds()
    
    # ----------------------------------------------------- Script ---------------------------------------------------------
    
    # Prepare extractor object
  #  res_file = res_folder + '\\' + res_name
    res_file = "{}{}{}".format(res_folder, os.sep, res_name)
    xtr = FvExtractor(res_file)
    
    # Get Polyline
    polyline = list()
#    line_file = line_folder + '\\' + line_name
    with open(line_file, 'r') as file:
        lines = file.readlines()
        for line in lines[1:]:
            polyline.append([float(aa) for aa in line.split(',')])
    
    # Prepare extractor object
    res_file = res_folder + '\\' + res_name
    xtr = FvExtractor(res_file)
    
    # Get average long section over time
    time = xtr.time_vector
    x_data = xtr.get_intersection_data(polyline)
    index = xtr.get_curtain_cell_index(polyline, x_data)
    t1=0
    for ii in range(len(time)):
            if time[ii]>=time1 and time[ii]<= time2:
                if t1 < 1:
                    data_av = xtr.get_curtain_cell(variable, ii, polyline, x_data, index)
                else:
                    data_ii = xtr.get_curtain_cell(variable, ii, polyline, x_data, index)
                    data_av = data_av+data_ii
                t1=t1+1;
    
    if(t1>0):
        data_av=data_av/t1
        data_av=data_av.filled()
    
    x=x_data+(data_av,)
    return x
    
