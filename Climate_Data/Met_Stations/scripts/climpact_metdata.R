##Script to turn 5 min observation data from ForestGEO meterological towers into daily mean, maxes, and/or minimums.
##Also included in this script is the code to reformat data into input form for R package Climpact ( https://climpact-sci.org/ )

library(readr)
library(tidyverse)
library(lubridate)
library(dplyr)

years <- c(2011:2019) #Enter years for which data is available

for(i in years){ # For loop to load each year's csv
  name <- paste0("data", i)
  Filename <- paste("Met_Stations/SCBI/ForestGEO_met_station-SCBI/Data/SCB_Metdata_5min", i, sep = "_")#change to whatever met station you wish
  Filename <- paste(Filename, "csv", sep = ".")
  assign(name, read.csv(Filename, skip = 3)) #skip = 3 tells R to skip the first 3 rows in each csv

}
#Problem: some temps in 2011 are appearing as NAN (not a number). Remove them. May have to be done for years other than 2011 depending on met tower. 
#Possible improvement here would be to have R automatically search through each DF - turning non-numeric entries into NA
data2011[data2011$Avg.3 == "NAN",9] <- NA
data2011$Avg.3 <- as.character(data2011$Avg.3)
data2011$Avg.3 <- as.numeric(data2011$Avg.3)
data2011 <- data2011[complete.cases(data2011$Avg.3),]

#Ensure each year has the same colnames for merging
names(data2013) <- names(data2011)
names(data2014) <- names(data2011)
names(data2015) <- names(data2011)
names(data2016) <- names(data2011)
names(data2017) <- names(data2011)
names(data2018) <- names(data2011)
names(data2019) <- names(data2011)

#merge all data into one DF
data <- rbind(data2011,data2012,data2013,data2014,data2015,data2016,data2017,data2018,data2019) 
warnings() #Unsure what these warnings indicate. Look into this

#Rename temperature sensor columns
names(data)[7] <- "Air_avgtmp1"
names(data)[8] <- "Air_std1"
names(data)[9] <- "Air_avgtmp2"
names(data)[10] <- "Air_std2"

data$Air_avgtmp1 <- as.character(data$Air_avgtmp1)
data$Air_avgtmp1 <- as.numeric(data$Air_avgtmp1) #Should already be numeric - but run again to be positive

data$Air_avgtmp2 <- as.character(data$Air_avgtmp2)
data$Air_avgtmp2<- as.numeric(data$Air_avgtmp2)


head(data) #Check that merge was successful

data <- data %>% #Converts character 'date times' into date time format readable by R 
  mutate(X = paste0(X, ":00"), #X = column with date times, first column in SCBI met tower
         X = parse_date_time(X, orders = "mdy HMS"),
         date = date(X), 
         time = chron::times(strftime(X,"%H:%M:%S", tz = "UTC")))
#Produces a warning - look into what this means

#sensor 1 - Pre-Climpact identification of missing dates####
data1 <- data[complete.cases(data$Air_avgtmp1),]
#dailymeans1 <- aggregate(data$Air_avgtmp1, by = list(data1$date), FUN = mean) #Climpact does not use average, only max and min. Run this line if interested only in averages
dailymax1 <- aggregate(data1$Air_avgtmp1, by = list(data1$date), FUN = max)
write.csv(dailymax1, file = "dailymaxes_sensor1.csv") #Maxes from sensor 1 before data filling

dailymins1 <- aggregate(data1$Air_avgtmp1, by = list(data1$date), FUN = min)
write.csv(dailymins1, file = "dailymins_sensor1.csv") #Mins from sensor 1 before data filling 

#Create the input for climpact analysis 
d1 <- merge(dailymax1, dailymins1, by = "Group.1")
d1 <- separate(d1, "Group.1", c("Year", "Month", "Day"), sep = "-")
d1$precip <- -99.9
d1 <- d1[,c(1,2,3,6,4,5)]
write.csv(d1, file = "SCBI_mettower_dailymeans_sensor1.csv", col.names = FALSE, row.names = FALSE) #change name of file

