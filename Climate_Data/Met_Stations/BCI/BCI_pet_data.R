#########
### Developed by: Bianca Gonzalez, bianca.glez94@gmail.com
### OBJECTIVE: # 
### Created July 2020

##########
library(readr)
library(ggplot2)
library(plotly)
library(anytime) 
library(dplyr)
library(viridis)
library(lubridate)
##########

# Clean environment ####
rm(list = ls())

#### BCI precip data --------
bci_man <- read_csv("C:/Users/GonzalezB2/Desktop/Smithsonian/Climate/Climate_Data/Met_Stations/BCI/El_Claro_precip_starting_1929/20180168_bci_manual_cl_ra/bci_cl_ra_man.csv")
pet_1900s <- read_csv("C:/Users/GonzalezB2/Desktop/Smithsonian/Climate/Climate_Data/Met_Stations/BCI/El_Claro_precip_starting_1929/20180168_bci_manual_cl_ra/rain_acp_ra_1929_1971.csv")

#### The standard CRU format for PRE is: 
BCI_pre_names<- storage.vess[[104]] %>% names()

## one value for month per year 1901-02-15

# so take pre data per day and average per month
class(pet_1900s$`Date(yyyy-mm-dd)`)
pet_1900s<- pet_1900s %>% rename(Date =`Date(yyyy-mm-dd)`)

pet_1900s$DateM <- as.Date(pet_1900s$Date, "%d/%m/%Y")

# get sum by month
pet_1900s <- pet_1900s %>% group_by(Date=floor_date(DateM, "month")) %>% summarize(climvar.val=sum(`rain (mm)`))

# now make the same format as 
#"Barro Colorado Island" # Date #climvar.val #id # climvar.class # month
pet_1900s$sites.sitename <- rep("Barro Colorado Island", nrow(pet_1900s))
pet_1900s$climvar.class <- rep("pre", nrow(pet_1900s))
pet_1900s$month<- month(pet_1900s$Date)

# rearrange
#pet_1900s<- pet_1900s[c(3,1,2,4,5)]

## write.csv

write.csv(pet_1900s, paste0(getwd(), "/Climate_Data/Met_Stations/BCI/pre_1900s_BCI.csv"), row.names = F)
