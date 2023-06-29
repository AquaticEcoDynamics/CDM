[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

# CDM Gen 2.1 

## Overview
This is the repository for the Coorong Dynamics Model Generation 2.1 (CDM Gen 2.1), which was updated from Gen 2.0 (see below) and includes a time frame of 07/2017 - 11/2022. The model time frame will be extended to 2023 once the tide and weather data were updated.

## Updates from Gen 2.0
- `model domain`: model domain has been extended in North Lagoon and South Lagoon to include Ruppia sampling locations at the shoreline; 
- `bathymetry`: latest bathymetry data at Parnka channel and Murray Mouth was integrated int the momdel;
- `material zones`: the material zone settings around the Parnka Point and Murray Mouth were refined for better resolving the local bathymetry and nutrient fluxes;
- `aed`: AED initial condition and sediment fluxes were updated to adapt to the new mesh and material zones;
- `time frame`: all boundary conditions were updated to Nov 2022, including the tide, weather, and flows; to be updated to 2023 once the tide and weather data were updated. 

## Folder Structure
- `bc_dbase`: database for boundary conditions, including tide, inflows, weather, barrage flow, and initial conditions; 
- `external`: AED setting files;
- `model`: repository for model structure, such as mesh, bathymetry, material zones, node-strings;
- `run`: configuration files of TFV;


## Upgraded Mesh and Material Zones

![2_panel_mesh_materials](https://github.com/AquaticEcoDynamics/CDM/assets/19967037/8f319a3e-2e8c-4f71-8466-1cf82883418c)
Gen 2.1 upgraded mesh & material zones


![Gen2 1 Mesh Upgrade](https://github.com/AquaticEcoDynamics/CDM/assets/19967037/5ca761f5-20a7-40fc-838c-fc595c3dc86f)
Gen 2.1 upgraded mesh showing the refinement of the mesh in shallow regions to imrove habitat modelling
