######################################################
# Purpose: SPEI data for ForestGEO network
# Developed by: Bianca Gonzalez (data inputs from V.Hermann)
# R version 3.6.2 - First created August 2020
######################################################

# clear environement ####
rm(list = ls())

# load libraries ####
library(dplR)
library(dplyr)
library(stringr)
library(SPEI)
library(tidyverse)
library(tidyr)

# load data ####--------------------------------------------
# could use the all_sites_cores file but some sites are missing from it so just this one! 
ForestGEO_sites <- read.csv("https://raw.githubusercontent.com/forestgeo/Site-Data/master/ForestGEO_site_data.csv")

path_to_climate_data <- "https://raw.githubusercontent.com/forestgeo/Climate/master/Climate_Data/CRU/CRU_v4_04/" # "https://raw.githubusercontent.com/forestgeo/Climate/master/Gridded_Data_Products/Historical%20Climate%20Data/CRU_v4_01/" # 
path_to_climate_data_NM <- "C:/Users/GonzalezB2/Desktop/Smithsonian/ForestGEO_dendro/data/cores/NM/CRU_climate/"
path_to_BCI_pre <- "https://raw.githubusercontent.com/forestgeo/Climate/master/Climate_Data/Met_Stations/BCI/El_Claro_precip_starting_1929/pre_BCI.csv"
path_to_BCI_wet <- "https://raw.githubusercontent.com/forestgeo/Climate/master/Climate_Data/Met_Stations/BCI/El_Claro_precip_starting_1929/wet_BCI.csv"

climate_variables <- c( "pre", "wet",
                        "tmp", "tmn", "tmx", "pet"#,
                        # "dtr", "cld") # "frs", "vap"
)

sites.sitenames <- c(BCI = "Barro_Colorado_Island", 
                     CedarBreaks = "Utah_Forest_Dynamics_Plot",
                     HarvardForest = "Harvard_Forest",
                     LillyDickey = "Lilly_Dickey_Woods",
                     SCBI = "Smithsonian_Conservation_Biology_Institute",
                     ScottyCreek = "Scotty_Creek",
                     Zofin = "Zofin",
                     HKK = "Huai_Kha_Khaeng",
                     NewMexico = "New_Mexico")

clim_var_group <- list(c("pre", "wet"),
                       c("tmp", "tmn", "tmx", "pet")#,
                       # c("dtr", "cld", "pet")
) # see issue 14, PET is in both the TMP and DTR groups. If it comes out as the best in both groups (should always be for the same time frame), then there are only 2 candidate variables for the GLS

clim_gaps <- read.csv("https://raw.githubusercontent.com/forestgeo/Climate/master/Climate_Data/CRU/scripts/CRU_gaps_analysis/all_sites.reps.csv")
clim_gaps <- clim_gaps[clim_gaps$start_climvar.class %in% climate_variables, ]

# prepare data ####
for(clim_v in climate_variables) {
  assign(clim_v, 
         rbind(
           read.csv(paste0(path_to_climate_data, clim_v,  ".1901.2019-ForestGEO_sites-6-03.csv")), #forestGEO sites
           read.csv(paste0(path_to_climate_data_NM, clim_v, ".1901.2019-NM_site-7-10.csv")) # NM site
         ) #https://github.com/EcoClimLab/ForestGEO_dendro/blob/master/data/cores/NM/CRU_climate/pre.1901.2019-NM_site-7-10.csv
  )
  
}

BCI_pre <- read.csv(path_to_BCI_pre, stringsAsFactors = F)
BCI_wet <- read.csv(path_to_BCI_wet, stringsAsFactors = F)


