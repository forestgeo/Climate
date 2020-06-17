##########
### Investigate CRU data for all sites
### Developed by: Bianca Gonzalez, bianca.glez94@gmail.com
### OBJECTIVE: # identify years data is filled with averages

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

#### Sites --------
# ForestGeo sites (and their locations) found in github (all 69)
ForestGEO_sites <- read.csv("https://raw.githubusercontent.com/forestgeo/Site-Data/master/ForestGEO_site_data.csv")

# See comments @ end of code for site indices
site.index<- c(55,18,54,34,45,68,64,61,21,5)
fsites<-ForestGEO_sites$Site.name[site.index]

# Sites in climate data have _ so replace space with _ to match later
fsites<- gsub(" ", "_", fsites)

#### Climate data -----

path_to_climate_data <- "https://raw.githubusercontent.com/forestgeo/Climate/master/Gridded_Data_Products/Historical%20Climate%20Data/CRU_v4_04/"
v<- c("cld", "dtr", "frs", "pet", "pre", "tmn", "tmp", "tmn", "tmx", "vap", "wet")
objs<- vector(mode = "list", length = length(v))
counter <- 0

for(clim_v in v) { #  clim_v is each climate variable (v)
  
  counter<- counter + 1 
  print(paste0(clim_v, " ", counter))
  objs[[counter]]<-read.csv(paste0(path_to_climate_data, clim_v, ".1901.2019-ForestGEO_sites-6-03.csv")) 
  names(objs)[counter] <- clim_v # assign names to list 
  
  # adding a col that will show the climate variable (ie cld or pet) 
  objs[[counter]]$clim<-  gsub(names(objs[counter]), v[counter], names(objs[counter]), ignore.case = FALSE)

}

#### Select the CRU data with the fsites (final sites) -----

# CRU data with final sites and storage vessel list for the long format of data
CRU_fsites <- vector(mode="list", length=length(fsites)*length(v)) # I should have ten of each site (so fsites*v)
storage.vess<- vector(mode="list", length=length(fsites)*length(v)) # and I should have a storage vessel with just as manny 

counter=0
for(j in fsites){ # 110 times because 11 clim vars and 10 sites 
  for(i in seq_along(v)){
  
    # i is seq # 1-11 of climvar objs ----- j is fsite raw - smithsonian ---- counter is the iterative # ie 110
    # for each climvar in objs we should have a smithsonian for cld smithsonian for dtr etc et
    #### Select only FSITES from climvar data 
    counter <- counter +1 # running fsites* clim vars
    print(paste0(j," counter # ", counter, " and clim var ", names(objs[i])))
    
    CRU_fsites[[counter]] <- objs[[i]][match(j, objs[[i]]$sites.sitename),] #go through each climvar and find the specified J aka site
    #### Transform data to long format
    df<- as.data.frame(CRU_fsites[[counter]]) # make df object

    df_long<- reshape(df, #reshape data for plot
                      times =gsub("X", "", names(df)[-1]),
                      timevar = "Date",
                      varying = list(colnames(df[-1])),
                      v.names = paste0(df$clim),
                      direction = "long",)

    storage.vess[[counter]]<- df_long # store newly reshaped data in new storage vessel
    names(storage.vess)[counter] <- j
    
    storage.vess[[counter]][,2]<- anytime::anydate(storage.vess[[counter]][,2]) # change to Date format
    storage.vess[[counter]]$climvar <- rep(names(storage.vess[[counter]])[3], times=nrow(storage.vess[[counter]])) # add the climvar column here
    storage.vess[[counter]][,"month"] <- format(storage.vess[[counter]][,"Date"], "%m") # add month col for later processing! --
    storage.vess[[counter]]<-storage.vess[[counter]][order(as.numeric(storage.vess[[counter]]$month)),] # order the columns by month so we can use the RLE function 
  
    repsnum <- rle(storage.vess[[counter]][,3]) # num of reps in the ordered vector
    
    # Compute star/end indices of run 
    end = cumsum(repsnum$lengths)
    start = c(1, lag(end)[-1] + 1) # https://stackoverflow.com/questions/43875716/find-start-and-end-positions-indices-of-runs-consecutive-values
    start.end.indices <-data.frame(start,end) #lags by one - shifts to the left , -1 puts it back ot original place and +1 adds the number to index (c(1)) - lag maintains length
    
    # now that we have start/end indices we can use the index to grab the values of that df for start / end 
    # grab all indices of the start/end values and then only retain the numbers of start/end output if the difference of start/end is >2
    
    start.df<-storage.vess[[counter]][start,] # add colanmes to start and end values
    end.df<- storage.vess[[counter]][end,]
    colnames(start.df) <- paste0('start_', colnames(start.df))
    colnames(end.df) <- paste0('end_', colnames(end.df))
    
    df.indices<-cbind(start.df,end.df)
    rownames(df.indices)<-c(1:nrow(df.indices)) #change rownames to sequential order 
    selection<-cbind(df.indices, start.end.indices) # add start and end indices column
    
    # if end - start >=2 then that means there are more or 3 consecutive years with the same value! (select only these)
    selection$rep.yrs <-selection$end -selection$start # 0 is a 0 repititions, 1 is 2, and 2 is 3 so on.... b/c index 1-2 is 1 but 2 instances of reps
    
    # if rep.yrs is >=2 select those rows (ie )
    selection<- selection %>% filter(selection$rep.yrs>=2)
    selection$rep.yrs <- selection$rep.yrs+1
    
    ## add only the reps back in! 
    storage.vess[[counter]] <- selection # selection should be in a list that is length of storage vess (unique sites)
  
    ## arrange for ease of viewing
    storage.vess[[counter]]<-storage.vess[[counter]] %>% arrange(desc(rep.yrs))
  
    storage.vess[[counter]] <- storage.vess[[counter]][-c(3:7,10,13:14)]
    
    ## grab years only for start / end dates
    storage.vess[[counter]][2]<-format(storage.vess[[counter]][2],"%Y")
    storage.vess[[counter]][3]<-format(storage.vess[[counter]][3],"%Y")
    
    
    #rename the startclimvar and endclimvar column
    storage.vess[[counter]]<- storage.vess[[counter]] %>%
    rename(climvar.val =names(storage.vess[[counter]][4]),
           climvar.class =names(storage.vess[[counter]][5]),
           month =names(storage.vess[[counter]][6])) #month =names(storage.vess)))
    
    ## We'll want to exclude frs=0
    storage.vess[[counter]]<-storage.vess[[counter]] %>% filter(climvar.class != "frs" & climvar.val !=0)
           #
  #en
   
  }
}

## Dataframe generated from the list above with all the relevent info for each sites (reps/year ranges)
sites_reps<-do.call("rbind", storage.vess)

##change wd
setwd(paste0(getwd(), "/scripts/CRU_viz_tool"))

## add row nums
row.names(sites_reps)<- 1:nrow(sites_reps)

##write.csv
write.csv(sites_reps, "all_sites.reps.csv")

  # ten sites and their indices: 
  # SERC  55
  # Harvard 18
  # scbi 54
  # Lilly Dickey Woods 34 
  # Ordway-Swisher 45
  # Yosemite 68
  # Wind River 64
  # Cedar Breaks, Ut 61 
  # thailand HKK, 21
  # BCI panama, 5
  # potentially going to have the NM and Scotty sites as well
