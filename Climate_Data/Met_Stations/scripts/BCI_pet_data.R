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
##########

# Clean environment ####
rm(list = ls())

#### BCI precip data --------
bci_cl_ra_man <- read_csv("C:/Users/GonzalezB2/Desktop/Smithsonian/Climate/Climate_Data/Met_Stations/BCI/El_Claro_precip_starting_1929/20180168_bci_manual_cl_ra/bci_cl_ra_man.csv")

rain_acp_ra_1929_1971 <- read_csv("C:/Users/GonzalezB2/Desktop/Smithsonian/Climate/Climate_Data/Met_Stations/BCI/El_Claro_precip_starting_1929/20180168_bci_manual_cl_ra/rain_acp_ra_1929_1971.csv")
View(rain_acp_ra_1929_1971)
#### 