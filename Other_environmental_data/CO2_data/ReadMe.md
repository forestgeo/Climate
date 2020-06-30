# Atmospheric CO<sub>2</sub> data: combined record for 1901-present

Here we combine two CO<sub>2</sub> data sources to provide a continuous record of atmospheric CO<sub>2</sub> from 1901-present:
1. Mauna Loa observatory data (1974-2019)
2. NOAA ice core data (1901 - 1973)

The combined record is [`co2_MOANA_NOAA_combined.csv`](https://github.com/forestgeo/Climate/blob/master/Other_environmental_data/CO2_data/co2_MOANA_NOAA_combined.csv).

## Data sources:

### Mauna Loa data
This data are only current through 2019. New data from the search tool must be downloaded to update the data continously. 
- Variables used: 
	- `value`
	- `year`
- Variable definitions: 
	- value: Mole fraction reported in units of micromol mol-1 (10-6 mol per mol of dry air); equivalent to ppm (parts per million).
	- year in AD time 
- Date ranges:
	- 1974 - 2019
- Data file is [here](https://github.com/forestgeo/Climate/blob/master/Other_environmental_data/CO2_data/NOAA_ESRL_CO2/ESRL_Mauna_Loa_co2_data.csv) 	
- Readme is [here](https://github.com/forestgeo/Climate/blob/master/Other_environmental_data/CO2_data/NOAA_ESRL_CO2/co2_mlo_surface-flask_1_ccgg_event.txt)
- [Search tool to find the data](https://www.esrl.noaa.gov/gmd/dv/data/index.php?category=Greenhouse%2BGases&parameter_name=Carbon%2BDioxide)


### NOAA ice core data 
- Variables used:
	- `CO<sub>2</sub> ppm`
	- `Year AD`
- Variable definitions: 
	- parts per million spline
	- Year in AD time
- Date ranges:
	- 1901 - 1973
- Data & readme files:
	- First page of [this excel file](https://github.com/forestgeo/Climate/blob/master/Other_environmental_data/CO2_data/NOAA_ESRL_CO2/NOAA_law2006_ice_core_data.xls) has readme, second page has the data.
- [Search tool to find the original NOAA data](https://www.ncdc.noaa.gov/paleo-search/study/9959)	

## Script

Script combining these data found [here](https://github.com/forestgeo/Climate/tree/master/scripts/downloading_CO2_data). The script takes averages of all values for a given year of Mauna Loa data and combines them with values derived from ice core data by NOAA. 

Developed by: Bianca Gonzalez

R version 3.6.1 - First created June 2020

## Citations

*Original Data Set: Mauna Loa*  
Dlugokencky, E.J., J.W. Mund, A.M. Crotwell, M.J. Crotwell, and K.W. Thoning (2019), Atmospheric Carbon Dioxide Dry Air Mole Fractions from the NOAA ESRL Carbon Cycle Cooperative Global Air Sampling Network, 1968-2018, Version: 2019-07, [https://doi.org/10.15138/wkgj-f215](https://doi.org/10.15138/wkgj-f215)  

*Original Data Set: NOAA Ice Cores*  
MacFarling Meure, C., D. Etheridge, C. Trudinger, P. Steele, R. Langenfelds, T. van Ommen, A. Smith, and J. Elkins. 2006. The Law Dome CO2, CH4 and N2O Ice Core Records Extended to 2000 years BP. Geophysical Research Letters, Vol. 33, No. 14, L14810 10.1029/2006GL026152.  

*Curated Data Set: Atmospheric CO<sub>2</sub> data: combined record for 1901-present*  
Please refer to the ForestGEO Climate Date Portal's data citation policy.
