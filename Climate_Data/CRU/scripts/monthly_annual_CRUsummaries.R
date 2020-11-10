######################################################
# Purpose: Generate monthly and annual summaries for CRU data from 1950 to present for all sites
# Developed by: Bianca Gonzalez & Cameron Dow
# R version 3.6.2 - First created September 2020
######################################################

# clear environement ####
rm(list = ls())

# Objectives: Jan and July temp, annual precip (for MEE ) &  and mean annual temperature 

# ------------------------------------------------------------------------------

# load relevant packages
library(tidyverse)

### Load CRU data (TMP, TMN, TMX, CLD, TMP, TMN, TMX, CLD, PET) ###
#### Climate data -----

path_to_climate_data <- "https://raw.githubusercontent.com/forestgeo/Climate/master/Climate_Data/CRU/CRU_v4_04/"
climate_variables <- c("cld", "dtr", "frs", "pet_sum", "pre", "tmn", "tmp", "tmn", "tmx", "vap", "wet")

for(clim_v in climate_variables) {
  assign(clim_v, # assign just gives it a name of the DATA in read.csv 
         read.csv(paste0(path_to_climate_data, clim_v,  ".1901.2019-ForestGEO_sites-6-03.csv"))
  )
  
}

# prepare data ####

## climate data ####
for(clim_v in climate_variables) {
  print(clim_v)
  x <- get(clim_v)
  
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
all_Clim_1950 <- all_Clim[all_Clim$Date>="1950-01-16",] # Krista only wants stats on >= 1950
all_Clim_1950$Year<- substr(all_Clim_1950$Date, 1, 4) ## group by year and site then calculate the summary for TMP, TMN, TMX, CLD
all_Clim_1950$Year_month <- substr(all_Clim_1950$Date, 1,7) ## to later group by month and year 
all_Clim_1950$Month <- substr(all_Clim_1950$Date, 6,7) ## to later group by month and year 

##### WELP Let's do another pass at annual values ######
range_stats_a<- all_Clim_1950 %>%
  group_by(sites.sitename) %>%
  summarise(across(where(is.numeric), list(min = min, max = max, 
                                           median = median, mean = mean,
                                           sd = sd, sum = sum)))

range_stats_m<- all_Clim_1950 %>%
  group_by(sites.sitename, Month) %>%
  summarise(across(where(is.numeric), list(min = min, max = max, 
                                           median = median, mean = mean,
                                           sd = sd, sum = sum)))

annual_stats<- all_Clim_1950 %>%
  group_by(sites.sitename, Year) %>% 
  summarise(across(where(is.numeric), list(mean = mean, sum = sum)))

annual_df_columns <- annual_stats %>%
  group_by(sites.sitename) %>%
  summarise((across(where(is.numeric), list(mean = mean, max = max, min = min, sd = sd, 
                                            median = median))))
## clean variables 

v_int <- annual_df_columns %>% select(sites.sitename, tmp_mean_mean, tmn.x_mean_mean, tmx_mean_mean, cld_mean_mean, pre_sum_mean, frs_sum_mean, wet_sum_mean)
annual_int <- annual_df_columns %>% select(-colnames(annual_df_columns[grepl("dtr_sum|tmn.y|pet|mean_mean|sum_mean|tmp_sum|tmp_mean_mean|tmn.x_mean_mean|tmx_mean_mean|cld_mean_mean|pre_sum_mean|frs_sum_mean|wet_sum_mean|tmn.x_sum|tmx_sum|cld_sum|pre_mean|frs_mean|wet_mean", colnames(annual_df_columns))]))
#annual_sum <- annual_sum_columns[, c(1,19,25,31, 67)]
range_annual_clean<- left_join(v_int, annual_int, by = c("sites.sitename"))
#range_annual_clean<- left_join(range_annual_clean, annual_sum, by = c("sites.sitename"))


#range_annual_clean$pre_mean <- range_annual_clean$pre_mean*12
#annual_stats[grepl("mean", colnames(annual_stats))]<- do.call(cbind, lapply(annual_stats[grepl("mean", colnames(annual_stats))], as.numeric))

v_int <- range_stats_m %>% select(sites.sitename,Month, tmp_mean, tmn.x_mean, tmx_mean, cld_mean, pre_mean)
annual_int <- range_stats_m %>% select(-colnames(annual_stats[grepl("mean|sum", colnames(annual_stats))]))
range_monthly_clean<- left_join(v_int, annual_int, by = c("sites.sitename", "Month"))
#annual_stats[grepl("mean", colnames(annual_stats))]<- do.call(cbind, lapply(annual_stats[grepl("mean", colnames(annual_stats))], as.numeric))

####

###    ---  ANNUAL summary tables (mean, mode, max, min, 5th and 95th percentiles) for CRU vars --- ####

# compute annual averages/ mean / max / mode/ sd / median / min 

#annual_stats<- all_Clim_1950 %>%
#  group_by(sites.sitename, Year) %>% 
#  summarise(across(where(is.numeric), list(min = min, max = max, 
#                                           median = median, mean = mean,
#                                           sd = sd, sum = sum)))

# interested in the following variables: 
# Average: TMP, TMN, TMX, CLD, PRE (everything with min, max, median, & sd) Sum: PRE, WET, FRS, PET_SUM 

#v_int <- annual_stats %>% select(sites.sitename, Year, tmp_mean, tmn.x_mean, tmx_mean, cld_mean, pre_sum,pre_mean, wet_sum, frs_sum,pet_sum_sum)
#annual_int <- annual_stats %>% select(-colnames(annual_stats[grepl("mean|sum", colnames(annual_stats))]))
#annual_stats_clean<- left_join(v_int, annual_int, by = c("sites.sitename","Year"))
#annual_stats[grepl("mean", colnames(annual_stats))]<- do.call(cbind, lapply(annual_stats[grepl("mean", colnames(annual_stats))], as.numeric))


###    ---  MONTHLY summary tables (mean, mode, max, min, 5th and 95th percentiles) for CRU vars --- ####

#monthly_stats<- all_Clim_1950 %>%
#  group_by(sites.sitename, Year_month) %>% 
#  summarise(across(where(is.numeric), list(min = min, max = max,
#                                           mean = mean, sum = sum)))

## clean up & select only vars of interest
#m_int <- monthly_stats %>% select(sites.sitename, Year_month, tmp_mean, tmn.x_mean, tmx_mean, cld_mean, pre_sum,pre_mean, wet_sum, frs_sum,pet_sum_sum)
#monthly_int <- monthly_stats %>% select(-colnames(monthly_stats[grepl("mean|sum", colnames(monthly_stats))]))
#monthly_stats_clean<- left_join(monthly_int, m_int, by = c("sites.sitename","Year_month"))
### Okay MVP is ready --  ## still need 5th and 95th percentiles, too.
#Find the quartiles (25th, 50th, and 75th percentiles) of the vector


#quantile(all_Clim_1950, probs = c(.95, .05))

write.csv(range_annual_clean, paste0(getwd(),"/Climate_Data/CRU/scripts/annual_stats.csv"), row.names = F)
write.csv(range_monthly_clean, paste0(getwd(),"/Climate_Data/CRU/scripts/monthly_stats.csv"), row.names = F)
