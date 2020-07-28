# Tropical Rainfall Measuring Mission (TRMM) precipitation data for ForestGEO Sites

**Temporal coverage**: 1998-01 to 2014-12 

**Temporal resolution**: Monthly, annual

**Geographic coverage**: 50 to -50 degrees latitude

**Spatial resolution**: 0.25° by 0.25°




## Data set description:

The Tropical Rainfall Measuring Mission (TRMM) by NASA was launched in 1997 and carried 5 instruments: a 3-sensor rainfall suite (PR, TMI, VIRS) and 2 related instruments (LIS and CERES). Specific information on sensors and data generation can be accessed [here](http://trmm.gsfc.nasa.gov). For a summary of TRMM data products and services, see Liu et al. (2012).

Data presented here are from the “Algorithm 3B43”, which gives the best-estimate precipitation rate and root-mean-square (RMS) precipitation-error estimates from TRMM.  Algorithm 3B43 is executed once per calendar month to produce the single, best-estimate precipitation rate and RMS precipitation-error estimate field (3B43) by combining the 3-hourly merged high-quality/IR estimates with the monthly accumulated Global Precipitation Climatology Centre (GPCC) rain gauge analysis.

Monthly precipitation data were downloaded on October 21, 2015 for 63 ForestGEO tropical, subtropical, and temperate sites (-50 to 50 degrees latitude). Data was retrieved from the [Mirador interface](http://mirador.gsfc.nasa.gov) from NASA Goddard Earth Sciences Data and Information Services Center (GES DISC). Version 7 was downloaded. Units were converted from mm hr-1 to mm mo-1 by multiplying by the number of hours in each month, and annual precipitation was computed by summing months. 

## Notes:

Comparison of TRMM data to local weather station data for ForestGEO sites (Table 2 in Anderson-Teixeira et al., 2015) showed that TRMM data tended to systematically underestimate MAP at sites with high MAP, particularly those receiving >3000 mm yr-1. Thus, TRMM precipitation values for high precipitation sites should be considered probable underestimates.

## Data files:

[`CTFS-ForestGEO_TRMM.3B43_monthly.csv`](https://github.com/forestgeo/Climate/blob/master/Climate_Data/TRMM/CTFS-ForestGEO_TRMM.3B43_monthly.csv)

[`CTFS-ForestGEO_TRMM.3B43_annual.csv`](https://github.com/forestgeo/Climate/blob/master/Climate_Data/TRMM/CTFS-ForestGEO_TRMM.3B43_annual.csv)

## Data file contents:
Described in [`CTFS_ForestGEO_TRMM_Metadata.pdf`](https://github.com/forestgeo/Climate/blob/master/Climate_Data/TRMM/CTFS_ForestGEO_TRMM_Metadata.pdf)

## Data use and attribution:
Researchers who wish to use these data are responsible for understanding and evaluating their appropriateness for specific research purposes.  They must cite the original data source (below) and should also cite the ForestGEO Climate Data Portal, as per our [data use policy](https://github.com/forestgeo/Climate/blob/master/README.md#data-use-policy).  Information on the TRMM data product is summarized in (Liu et al., 2012) and at http://trmm.gsfc.nasa.gov.

Liu Z, Ostrenga D, Teng W, Kempler S (2012) Tropical Rainfall Measuring Mission (TRMM) Precipitation Data and Services for Research and Applications. Bulletin of the American Meteorological Society, 93, 1317–1325. http://journals.ametsoc.org/doi/abs/10.1175/BAMS-D-11-00152.1


## References:

Anderson-Teixeira KJ, Davies SJ, Bennett AC et al. (2015) CTFS-ForestGEO: a worldwide network monitoring forests in an era of global change. Global Change Biology, 21, 528–549.

Liu Z, Ostrenga D, Teng W, Kempler S (2012) Tropical Rainfall Measuring Mission (TRMM) Precipitation Data and Services for Research and Applications. Bulletin of the American Meteorological Society, 93, 1317–1325. http://journals.ametsoc.org/doi/abs/10.1175/BAMS-D-11-00152.1


