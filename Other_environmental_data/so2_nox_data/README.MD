# SO<sub>2</sub> & NO<sub>x</sub> Emissions Data

## Data
The Community Emissions Data System (CEDS) produces consistent estimates of global air emissions species over the industrial era (1750 - present). The system is written in R and uses open-source data (with the exception of the IEA energy statistics which must be purchased from IEA). CEDS is publicly available through an [Open Source License](https://github.com/JGCRI/CEDS/#license-section).

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
The following steps will allow data users to create the most up-to-date version of the data, as new data become available and as additional plots join the ForestGEO network: 

1.  Download the following files from [Zenodo](https://zenodo.org/record/3606753#.X2kAxWhKjIU), unzip, select relevant files) and store them.  
    [`CEDS_NOx_emissions_by_country_CEDS_sector_v_2019_12_23.csv`]  
    [`CEDS_SO2_emissions_by_country_CEDS_sector_v_2019_12_23.csv`]  

2.  Edit and debug Module G.G1 script to generate NC files from the above files. Store these files in the intermediate output of CEDS directory.
    Edits and bugs found in G1 scipt:  
    
        a.  Change relevent atmospheric metric: line 39 in module G script to "if ( is.na( em ) ) em <- "NOx" # change to nox or s02"  
        b.  module G bug identified (CEDS team is now fixing)  
        c.  add ", meta = FALSE ) to all readData() functions"  
        
3.  Run the [`G1.1.grid_bulk_emissions.R`](https://github.com/forestgeo/Climate/blob/master/Other_environmental_data/so2_nox_data/G1.1.grid_bulk_emissions.R) script.

4.  Run the [`forest_geo_nos_so2.R` script](https://github.com/forestgeo/Climate/blob/master/Other_environmental_data/so2_nox_data/forest_geo_nos_so2.R) to isolate historic levels of SO<sub>2</sub> and NO<sub>x</sub> at 69 of ForestGEO's research location from CEDS's global data set.  

[`forest_geo_nos_so2.R` script](https://github.com/forestgeo/Climate/blob/master/Other_environmental_data/so2_nox_data/forest_geo_nos_so2.R): Developed by: Bianca Gonzalez | R version 3.6.1 - First created August 2020

Helpful Resources:  
    - wiki instructions on running gridding https://github.com/JGCRI/CEDS/wiki/User_Guide#use-instructions  
    - download the gridding proxies here https://zenodo.org/record/3606753#.X1kTUmdTk6U

<i>Special thanks to [Steve Smith](https://github.com/ssmithClimate) for guidance in editing and using the G1.1.grid_bulk_emissions.R script</i>

## Data Use & Attribution
Researchers who wish to use these data are responsible for understanding and evaluating their appropriateness for specific research purposes.  They must cite the original data source (below) and should also cite the ForestGEO Climate Data Portal, as per our [data use policy](https://github.com/forestgeo/Climate/blob/master/README.md#data-use-policy).

<b>CEDS Data Set:</b>  
Hoesly, Rachel M., O'Rourke, Patrick R, Smith, Steven J., Feng, Leyang, Klimont, Zbigniew, Janssens-Maenhout, Greet, … Muwan, Presley. (2020). CEDS v_2019_12_23 Emission Data (Version v_2019_12_23) [Data set]. [Zenodo](http://doi.org/10.5281/zenodo.3606753).
