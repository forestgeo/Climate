######################################################
# Purpose: SPEI data for ForestGEO network
# Developed by: Bianca Gonzalez (data inputs from V.Hermann & B.G)
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
path_to_climate_data_NM <- "C:/Users/herrmannV/Dropbox (Smithsonian)/GitHub/EcoClimLab/ForestGEO_dendro/data/climate/NM/CRU_climate/CRU_v4_04/"
path_to_BCI_pre <- "https://raw.githubusercontent.com/forestgeo/Climate/master/Climate_Data/Met_Stations/BCI/El_Claro_precip_starting_1929/pre_BCI.csv"
path_to_BCI_wet <- "https://raw.githubusercontent.com/forestgeo/Climate/master/Climate_Data/Met_Stations/BCI/El_Claro_precip_starting_1929/wet_BCI.csv"

climate_variables <- c( "pre", "wet",
                        "tmp", "tmn", "tmx", "pet_sum"#,
                        # "dtr", "cld") # "frs", "vap"
)


clim_var_group <- list(c("pre", "wet"),
                       c("tmp", "tmn", "tmx", "pet_sum")#,
                       # c("dtr", "cld", "pet_sum")
) # see issue 14, PET is in both the TMP and DTR groups. If it comes out as the best in both groups (should always be for the same time frame), then there are only 2 candidate variables for the GLS

clim_gaps <- read.csv("https://raw.githubusercontent.com/forestgeo/Climate/master/Climate_Data/CRU/scripts/CRU_gaps_analysis/all_sites.reps.csv")
clim_gaps <- clim_gaps[clim_gaps$start_climvar.class %in% climate_variables, ]

# prepare data ####
for(clim_v in climate_variables) {
  x = read.csv(paste0(path_to_climate_data, clim_v,  ".1901.2019-ForestGEO_sites-6-03.csv"))
  
  y =  read.csv(paste0(path_to_climate_data_NM, clim_v, ".1901.2019-NM_site-7-10.csv"))

  head(colnames(x))
  head(colnames(y))
   
  colnames(y) <- gsub("_", "\\.", colnames(x))

  assign(clim_v, 
         rbind(
           x, #forestGEO sites
           y # NM site
         ) #https://github.com/EcoClimLab/ForestGEO_dendro/blob/master/data/cores/NM/CRU_climate/pre.1901.2019-NM_site-7-10.csv
  )
  
}

BCI_pre <- read.csv(path_to_BCI_pre, stringsAsFactors = F)
BCI_wet <- read.csv(path_to_BCI_wet, stringsAsFactors = F)


## climate data ####
for(clim_v in climate_variables) {
  print(clim_v)
  x <- get(clim_v)
  
  ### all forestgeo sites
  x <- x[x$sites.sitename %in% gsub(" ", "_", ForestGEO_sites$Site.name), ]
  
  ### reshape to long format
  x_long <- reshape(x, 
                    times = names(x)[-1], timevar = "Date",
                    varying = list(names(x)[-1]), direction = "long", v.names = clim_v)
  
  ### format date
  x_long$Date <- gsub("X", "", x_long$Date)
  x_long$Date <- as.Date(x_long$Date , format = "%Y.%m.%d")
  
  ### combine all variables in one
  if(clim_v == climate_variables[1]) all_Clim <- x_long[, c(1:3)]   else all_Clim <- merge(all_Clim, x_long[, c(1:3)], by = c("sites.sitename", "Date"), all = T)
  
}

### replace BCI pre and wet by local data
idx_BCI <- all_Clim$sites.sitename %in% "Barro_Colorado_Island"

all_Clim$pre[idx_BCI] <- BCI_pre$climvar.val[match(format(all_Clim$Date[idx_BCI], "%Y-%m"), format(as.Date(BCI_pre$Date), "%Y-%m"))]
all_Clim$wet[idx_BCI] <- BCI_wet$climvar.val[match(format(all_Clim$Date[idx_BCI], "%Y-%m"), format(as.Date(BCI_wet$Date), "%Y-%m"))]

### remove BCI pre and wet from clim gap as it is not relevant anymore
clim_gaps <- clim_gaps[!(clim_gaps$start_sites.sitename %in% "Barro_Colorado_Island" & clim_gaps$start_climvar.class %in% c("pre", "wet")), ]

# keep only complete rows (this will remove BCI dat for years where we don't have pre data)
all_Clim <- all_Clim[complete.cases(all_Clim), ]

