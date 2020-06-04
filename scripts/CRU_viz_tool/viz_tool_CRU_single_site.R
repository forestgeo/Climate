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
library(viridis)  
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

  ## add months column in really nonpleasant code 
  df_long<- df_long %>%
    mutate(months=ifelse(Date %in% df_long[grep("01",substr(df_long$Date,6,7)),][[2]], "Jan",
                         ifelse(Date %in% df_long[grep("02",substr(df_long$Date,6,7)),][[2]], "Feb",
                                ifelse(Date %in% df_long[grep("03",substr(df_long$Date,6,7)),][[2]], "Mar",
                                       ifelse(Date %in% df_long[grep("04",substr(df_long$Date,6,7)),][[2]], "Apr",
                                              ifelse(Date %in% df_long[grep("05",substr(df_long$Date,6,7)),][[2]], "May",
                                                     ifelse(Date %in% df_long[grep("06",substr(df_long$Date,6,7)),][[2]], "Jun",
                                                            ifelse(Date %in% df_long[grep("07",substr(df_long$Date,6,7)),][[2]], "Jul",
                                                                   ifelse(Date %in% df_long[grep("08",substr(df_long$Date,6,7)),][[2]], "Aug",
                                                                          ifelse(Date %in% df_long[grep("09",substr(df_long$Date,6,7)),][[2]], "Sep",
                                                                                 ifelse(Date %in% df_long[grep("10",substr(df_long$Date,6,7)),][[2]], "Oct",
                                                                                        ifelse(Date %in% df_long[grep("11",substr(df_long$Date,6,7)),][[2]], "Nov",
                                                                                               ifelse(Date %in% df_long[grep("12",substr(df_long$Date,6,7)),][[2]], "Dec","NA")))))))))))))
  #making months a factor now for viz purposes 
  df_long$months <- factor(df_long$months, levels = month.abb)
  
  # add geom_point if we prefer geom_point scatterplots
  p = ggplot(df_long, aes_string(x="Date", y=paste0(names(df_long[3]))))+ #geom_point()+ 
    theme(axis.text.x = element_text(angle = 90, vjust = 1, hjust=1))+ 
    theme(axis.text.y = element_text(angle = 90, vjust = 1, hjust=1))+
    ggtitle(paste0(unique(df_long[,1])))+ geom_line(aes(color = months))+
    scale_color_viridis(discrete = TRUE, option = "D") # change option to A,B,C, or D for other color schemes
  
  plot_list[[i]] = p
  while (!is.null(dev.list()))  dev.off() ## online hack to cannot shut down null device 
  
  ##### to save to tiff - also need to change wd 
  # file_name = paste("CRU_plot", i, ".tiff", sep="")
  # tiff(file_name)
  # print(plot_list[[i]])
  # dev.off()
}

#### if we want to view the plots without saving them use plot_list[[i]] -- change i to a number between 1-11

plot_list[[5]] # plot for CLD 
plot_list[[9]] # plot for TMX

## if we want to view the graphs in more detail use ggplotly function for interactivity ( you can zoom in for interested years)
ggplotly(plot_list[[1]])


