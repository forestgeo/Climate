# Extracting CRU data from KML file downloaded here: https://crudata.uea.ac.uk/cru/data/hrg/cru_ts_4.06/ge/
# Temperature (TMP), Precipitation (PRE), Diurnal Temperature Range (DTR) and Vapour Pressure (VAP) are available.
# Also extracting PET from https://crudata.uea.ac.uk/cru/data/hrg/cru_ts_4.06/cruts.2205201912.v4.06/pet/cru_ts4.06.1901.2021.pet.dat.nc.gz

# clear environment ####
rm(list = ls())


# load libraries ####

library(XML)
library(xml2)
library(rgdal)
library(raster)
library(sp)


# load data ####
CRU_version  = "CRU_v4_06"

# ForestGeo sites (and their locations) found in github
ForestGEO_sites <-
  read.csv(
    "https://raw.githubusercontent.com/forestgeo/Site-Data/master/ForestGEO_site_data.csv"
  )

ForestGEO_sites <-
  ForestGEO_sites[!is.na(ForestGEO_sites$Latitude), ]

points <- ForestGEO_sites
coordinates(points) <- c("Longitude", "Latitude")

# CRU KML data

CRU_5degree <-
  readOGR(dsn = paste0(
    "Climate_Data/CRU/",
    CRU_version,
    "/KML_files/cruts_4.06_gridboxes.kml"
  ))


plot(CRU_5degree)
points(points, col = "red")

# figure out and download the 0.5 degree files we need for each site + extract CRU data ####
list_XML_to_download <- extract(CRU_5degree, points)

all_Data <- NULL

download = FALSE # turn to TRUE if this is the first time you download for the newest CRU version

for (i in 1:nrow(list_XML_to_download)) {
  url = list_XML_to_download[i, "Description"]
  url = regmatches(url, regexpr("http.*kml", url))
  file = paste0("Climate_Data/CRU/",
                CRU_version,
                "/KML_files/",
                rev(strsplit(url, "/")[[1]])[1])
  
  if (download)
    download.file(url, destfile = file)
  
  # read file and extract data (which is stored in several .txtfiles that are online)
  
  x <- readOGR(file)
  y <- extract(x, points[i,])
  
  url = y[1, "Description"]
  
  url <- read_html(url)
  # xml_structure(url)
  
  all_url <- xml_find_all(url, ".//a")
  all_url <- as.character(all_url)
  all_url <-
    all_url[grepl(".txt", all_url) & grepl(">Data<", all_url)]
  all_url <- regmatches(all_url, regexpr("http.*txt", all_url))
  
  # get the data
  
  for (f in all_url) {
    df  <- read.csv(f, skip = 6, sep = "")
    all_Data <-
      rbind(
        all_Data,
        data.frame(
          sites.sitename = points$Site.name[i],
          variable = rev(strsplit(f, "\\.")[[1]])[2],
          read.csv(f, skip = 6, sep = "")[, c(1:4)]
        )
      )
    
  }
  
  
  
  
}


# now get PET **version hard codede here!**####


download.file(
  "https://crudata.uea.ac.uk/cru/data/hrg/cru_ts_4.06/cruts.2205201912.v4.06/pet/cru_ts4.06.1901.2021.pet.dat.nc.gz",
  destfile = "Climate_Data/CRU/CRU_v4_06/nc_files/cru_ts4.06.1901.2021.pet.dat.nc.gz"
) # ATTENTION< this may not download the whole file. May need to do it by hand here: https://crudata.uea.ac.uk/cru/data/hrg/cru_ts_4.06/cruts.2205201912.v4.06/pet/
R.utils::gunzip(
  "Climate_Data/CRU/CRU_v4_06/nc_files/cru_ts4.06.1901.2021.pet.dat.nc.gz",
  "Climate_Data/CRU/CRU_v4_06/nc_files/cru_ts4.06.1901.2021.pet.dat.nc"
)


r <-
  brick("Climate_Data/CRU/CRU_v4_06/nc_files/cru_ts4.06.1901.2021.pet.dat.nc",
        varname = "pet")   #maybe ~3mins
x <- raster::extract(r, points)
rownames(x) <- points$Site.name

x <- data.frame(t(x))

for (i in colnames(x)) {
  y <- x[i]
  all_Data <- rbind(
    all_Data,
    data.frame(
      sites.sitename = i,
      variable = "pet",
      Yr = as.numeric(substr(rownames(y), 2, 5)),
      Mo = as.numeric(substr(rownames(y), 7, 8)),
      Value = y[, 1],
      N.Obs = NA
    )
  )
  
  
}

# delete nc fil since it is so big
# file.remove("Climate_Data/CRU/CRU_v4_06/nc_files/cru_ts4.06.1901.2021.pet.dat.nc")

# save data ####

sapply(unique(all_Data$variable), function(v)
  write.csv(
    all_Data[all_Data$variable %in% v,],
    file = paste0(
      "Climate_Data/CRU/",
      CRU_version,
      "/",
      v,
      ".1901-2021-ForestGEO_sites.csv"
    ),
    row.names = F
  ))
