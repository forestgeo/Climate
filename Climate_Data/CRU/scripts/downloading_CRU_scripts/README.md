# CRU Download Instructions for newer CRU version

1. create a new folder for the newest version in [here](https://github.com/forestgeo/Climate/tree/master/Climate_Data/CRU) and in S:\Global Maps Data\CRU

2. download the one KML file  equivalent to [this file](https://github.com/forestgeo/Climate/blob/master/Climate_Data/CRU/CRU_v4_06/KML_files/cruts_4.06_gridboxes.kml) and save it in a subfolder called `KML_files` in your newly created folder of this repository. This takes care of variables tmp, pre, dtr, vap

3. for all other variables than tmp, pre, dtr, vap, download the .nc files, zipped (extention `nc.gz`, example file `cru_ts4.06.1901.2021.dtr.dat.nc.gz` and save then in a subfolder called `nc_files` in the newly created folder in S:\Global Maps Data\CRU

4. in the script, update variable `CRU_version` in line 23.

5. run the script

