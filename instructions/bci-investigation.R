##########

### Investigate CRU data of Barrio Colorado Island (BCI)
### Developed by: Bianca Gonzalez, bianca.glez94@gmail.com

### OBJECTIVE:
# make plots of all variables showing the variable over time 
# look at plots and see if there is any descrepancy in data 

##########
library(readr)
library(ggplot2)
library(plotly)
library(anytime) 
##########
# Data 
files <- list.files("S:/Global Maps Data/CRU/v4.03", pattern = ".csv", full.names = T) #replace with CRU data online
objs<- sapply(files, read_csv, simplify=FALSE) # put files in a large list

#### purpose: select the basso_caolorado site from every climate file ----

# prep vectors for for loop - to save dfs and plots 
df_sps<- vector(mode = "list", length = length(objs))
v<- c("cld", "dtr", "frs", "pet", "pre", "tmn", "tmp", "tmn", "tmx", "vap", "wet")
plot_list = list() # to save plots later

# vector of sites to loop through
sites <- objs[[1]]$sites.sitename

for(i in seq_along(files)){
  
  #select only BCI records in clim data 
  print(paste0("visualizing site ", sites[54]))
  df_sps[[i]] <- objs[[i]][match(sites[54], objs[[i]]$sites.sitename),] 
 # df_sps[[i]] <- objs[[i]][objs[[i]]$sites.sitename=="Barro_Colorado_Island",]
  
  # also add a col that will show the climate variable (ie cld or pet)
  df_sps[[i]]$clim<-  gsub(names(objs[i]), v[i], names(objs[i]), ignore.case = FALSE)
  
  # make into df objects to plot
  df<- as.data.frame(df_sps[[i]])
  
  # select only one record per month for all years
  
  #reshape data for plot
  
  df_long<- reshape(df, 
                    times =gsub("X", "", names(df)[-1]),
                    timevar = "Date", #maybe has to be year?
                    varying = list(colnames(df[-1])), 
                    v.names = paste0(df$clim),
                    direction = "long",
  )
  
  # months are already selected so we can do a spring, summer, fall readings
  df_long<- df_long[grep("03|06|12",substr(df_long$Date,6,7)),] 
  
  # shorter time windows to easily visualize data 
  df_long$Date<- anytime::anydate(df_long$Date)
  # make scale from char to numeric for clim vars
  df_long[[3]]<- as.numeric(df_long[[3]])
  
  # 1901-1930, 1931-1960, 1961-1990, 1991 -2018
  
  ggplot(df_long, aes(x=Date, y=df$clim))+geom_point()
  
  p = ggplot(df_long, aes_string(x="Date", y=paste0(df$clim)))+geom_point() + theme(axis.text.x = element_text(angle = 90, vjust = 1, hjust=1)) + theme(axis.text.y = element_text(angle = 90, vjust = 1, hjust=1))
  #scale_y_continuous(names(df_long[3]), limits=)
  
  plot_list[[i]] = p
  while (!is.null(dev.list()))  dev.off() ## online hack to cannot shut down null device 
  
  ##### to save to tiff - also need to change wd 
  # file_name = paste("iris_plot_", i, ".tiff", sep="")
  # tiff(file_name)
  # print(plot_list[[i]])
  # dev.off()
}

## if we want to view the graphs in more detail use ggplotly function for interactivity

ggplotly(plot_list[[11]])

####  Summary ####

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

#df_sps[[i]] <- objs[[1]][objs[[1]]$sites.sitename=="Barro_Colorado_Island",]
