# BCI Precipitation Records

[Daily precipitation data](https://github.com/forestgeo/Climate/tree/master/Climate_Data/Met_Stations/BCI/El_Claro_precip_starting_1929/20180168_bci_manual_cl_ra) were downloaded from [here](https://smithsonian.figshare.com/articles/Barro_Colorado_Island_Clearing_Precipitation_manual/10042502). 

[This script](https://github.com/forestgeo/Climate/blob/master/Climate_Data/Met_Stations/BCI/El_Claro_precip_starting_1929/BCI_pet_data.R) converts the data into  monthly format (parallel to [CRU](https://github.com/forestgeo/Climate/tree/master/Climate_Data/CRU), producing files [pre_BCI](https://github.com/forestgeo/Climate/blob/master/Climate_Data/Met_Stations/BCI/El_Claro_precip_starting_1929/pre_BCI.csv) and [wet_BCI](https://github.com/forestgeo/Climate/blob/master/Climate_Data/Met_Stations/BCI/El_Claro_precip_starting_1929/wet_BCI.csv).

**NOTE: `pre_BCI.csv` is currently missing records for months with zero precipitation. See [this issue](https://github.com/forestgeo/Climate/issues/42).**

# Reference
Paton, S. (2019). Barro Colorado Island, Clearing_Precipitation, manual. doi:10.25573/data.10042502.v3
