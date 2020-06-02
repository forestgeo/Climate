##########

### Investigate CRU data of site of Choice!
### Developed by: Bianca Gonzalez, bianca.glez94@gmail.com

### OBJECTIVE:
# make plots of all variables showing the variable over time for site of choice!
# look at plots and see if there is any descrepancy in data 

# Make sure to install packages below with install.packages('PACKAGENAMEHERE') if you dont have them

#these are the packages
##########
library(readr)
library(ggplot2)
library(plotly)
library(anytime) 
##########
# Data 

path_to_climate_data <- "https://raw.githubusercontent.com/forestgeo/Climate/master/Gridded_Data_Products/Historical%20Climate%20Data/CRU_v4_03/"
v<- c("cld", "dtr", "frs", "pet", "pre", "tmn", "tmp", "tmn", "tmx", "vap", "wet")
objs<- vector(mode = "list", length = length(v))
counter <- 0

for(clim_v in v) { # so this is saying clim_v is each climate variable (v)
  
  counter<- counter + 1 
  print(paste0(clim_v, " ", counter))
  objs[[counter]]<-read.csv(paste0(path_to_climate_data, clim_v, ".1901.2018-ForestGEO_sites-5-20.csv")) 
  names(objs)[counter] <- clim_v # assign names to list 
}

#### purpose: select site of choice and all its climate vars and visualize them! ----

# prep vectors for for loop - to save dfs and plots 
df_sps<- vector(mode = "list", length = length(objs))
plot_list = list() # to save plots later

##### vector of sites to loop through ------- 

sites <- objs[[1]]$sites.sitename

### HOW TO VISUALIZE! CHANGE SITE INDEX BELOW!
#If trying to use this tool to visualize the site of choice,  look at sites, pick index of the given site 
# we are interested in -- and then change the site in the first & second line in the for loop

# IE in sites[54] is Smithsonian_Conservation_Biology_Institute 
sites

for(i in seq_along(objs)){
  
  #select only BCI records in clim data 
  print(paste0("visualizing site ", sites[5], " for  ", toupper(v[i]))) ### CHANGE SITE INDEX HERE - for site of choice
  df_sps[[i]] <- objs[[i]][match(sites[5], objs[[i]]$sites.sitename),] ### CHANGE SITE INDEX HERE - for site of choice
  
  # adding a col that will show the climate variable (ie cld or pet)
  df_sps[[i]]$clim<-  gsub(names(objs[i]), v[i], names(objs[i]), ignore.case = FALSE)
  
  # make into df objects to plot
  df<- as.data.frame(df_sps[[i]])
  
  #reshape data for plot
  df_long<- reshape(df, 
                    times =gsub("X", "", names(df)[-1]),
                    timevar = "Date", 
                    varying = list(colnames(df[-1])), 
                    v.names = paste0(df$clim),
                    direction = "long",
  )
  
  # months are already selected so we can do a spring, summer, fall readings
  ##### change the months (03 is march 06 is June) to see months you are interested in displayed 
  ### makes it easier to read chart - can comment out to view all data
  
  #df_long<- df_long[grep("03|06|12",substr(df_long$Date,6,7)),] 
  
  # fix data formats
  df_long$Date<- anytime::anydate(df_long$Date)
  df_long[[3]]<- as.numeric(df_long[[3]]) #3 is the column of the clim var we need to convert to numeric! 
  #
  
  ggplot(df_long, aes(x=Date, y=df$clim))+geom_point()
  p = ggplot(df_long, aes_string(x="Date", y=paste0(names(df_long[3]))))+geom_point() + theme(axis.text.x = element_text(angle = 90, vjust = 1, hjust=1)) + theme(axis.text.y = element_text(angle = 90, vjust = 1, hjust=1))+ggtitle(paste0(unique(df_long[,1])))
  
  plot_list[[i]] = p
  while (!is.null(dev.list()))  dev.off() ## online hack to cannot shut down null device 
  
  ##### to save to tiff - also need to change wd 
  # file_name = paste("iris_plot_", i, ".tiff", sep="")
  # tiff(file_name)
  # print(plot_list[[i]])
  # dev.off()
}

#### if we want to view the plots without saving them use plot_list[[i]] -- change i to a number between 1-11

plot_list[[2]] # plot for CLD 
plot_list[[9]] # plot for TMX

## if we want to view the graphs in more detail use ggplotly function for interactivity ( you can zoom in for interested years)
ggplotly(plot_list[[1]])

####  Summary for BCI ####

#Clim var data was averaged for the ~ first thirty years creating inconsistent data 

# CLD data: 1901 - 1932 the data for months are constant 
# DTR: 1901 - 1940 constant and again from 1991 to 2010
# FRS: 0 NO DATA
# PET: 1901 - 1924
# PRE: 1904 - 1916
# tmn: 1901 - 1932
# TMP: 1901 - 1917
# TMX: 1901 - 1914
# VAP: 1901 - 1928
# WET: 1901 - 1936

####  Summary for Scotty Creek ####

ggplotly(plot_list[[11]])
# frs is averaged for March, Nov, Feb all years
# wet filled with some averages 1908 -1940 



