# Bathymetry Composite Details
The bathymetry utilised in the 2022 Coorong Barrage Release modelling was assembled from a composite of bathymetry sources. The adopted bathymetry sources are detailed in Section 2 of BMT (2022).

The original intent of the referenced modelling work was to use the DEW Coorong bathymetry product (Hobbs et al., 2019), however testing showed significant differences in bed levels between SDB and survey points - having significant impact on the salinity dynamics, particularly within the CSL.

For the 2022 Coorong Barrage Release modelling, a move to an orthogonal-style mesh at the Murray River Mouth was adopted. With this shift, the mesh formerly used in the CIIP modelling (BMT/UWA, 2022) was not suitable, however the model boundaries south of Round Island adopted the CIIP boundary extents (with some model extension just east of Snake Island).

Following these mesh updates and in-line with bathymetry sensitivity testing, a composite bathymetry was developed with details on the development and configuration listed in the following. 



## Data Sources
The bathymetry data sources are described as follows:

1. *master*: XYZ point dataset supplied by DEWNR for a model update and scenario assessment study commissioned by SA Water (B21159 (BMT, 2015)). This dataset covers the vast majority of the model domain. 
2. *Coorong_detailed_rma_001*: Node-defined bathymetry embedded within the model mesh used for the CIIP modelling. This was renamed for the Coorong Barrage release modelling but was originally sourced from UWA at the beginning of the CIIP project with the filename *014_Coorong_Salt_Crk_Mouth_Channel_MZ3_Culverts.2dm*. Matt Gibbs also added the March 2021 Parnka Narrows survey in this dataset for the CIIP modelling, however due to substantial mesh adjustments in The Narrows for the Barrage Release modelling, bathymetry in this region was resampled (process detailed later on). Used to define bathymetry in proximity of Salt Creek and Boundary Creek.
3. *CI_006_20150101*: former model bathymetry dataset originating from B23126 (BMT, 2019). Used to define the bathymetry upstream of the barrages, the Murray River Mouth and the offshore region. The Murray River Mouth state as at 01/01/2015 was nominally selected as a relatively "neutral" bathymetry state for the purposes of the CIIP modelling.
4. *Coorong_Parnka_Narrows_survey_pts_202103_TIN_linear_mAHD*: March 2021 bathymetry survey of the Parnka Narrows. Desktop review of the provided raster dataset revealed some interpolation artefacts from blending survey composites from historical measurements. To avoid this, BMT used the raw single-beam scatter set from the survey and applied a TIN linear interpolation to develop a new raster dataset for the Barrage Release modelling.

With exception of the March 2021 Parnka Narrows survey, the bathymetry sources are applied across the domain as illustrated below:

![Bathymetry composite origins](./readme_figs/bathymetry_source_polygons.JPG "Map depicting the bathymetry origins")

Where applicable, the Parnka Narrows 2021 survey takes precendence over the defined bathymetry in the region.


## Bathymetry Composite Methodology
To compile the bathymetry sources into a full composite, several steps were undertaken.

### Scatter Interpolation (SMS)
Firstly, for the sources in scatter set form, these were interpolated to the cell centeres of the model mesh. This process was necessary for the *master*, *Coorong_detailed_rma_001* and *CI_006_20150101* input scatter sets. This interpolation method was conducted as follows:

1. Extract cell centres for the new model mesh.
2. Interpolate the bathymetry scatter set to the extracted cell centres. Extrapolation may also be required such that the full model domain is covered. To do this in SMS:
	1. Select cell-centered scatter layer
	2. Scatter -> Interpolate to Scatter -> from Other Scatter Set
	3. Select bathymetry scatter set to interpolate from. Use "Linear" interpolation method, and "Inverse Distance Weighted" interpolation using nearest 8-points.
	4. Select OK and continue for other scatter sets.
3. Export the interpolated cell-centered scatter set with ID, X, Y, and Z from the interpolated fields as a *.csv* file. You can do this within a single file, where for example you may have a header such as *ID, X, Y, Z_CI_006_20150101, Z_master, Z_Coorong_detailed_rma_001*.

The output from the steps above is used as input for the polygon-based bathymetry assignment.

### Raster Sampling (QGIS)
For the March 2021 Parnka Narrows Survey, a TIN-based raster was generated from the scatter set. Due to the significance of this region in the hydraulic control into the CSL, an alternative statistical approach was adopted in place of the usual cell-centered inspection of a raster dataset in order to provide a better representation of the bathymetry schemetisation over a model cell. This process was undertaken within QGIS as follows:

1. Load the *.2dm* mesh into QGIS.
2. Using the *Export mesh faces* tool, convert the mesh to polygons.
3. Using the polygon vector layer as output from the previous step, compute statistics (e.g., mean, median etc.) using the *Zonal Statistics* tool. This will provide statistics for each discretised cell coinciding with the raster.
4. Export the output as a *.csv*

