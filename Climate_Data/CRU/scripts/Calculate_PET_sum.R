######################################################
# Purpose: Calculate PET_sum 
# Developped by: Valentine Herrmann - HerrmannV@si.edu
# R version 3.4.4 (2018-08-29)
######################################################

# Clean environment ####
rm(list = ls())

# Set working directory as Shenandoah main folder ####
setwd(".")

# Load libraries ####
library(lubridate)


## v4_04 ####

# load data
CRU_PET <- read.csv("Climate_Data/CRU/CRU_v4_04/pet.1901.2019-ForestGEO_sites-6-03.csv")
head(CRU_PET[, c(1:6)])

# multiply each value by the number of day of that month

nb.days.in.month <- days_in_month(as.Date(names(CRU_PET)[-1], format = "X%Y.%m.%d"))
CRU_PET[, -1] <- CRU_PET[, -1] * matrix(rep(nb.days.in.month, each = nrow(CRU_PET)), nrow = nrow(CRU_PET))

#save ####
write.csv(CRU_PET, "Climate_Data/CRU/CRU_v4_04/pet_sum.1901.2019-ForestGEO_sites-6-04.csv", row.names = F)



## v4_06 ####

# load data
pet <- read.csv("Climate_Data/CRU/CRU_v4_06/pet.1901-2021-ForestGEO_sites.csv")

# multiply each value by the number of day of that month
nb.days.in.month <- days_in_month(as.Date(paste(pet$Yr, pet$Mo, 01, sep = "-"), format = "%Y-%m-%d"))
pet$value <- pet$value * nb.days.in.month

#save ####
write.csv(pet, "Climate_Data/CRU/CRU_v4_06/pet_sum.1901-2021-ForestGEO_sites.csv", row.names = F)
