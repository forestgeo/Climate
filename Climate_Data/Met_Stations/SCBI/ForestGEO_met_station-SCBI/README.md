# ForestGEO Weather Station @ SCBI

**Temporal coverage**: 09/01/2009 - present 

**Temporal resolution**: 5 min

**Location**: clearing area adjacent to ForestGEO plot, within the elevation range of the plot

**Variables**: Solar (shortwave) radiation, Precipitation, Wind speed & direction (2D), Air Temperature, Relative humidity 

## Data set description:
In 2009 ForestGEO started its own meteorological program. Four standardized stations were built in collaboration with Bill Munger (Harvard University) and installed near four ForestGEO plots: SCBI, KHC, HKK and BCI. The ForestGEO stations comprise several sensors recorded automatically by a CR1000 datalogger (Campbell Scientific) at 5 min time interval. These sensors include:
1)	Aspirated and shield temperature and relative humidity sensor plus an additional secondary temperature sensor (MetOne Instruments)
2)	 2-D sonic anemometer WS425 (Vaisala)
3)	Tipping rain bucket TB4-L (Campbell Scientific)
4)	Solar radiometer CMP11 (Kipp&Zonen), plus a secondary radiometer LI-290 (LiCOR biogeoscience)

## Data files and contents:
Data files: Each year is formatted with this nomenclature: `SCB_Metdata_5min_[YEAR].csv`. You can find data [in this folder](https://github.com/forestgeo/Climate/tree/master/Climate_Data/Met_Stations/SCBI/ForestGEO_met_station-SCBI/Data).

Metadata: [METADATA.pdf](https://github.com/forestgeo/Climate/tree/master/Climate_Data/Met_Stations/SCBI/ForestGEO_met_station-SCBI/Metadata)

Data collection: These files are used internally to collect data in the field. Currently (as 2019) using [this method](https://github.com/forestgeo/Climate/tree/master/Climate_Data/Met_Stations/SCBI/ForestGEO_met_station-SCBI/Data%20collection).

Processing: To [visualize](https://github.com/forestgeo/Climate/tree/master/Climate_Data/Met_Stations/SCBI/ForestGEO_met_station-SCBI/plots) and to find anomalies in the datasets (per year) you can build plots using this [R script](https://github.com/forestgeo/Climate/blob/master/Climate_Data/Met_Stations/scripts/plotting_ForestGEO_weather_data/format_met_tower_data_graphs.R). Please add notes [to this file](https://github.com/forestgeo/Climate/blob/master/Climate_Data/Met_Stations/SCBI/ForestGEO_met_station-SCBI/data_anomalies.md) if any abnormality is found.

## Data use:

The data are freely available to the ForestGEO community for research and educational (non-commercial) purposes.

Research using the data should acknowledge the ForestGEO meteorological monitoring program and funding from the Smithsonian Institution's ForestGEO program.

## Data contacts:

Kristina Anderson-Teixeira

Erika Gonzalez-Akre

Matteo Detto
