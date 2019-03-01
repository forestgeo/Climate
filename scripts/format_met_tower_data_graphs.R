##read in the met tower data and reformat

setwd("C:/Users/mcgregori/Dropbox (Smithsonian)/Github_Ian/Climate/Met_Station_Data/SCBI/ForestGEO_met_station-SCBI")

#read and reformat met data ####
data_2019 <- read.csv("C:/Users/mcgregori/Dropbox (Smithsonian)/Github_Ian/Climate/Met_Station_Data/SCBI/ForestGEO_met_station-SCBI/SCB_Metdata_5min_2019.csv", header=FALSE, stringsAsFactors = FALSE)

#remove unnecessary rows
test <- data_2019[-c(1,4),]

#combine descriptor rows (variable and unit) into one, then make them the headers
test <- rbind(paste0(test[1,], sep="_", test[2,]), test[3:nrow(test),], stringsAsFactors=FALSE)

colnames(test) <- test[1,]
test <- test[-1,]

#convert date into usable format
#"tz" should be changed depending on the location source of the weather data
library(lubridate)
test$TIMESTAMP_TS <- mdy_hm(test$TIMESTAMP_TS, tz="EST")

#can also split timestamp into two different columns and format from there
##library(tidyr)
##test <- test %>%
##separate(TIMESTAMP_TS, c("date", "time"), " ")

#convert missing data code NaN to NA
test$`WS_WVc(1)_m/s` <- gsub("NAN", NA, test$`WS_WVc(1)_m/s`)

#convert data into numeric class
test[] <- lapply(test, function(x) {
  if(is.character(x)) as.numeric(as.character(x)) else x
})
sapply(test, class)



#make graphs from data ####
## Numbers 1-7 are simple graphs made with ggplot.
## Numbers 8-9 are attempts at more complex graphs, with 9 using plot function. Both need more troubleshooting if going to use.

#basic graphs of 5-minute averages:
library(ggplot2)

##to make a pdf of any combination of graphs, simply do the following:
setwd()
pdf(file="2017_Weather_Stats.pdf", width=12) #before running the graph scripts

dev.off() #after running the graph scripts

#1 solar radiation Kipp&Zonen ####
ggplot(data = test) +
  aes(x = TIMESTAMP_TS, y = `RadTot_KZ_Avg_W/m2`) +
  geom_line(color = "#0c4c8a") +
  ggtitle("Solar radiation Kipp&Zonen in 5-min. average") +
  labs(x="Timestamp", y="Solar radiation (W/m2)") +
  theme_grey()

#2 solar radiation LiCOR ####
ggplot(data = test) +
  aes(x = TIMESTAMP_TS, y = `RadTot_Li_Avg_W/m2`) +
  geom_line(color = "#0c4c8a") +
  ggtitle("Solar radiation LiCOR in 5-min. average") +
  labs(x="Timestamp", y="Solar radiation (W/m2)") +
  theme_grey()

#3 air temperature sensor 2 ####
##sensor 1 in 2018 regularly recorded temps of -60C
ggplot(test, aes(x=TIMESTAMP_TS)) + 
  #geom_line(aes(y = T_Air1_Avg_C, color = "Sensor 1")) + 
  geom_line(aes(y = T_Air2_Avg_C, color = "Sensor 2")) +
  labs(title= "Air temperature by Sensor in 5-min. average", x= "Timestamp", y= "Air temperature (C)") +
  theme(legend.position = "right") +
  theme_grey()

#4 relative humidity ####
ggplot(data = test) +
  aes(x = TIMESTAMP_TS, y = `RH_Avg_%`) +
  geom_line(color = "#0c4c8a") +
  ggtitle("Relative Humidity in 5-min. average") +
  labs(x="Timestamp", y="Relative humidity (%)") +
  theme_grey()

#5 wind speed ####
ggplot(data = test) +
  aes(x = TIMESTAMP_TS, y = `WS_WVc(1)_m/s`) +
  geom_line(color = "#0c4c8a") +
  ggtitle("Wind Speed in 5-min. average") +
  labs(x="Timestamp", y="Wind Speed (m/s)") +
  theme_grey()

#6 precipitation ####
ggplot(data = test) +
  aes(x = TIMESTAMP_TS, y = Prec_Tot_mm) +
  geom_line(color = "#0c4c8a") +
  ggtitle("Precipitation in 5-min. average") +
  labs(x="Timestamp", y="Precipitation(mm)") +
  theme_grey()

#7 battery voltage of box ####
ggplot(data = test) +
  aes(x = TIMESTAMP_TS, y = BattV_Avg_V) +
  geom_line(color = "#0c4c8a") +
  ggtitle("Battery voltage in 5-min. average") +
  labs(x="Timestamp", y="Battery Volatage (V)") +
  theme_grey()

#8 relative humidity (line) and temperature (bar) ####
##needs more troubleshooting
ggplot(test, aes(x=TIMESTAMP_TS, y="RH_Avg_%")) + 
  geom_bar(aes(fill=T_Air1_Avg_C),stat='identity', position='identity') + 
  scale_fill_grey() +
  geom_line(aes(x=TIMESTAMP_TS,color="RH"),size=1) +
  ggtitle("Air temperature and Relative humidity") + 
  labs(x = "Timestamp", y = "%") +
  theme_grey()

#9 horizontal wind speed and direction (2 different axes) ####
#taken from https://stackoverflow.com/questions/6142944/how-can-i-plot-with-2-different-y-axes

##when using plot as opposed to ggplot, need to convert timestamp from POSIXct to an identifiable range. Plot enables you to build the graph from the ground up, but requires you give it more direction.
striptime() maybe

##Get the range of the wind speed (direction is in degrees). This is the ylim of the first plot.
range(test$`WS_WVc(1)_m/s`, na.rm=TRUE)

## add extra space to right margin of plot within frame
par(mar=c(5, 4, 4, 6) + 0.1)

## Plot first set of data and draw its axis
plot(x=test$TIMESTAMP_TS, y=test$'WS_WVc(1)_m/s', pch=16, axes=FALSE, ylim=c(0,6),
     xlab="", ylab="", type="b",col="black", main="Wind speed and direction")
axis(2, ylim=c(0,6),col="black",las=1)  ## las=1 makes horizontal labels
mtext("Wind speed m/s",side=2,line=2.5)
box()

## Allow a second plot on the same graph
par(new=TRUE)

## Plot the second plot and put axis scale on right
plot(x=test$TIMESTAMP_TS, y=test$'WS_WVc(2)_m/s', pch=15, 
     xlab="", ylab="", ylim=c(0,360), axes=FALSE, type="b", col="red")
## a little farther out (line=4) to make room for labels
mtext("Wind direction (degrees)",side=4,col="red",line=4) 
axis(4, ylim=c(0,360), col="red",col.axis="red",las=1)

## Draw the time axis
axis(1,pretty(range(test$TIMESTAMP_TS),10))
mtext("Timestamp",side=1,col="black",line=2.5)  