This Parnka Narrows output is used to take precendence in the final bathymetry in the polygon-based bathymetry assignment scripting. The cell **median** was used to define the Parnka Narrows bathymetry for the Coorong Barrage Release modelling (BMT, 2021).

### Polygon-Based Bathymetry Assignment
The cell-centered bathymetry is assigned by a series of polygons as shown in the figure above. This process is conducted within the MATLAB script *define_bathy_pts_by_shapefile.m* contained within the *./scripts* working directory.

The script inputs include:
1. Interpolated cell-centered scatter set data from the SMS interpolation.
2. Raster-inspected cell bathymetry from the QGIS zonal statistics analysis.
3. Polygon shapefile defining the bathymetry to assign for each region.

The final output is a cell-cell-centered file suited to direct input into the TUFLOW FV model.


## Resources
### Scatter Data
The raw scatter sets used as input for the bathymetry setup are located in *./input/raw_scatter* and include:

| Date Source Name                                         | File Name                                          | Originating Filepath (BMT Specific)                                                                                                                  |
|----------------------------------------------------------|----------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| master                                                   | master.csv                                         | \\archivenas01\archive2\pcarchive\B21159.L.iat.MurrayMouthDredging\modelling\TUFLOWFV_2\geo\NEW\MASTER\master.csv                                    |
| Coorong_detailed_rma_001                                 | Coorong_detailed_rma_001_node_bathy.csv            | L:\A11650.L.iat.CoorongRelease\05_modelling\pre_processing\bathymetry\working\Coorong_detailed_rma_001_node_bathy.csv                                |
| CI_006_20150101                                          | CI_006_20150101.txt                                | L:\B23126.L.tjd_MurrayMorphUpdate\Modelling\TUFLOWFV\geo\CI_006_Z_IC_20150101.txt                                                                    |
| Coorong_Parnka_Narrows_survey_pts_202103_TIN_linear_mAHD | HCHB_ParnkaNarrows_202103_merged_MGA94_AHD_pts.csv | L:\A11650.L.iat.CoorongRelease\01_data_in\20220209_202103_Parnka_Narrows_Bathy\BMT_working\inputs\HCHB_ParnkaNarrows_202103_merged_MGA94_AHD_pts.csv |

### Rasters
The rasterised bathymetry sources used as input for the composite bathymetry are compiled into a single GeoTIFF *Coorong_detailed_006_bathymetry_inputs.tif* (not contained within this repository due to file size), with each bathymetry source stored in a seperate band. The origin of the bands are specified in an accompanying metadata file (*Coorong_detailed_006_bathymetry_inputs_metadata.csv*), but put briefly the bands are defined as:

| Band | Data Source Name                                         |
|:----:|----------------------------------------------------------|
|   1  | CI_006_20150101                                          |
|   2  | Coorong_Parnka_Narrows_survey_pts_202103_TIN_linear_mAHD |
|   3  | Coorong_detailed_rma_001                                 |
|   4  | master                                                   |

### Shapefiles
The polygon shapefile used to define the bathymetry for the 2022 Coorong Barrage Release (BMT, 2022) and as illustrated in the figure above is located at *./input/shapefiles/bathy_source_merged_004.shp*

### Example Files
For demonstrative purposes, an example output from the SMS Scatter Interpolation methodology is included at: 
*./input/interp_scatter/demonstration/SMS/Coorong_detailed_006_cc_working.txt*

Similarly, an example output from the QGIS Raster Sampling is included at:
*./input/interp_scatter/demonstration/QGIS/Coorong_detailed_006_cc_Coorong_Parnka_Narrows_survey_pts_202103_TIN_linear_mAHD.csv*


## Notes
This bathymetry composite exercise was conducted in February 2022. Data sources and the scripting were compiled retrospectively in March 2023. All original processing conducted by BMT was conducted at the filepaths below:

SMS project: *"L:\A11650.L.iat.CoorongRelease\05_modelling\pre_processing\bathymetry\sms\Coorong_detailed_006\Coorong_detailed_006.sms"*

QGIS project: *"L:\A11650.L.iat.CoorongRelease\05_modelling\pre_processing\bathymetry\Coorong_bathy.qgz"*

Interpolated scatter set outputs: *L:\A11650.L.iat.CoorongRelease\05_modelling\pre_processing\bathymetry\working*

Script: *L:\A11650.L.iat.CoorongRelease\05_modelling\pre_processing\bathymetry\scripts\a_define_bathy_pts_by_shapefile.m*


## References
BMT (2015), “Murray Mouth Model Updates and Scenario Assessments”. Report prepared for SA Water. Report no.: R.B21159.002.01.

BMT (2019), “Murray Mouth Model Status Report”. Report prepared for the Department for Environment and Water. Report no.: R.B23126.001.00.

BMT/UWA (2022), “Coorong Infrastructure Investigations Project”. Report Prepared for the Department for Environment and Water. Report no.: R.A10780.001.03.

BMT (2022), “Coorong Barrage Release Windows Investigations”. Report Prepared for the Department for Environment and Water. Report no.: R.A11650.001.00.