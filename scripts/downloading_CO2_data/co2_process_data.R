######################################################
# Purpose: Download C02 data and fill in from several sources
# Developed by: Bianca Gonzalez
# R version 3.6.1 - First created June 2020
######################################################

# clear environement ####
rm(list = ls())

# load libraries ####
library(dplR)
library(stringr)
library(tidyverse)
library(readxl)

#### load data #### -------
path = "/Other_environmental_data/NOAA_ESRL_C02_data/"

# moana loa data // NOAA ice core data 
moana <-read.csv(paste0(getwd(), path, "ESRL_Mauna_Loa_co2_data.csv")) 
ice_core <- read_excel(paste0(getwd(), path, "NOAA_law2006_ice_core_data.xls"),sheet= "SplineFit20yr") 

#### Process data #### -------
# average the ppm for all twelve values in `year` val for Moana Loa 
avg_ml<- moana %>% group_by(year) %>% summarise_at(vars(value), list(mean))

# grab only useful vals from ml
avg_ml<- avg_ml[-c(1,2),]

# ice_core data - grab vals from 1901 - 1975
core <-ice_core[-c(1,2),]  # drop extranneous info from data
colnames(core)<-core[1,] #rename cols
core<-core[-1,] #drop xtra col

core<-core %>% select('Year AD', 'CO2 Spline (ppm)') # select only interested in vals
core<-sapply(core, as.numeric) %>% as.data.frame()# convert to numeric

core<- dplyr::filter(core, `Year AD` > 1900 & `Year AD` < 1976) # everything above 1974 to combine with ML data
core<-rename(core, value ='CO2 Spline (ppm)', year = 'Year AD') # rename to match ML data

#### Combine Ice Core data and Moana Loa Data #### ------
c02data<- rbind(core, avg_ml) %>% rename(c02_ppm=value)

#### write CSVs make sure you always have argument row.names = FALSE ####
write.csv(c02data, paste0(getwd(), "/Other_environmental_data/c02_MOANA_NOAA_combined.csv"), row.names =F)
