# brickCRU.R

### ### ####
# 24 April 2014
# Amy Bennett
# R Code to use brick function from raster package to extract data from ncdf files
### ### ####
# Decompressing and unzipping files
# Reading in forestGEO site coordinates and creating spatial points dataframe
# Using brick function to extract data at these points

# load relevant packages
#install.packages("R.utils")
install.packages("C:/Users/wangma/Downloads/ncdf4_1.12.zip", repos = NULL) #this package not available from CRAN, so download it from http://cirrus.ucsd.edu/~pierce/ncdf/

library(ncdf4)
library(sp)
library(raster)
#library(base)
#library(R.utils)

# set and check the working directory
setwd('R:/DATA-Permanent Repository/ForestGEO/GlobalData/CRU/Cloud Cover') 
getwd()
list.files()

# load dataset
si <- read.csv("SiteIndicies.csv")
head(si)


###    --- Decompressing and unzipping files ------------------------------------------------------------------------------------

# list files with the .gz extension (should be 10)
#files <- list.files(pattern = "\\.gz$")

# decompress .gz files   
#untar('tmp.gz')

# now gunzup the files ending in .nc.gz to give just .nc
#gunzip('cru_ts3.21.1981.1990.wet.dat.nc.gz')



###    --- Reading in Forest GEo site coordinates and creating spatial points dataframe ---

# points of interest
# read in the CTFS lat/long coordinates from dataset
points <- read.csv('ForestGEOcoordinates.csv')
head(points)
summary(points)
points[,1]
#long and lat
coordinates(points)<-c("Longitude", "Latitude")
#create a spatial points dataframe
proj<-CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")
proj4string(points)<-proj
plot(points)
#make this back to a normal dataframe
as.data.frame(points)



###   --- Using brick function to extract data at these points

r <- brick("cru_ts3.21.1961.1970.cld.dat.nc", varname="cld")
cld.1961.1970 <- extract(r,points,ncol=2)
write.csv(cld.1961.1970, "cld.1961.1970.csv")