#Sensor 2 Pre-Climpact identification of missing dates####
#Identical to sensor 1
data2 <- data[complete.cases(data$Air_avgtmp2),]
#dailymeans2 <- aggregate(data2$Air_avgtmp2, by = list(data2$date), FUN = mean)
dailymax2 <- aggregate(data2$Air_avgtmp2, by = list(data2$date), FUN = max)
write.csv(dailymax2, file = "dailymaxes_sensor2.csv", row.names = FALSE)
dailymins2 <- aggregate(data2$Air_avgtmp2, by = list(data2$date), FUN = min)
write.csv(dailymins2, file = "dailymins_sensor2.csv", row.names = FALSE)

d2 <- merge(dailymax2, dailymins2, by = "Group.1")
d2 <- separate(d2, "Group.1", c("Year", "Month", "Day"), sep = "-")
d2$precip <- -99.9
d2 <- d2[,c(1,2,3,6,4,5)]
write.csv(d2, file = "SCBI_mettower_dailymeans_sensor2.csv", col.names = FALSE, row.names = FALSE)

######## Run climpact once to determine missing dates in each sensor! 
#fill missing dates with either -99.9 (how climpact reads NA) or supplement with NCDC data
#NCDC data in far - convert to C first
NCDC_NOAA_precip_temp <- read_csv("NCDC_NOAA_precip_temp.csv")

#Convert NCDC dates into date format for R
NCDC_NOAA_precip_temp$newdate <- strptime(as.character(NCDC_NOAA_precip_temp$DATE), "%d/%m/%Y")
NCDC_NOAA_precip_temp$newdate <- format(NCDC_NOAA_precip_temp$newdate, "%Y-%m-%d")

#Convert F to C
NCDC_NOAA_precip_temp$TMAX <- (NCDC_NOAA_precip_temp$TMAX - 32)*(5/9)
NCDC_NOAA_precip_temp$TMIN <- (NCDC_NOAA_precip_temp$TMIN - 32)*(5/9)


#Sensor 1 Post-climpact identification of missing dates####
missingdates1 <- read_csv("SCBI_mettower_dailymeans_sensor1.txt.missing_dates.csv", col_names = "date") #This is the missing date csv created by climpact

missingdates1$date <- strptime(as.character(missingdates1$date), "%m/%d/%Y")
missingdates1$date <- format(missingdates1$date, "%Y-%m-%d")

dailymax1 <- read_csv("dailymaxes_sensor1.csv")
dailymins1 <- read_csv("dailymins_sensor1.csv")

dailymax1$Group.1 <- as.Date(dailymax1$Group.1)

#Pull missing data from NCDC
missingdates_data1 <- NCDC_NOAA_precip_temp[NCDC_NOAA_precip_temp$newdate %in% missingdates1$date,]

#Store dates where no data is available - will become NA's
missingdates_nodata1 <- missingdates1[!(missingdates1$date %in% missingdates_data1$newdate),]

missingdates_data_tmax1 <- missingdates_data1[,c(15,9)]#TMAX
missingdates_data_tmax1$newdate <- as.Date(missingdates_data_tmax1$newdate)

missingdates_data_tmin1 <- missingdates_data1[,c(15,10)]#TMIN
missingdates_data_tmin1$newdate <- as.Date(missingdates_data_tmin1$newdate)

#Makes colnames the same for merging
names(dailymax1) <- names(missingdates_data_tmax1)
names(dailymins1) <- names(missingdates_data_tmin1)

#adding dates w/ NCDC data to ForestGEO met tower data
dailymax1_missingadded <- full_join(missingdates_data_tmax1,dailymax1)
dailymins1_missingadded <- full_join(missingdates_data_tmin1,dailymins1)

