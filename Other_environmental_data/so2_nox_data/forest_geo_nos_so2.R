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

#create a spatial points dataframe
proj<-CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")
proj4string(points)<-proj

# list files with the .nc extension
ncfilenames <- list.files(path = paste0('C:/Users/GonzalezB2/Desktop/Smithsonian/CEDS/intermediate-output/gridded-emissions/SO2'), pattern = "\\.nc") # replace with your local path name

setwd("C:/Users/GonzalezB2/Desktop/Smithsonian/CEDS/intermediate-output/gridded-emissions/SO2")

# ncfilenames will have to change
#tt<-brick(paste0(getwd(),"/", ncfilenames[1]),)
vars<- c("AGR", "ENE", "IND", "TRA", "SLV", "WST", "SHP", "RCO")
# for all of these varnames for that year make a df and bind to the other year (if not all 0 values)
testy<- raster(paste0(getwd(),"/", ncfilenames[1]), varname="RCO")
t<- raster::extract(testy, points)

for(file in ncfilenames){
    print(file)

    ## extract emission values from raster object at forestgeo points
    #r <- brick(paste0(getwd(),"/", file))  # create a raster brick object from .nc file
    r<- raster(paste0(getwd(),"/", file), varname="RCO")
    x <- raster::extract(r,points) # extract values from raster-brick at pts

    ### add relevent columns
    x <- cbind(sites.sitename = gsub(" ", "_", points@data$Site.name), x) # add sites.sitename
    x <- cbind(emission_source = rep(r@title, nrow(x)), x)
    x <- cbind(emission_units = rep(r@data@unit, nrow(x)), x)
    x <- cbind(emission_type = rep(stringr::str_sub(file, start=6, end=8), nrow(x)),x)
   # x <- cbind(points,x) # grab the lat longs and rest of file info if wanted
   # x <- cbind(year = rep(as.integer(stringr::str_sub(gsub("X","", r@data@names[1]), start=1, end=4)), nrow(x)),x)

    if(file[1]==ncfilenames[1]){
        all_DEP <- x

    }

    else {
        print("merging years")
        all_DEP <- merge(all_DEP, x, by = c("sites.sitename", "emission_source", "emission_type", "emission_units"), all = T)
    }
}

ncfilenames_so2 <- list.files(path = paste0('C:/Users/GonzalezB2/Desktop/Smithsonian/CEDS/intermediate-output/gridded-emissions/SO2'), pattern = "\\.nc") # replace with your local path name
test <- list.files(path = paste0('C:/Users/GonzalezB2/Desktop/Smithsonian/CEDS/intermediate-output/gridded-emissions/test'), pattern = "\\.nc") # replace with your local path name
setwd("C:/Users/GonzalezB2/Desktop/Smithsonian/CEDS/intermediate-output/gridded-emissions/")

emission_calc <- function(spa_file){  # the arguement is going to be the filenames(nc)
counter=0
for(file in spa_file){
counter= counter+1
   r <- brick(paste0(getwd(),"/",stringr::str_sub(file[1], start=6, end=8),"/", file))  # create a raster brick object from .nc file
   print(file)
   x <- raster::extract(r,points) # extract raster-brick at pts

   ### add relevent columns
   x <- cbind(sites.sitename = gsub(" ", "_", points@data$Site.name), x) # add sites.sitename
   x <- cbind(emission_source = rep(r@title, nrow(x)), x)
   x <- cbind(emission_units = rep(r@data@unit, nrow(x)), x)
   x <- cbind(emission_type = rep(stringr::str_sub(file, start=6, end=8), nrow(x)),x)
   # x <- cbind(year = rep(as.integer(stringr::str_sub(gsub("X","", r@data@names[1]), start=1, end=4)), nrow(x)),x)

   if(file[1]==ncfilenames[1]){
       print("first df")
       all_DEP <- x
   }

   else {
       print(paste0("merging years",counter ))
       all_DEP <- merge(all_DEP, x, by = c("sites.sitename", "emission_source", "emission_type", "emission_units"), all = T)
        }
    }
# here make sure we write the relevant
print("out of forloop and writing the emissions file")
write.csv(all_DEP,paste0(getwd(), "/","emissions_",stringr::str_sub(file[1], start=6, end=8), ".csv"))
}

filter_all(all_DEP, any_vars(. != 0)) %>% View()
