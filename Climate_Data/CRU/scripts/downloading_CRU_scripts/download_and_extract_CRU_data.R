# Extracting CRU data for all forestGEO sites

# Temperature (TMP), Precipitation (PRE), Diurnal Temperature Range (DTR) and Vapour Pressure (VAP) are available by reasing txt files online but we need to read in a KML file to figure out the address of the txt file (depends on the coordinate of the site)

# for the rest of the variables, the .nc.gz files need to be downloaded (somewhere like here: https://crudata.uea.ac.uk/cru/data/hrg/cru_ts_4.06/cruts.2205201912.v4.06/pet/cru_ts4.06.1901.2021.pet.dat.nc.gz) and unzipped. We typically store those in S:/Gloval Maps Data/CRU/v4.XX/nc_files


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

# CRU KML data ####
## Extracting CRU data from KML file downloaded here: https://crudata.uea.ac.uk/cru/data/hrg/cru_ts_4.06/ge/ 

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

for (i in 1:nrow(list_XML_to_download)) {
  
  url = list_XML_to_download[i, "Description"]
  url = regmatches(url, regexpr("http.*kml", url))
  
  file = paste0("Climate_Data/CRU/",
                CRU_version,
                "/KML_files/",
                rev(strsplit(url, "/")[[1]])[1])
  
  if (!file.exists(file)) download.file(url, destfile = file)
  
  
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


# now get the rest of the variables for which the .nc files have been downloaded ####

for (v in c("tmn", "tmx", "frs", "wet", "cld", "pet")) {
  
  # figure out if file needs to be unzip, if yes, unzip and delete zipped one
  ncfile <- list.files(paste0("S:/Global Maps Data/CRU/", CRU_version, "/nc_files/"), v, full.names = T)
  
  if(grepl("\\.gz", ncfile)) {
    R.utils::gunzip(
      ncfile,
      gsub("\\.gz", "", ncfile)
      ) # this takes several minutes
    
    ncfile <- gsub("\\.gz", "", ncfile)
  }
  
    r <- raster::brick(ncfile, varname = v)  
    
    x <- raster::extract(r, points)  #this takes several minutes, maybe ~3mins
    rownames(x) <- points$Site.name
    
    
    x <- data.frame(t(x))
    
    for (i in colnames(x)) {
      y <- x[i]
      all_Data <- rbind(
        all_Data,
        data.frame(
          sites.sitename = gsub("\\.", " ", i),
          variable = v,
          Yr = as.numeric(substr(rownames(y), 2, 5)),
          Mo = as.numeric(substr(rownames(y), 7, 8)),
          Value = y[, 1],
          N.Obs = NA
        )
      )
      
      
    }
}


# save data ####

sapply(unique(all_Data$variable), function(v)
  write.csv(
    all_Data[all_Data$variable %in% v,],
    file = paste0(
      "Climate_Data/CRU/",
      CRU_version,
      "/",
      v,
      ".",
      gsub("\\.", "-", regmatches(ncfile, regexpr("\\d{4}\\.\\d{4}", ncfile))),
      "-ForestGEO_sites.csv"
    ),
    row.names = F
  ))
