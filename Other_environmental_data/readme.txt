######################################################
# Data: Moana Loa and NOAA data
# Purpose: Download C02 data and combine to create a c02 record matching years of CRU data.
# Developed by: Bianca Gonzalez
# R version 3.6.1 - First created June 2020
# Script combining these data found here: https://github.com/forestgeo/Climate/tree/master/scripts/downloading_CO2_data
######################################################
- The script takes averages of all values for a given year and adds them to the ice cores data.

##### Data sources:

# Moana Loa data
- Variables used: 
	- value
	- year
- Variable definitions: 
	- value:comment : Mole fraction reported in units of micromol mol-1 (10-6 mol per mol of dry air); equivalent to ppm (parts per million).
	- year in AD time 
- Find their read me here: 
	- https://github.com/forestgeo/Climate/blob/master/Other_environmental_data/NOAA_ESRL_C02_data/co2_mlo_surface-flask_1_ccgg_event.txt
- The search tool to fine the data:
	- https://www.esrl.noaa.gov/gmd/dv/data/index.php?category=Greenhouse%2BGases&parameter_name=Carbon%2BDioxide

# NOAA data 
- Variables used:
	- c02 ppm
	- Year AD
- Variable definitions: 
	- parts per million
	- Year in AD time
- Find their read me here:
	- First page of the excel sheet has readme, second page has the data used: https://github.com/forestgeo/Climate/blob/master/Other_environmental_data/NOAA_ESRL_C02_data/NOAA_law2006_ice_core_data.xls
- The search tool to fine the data:
	- https://www.ncdc.noaa.gov/paleo-search/study/9959