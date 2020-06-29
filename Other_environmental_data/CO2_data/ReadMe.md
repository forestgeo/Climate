# Mauna Loa and NOAA CO2 data

######################################################

Data: Mauna Loa and NOAA data

Purpose: Download CO2 data and combine to create a CO2 record for 1901-present.

Developed by: Bianca Gonzalez

R version 3.6.1 - First created June 2020

Script combining these data found here: https://github.com/forestgeo/Climate/tree/master/scripts/downloading_CO2_data

######################################################


- The script takes averages of all values for a given year of Mauna Loa data and combines them with values derived from ice core data by NOAA. 
- The combined file contains annual CO2 levels from 1901-present, with NOAA data ranging from 1901 - 1973 and Mauna Loa data from 1974-2019.


# Data sources:

## Mauna Loa data
This data is only current through 2019. New data from the search tool must be downloaded to update the data continously. 
- Variables used: 
	- `value`
	- `year`
- Variable definitions: 
	- value: Mole fraction reported in units of micromol mol-1 (10-6 mol per mol of dry air); equivalent to ppm (parts per million).
	- year in AD time 
- Date ranges:
	- 1974 - 2019
- Find their read me here: 
	- https://github.com/forestgeo/Climate/blob/master/Other_environmental_data/CO2_data/NOAA_ESRL_CO2/co2_mlo_surface-flask_1_ccgg_event.txt
- The search tool to find the data:
	- https://www.esrl.noaa.gov/gmd/dv/data/index.php?category=Greenhouse%2BGases&parameter_name=Carbon%2BDioxide

## NOAA data 
- Variables used:
	- CO2 ppm
	- Year AD
- Variable definitions: 
	- parts per million spline
	- Year in AD time
- Date ranges:
	- 1901 - 1973
- Find their read me here:
	- First page of the excel sheet has readme, second page has the data used: https://github.com/forestgeo/Climate/blob/master/Other_environmental_data/CO2_data/NOAA_ESRL_CO2/NOAA_law2006_ice_core_data.xls
- The search tool to find the original NOAA data:
	- https://www.ncdc.noaa.gov/paleo-search/study/9959
