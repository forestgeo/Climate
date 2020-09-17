# SO<sub>2</sub> & NO<sub>x</sub>

## Data
- <b>SO<sub>2</sub> Emissions:</b>[`so2_emissions.csv`](https://github.com/forestgeo/Climate/blob/master/Other_environmental_data/so2_nox_data/so2_emissions.csv)
    - date range: 1750-2014
    -   increment: annual
    -   locations: 69 ForestGEO plots
    -   original source: Community Emissions Data System (CEDS)
    
 - <b>NO<sub>x</sub> Emissions: </b>[`nox_emissions.csv`](https://github.com/forestgeo/Climate/blob/master/Other_environmental_data/so2_nox_data/nox_emissions.csv)
    - date range: 1750-2014
    -   increment: annual
    -   locations: 69 ForestGEO plots
    -   original source: Community Emissions Data System (CEDS)

## Script 
This [script](https://github.com/forestgeo/Climate/blob/master/Other_environmental_data/so2_nox_data/forest_geo_nos_so2.R) isolates historic levels of SO<sub>2</sub> and NO<sub>x</sub> at 69 of ForestGEO's research location from CEDS's global data set.  Data users can use this script to to create the most up-to-date version of the data set as new data become available, and as additional plots join the ForestGEO network.   

Developed by: Bianca Gonzalez

R version 3.6.1 - First created August 2020

<i>Special thanks to [Steve Smith](https://github.com/ssmithClimate) for guidance in editing and using the G1.1.grid_bulk_emissions.R script</i>

## Data Use & Attribution
Researchers who wish to use these data are responsible for understanding and evaluating their appropriateness for specific research purposes.  They must cite the original data source (below) and should also cite the ForestGEO Climate Data Portal, as per our [data use policy](https://github.com/forestgeo/Climate/blob/master/README.md#data-use-policy).

<b>CEDS Data Set:</b>  
Hoesly, Rachel M., O'Rourke, Patrick R, Smith, Steven J., Feng, Leyang, Klimont, Zbigniew, Janssens-Maenhout, Greet, … Muwan, Presley. (2020). CEDS v_2019_12_23 Emission Data (Version v_2019_12_23) [Data set]. [Zenodo](http://doi.org/10.5281/zenodo.3606753).

