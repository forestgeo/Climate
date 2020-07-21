# WorldClim BioClimatic Data for ForestGEO Sites

**Temporal coverage**: 1960 - 1990 

**Temporal resolution**: 30 years (climatic average)

**Geographic coverage**: global

**Spatial resolution**: 30 seconds

**Variables**: 19 bioclimatic variables: http://www.worldclim.org/bioclim

## Data set description
For all ForestGEO sites (current as of Jan. 2017), we extracted 19 bioclimatic variables from WorldClim v. 1.4 (Hijmans et al., 2005), downloaded November 2013 from http://www.worldclim.org/.

For 59 ForestGEO sites (current as of fall 2013), projected future climate data were extracted from WorldClim data downloaded in November 2013. Future projections are based on predictions of the HadGEM2-ES model as part of the CMIP5 (IPPC Fifth Assessment) for the year 2050 (2041-2060 climatic average) under the lowest and highest emissions scenarios (RCP 2.6 and RCP 8.5, respectively). These data have been downscaled and calibrated using WorldClim’s current climate (v. 1.4) as a baseline, which makes it appropriate to compare current and future climate data from these sources (e.g., Fig. 2 in Anderson-Teixeira et al., 2015).

## Notes

These data are an updated version of those presented in Anderson-Teixeira et al. (2015), which used the same WorldClim version (1.4) but included fewer ForestGEO sites.

Comparison of available local weather station data (Table 2 in Anderson-Teixeira et al., 2014) to WorldClim data revealed close correlation for MAT (R2 >97%). However, WorldClim data tended to systematically underestimate MAP at sites with high MAP, particularly those receiving >3000 mm yr-1 (e.g., Korup, Kuala Belalong, Sinharaja, Fushan, La Planada). Thus, WorldClim precipitation values for high precipitation sites should be considered probable underestimates.

## Data files
•	`CTFS-ForestGEO_WorldClim.csv`: Recent climate (1960-1990)

•	`CTFS-ForestGEO_HADGEM2_RCP26.csv`: year 2050 climate projections under lowest emissions scenario considered in IPCC5 (RCP 2.6)

•	`CTFS-ForestGEO_HADGEM2_RCP85.csv`: year 2050 climate projections under highest emissions scenario considered in IPCC5 (RCP 8.5)

## Data file contents
Described in `CTFS_ForestGEO_WorldClim_Metadata.pdf`

## Data use and attribution:

Researchers who wish to use this data product are responsible to understand and evaluate its appropriateness for their research purposes. The WorldClim data product is described at http://www.worldclim.org/ and in Hijmans, et al. (2005). Publications using these data should cite Anderson-Teixeira, et al. (2015) and Hijmans, et al. (2005):

Anderson-Teixeira KJ, Davies SJ, Bennett AC, et al. (2015) CTFS-ForestGEO: a worldwide network monitoring forests in an era of global change. *Global Change Biology*, 21(2), 528–549.  https://doi.org/10.1111/gcb.12712

Hijmans RJ, Cameron SE, Parra JL, Jones PG, and Jarvis A. (2005) Very high resolution interpolated climate surfaces for global land areas. *International Journal of Climatology*, 25(15), 1965–1978.  https://doi.org/10.1002/joc.1276

Please also refer to the ForestGEO Climate Date Portal's [data use policy](https://github.com/forestgeo/Climate/blob/master/README.md#data-use-policy) re: citation of the curated data set.
