# Corrected CRU records

This folder contains CRU records that have been corrected (using [this script](https://github.com/forestgeo/Climate/blob/master/Climate_Data/CRU/scripts/compare%26correct/compare_correct.m)) based on more accurate local records.

## Data sets used for correction:
- **PRISM records of T_max, T_mean, T_min, and PPT for sites within the continental US**. Spatial resolution is 800 m, time period is 1930-2015. Data are available [here, in a private repository](https://github.com/forestgeo/Climate_private/tree/master/PRISM%20data) because they were purchased and cannot be posted publicly, but contact us for access. 
- **["El Claro" weather station precipitation records for Barro Colorado Island, Panama](https://github.com/forestgeo/Climate/tree/master/Climate_Data/Met_Stations/BCI/El_Claro_precip_starting_1929)**. These extend back to 1929.  

## Summary of methods:
- CRU data were combined with the alternate source on a monthly basis. We used linear regression to characterize the relationship between the CRU and alternative sources. We then used this relationship to correct CRU data outside the time frame of the alternative source. CRU records were replaced with alternative records over the time frame for which they were available.
- Corrections were applied either to all sites (`_all` file names) or only to those where there was a substantial difference between CRU and the alternative source (`_conservative` file names). "Conservative" corrections were applied if (1) a paired t-test revealed a significant difference between CRU and the alternative source, and (2) the absolute value of the mean monthly difference between CRU and the alternative source exceeded 2.5 °C (temperature variables) or 20 mm per month (precipitation). 
- For sites whose local records deviated substantially from CRU (according to the criteria above), we removed records of related climate variables in corrected file versions (`_conservative` file names). Specifically, if one or more temperature variables differed substantially from CRU, we distrusted and removed CRU values for PET, DTR, and FRS. If precipitation differed substantially from CRU, we we distrusted and removed CRU values for WET. 

## Description of files in this repo:
- [`corrections_report.csv`](https://github.com/forestgeo/Climate/blob/master/Climate_Data/CRU/CRU_corrected/corrections_report.csv) lists the sites and climate variables analyzed, whether they are corrected in `_conservative` files, and statistics on the difference between CRU and the alternative source.
- `[climate variable]_CRU_corrected_all.csv` and `[climate variable]_CRU_corrected_conservative.csv` files contain corrected data records for all variables analyzed and those with substantial differences (see **Summary of methods**, above), respectively. They follow the CRU data format, as described [here](https://github.com/forestgeo/Climate/tree/master/Climate_Data/CRU).
- [Figures](https://github.com/forestgeo/Climate/tree/master/Climate_Data/CRU/CRU_corrected/figures) show monthly values of corrected and uncorrected records for each site. File naming convention is `[climate variable] -[site]-[figure type].png`, where `figure type` is `-ts` for the time series and `-corr` for correlations.

## Guidance on use
- The version with all values corrected will generally be the more accurate, as we consider the alternative data sources used here to be more locally accurate than CRU. 
- The conservative correction will be appropriate in cases where it is desirable to use CRU climate variables (e.g., PET, CLD...) for which alternative sources suitable for correction are not available. 

**(README IS NOT YET COMPLETE. MORE TO COME)**
