#Tropical Rainfall Measuring Mission (TRMM) precipitation data for CTFS-ForestGEO Sites.

**Temporal coverage**: 1998-01 to 2014-12 

**Geographic coverage**: 50 to -50 degrees latitude

**Temporal resolution**: Monthly and annual


##Data set description:

Standardized precipitation data is presented for 63 CTFS-ForestGEO tropical, subtropical, and temperate sites. The Tropical Rainfall Measuring Mission (TRMM) by NASA was launched in 1997 and carried 5 instruments: a 3-sensor rainfall suite (PR, TMI, VIRS) and 2 related instruments (LIS and CERES). Specific information on sensors and data generation can be accessed here http://trmm.gsfc.nasa.gov. For a summary of TRMM data products and services, see Liu et al. (2012).

Data presented here are from the “Algorithm 3B43”, which gives the best-estimate precipitation rate and root-mean-square (RMS) precipitation-error estimates from TRMM. The gridded estimates are on a calendar month temporal resolution and a 0.25° by 0.25° spatial resolution. Spatial coverage extends from 50 degrees south to 50 degrees north latitude, therefore some CTFS-ForestGEO sites have no data. Algorithm 3B43 is executed once per calendar month to produce the single, best-estimate precipitation rate and RMS precipitation-error estimate field (3B43) by combining the 3-hourly merged high-quality/IR estimates with the monthly accumulated Global Precipitation Climatology Centre (GPCC) rain gauge analysis.

Monthly precipitation data were downloaded on October 21, 2015. Data was retrieve from the Mirador interface (http://mirador.gsfc.nasa.gov) from NASA Goddard Earth Sciences Data and Information Services Center (GES DISC). Version 7 was downloaded as recommended. Units were converted from mm hr-1 to mm mo-1 by multiplying by the number of hours in each month, and annual precipitation was computed by summing months. 

##Notes:

Comparison of TRMM data to local weather station data for CTFS-ForestGEO sites (Table 2 in Anderson-Teixeira et al., 2015) showed that TRMM data tended to systematically underestimate MAP at sites with high MAP, particularly those receiving >3000 mm yr-1. Thus, TRMM precipitation values for high precipitation sites should be considered probable underestimates.

##Data files:

'CTFS-ForestGEO_TRMM.3B43_daily.csv'

'CTFS-ForestGEO_TRMM.3B43_monthly.csv'

'CTFS-ForestGEO_TRMM.3B43_annual.csv'

##Data file contents:
Described in 'CTFS_ForestGEO_TRMM_Metadata.pdf'

##Data use:

Researchers who wish to use this data product are responsible to understand and evaluate its appropriateness for their research purposes. Information on the TRMM data product is summarized in (Liu et al., 2012) and at http://trmm.gsfc.nasa.gov.

These data are freely available for scientific research purposes, as a service of the CTFS-ForestGEO Ecosystems & Climate Initiative. Publications using these data should cite Liu et al. (2012) and cite this CTFS-ForestGEO data product. 


##References:

Anderson-Teixeira KJ, Davies SJ, Bennett AC et al. (2015) CTFS-ForestGEO: a worldwide network monitoring forests in an era of global change. Global Change Biology, 21, 528–549.

Harris I, Jones PD, Osborn TJ, Lister DH (2014) Updated high-resolution grids of monthly climatic observations - the CRU TS3.10 Dataset: UPDATED HIGH-RESOLUTION GRIDS OF MONTHLY CLIMATIC OBSERVATIONS. International Journal of Climatology, 34, 623–642.

Hijmans RJ, Cameron SE, Parra JL, Jones PG, Jarvis A (2005) Very high resolution interpolated climate surfaces for global land areas. International Journal of Climatology, 25, 1965–1978.

Liu Z, Ostrenga D, Teng W, Kempler S (2012) Tropical Rainfall Measuring Mission (TRMM) Precipitation Data and Services for Research and Applications. Bulletin of the American Meteorological Society, 93, 1317–1325.


