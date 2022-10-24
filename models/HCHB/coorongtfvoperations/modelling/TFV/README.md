## Symbolic Links
Note that in order to avoid needing to customise the run files for different machines, symbolic links are used to provide a neat way to emulate the respective directory. This should be done for outputs and large BC files. ***Don't commit these links to the Git repository***. The symbolic links can be added to .gitignore. Note that Git considers the links as files rather than directories. On unix-based systems, symbolic links can be identified with the following command: ``find . -type l``.
For example, a symbolic link for the *output* directory may be created as below. Note that the link will be created in the present working directory.

Unix:  
``ln -s <link destination> <link name>``  
e.g. ``ln -s /scratch1/coorong-barrage-release/TUFLOWFV/rapid output``  

Windows (need to open Command Prompt in administrator mode):  
``mklink /d <link name> <link destination>``  
e.g. ``mklink /d output D:\projects_D\coorong-barrage-release\TUFLOWFV\rapid``

To get the models in this repository set up, ***at this stage symbolic links need to be manually set up by the user***. The links should be created at the listed *directory*, with links as specified below. Note that depending on the computer setup (i.e., blaydos or local machine), the links may need to be updated accordingly - depending on where the corresponding files are located. If you're running on a local machine, it may be beneficial to copy the relevant files over to a local drive to save network overheads. Note that the link destination may require updating to accommodate for windows/unix machines.

Symbolic links should be created as follows. Note that *blaydos* is in reference to a BMT computing resource so depending on the user a different link destination may need to be used. Failure to set these links up will lead to issues in finding correct file paths when running TUFLOW FV:  
1. **CSIRO BARRA Atmospheric BCs:**  
	Directory:	``coorong-barrage-release\modelling\TFV\bc_dbase\calibration\met``  
	Link name:	``BARRA``  
	Link destination:	``\\blaydos\spare\projects\A10780\bcs\BARRA``  
2. **TUFLOW FV Outputs:**  
	Directory:	``coorong-barrage-release\modelling\TFV\run\*``  
	Link name:	``output``  
	Link destination:	**will vary based on machine and project**