#Adding no data dates to ForestGEO met tower data
missingdates_nodata1$newdate <- as.Date(missingdates_nodata1$date)
missingdates_nodata1 <- missingdates_nodata1[,2]

dailymax1_missingadded <- full_join(dailymax1_missingadded,missingdates_nodata1)
dailymins1_missingadded <- full_join(dailymins1_missingadded,missingdates_nodata1)

dailymax1_missingadded <- dailymax1_missingadded[order(dailymax1_missingadded$newdate),]
dailymins1_missingadded <- dailymins1_missingadded[order(dailymins1_missingadded$newdate),]

#convert NA's to -99.9 (how climpact reads NA)
dailymax1_missingadded[is.na(dailymax1_missingadded$TMAX),2] <- -99.9
dailymins1_missingadded[is.na(dailymins1_missingadded$TMIN),2] <- -99.9

#Makes the csv files
d1 <- cbind(dailymax1_missingadded, dailymins1_missingadded[,2])
d1 <- separate(d1, "newdate", c("Year", "Month", "Day"), sep = "-")
d1$precip <- -99.9
d1 <- d1[,c(1,2,3,6,4,5)] #make sure years are in ascending order
write.csv(d1, file = "SCBI_mettower_data_sensor1.csv", row.names = FALSE) #change name of file






#Sensor 2 Post-climpact identification of missing dates####
#Identical to Sensor 1 method
dailymax2 <- read_csv("dailymaxes_sensor2.csv")
dailymins2 <- read_csv("dailymins_sensor2.csv")

missingdates2 <- read_csv("SCBI_mettower_dailymeans_sensor2.txt.missing_dates.csv", col_names = "date")

missingdates2$date <- strptime(as.character(missingdates2$date), "%m/%d/%Y")
missingdates2$date <- format(missingdates2$date, "%Y-%m-%d")

dailymax2$Group.1 <- as.Date(dailymax2$Group.1)

missingdates_data2 <- NCDC_NOAA_precip_temp[NCDC_NOAA_precip_temp$newdate %in% missingdates2$date,]

missingdates_nodata2 <- missingdates2[!(missingdates2$date %in% missingdates_data2$newdate),]

missingdates_data_tmax2 <- missingdates_data2[,c(15,9)]
missingdates_data_tmax2$newdate <- as.Date(missingdates_data_tmax2$newdate)

missingdates_data_tmin2 <- missingdates_data2[,c(15,10)]
missingdates_data_tmin2$newdate <- as.Date(missingdates_data_tmin2$newdate)

names(dailymax2) <- names(missingdates_data_tmax2)
names(dailymins2) <- names(missingdates_data_tmin2)

dailymax2_missingadded <- full_join(missingdates_data_tmax2,dailymax2)
dailymins2_missingadded <- full_join(missingdates_data_tmin2,dailymins2)

missingdates_nodata2$newdate <- as.Date(missingdates_nodata2$date)
missingdates_nodata2 <- missingdates_nodata2[,2]

dailymax2_missingadded <- full_join(dailymax2_missingadded,missingdates_nodata2)
dailymins2_missingadded <- full_join(dailymins2_missingadded,missingdates_nodata2)

dailymax2_missingadded <- dailymax2_missingadded[order(dailymax2_missingadded$newdate),]
dailymins2_missingadded <- dailymins2_missingadded[order(dailymins2_missingadded$newdate),]

dailymax2_missingadded[is.na(dailymax2_missingadded$TMAX),2] <- -99.9
dailymins2_missingadded[is.na(dailymins2_missingadded$TMIN),2] <- -99.9

d2 <- cbind(dailymax2_missingadded, dailymins2_missingadded[,2])
d2 <- separate(d2, "newdate", c("Year", "Month", "Day"), sep = "-")
d2$precip <- -99.9
d2 <- d2[,c(1,2,3,6,4,5)] #make sure years are in ascending order
write.csv(d2, file = "SCBI_mettower_data_sensor2.csv", col.names = FALSE, row.names = FALSE) #change name of file
