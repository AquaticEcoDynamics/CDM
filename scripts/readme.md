# CDM Scripts

The Scripts directory folder is separated out into three folders:

* dataimport
* datatools
* modeltools

## dataimport

The data import folder contains all the scripts that:
  * Download data from 3rd party
  * Import and convert and data in the data/incoming directory

Converted data is then stored in the data/store directory.

## datatools

The data tools folder contains scripts that:
  * Create BC files from data in the data/store directory
  * Create GIS files from imported data
  * Create model I.C. files

## modeltools

The model tools directory contains all scripts that post process any model output data.


![scripts_schematic_v1](https://user-images.githubusercontent.com/19967037/126591194-e87579a5-c026-4a04-90b1-f41a513e83f9.png)

**Figure. Design schematic for how the scripts in the different folders interact with the other parts of the CDM repository**

![Example_workflow](https://user-images.githubusercontent.com/19967037/126721518-98eb56c4-1efc-467b-8472-473120064439.png)

**Figure. Example workflow highlighting dataimport and datatools**

