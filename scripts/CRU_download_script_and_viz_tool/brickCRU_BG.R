## last updated: may 18th 2020 bianca gonzalez

#### ### ###
# 18 May 2020
# Amy Bennett, updated in 2015 by Maria Wang and in 2018 by Valentine Herrmann, & in 2020 Bianca Gonzalez
# R Code to use brick function from raster package to extract data from ncdf files
#### ### ###

# Decompressing and unzipping files
# Reading in forestGEO site coordinates and creating spatial points dataframe
# Using brick function to extract data at these points

#The ncdf4 package is not available from CRAN; downloaded from http://cirrus.ucsd.edu/~pierce/ncdf/
#install.packages("R:/Global Maps Data/1. R Code and Instructions/ncdf4_1.12.zip", repos = NULL)
#install.packages("R.utils")

# load relevant packages
library(ncdf4)
library(sp)
library(raster)
library(R.utils)

###    --- Reading in site coordinates and creating spatial points dataframe --- ####

# ForestGeo sites (and their locations) found in github
ForestGEO_sites <- read.csv("https://raw.githubusercontent.com/forestgeo/Site-Data/master/ForestGEO_site_data.csv")

# points of interest
ForestGEO_sites$lat<- ForestGEO_sites$Latitude
ForestGEO_sites$lon<- ForestGEO_sites$Longitude

ForestGEO_sites <- ForestGEO_sites[!is.na(ForestGEO_sites$Lat),]

points <- ForestGEO_sites
head(points)
summary(points)
points[,1]
#long and lat
coordinates(points)<-c("lon", "lat")
#create a spatial points dataframe
proj<-CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")
proj4string(points)<-proj
plot(points)

#make this back to a normal dataframe
as.data.frame(points)

###   --- Set and check the working directory ----------------------------------------------------------- ####

# BG: See instuctions doc to download CRU 
#v4.03 version - 2018 data - updated in 2020 by BG
setwd('S:/Global Maps Data/CRU/v4.03/gzfiles') # replace with your local path name


###    --- Decompressing and unzipping files ------------------------------------------------------------ ####

# list files with the .gz extension (should be 10)
gzfilenames <- list.files(path = 'S:/Global Maps Data/CRU/v4.03/gzfiles', pattern = "\\.nc.gz$") # replace with your local path name


# filename placeholders after below loop unzipping .gz files
ncfilenames <- gsub("\\.nc.gz$", "\\.nc", gzfilenames)
ncfilenames <- gsub("gzfiles", "ncfiles", ncfilenames) # pattern, replacement in ncfilenames


# unzip files using gunzip in package 'R.utils'
# batch gunzip not working - so I've been doing it one file at a time 
# to gunzip 1 file takes ~3 mins

for(i in 1:length(gzfilenames)) { # BG needs to post instructions file on github repo as well 
  
  print(paste("unzipping", gzfilenames[i], "into", ncfilenames[i]))
  gunzip(gzfilenames[i], ncfilenames[i], remove=FALSE)
}

detach("package:R.utils", unload=TRUE)

#lapply(gzfilenames, function(x) { gunzip(x, ncfilenames)}) #need to play around with this more


#### ----Function for Batch Extracting data from multiple .nc files with the same varname --------------####
#### not used for CRU TS 3.23

#   filenames <- paste('ncfiles/',list.files(path = "ncfiles/", pattern = "\\.nc$"),sep='')
#   lapply(filenames, function(x) {
#   r <- brick(x, varname="pet")
#   pet.test <- extract(r,points,ncol=2)
#   write.csv(pet.test, paste(x,"PET","csv",sep="."))})

#   To combine several csv into one dataframe:
#   csvfiles <- paste('ncfiles/', list.files(path = 'ncfiles/', pattern = "\\.csv"), sep='')
#   pet.1901.2014 = do.call("cbind", lapply(csvfiles, function(x) read.csv(x, stringsAsFactors = FALSE)))


