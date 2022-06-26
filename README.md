
![image](sandbox/coorong_banner.jpeg)

# CDM : Coorong Dynamics Model

[![Project Status: Active – The project is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![CDM](https://img.shields.io/badge/CDM-2.0-brightgreen)](https://aquatic.science.uwa.edu.au/research/models/AED/quickstart.html)
[![TUFLOW-FV](https://img.shields.io/badge/TUFLOW--FV-2020.008-yellow)](https://tuflow.com/products/tuflow-fv/)
[![AED](https://img.shields.io/badge/AED-2.0.5-orange)](https://aquatic.science.uwa.edu.au/research/models/AED/quickstart.html)
[![GPLv3 license](https://img.shields.io/badge/License-GPLv3-blue.svg)](http://perso.crans.org/besson/LICENSE.html)


<br>

This is the repository for relevant **data, models and scripts** for environmental modelling of the [Coorong](https://en.wikipedia.org/wiki/Coorong,_South_Australia). It is a simulation platform developed as part of the [Healthy Coorong Healthy Basin](https://www.environment.sa.gov.au/topics/coorong/healthy-coorong-healthy-basin) program for assisting in management of the iconic Australian ecosystem.

For an overview of the CDM model, refer to the [CDM Documentation](https://aquaticecodynamics.github.io/cdm-science/).

<br>

## Repository organisation


<img src="https://user-images.githubusercontent.com/19967037/127596869-b62ce358-925f-45cc-82cd-0f55aea5b991.png" alt="Fodler structure" width="538"/>
**Figure 1. Design schematic for the CDM repository**

<br>

## Cloning the repo with all submodule code/files

A basic clone will not include the code in the submodules so an extra argument is needed `--recurse-submodules`

### Cloning the latest bundle
```
git clone --recurse-submodules https://github.com/AquaticEcoDynamics/CDM.git
```

### Cloning a particular tag
```
git clone --recurse-submodules -b v1.1.0 https://github.com/AquaticEcoDynamics/CDM.git
```

<br>

## Archiving all code/files

If you want to create an archive of all the code (including the submodules), first clone the repository as described above and zip entire repository.  The zip file can be uploaded to Zenodo to get a DOI.  An automated integration with Zenodo will not archive the code from the submodules.

<br>

## Additional information

See repository Wiki for additional information on editing the repository and adding new content.

<br>