## climate data ####
for(clim_v in climate_variables) {
  print(clim_v)
  x <- get(clim_v)
  
  ### subset for the sites we care about
  
  x <- x[x$sites.sitename %in% sites.sitenames, ]
  
  ### reshape to long format
  x_long <- reshape(x, 
                    times = names(x)[-1], timevar = "Date",
                    varying = list(names(x)[-1]), direction = "long", v.names = clim_v)
  
  ### format date
  x_long$Date <- gsub("X", "", x_long$Date)
  x_long$Date <- as.Date(x_long$Date , format = "%Y.%m.%d")
  
  ### combine all variables in one
  if(clim_v == climate_variables [1]) all_Clim <- x_long[, c(1:3)]
  else all_Clim <- merge(all_Clim, x_long[, c(1:3)], by = c("sites.sitename", "Date"), all = T)
  
}

### replace BCI pre and wet by local data
idx_BCI <- all_Clim$sites.sitename %in% "Barro_Colorado_Island"

all_Clim$pre[idx_BCI] <- BCI_pre$climvar.val[match(format(all_Clim$Date[idx_BCI], "%Y-%m"), format(as.Date(BCI_pre$Date), "%Y-%m"))]
all_Clim$wet[idx_BCI] <- BCI_wet$climvar.val[match(format(all_Clim$Date[idx_BCI], "%Y-%m"), format(as.Date(BCI_wet$Date), "%Y-%m"))]

### remove BCI pre and wet from clim gap as it is not relevant anymore
clim_gaps <- clim_gaps[!(clim_gaps$start_sites.sitename %in% "Barro_Colorado_Island" & clim_gaps$start_climvar.class %in% c("pre", "wet")), ]

# keep only complete rows (this will remove BCI dat for years where we don't have pre data)
all_Clim <- all_Clim[complete.cases(all_Clim), ]

### Calculate the Standardized Precipitation-Evapotranspiration Index (SPEI) ----
clim_prep <- all_Clim %>% 
  select(sites.sitename, Date, pre, pet)

## calculate water balance before SPEI 
clim_prep$bal<-clim_prep$pre - clim_prep$pet

## selecting only relevent fields to convert to wide
clim_prep <- clim_prep %>% 
  select(sites.sitename,Date,bal)

## convert to wide format & calculate for all sites
wide_clim_all <- tidyr::spread(clim_prep, sites.sitename, bal)

# drop BCI so can calculate SPEI for all sites (BCI has NA values and SPEI doesn't accept)
wide_clim<- wide_clim_all %>% select(-Barro_Colorado_Island, -Date)

# Convert to a ts (time series) object --- time series wont have date
ts_sites<- ts(wide_clim, start=c(1901,01), end=c(2019,12), frequency = 12)

### convert SPEI for all sites
spei_sites<- spei(ts_sites, 6) # going to take into account 

spei_df<- data.frame(.preformat.ts(spei_sites$fitted), stringsAsFactors = FALSE)

# original date forma
spei_df$Date<- wide_clim_all$Date

# no need for this
row.names(spei_df)<- NULL

# Extract information from spei object: summary, call function, fitted values, and coefficients
plot(spei_sites)
summary(spei_sites)
names(spei_sites)
spei_sites$call
spei_sites$fitted 
spei_sites$coefficients

write.csv(spei_df, paste0(getwd(), "/spei_sites.csv"), row.names = F)

############ SPEI for BCI  

## filter by single site and apply to single site
clim_prep_bci_date<- clim_prep %>% filter(sites.sitename=="Barro_Colorado_Island") 

## convert to wide
clim_prep_bci_date <- tidyr::spread(clim_prep_bci_date, sites.sitename, bal)

## look at start and end dates (Start is 1929-01-16 and End is 2019-11-16
clim_prep_bci <- clim_prep_bci_date %>% select(-Date)

# Convert to a ts (time series) object --- time series wont have date
ts_BCI<- ts(clim_prep_bci, start=c(1929,1), end=c(2019,11), frequency = 12)

spei_BCI<-spei(ts_BCI,6)
plot(spei_BCI)

spei_BCI_df<- data.frame(spei_BCI$fitted)