##### ---------- brick function to extract data at the coordinate points -----------------------####
# Extract data from a single .nc file 
setwd('S:/Global Maps Data/CRU/v4.03/') # replace with your local path name

for(v in c("cld", "dtr", "frs", "pet", "pre", "tmn", "tmp", "tmn", "tmx", "vap", "wet")) {
  print(paste("extracting", v, "data for ForestGEo sites"))
  r <- brick(paste0("ncfiles/cru_ts4.03.1901.2018.", v, ".dat.nc"), varname = v)   #maybe ~3mins
  
  print("extracting points")
  x <- raster::extract(r, points) #maybe ~15 mins # ncol=2
  head(x)
  x <- cbind(sites.sitename = gsub(" ", "_", points@data$Site), x)
  write.csv(x, file = paste0(v, ".1901.2018-ForestGEO_sites-5-20.csv"), row.names = F)
}

#### Extractintg Individual climate data

# #### ----- PET data ----- ####
# r <- brick("ncfiles/cru_ts3.23.1901.2014.pet.dat.nc", varname="pet")  #maybe ~3mins
# pet.1901.2014 <- extract(r,points,ncol=2) #maybe ~15 mins
# write.csv(pet.1901.2014, "pet.1901.2014-ForestGEO-6-17.csv")
# 
# 
# #### ----- Precip data ----- ####
# # set and check the working directory
# r <- brick("ncfiles/cru_ts3.23.1901.2014.pre.dat.nc", varname="pre")
# pre.1901.2014 <- extract(r,points,ncol=2)
# hist(pre.1901.2014)
# write.csv(pre.1901.2014, "pre.1901.2014-ForestGEO-6-17.csv")
# 
# 
# #### ----- Daily Mean T data ----- ####
# r <- brick("R:/Global Maps Data/CRU/v3.23/ncfiles/cru_ts3.23.1901.2014.tmp.dat.nc", varname="tmp") #takes 1 min
# tmp.1901.2014 <- extract(r,points,ncol=2) #11.52am-11.56am
# write.csv(tmp.1901.2014, "tmp.1901.2014-ForestGEO-6-17.csv")
# 
# 
# #### ----- Min T data ----- ####
# r <- brick("R:/Global Maps Data/CRU/v3.23/ncfiles/cru_ts3.23.1901.2014.tmn.dat.nc", varname="tmn")
# tmn.1901.2014 <- extract(r,points,ncol=2)
# write.csv(tmn.1901.2014, "tmn.1901.2014-ForestGEO-6-17.csv")
# 
# 
# #### ----- Max T data ----- ####
# r <- brick("ncfiles/cru_ts3.23.1901.2014.tmx.dat.nc", varname="tmx")
# tmx.1901.2014 <- extract(r,points,ncol=2)
# write.csv(tmx.1901.2014, "tmx.1901.2014-ForestGEO-6-17.csv")



######## ---------------- Average of monthly temps across all years ------------------ ####
# library(dplyr)
# library(tidyr)
# 
# dpet <- read.csv("pet.1901.2016-ForestGEO_sites-8-18.csv")
# names(dpet)
# 
# #Transposing dataframe
# dpet2 <- dpet %>% gather(key = date, value = dailypet, X1901.01.16:X2016.12.16) 
# 
# #Separating date in one column into three to isolate out the months
# dpet3 <- dpet2 %>% separate(date, c("YYYY", "MM", "DD"), sep = "[.]")
# str(dpet3)
# dpet3$MM <- as.numeric(dpet3$MM)
# 
# dpet4 <- dpet3 %>% group_by(sites.sitename, MM) %>% summarize(meanPET = mean(dailypet))
# 
# dpet5 <- dpet4 %>% spread(MM, meanPET) #mean PET by month
# dpet5$coldestmonthT <- apply(dpet5[ , 2:13], 1, min)
# dpet5$warmestmonthT <- apply(dpet5[ , 2:13], 1, max)
# 
# write.csv(dpet5, "ForestGEO-CRU-monthlypet.csv")
