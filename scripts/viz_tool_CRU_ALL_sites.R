##########

### Investigate CRU data for all sites
### Developed by: Bianca Gonzalez, bianca.glez94@gmail.com

### OBJECTIVE:
# make plots of all variables showing the variable over time for all sites
# manually look at plots and see if there is any descrepancy in data 

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

#### purpose: visualize all sites & their CRU climate vars ----

# prep vectors for for loop - to save dfs and plots 
sites <- objs[[1]]$sites.sitename
df_sps<- vector(mode = "list", length = length(objs)*length(sites))
plot_list = list() # to save plots later

counter<-0
for(j in sites){
  for(i in seq_along(objs)){

    counter <- counter +1 # gonna need 69 sites X 11 variables so 759 plots 
    print(paste0("this is the counter # ", counter)) # to debug
    
    print(paste0("visualizing site ", j, " for  ", toupper(v[i])))    # look at all records for each variable
    df_sps[[counter]] <- objs[[i]][match(j, objs[[i]]$sites.sitename),] 
 
    # adding a col that will show the climate variable (ie cld or pet) 
    df_sps[[counter]]$clim<-  gsub(names(objs[i]), v[i], names(objs[i]), ignore.case = FALSE)
    
    df<- as.data.frame(df_sps[[counter]]) # make df object for plot
    
    df_long<- reshape(df, #reshape data for plot
                      times =gsub("X", "", names(df)[-1]),
                      timevar = "Date", 
                      varying = list(colnames(df[-1])), 
                      v.names = paste0(df$clim),
                      direction = "long",
    )
    
    # fix data formats
    df_long$Date<- anytime::anydate(df_long$Date)
    df_long[[3]]<- as.numeric(df_long[[3]]) #3 is the column of the clim var we need to convert to numeric! 
    
    # months are already selected so we can do a spring, summer, fall readings
    ##### change the months (03 is march 06 is June) to see months you are interested in displayed 
    ### makes it easier to read chart - can comment out to view all data
    #df_long<- df_long[grep("03|06|12",substr(df_long$Date,6,7)),] 
    
    p = ggplot(df_long, aes_string(x="Date", y=paste0(df$clim)))+geom_point() + theme(axis.text.x = element_text(angle = 90, vjust = 1, hjust=1)) + theme(axis.text.y = element_text(angle = 90, vjust = 1, hjust=1))+ggtitle(unique(df_long[,1]))
    
    plot_list[[counter]] = p
    names(plot_list)[[counter]] <- paste0(j, " ",toupper(v[i])) # add plot list name 
    
    while (!is.null(dev.list()))  dev.off() ## online hack to error 'cannot shut down null device' 
    
  }
}


#### if we want to view the plots call using below instructions

## can also just open plot_list object
plot_list[[paste0(sites[1], " ", toupper(v[1]))]] ## CHANGE site index to site of choice and v index to clim var of choice
plot_list[["Amacayacu CLD"]]  ## or manually type in Site name with climvar of interest (in caps)

## if we want to view the graphs in more detail use ggplotly function for interactivity
ggplotly(plot_list[["Amacayacu CLD"]])