###### Prep Data to Calculate (SPEI) for multiple sites ---------------------------------------------
clim_prep <- all_Clim %>% 
  select(sites.sitename, Date, pre, pet_sum)


## calculate water balance before SPEI 
clim_prep$bal <- clim_prep$pre - clim_prep$pet_sum

## selecting only relevent fields to convert to wide
clim_prep <- clim_prep %>% 
  select(sites.sitename, Date, bal)

## convert to wide format & calculate for all sites
wide_clim_all <- tidyr::spread(clim_prep, sites.sitename, bal)

# drop BCI so can calculate SPEI for all sites (BCI has NA values and SPEI doesn't accept)
wide_clim <- wide_clim_all %>% select(-Barro_Colorado_Island,-Date)

# Convert to a ts (time series) object --- time series iput for SPEI obj
ts_sites <- ts(wide_clim, start=c(1901,01), end=c(2019,12), frequency = 12)

####### Calculating SPEI at all time-scales (1-48 months) ---------------------------------------------
month_ranges<- 1:48

for(month in month_ranges){
  x <- spei(ts_sites, month)
  x_df <- data.frame(.preformat.ts(x$fitted), stringsAsFactors = FALSE)
  x_df$Date <- wide_clim_all$Date
  
  # then reshape into long format // date // site // value // 
  x_long <- gather(x_df,
                   "sites.sitename", !!paste0("value_month_",month, collapse = '*'), 
                   -Date, factor_key = T)
  
  if(month == month_ranges[1]) 
    all_SPEI <- x_long
  else 
    all_SPEI <- merge(all_SPEI, x_long, by = c("sites.sitename","Date"), all =T)

}

write.csv(all_SPEI, "Climate_Data/SPEI/data_calculated_with_script/spei_all_months.csv", row.names = F)

############ SPEI for BCI for (1-48 months)  -------

## filter by single site and filter nas
clim_prep_bci_date <- wide_clim_all %>% select("Barro_Colorado_Island", "Date") %>% filter(!is.na(Barro_Colorado_Island))

## look at start and end dates (Start is 1929-01-16 and End is 2019-11-16 //convert to TS obj
clim_prep_bci <- clim_prep_bci_date %>% select(-Date)
ts_BCI<- ts(clim_prep_bci, start=c(1929,1), end=c(2019,11), frequency = 12)

month_ranges<- 1:48
for(month in month_ranges){
  x <- spei(ts_BCI, month)
  x_df <- data.frame(.preformat.ts(x$fitted), stringsAsFactors = FALSE)
  
  # then reshape into long format // date // site // value // 
  x_long <- reshape(x_df,varying=colnames(x_df),
                    v.names = paste0("value_month_",month),direction = "long", ids=rownames(x_df))
  x_long$sites.sitename<-"Barro_Colorado_Island"
  x_long$Date<- paste0(x_long$id,"-",x_long$time,"-", "01")
  x_long$Date<- lubridate::ymd(x_long$Date)
  
  # drop unnecessary cols
  x_long$time<-NULL
  x_long$id<-NULL
  
  if(month == month_ranges[1]) 
    BCI_SPEI <- x_long
  else 
    BCI_SPEI <- merge(BCI_SPEI, x_long, by = c("sites.sitename","Date"), all =T)
}

## Now write BCI_SPEI and sites_SPEI as CSV dataframes and put into one dataframe in excel
## delete NM dataframe and add to different repo 

write.csv(BCI_SPEI, "Climate_Data/SPEI/data_calculated_with_script/spei_bci.csv", row.names = F)




# check calculated vs extracted values ####
x <- all_SPEI[all_SPEI$sites.sitename %in% "Smithsonian_Conservation_Biology_Institute", ]
y <- read.csv("Climate_Data/SPEI/data_downloaded/SCBI/spei_-78.25_38.75.csv", skip = 1)

range(x$Date)
y$Date = seq.Date(from = as.Date("1901-01-01"), by = "month", length.out = nrow(y))
range(y$Date)

png("Climate_Data/SPEI/comparing_extracted_vs_calculated.png", width = 6, height = 5, units = "in", res = 300)
plot(x$value_month_1[x$Date <= as.Date("2015-12-31")], y$SPEI01, xlab = "calculated", ylab = "extracted", main = "SCBI")
abline(0,1, col = "red")
dev.off()
