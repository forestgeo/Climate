# ------------------------------------------------------------------------------
#Reading gridded data and extracting data points
# load relevant packages
library(ncdf4)
library(sp)
library(raster)
library(R.utils)
library(rgdal)
library(raster)
library(tidyverse)
###    --- Reading in site coordinates --- ####

# ForestGeo sites (and their locations) found in github
ForestGEO_sites <- read.csv("https://raw.githubusercontent.com/forestgeo/Site-Data/master/ForestGEO_site_data.csv")

# points of interest
ForestGEO_sites$lat<- ForestGEO_sites$Latitude
ForestGEO_sites$lon<- ForestGEO_sites$Longitude

ForestGEO_sites <- ForestGEO_sites[!is.na(ForestGEO_sites$Lat),]
points <- ForestGEO_sites
coordinates(points)<-c("lon", "lat") #long and lat

# create a spatial points dataframe
proj<-CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")
proj4string(points)<-proj

#### list files with the .nc extension
### Make sure the change this file extension if loooking at another folder

## SO2
ncfilenames <- list.files(path = paste0('C:/Users/GonzalezB2/Desktop/Smithsonian/CEDS/intermediate-output/gridded-emissions/SO2'), pattern = "\\.nc")

## NOX
ncfilenames <- list.files(path = paste0('C:/Users/GonzalezB2/Desktop/Smithsonian/CEDS/intermediate-output/gridded-emissions/NOx'), pattern = "\\.nc")

### Change this too to reflect the dir we're interested in
setwd("C:/Users/GonzalezB2/Desktop/Smithsonian/CEDS/intermediate-output/gridded-emissions/SO2")

### R hack-- function converting factor to to numeric
funny <- function(poopy){
    as.numeric(as.character(poopy))
}

# emissions sectors
vars<- c("AGR", "ENE", "IND", "TRA", "SLV", "WST", "SHP", "RCO")
# for all of these varnames for that year make a df and bind to the other year (if not all 0 values)

for(file in ncfilenames) {
    print(file)
    for(v in vars) {
        print(paste0("working on var ", v))
        ## extract emission values from raster object at forestgeo points
        r<-brick(paste0(getwd(),"/", file),varname=v)  # use brick to create a raster obj and NOT raster because extracts all yrs info
        x<- raster::extract(r, points)

        ### add relevent columns
        x <- cbind(sites.sitename = gsub(" ", "_", points@data$Site.name), x) # add sites.sitename
        x <- cbind(emission_source = rep(r@title, nrow(x)), x)
        x <- cbind(emission_units = rep(r@data@unit, nrow(x)), x)
        x <- cbind(emission_type = rep(stringr::str_sub(file, start=6, end=8), nrow(x)),x)

        ### R hack to grab RowSums
        x<-as.data.frame(x)
        x[,5:16]<- sapply(x[,5:16], funny) # converting to numeric using R hack function
        x$year_sum<- rowSums(x[,5:16]) #base package sums for rows
        names(x)[names(x) == "year_sum"] <- paste0(substr(r@z$Date[1], 1,4)) # rename year_sum column to yr

        # delete all `X`` columns
        x <- x[,grepl("X", colnames(x))==FALSE]

        ### Add to master dataset & merge
        if(file[1]==ncfilenames[1] & v[1]==vars[1]){ # if first file and var
            all_DEP <- x
        }
        else{

            all_DEP <- merge(all_DEP, x,by =  , all = T) # merge by everything except for the year value -
        }
    }
}

### Change to Tidy format // gather values //filter extra NAs from merge process

DEP_clean <-  pivot_longer(all_DEP,cols= starts_with(c("1", "2")), # 1700s-2000s
                        names_to= "year",values_to = "value") %>%
                        filter(!is.na(value))

### Group and sum deposition values
DEP_clean$year<- str_sub(DEP_clean$year, 1,4) # clean year value to group later
DEP_clean<- DEP_clean %>% group_by(year, sites.sitename, emission_units, emission_type) %>%
                         summarise(value = sum(value))# sum across all industries

### Okay great! now let's CSV this puppy
write.csv(DEP_clean, "C:/Users/GonzalezB2/Desktop/Smithsonian/Climate/Other_environmental_data/so2_emissions_wout_2000s.csv", row.names=FALSE)
