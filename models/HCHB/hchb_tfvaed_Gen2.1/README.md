[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

# CDM Gen 2.1 

## Overview
This is the repository for the Coorong Dynamics Model Generation 2.1 (CDM Gen 2.1), which was updated from Gen 2.0 (see below) and includes a time frame of 07/2017 - 11/2022.  

## Updates from Gen 2.0
- `model domain`: model domain has been extended in North Lagoon and South Lagoon to include Ruppia sampling locations at the shoreline; 
- `bathymetry`: Integrated the latest bathymetry data at Parnka channel and Murray Mouth;
- `material zones`: refine the material zone settings around the Parnka Point and Murray Mouth;
- `aed`: update AED initial condition and sediment fluxes to adapt the new mesh and material zones;
- `time frame`: update CDM to Nov 2011, including the tide, weather, and flows;

## Folder Structure
- `bc_dbase`: database for boundary conditions, including tide, inflows, weather, barrage flow, and initial conditions; 
- `external`: AED setting files;
- `model`: repository for model structure, such as mesh, bathymetry, material zones, node-strings;
- `run`: configuration files of TFV;