[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

# CDM Gen 2.1 updates

## Overview
This repository contains the model files for CDM Gen 2.1, which has updates from Gen 2.0 (see below) and includes time frame of 07/2017 - 11/2022.  

## Folder Structure
- `bc_dbase`: database for boundary conditions, including tide, inflows, weather, barrage flow, and initial conditions; 
- `external`: AED setting files;
- `model`: repository for model structure, such as mesh, bathymetry, material zones, node-strings;
- `run`: configuration files of TFV;

## Updates
- `model domain`: model domain has been extended in North Lagoon and South Lagoon to include Ruppia sampling locations at the shoreline; 
- `bathymetry`: Integrated the latest bathymetry data at Parnka channel and Murray Mouth;
- `material zones`: refine the material zone settings around the Parnka Point and Murray Mouth;
- `aed`: update AED initial condition and sediment fluxes to adapt the new mesh and material zones;
- `time frame`: update CDM to Nov 2011, including the tide, weather, and flows;

