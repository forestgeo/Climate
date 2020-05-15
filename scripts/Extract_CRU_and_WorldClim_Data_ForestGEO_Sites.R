library(raster)

ForestGEO_sites <- read.csv("ForestGEO_sites_coordinates/ForestGEO_master.csv")

names(ForestGEO_sites) <- c("ID", "sites.sitename", "lat", "lon")


# add Jim's sites:
# ForestGEO_sites <- rbind(ForestGEO_sites, data.frame(sites.sitename = c("Utah_Forest_Dynamics_Plot", "Michigan_Big_Woods_(E.S._George_Reserve)", "UMBC-University_of_Maryland, Baltimore", "Ngel_Nyaki", "Baishanzu", "Daxinganling", "Fenglin", "Liangshui", "Ailaoshan"), lat = c(37.660268, 42.4667, 39.2549, 7.068, 27.761, 51.8167, NA, NA, NA), lon = c(-112.854393, -84, -76.7081, 11.0566, 119.198, 122.998, NA, NA, NA)))

ForestGEO_sites <- ForestGEO_sites[!is.na(ForestGEO_sites$lat),]

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



# CRU ####

# cld
r <- brick("CRU/v3.23/ncfiles/cru_ts3.23.1901.2014.cld.dat.nc", varname="cld")
cld.1901.2014 <- raster::extract(r, points)

# drt
r <- brick("CRU/v3.23/ncfiles/cru_ts3.23.1901.2014.dtr.dat.nc", varname="dtr")
drt.1901.2014 <- raster::extract(r, points)

# frs
r <- brick("CRU/v3.23/ncfiles/cru_ts3.23.1901.2014.frs.dat.nc", varname="frs")
frs.1901.2014 <- raster::extract(r, points)

# pet
r <- brick("CRU/v3.23/ncfiles/cru_ts3.23.1901.2014.pet.dat.nc", varname="pet")
pet.1901.2014 <- raster::extract(r, points)

# pre
r <- brick("CRU/v3.23/ncfiles/cru_ts3.23.1901.2014.pre.dat.nc", varname="pre")
pre.1901.2014 <- raster::extract(r, points)

# rhm
# r <- brick("CRU/v3.23/ncfiles/", varname="cld")


# ssh
# r <- brick("CRU/v3.23/ncfiles/", varname="cld")

# tmp
r <- brick("CRU/v3.23/ncfiles/cru_ts3.23.1901.2014.tmp.dat.nc", varname="tmp")
tmp.1901.2014 <- raster::extract(r, points)

# tmn
r <- brick("CRU/v3.23/ncfiles/cru_ts3.23.1901.2014.tmn.dat.nc", varname="tmn")
tmn.1901.2014 <- raster::extract(r, points)

# tmx
r <- brick("CRU/v3.23/ncfiles/cru_ts3.23.1901.2014.tmx.dat.nc", varname="tmx")
tmx.1901.2014 <- raster::extract(r, points)

# vap
r <- brick("CRU/v3.23/ncfiles/cru_ts3.23.1901.2014.vap.dat.nc", varname="vap")
vap.1901.2014 <- raster::extract(r, points)

# wet
r <- brick("CRU/v3.23/ncfiles/cru_ts3.23.01.1901.2014.wet.dat.nc", varname="wet")
wet.1901.2014 <- raster::extract(r, points)

## save ####

# cld
cld <- data.frame(sites.sitename = as.character(ForestGEO_sites[,1]), cld.1901.2014)
write.csv(cld, file = "C:/Users/Herrmannv/Dropbox (Smithsonian)/Climate/CRU/2017_download/cld.1901.2014.csv", row.names = F)

# drt
drt <- data.frame(sites.sitename = as.character(ForestGEO_sites[,1]), drt.1901.2014)
write.csv(drt, file = "C:/Users/Herrmannv/Dropbox (Smithsonian)/Climate/CRU/2017_download/drt.1901.2014.csv", row.names = F)

# frs
frs <- data.frame(sites.sitename = as.character(ForestGEO_sites[,1]), frs.1901.2014)
write.csv(frs, file = "C:/Users/Herrmannv/Dropbox (Smithsonian)/Climate/CRU/2017_download/frs.1901.2014.csv", row.names = F)

# pet
pet <- data.frame(sites.sitename = as.character(ForestGEO_sites[,1]), pet.1901.2014)
write.csv(pet, file = "C:/Users/Herrmannv/Dropbox (Smithsonian)/Climate/CRU/2017_download/pet.1901.2014.csv", row.names = F)

