# Climatic Research Unit (CRU) data for ForestGEO sites

**Source**: CRU TS monthly high-resolution gridded multivariate climate dataset, available [here](https://crudata.uea.ac.uk/cru/data/hrg/). The CRU data product is described by Harris et al. (2014, 2020).

**Temporal coverage**: 1901 - 2019 (ongoing)

**Temporal resolution**: monthly

**Geographic coverage**: global

**Spatial resolution**: 0.5° by 0.5° (~55.66 km at equator, 42.5 km at 40° latitude, 0 km at poles)

**Variables**: 
               
Abbreviation	| Description	| Units
--|--|--
tmp	| average daily mean temperatures	|°C
tmn	| 	average daily minimum temperatures	| 	°C
tmx		| average daily maximum temperatures	| 	°C
drt		| diurnal temperature range	(*i.e.,* temperature amplitude)	| °C
frs		| frost day frequency	| days  mo-1
pre	| 	precipitation		| mm mo-1
wet		| wet day frequency	|  days	mo-1
cld		| cloud cover		| %
vap		| vapour pressure		| hPa
pet		| average daily potential evapotranspiration 	| 	mm day-1
pet_sum		| potential evapotranspiration sum (computed [here](https://github.com/forestgeo/Climate/tree/master/Climate_Data/CRU/scripts/Calculate_PET_sum.R))	| 	mm mo-1

## Data description

### CRU version:

The latest version for tmp, dtr, pre, vap and pet is [**v.4.06**](https://github.com/forestgeo/Climate/tree/master/Climate_Data/CRU/CRU_v4_06) (released 26 May 2022, covers the period 1901-2021). We recommend that anyone interested in using these data check the [CRU website](https://crudata.uea.ac.uk/cru/data/hrg/) to see if there is a more recent version.
This version only has tmp, dtr, pre, vap and pet because it is generated with [this script](https://github.com/forestgeo/Climate/tree/master/Climate_Data/CRU/scripts/downloading_CRU_scripts/download_and_extract_from_KML_files_for_tmp_pre_dtr_vap.R), which extracts the data from a KML file downloaded [here](https://crudata.uea.ac.uk/cru/data/hrg/cru_ts_4.06/ge/) for tmp, dtr, pre, vap and downloads the PET NETCDF file for pet [here](https://crudata.uea.ac.uk/cru/data/hrg/cru_ts_4.06/cruts.2205201912.v4.06/pet/).



The latest version for all variables is [**v.4.04**](https://github.com/forestgeo/Climate/tree/master/Climate_Data/CRU/CRU_v4_04) (released 24 April 2020, covers the period 1901-2019). We recommend that anyone interested in using these data check the [CRU website](https://crudata.uea.ac.uk/cru/data/hrg/) to see if there is a more recent version.

[*Previous versions*](https://github.com/forestgeo/Climate/tree/master/Climate_Data/CRU/previous_versions) in this repository include:
- v. 3.10 - Values from this version, including annual and climatic means calculated using Matlab by K. Anderson-Teixeira, are presented in [Anderson-Teixeira et al. (2015)](https://onlinelibrary.wiley.com/doi/abs/10.1111/gcb.12712). A detailed description of data files and contents is given in [metadata associated with this version](https://github.com/forestgeo/Climate/blob/master/Climate_Data/CRU/previous_versions/CRU_v3_10_01/CTFS-ForestGEO_historical_climate_metadata.pdf)
- v. 3.23 - Includes annual and climatic means calculated using Matlab by K. Anderson-Teixeira, as detailed in [metadata associated with this version](https://github.com/forestgeo/Climate/blob/master/Climate_Data/CRU/previous_versions/CRU_v3_23/CTFS-ForestGEO_historical_climate_metadata.pdf). 
- v. 4.01 
- v. 4.03 

### Metadata:

*Data file names*: 

`[xxx].1901.20xx.csv`, where `xxx` is a three-letter abbreviation for the climate variable in table above, and `20xx` indicates the data end year. 

*Data file contents:*

- v. 4.06 

Column|Description
--|--
sites.sitename|Site name
variable|three-letter abbreviation for the climate variable
Yr|Year
Mo|Month
Value|Value
N.obs|level of station support enjoyed by each datum; 0 (no cover) - 8 (the maximum station count for interpolation)



- v. 4.04 

Column	| Description
--|--
sites.sitename	| Site name
X[YYYY.MM.DD]	| Date 



### Notes:

- Accuracy of CRU data varies across sites:

  - Comparison of available local weather station data (Table 2 in Anderson-Teixeira et al., 2015) to CRU data revealed close correlation for MAT (R2 >94%). However, CRU data tended to systematically underestimate MAP at sites with high MAP, particularly those receiving >3000 mm yr-1 (e.g., Korup, Kuala Belalong, Sinharaja, Fushan, La Planada). Thus, CRU precipitation values for high precipitation sites should be considered probable underestimates.
  
  - CRU data tend to be off for sites in mountainous terrain (e.g., Utah Forest Dynamics Plot). Details can be found [here](https://github.com/forestgeo/Climate/tree/master/Climate_Data/CRU/CRU_corrected).
  
  - CRU precipitation record for Barro Colorado Island is terrible (compared with accurate [long-term record from *El Claro*](https://github.com/forestgeo/Climate/tree/master/Climate_Data/Met_Stations/BCI/El_Claro_precip_starting_1929). Details can be found [here](https://github.com/forestgeo/Climate/tree/master/Climate_Data/CRU/CRU_corrected).

- In the CRU database, data gaps are filled with averages (by month), which would be an issue for some analyses. Details can be found [here](https://github.com/forestgeo/Climate/tree/master/Climate_Data/CRU/scripts/CRU_gaps_analysis)

## CRU_corrected

[CRU_corrected](https://github.com/forestgeo/Climate/tree/master/Climate_Data/CRU/CRU_corrected) contains CRU records that have been corrected based on more accurate local records *for a subset of sites with local records*. We highly recommend that anyone interested in using the CRU data review the [CRU_corrected ReadMe](https://github.com/forestgeo/Climate/blob/master/Climate_Data/CRU/CRU_corrected/ReadMe.md) and, at a minimum, use corrections for sites corrected in the `corrected_conservative` data versions.

## Scripts

[*Scripts*](https://github.com/forestgeo/Climate/tree/master/Climate_Data/CRU/scripts) in this repository include: 
- **[CRU downloading scripts](https://github.com/forestgeo/Climate/tree/master/Climate_Data/CRU/scripts/downloading_CRU_scripts)** - Scripts for extracting data for ForestGEO sties from the CRU database. The script unzips .nc.gz files and outputs .csv
- **[CRU pet_sum calculations](https://github.com/forestgeo/Climate/blob/master/Climate_Data/CRU/scripts/Calculate_PET_sum.R)**  - calculates pet_sum and outputs a .csv
- **[CRU historical climate database visualization tools](https://github.com/forestgeo/Climate/tree/master/Climate_Data/CRU/scripts/CRU_viz_tool)**
   - viz_tool_CRU_single_site.R script to produce plots for CRU variables for a single site
   - viz_tool_CRU_ALL_sites.R script to produce plots for CRU variables for ALL forest geo sites
- **[CRU gaps analysis tool](https://github.com/forestgeo/Climate/tree/master/Climate_Data/CRU/scripts/CRU_gaps_analysis)** - In the CRU database, data gaps are filled with averages (by month). This folder contains 
   - a script to identify average-filled gaps of ≥3 years
   - csv file summarizing these gaps for a subset of ForestGEO sites
- **[monthly_annual_CRUsummaries.R](https://github.com/forestgeo/Climate/blob/master/Climate_Data/CRU/scripts/monthly_annual_CRUsummaries.R)** - Generate monthly and annual summaries for CRU data from 1950 to present for all sites. 
- **[compare&correct.m](https://github.com/forestgeo/Climate/tree/master/Climate_Data/CRU/scripts/compare%26correct)** - Matlab script to create CRU_corrected.

## Data summries
These data summaries draw upon the [original CRU data](https://github.com/forestgeo/Climate/tree/master/Climate_Data/CRU/CRU_v4_04) to create monthly and annual climatic summaries for 1950-2019. They were produced using [this script](https://github.com/forestgeo/Climate/blob/master/Climate_Data/CRU/scripts/monthly_annual_CRUsummaries.R). 

These use the *uncorrected* data; corrected versions will be posted in [CRU_corrected](https://github.com/forestgeo/Climate/tree/master/Climate_Data/CRU/CRU_corrected).


## Data use and attribution
Researchers who wish to use these data are responsible for understanding and evaluating their appropriateness for specific research purposes.  They must cite the original data source (below) and should also cite the ForestGEO Climate Data Portal (essential if using `CRU_corrected`), as per our [data use policy](https://github.com/forestgeo/Climate/blob/master/README.md#data-use-policy).  Researchers using the CRU data product should abide by the latest data use guidelines (available via the [CRU website](https://crudata.uea.ac.uk/cru/data/hrg/)).

Climatic Research Unit, University of East Anglia.  2020.  CRU TSv4, Version 4.04, DOI: [10.1038/s41597-020-0453-3](https://doi.org/10.1038/s41597-020-0453-3)

Harris, I., Osborn, T.J., Jones, P. et al. Version 4 of the CRU TS monthly high-resolution gridded multivariate climate dataset. Sci Data 7, 109 (2020). https://doi-org.smithsonian.idm.oclc.org/10.1038/s41597-020-0453-3


## References

Harris, I., Osborn, T.J., Jones, P. et al. Version 4 of the CRU TS monthly high-resolution gridded multivariate climate dataset. Sci Data 7, 109 (2020). https://doi-org.smithsonian.idm.oclc.org/10.1038/s41597-020-0453-3

Harris I, Jones PD, Osborn TJ, Lister DH (2014) Updated high-resolution grids of monthly climatic observations - the CRU TS3.10 Dataset: UPDATED HIGH-RESOLUTION GRIDS OF MONTHLY CLIMATIC OBSERVATIONS. International Journal of Climatology, 34, 623–642.

Anderson-Teixeira KJ, Davies SJ, Bennett AC et al. (2015) CTFS-ForestGEO: a worldwide network monitoring forests in an era of global change. Global Change Biology, 21, 528–549.

