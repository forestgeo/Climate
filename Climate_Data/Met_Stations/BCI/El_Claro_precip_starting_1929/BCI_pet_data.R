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
seventies_rain <- read_csv("C:/Users/GonzalezB2/Desktop/Smithsonian/Climate/Climate_Data/Met_Stations/BCI/El_Claro_precip_starting_1929/20180168_bci_manual_cl_ra/bci_cl_ra_man.csv")
rain_1900s <- read_csv("C:/Users/GonzalezB2/Desktop/Smithsonian/Climate/Climate_Data/Met_Stations/BCI/El_Claro_precip_starting_1929/20180168_bci_manual_cl_ra/rain_acp_ra_1929_1971.csv")

## Change names, format dates for 1900s and 1970s data 
rain_1900s<- rain_1900s %>% rename(Date =`Date(yyyy-mm-dd)`)
rain_1900s$Date <- as.Date(rain_1900s$Date, "%d/%m/%Y") 
seventies_rain<- seventies_rain %>% rename(Date =date, avg_rain=ra)
seventies_rain$Date <- as.Date(seventies_rain$Date, "%d/%m/%Y")

## FOR PRE FORMATTING ----
seventies_PRE <- seventies_rain %>% group_by(Date=floor_date(Date, "month")) %>% summarize(climvar.val=sum(avg_rain))
pre_1900s <- rain_1900s %>% group_by(Date=floor_date(Date, "month")) %>% summarize(climvar.val=sum(`rain (mm)`))

# bind these puppies, add relevent cols, and write.csv
pre_BCI <- rbind(pre_1900s, seventies_PRE)
pre_BCI$sites.sitename <- rep("Barro Colorado Island", nrow(pre_BCI))
pre_BCI$month<- month(pre_BCI$Date)
pre_BCI$climvar.class <- rep("pre", nrow(pre_BCI))

# rearrange cols to match long format
pre_BCI<- pre_BCI[c(3,1,2,5,4)]

## write.csv for PRE
#write.csv(pre_BCI, paste0(getwd(), "/Climate_Data/Met_Stations/BCI/pre_BCI.csv"), row.names = F)

## FOR WET FORMATTING ----

# for daily WET data 
# need to sum the # of days per month that were was precip if precip was above > 0.1mm 

wet_1900s<- rain_1900s %>% group_by(Date=floor_date(Date, "month")) %>% filter(`rain (mm)`>.1) %>% tally()
wet_1970s<- seventies_rain %>% group_by(Date=floor_date(Date, "month")) %>% filter(avg_rain>.1) %>% tally()

# bind these puppies, add relevent cols, and write.csv
wet_BCI <- rbind(wet_1900s, wet_1970s)
wet_BCI$sites.sitename <- rep("Barro Colorado Island", nrow(wet_BCI))
wet_BCI$month<- month(wet_BCI$Date)
wet_BCI$climvar.class <- rep("wet", nrow(wet_BCI))
wet_BCI<- wet_BCI %>% rename(climvar.val= n)

# rearrange cols to match long format
wet_BCI<- wet_BCI[c(3,1,2,5,4)]

## write.csv for PRE
write.csv(wet_BCI, paste0(getwd(), "/Climate_Data/Met_Stations/BCI/wet_BCI.csv"), row.names = F)