# pre
pre <- data.frame(sites.sitename = as.character(ForestGEO_sites[,1]), pre.1901.2014)
write.csv(pre, file = "C:/Users/Herrmannv/Dropbox (Smithsonian)/Climate/CRU/2017_download/pre.1901.2014.csv", row.names = F)

# rhm
# r <- brick("CRU/v3.23/ncfiles/", varname="cld")


# ssh
# r <- brick("CRU/v3.23/ncfiles/", varname="cld")

# tmp
tmp <- data.frame(sites.sitename = as.character(ForestGEO_sites[,1]), tmp.1901.2014)
write.csv(tmp, file = "C:/Users/Herrmannv/Dropbox (Smithsonian)/Climate/CRU/2017_download/tmp.1901.2014.csv", row.names = F)

# tmn
tmn <- data.frame(sites.sitename = as.character(ForestGEO_sites[,1]), tmn.1901.2014)
write.csv(tmn, file = "C:/Users/Herrmannv/Dropbox (Smithsonian)/Climate/CRU/2017_download/tmn.1901.2014.csv", row.names = F)

# tmx
tmx <- data.frame(sites.sitename = as.character(ForestGEO_sites[,1]), tmx.1901.2014)
write.csv(tmx, file = "C:/Users/Herrmannv/Dropbox (Smithsonian)/Climate/CRU/2017_download/tmx.1901.2014.csv", row.names = F)

# vap
vap <- data.frame(sites.sitename = as.character(ForestGEO_sites[,1]), vap.1901.2014)
write.csv(vap, file = "C:/Users/Herrmannv/Dropbox (Smithsonian)/Climate/CRU/2017_download/vap.1901.2014.csv", row.names = F)

# wet
wet <- data.frame(sites.sitename = as.character(ForestGEO_sites[,1]), wet.1901.2014)
write.csv(wet, file = "C:/Users/Herrmannv/Dropbox (Smithsonian)/Climate/CRU/2017_download/wet.1901.2014.csv", row.names = F)


# WorldClim ####

## Extract ####
r <- stack("WorldClim/tiff/1bioclim_stacked_all.tif")
# plot(r) 
points(points)
WorldClim <- raster::extract(r, points) #takes 10? mins


## create output dataframe ####
WorldClimDF <- data.frame(ID = points$ID, sites.sitename = points$sites.sitename)
WorldClimDF <- cbind(WorldClimDF, WorldClim)
#rename variables
names(WorldClimDF) <- c("ID", "sites.sitename","AnnualMeanTemp", "MeanDiurnalRange", "Isothermality","TempSeasonality", "MaxTWarmestMonth", "MinTColdestMonth", "TempRangeAnnual", "MeanTWetQ", "MeanTDryQ","MeanTWarmQ","MeanTColdQ", "AnnualPre","PreWetMonth", "PreDryMonth", "PreSeasonality", "PreWetQ", "PreDryQ", "PreWarmQ", "PreColdQ")
head(WorldClimDF)

WorldClimDF$AnnualMeanTemp  <- WorldClimDF$AnnualMeanTemp / 10
WorldClimDF$MeanDiurnalRange <- WorldClimDF$MeanDiurnalRange / 10
WorldClimDF$Isothermality <- WorldClimDF$Isothermality / 100
WorldClimDF$TempSeasonality  <- WorldClimDF$TempSeasonality / 100
WorldClimDF$MaxTWarmestMonth  <- WorldClimDF$MaxTWarmestMonth / 10
WorldClimDF$MinTColdestMonth <- WorldClimDF$MinTColdestMonth / 10
WorldClimDF$TempRangeAnnual <- WorldClimDF$TempRangeAnnual / 10
WorldClimDF$MeanTWetQ <- WorldClimDF$MeanTWetQ / 10
WorldClimDF$MeanTDryQ <- WorldClimDF$MeanTDryQ / 10
WorldClimDF$MeanTWarmQ <- WorldClimDF$MeanTWarmQ / 10
WorldClimDF$MeanTColdQ <- WorldClimDF$MeanTColdQ / 10

head(WorldClimDF)


## save ####
# write.csv(bioDataDF, file="R:/Current Projects/DOE/DOE database/Extracted Data/TropForC_bioclimdata.csv")
write.csv(WorldClimDF,"C:/Users/Herrmannv/Dropbox (Smithsonian)/Climate/WorldClim/2017_download/CTFS-ForestGEO_WorldClim.csv", row.names = F)
