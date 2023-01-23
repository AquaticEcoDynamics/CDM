# -*- coding: utf-8 -*-
"""
Created on Wed Sep  8 16:13:52 2021

@author: mgibbs
"""

from tfv.extractor import *
from tfv.geometry import *
from datetime import datetime,timezone

import sys
import shapefile #from pyshp
import numpy as np
import pandas as pd

#"D:\TUFLOW\CoorongTFV\TUFLOWFV\output\Fast\00_Historic_basecase_climatechange.nc"

resultFiles =[r"D:\TUFLOW\CoorongTFV\TUFLOWFV\output\Historical_basecase_extended_tiderepeat.nc"]
# resultFiles =[r"D:\TUFLOW\CoorongTFV\TUFLOWFV\output\Historic_basecase.nc",
# r"D:\TUFLOW\CoorongTFV\TUFLOWFV\output\Fast\Current_Basecase.nc",
# r"D:\TUFLOW\CoorongTFV\TUFLOWFV\output\Fast\00_Historic_basecase_climatechange.nc",
# r"D:\TUFLOW\CoorongTFV\TUFLOWFV\output\Fast\01_ClimateChange_PumpOut1000ML_const_PolicemanPt_above0.3m.nc",
# r"D:\TUFLOW\CoorongTFV\TUFLOWFV\output\Fast\01_Current_PumpOut1000ML_const_PolicemanPt_above0.3m.nc",
# r"D:\TUFLOW\CoorongTFV\TUFLOWFV\output\Fast\01_Historic_PumpOut1000ML_const_PolicemanPt_above0.3m.nc",
# r"D:\TUFLOW\CoorongTFV\TUFLOWFV\output\Fast\02_ClimateChange_PassivePipe2000x10.nc",
# r"D:\TUFLOW\CoorongTFV\TUFLOWFV\output\Fast\02_Current_PassivePipe2000x10.nc",
# r"D:\TUFLOW\CoorongTFV\TUFLOWFV\output\Fast\02_Historic_PassivePipe2000x10.nc",
# r"D:\TUFLOW\CoorongTFV\TUFLOWFV\output\Fast\03_ClimateChange_Out250_Dredge_KBR02A_fast_mesh_aligned.nc",
# r"D:\TUFLOW\CoorongTFV\TUFLOWFV\output\Fast\03_Current_Out250_Dredge_KBR02A_fast_mesh_aligned.nc",
# r"D:\TUFLOW\CoorongTFV\TUFLOWFV\output\Fast\03_Historic_Out250_Dredge_KBR02A_fast_mesh_aligned.nc",
# r"D:\TUFLOW\CoorongTFV\TUFLOWFV\output\Fast\06_ClimateChange_Out250.nc",
# r"D:\TUFLOW\CoorongTFV\TUFLOWFV\output\Fast\06_Current_Out250.nc",
# r"D:\TUFLOW\CoorongTFV\TUFLOWFV\output\Fast\06_Historic_Out250.nc",
# r"D:\TUFLOW\CoorongTFV\TUFLOWFV\output\Fast\07_ClimateChange_Out350PolicemanPt_In350RoundIs_above0.3m.nc",
# r"D:\TUFLOW\CoorongTFV\TUFLOWFV\output\Fast\07_Current_Out350PolicemanPt_In350RoundIs_above0.3m.nc",
# r"D:\TUFLOW\CoorongTFV\TUFLOWFV\output\Fast\07_Historic_Out350PolicemanPt_In350RoundIs_above0.3m.nc"]

#result files to process passed in from the command line
script, resultFiles, = sys.argv
print(script)
print(resultFiles)

# input polygon shapefile
shpFile = r"D:\TUFLOW\CoorongTFV\code\Python\GIS\Lagoons_Wet.shp"

# parameters
parameters = ['SAL','H','TRACE_2','TRACE_3','TRACE_4','TRACE_5']
parametersnames = ['Salinity','Waterlevel','Ocean','Barrage','SouthEast','WaterAge']

for resultFile in resultFiles:
    # instantiate extractor object
    xtr = FvExtractor(resultFile)
    
    # get cell areas, elevation and centroids directly from netCDF4 file (.nc attribute is a netCDF4 Dataset object)
    cell_area = xtr.nc['cell_A'][:].data
    cell_elev = xtr.nc['cell_Zb'][:].data
    
    cell_x = xtr.nc['cell_X'][:].data
    cell_y = xtr.nc['cell_Y'][:].data
    
    # read in polygon geometry from the shape file
    sf= shapefile.Reader(shpFile)
    
    polygons = [np.array(shape.points) for shape in sf.shapes()]
    records =sf.records()
    
    dates = []
    for ii in range(xtr.nt):
        dates.append(datetime.fromtimestamp(xtr.time_vector[ii],timezone.utc).strftime("%d/%m/%Y %H:%M"))
    
    df=pd.DataFrame({'Date':dates})
    
    for i in range(len(polygons)):
    #for i in range(1):
        p=polygons[i]
        name=records[i][1]
    
        # get logical index for cells which are in at least 1 polygon
        in_area = np.sum(np.array([in_polygon(cell_x, cell_y, p[:, 0], p[:, 1])]), axis=0) > 0
    
    # # check in polygon search worked properly
    # f = plt.figure()
    # ax = f.add_axes([0.1, 0.1, 0.9, 0.9])
    
    # verts = np.dstack((xtr.node_x[xtr.cell_node], xtr.node_y[xtr.cell_node]))
    # ax.add_collection(PolyCollection(verts=verts, facecolors='white', edgecolors='black'))
    
    # plt.plot(cell_x, cell_y, 'bo', markersize=1.5)
    # plt.plot(cell_x[in_area], cell_y[in_area], 'ro', markersize=1.5)
    # for p in polygons:
    #     plt.plot(p[:, 0], p[:, 1], 'm-', linewidth=2)
    
    # ax.set_aspect('equal')
    
        for p in range(len(parameters)):
            parameter=parameters[p]
            parametername=parametersnames[p]
        
        # # pre-allocate an array of size (nt,) for total area
            average_val = np.zeros((xtr.nt,), dtype=float)
            
            # # iterate across time
            for ii in range(xtr.nt):
            
            #     # extract depth at ith time step.
                depth_ii = xtr.get_sheet_cell('D', ii) #
                value_ii = xtr.get_sheet_cell(parameter, ii)
            
            
            #     # sum the area of all cells which are in depth range and are in at least one polygon
                if parameter=='H': #area weighting
                     average_val[ii] = np.sum(value_ii[in_area] * cell_area[in_area]) / np.sum(cell_area[in_area])         
                else: #volume weighting
                     average_val[ii] = np.sum(value_ii[in_area] * cell_area[in_area]*depth_ii[in_area]) / np.sum(cell_area[in_area]*depth_ii[in_area])  
                     
            df[name+"_"+parametername]=average_val
    
    df.to_csv(resultFile.replace('.nc','')+'_AVERAGES.csv',index=False, float_format='%.3f')
    
