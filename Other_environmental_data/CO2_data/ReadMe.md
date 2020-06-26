# Moana Loa and NOAA CO2 data

######################################################

Data: Moana Loa and NOAA data

Purpose: Download CO2 data and combine to create a CO2 record matching years of CRU data.

Developed by: Bianca Gonzalez

R version 3.6.1 - First created June 2020

Script combining these data found here: https://github.com/forestgeo/Climate/tree/master/scripts/downloading_CO2_data

######################################################

- The script takes averages of all values for a given year of Moana Loa data and adds them to values derived from ice core data by NOAA. 
- The combined file contains annual CO2 levels from 1901-present, with NOAA data ranging from 1901 - 1973 (to match CRU data) and Moana Loa data from 1974-2019 (to complete the record to present date).

# Data sources:

## Moana Loa data
- Variables used: 
	- value
	- year
- Variable definitions: 
	- value: comment: Mole fraction reported in units of micromol mol-1 (10-6 mol per mol of dry air); equivalent to ppm (parts per million).
	- year in AD time 
- Date ranges:
	- 1974 - 2019
- Find their read me here: 
	- https://github.com/forestgeo/Climate/blob/master/Other_environmental_data/NOAA_ESRL_C02_data/co2_mlo_surface-flask_1_ccgg_event.txt
- The search tool to find the data:
	- https://www.esrl.noaa.gov/gmd/dv/data/index.php?category=Greenhouse%2BGases&parameter_name=Carbon%2BDioxide

## NOAA data 
- Variables used:
	- CO2 ppm
	- Year AD
- Variable definitions: 
	- parts per million
	- Year in AD time
- Date ranges:
	- 1901 - 1973
- Find their read me here:
	- First page of the excel sheet has readme, second page has the data used: https://github.com/forestgeo/Climate/blob/master/Other_environmental_data/NOAA_ESRL_C02_data/NOAA_law2006_ice_core_data.xls
- The search tool to find the data:
	- https://www.ncdc.noaa.gov/paleo-search/study/9959
