# Historical Climate Data for CTFS-ForestGEO Sites

**Versions**: 
- v. 3.10 - values from this version are presented in [Anderson-Teixeira et al. (2015)](https://onlinelibrary.wiley.com/doi/abs/10.1111/gcb.12712)
- v. 3.23 - includes annual and climatic summary statistics.
- v. 4.01 - Annual and climatic means were not calculated.
- v. 4.03 - 2018 data latest version, sum pet also calculated

**Temporal coverage**: 1901 - 2016 (ongoing)

**Temporal resolution**: monthly, annual, climatic means 

**Geographic coverage**: global

**Spatial resolution**: 0.5° by 0.5°

**Variables**: All CSV's are prefixed with the following codes:
* `cld`: cloud cover
* `dtr`: diurnal temperate range i.e. temperature amplitude
* `frs`: frost day frequency
* `pet`: potential evapotranspiration
* `pre`: precipitation
* `tmn`: average daily minimal temperatures
* `tmp`: average daily mean temperatures
* `tmx`: average daily maximal temperatures
* `vap`: vapour pressure
* `wet`: wet day frequency
               

## Data set description:
In order to obtain standardized climate data for all sites, global climate data with 0.5 degree spatial resolution were downloaded from the [CRU website](https://crudata.uea.ac.uk/cru/data/hrg/), most recently in August 2018.  

Annual values and climatic means were calculated using Matlab by K. Anderson-Teixeira.

## Notes:

Comparison of available local weather station data (Table 2 in Anderson-Teixeira et al., 2015) to CRU data revealed close correlation for MAT (R2 >94%). However, CRU data tended to systematically underestimate MAP at sites with high MAP, particularly those receiving >3000 mm yr-1 (e.g., Korup, Kuala Belalong, Sinharaja, Fushan, La Planada). Thus, CRU precipitation values for high precipitation sites should be considered probable underestimates.

## Data files and contents.

Described in [`CTFS_ForestGEO_Historical_Climate_Metadata.pdf`](https://github.com/forestgeo/Climate/blob/master/Gridded_Data_Products/Historical%20Climate%20Data/CTFS-ForestGEO_historical_climate_metadata.pdf)

## Data use:

Researchers who wish to use this data product are responsible to understand and evaluate its appropriateness for their research purposes. The CRU data product is described by Harris et al. (2014, 2020).

## References:

Anderson-Teixeira KJ, Davies SJ, Bennett AC et al. (2015) CTFS-ForestGEO: a worldwide network monitoring forests in an era of global change. Global Change Biology, 21, 528–549.

Harris I, Jones PD, Osborn TJ, Lister DH (2014) Updated high-resolution grids of monthly climatic observations - the CRU TS3.10 Dataset: UPDATED HIGH-RESOLUTION GRIDS OF MONTHLY CLIMATIC OBSERVATIONS. International Journal of Climatology, 34, 623–642.

Harris, I., Osborn, T.J., Jones, P. et al. Version 4 of the CRU TS monthly high-resolution gridded multivariate climate dataset. Sci Data 7, 109 (2020). https://doi-org.smithsonian.idm.oclc.org/10.1038/s41597-020-0453-3

University of East Anglia Climatic Research Unit; Jones, P.D.; Harris, I.C. (2008): Climatic Research Unit (CRU) time-series datasets of variations in climate with variations in other phenomena. NCAS British Atmospheric Data Centre, [date of citation]. http://catalogue.ceda.ac.uk/uuid/3f8944800cc48e1cbc29a5ee12d8542d


