## SPEI  
Standardized Precipitation Evapotranspiration Index 

## Folder Contents
  - [`spei_all_months.csv`](https://github.com/forestgeo/Climate/blob/master/Climate_Data/SPEI/data_calculated_with_script/spei_all_months.csv) contains all of the SPEI values calculated for ForestGEO sites.
  - [`spei_forestGEO.R`](https://github.com/forestgeo/Climate/blob/master/Climate_Data/SPEI/data_calculated_with_script/spei_forestGEO.R) is the script that was used to calculate SPEI for all **{I only see eight}** ForestGEO sites.
  - [`SPEIbase.github.Rproj`](https://github.com/forestgeo/Climate/blob/master/Climate_Data/SPEI/data_calculated_with_script/SPEIbase.github.Rproj) **{I don't know what this is}**

## About the Data
  - Timescales between 1 and 48 months. Each column is a time series of monthly SPEI values starting on January 1901 (exception: BCI's data begins in 1929).  
  
    `NOTE`: An important advantage of the SPEI and the SPI (Standardized Precipitation Index) is that they can be computed at different time scales. This way it is possible to incorporate the influence of the past values of the variable in the computation enabling the index to adapt to the memory of the system under study. The magnitude of this memory is controlled by parameter scale. For example, a value of six would imply that data from the current month and of the past five months will be used for computing the SPEI or SPI value for a given month. By default all past data will have the same weight in computing the index, as it was originally proposed in the references below. Other kernels, however, are available through parameter kernel. The parameter kernel is a list defining the shape of the kernel and a time shift. These parameters are then passed to the function kern.
  
  - Units: standard (Z) scores, i.e. normally distributed values with mean 0 and unit standard deviation. 
  - Missing value: NA. Not a number: nan. 
  
 
## Data Use and Attribution
Researchers who wish to use these data are responsible for understanding and evaluating their appropriateness for specific research purposes.  They must cite the original data source (below) and should also cite the ForestGEO Climate Data Portal, as per our [data use policy](https://github.com/forestgeo/Climate/blob/master/README.md#data-use-policy).
 
  S.M. Vicente-Serrano, S. Beguería, J.I. López-Moreno. 2010. A Multi-scalar drought index sensitive to global warming: The Standardized Precipitation Evapotranspiration Index – SPEI. Journal of Climate 23: 1696, DOI: 10.1175/2009JCLI2909.1.

  Beguería S, Vicente-Serrano SM, Reig F, Latorre B. 2014. Standardized precipitation evapotranspiration index (SPEI) revisited: parameter fitting, evapotranspiration models, tools, datasets and drought monitoring. International Journal of Climatology 34(10): 3001-3023.
