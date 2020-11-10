##########
### Investigate CRU data for all sites
### Developed by: Bianca Gonzalez, bianca.glez94@gmail.com
### OBJECTIVE: # identify years data is filled with averages
### Created June 2020

##########
library(readr)
library(ggplot2)
library(plotly)
library(anytime) 
library(dplyr)
library(padr)
library(viridis)
##########

# Clean environment ####
rm(list = ls())

#### Sites --------
# ForestGeo sites (and their locations) found in github (all 69)
ForestGEO_sites <- read.csv("https://raw.githubusercontent.com/forestgeo/Site-Data/master/ForestGEO_site_data.csv")

# See comments @ end of code for site indices
fsites<-c("Smithsonian Environmental Research Center","Harvard Forest"                            
,"Smithsonian Conservation Biology Institute", "Lilly Dickey Woods"                        
,"Ordway-Swisher"                             ,"Yosemite National Park"                    
,"Wind River"                                 ,"Utah Forest Dynamics Plot"                 
,"Huai Kha Khaeng"                            ,"Barro Colorado Island",
"Zofin", "Scotty Creek")       

## reconstructing by one to debug
#fsites <- c("Barro Colorado Island", "Scotty Creek")
# write.csv for the current final sites 


# Sites in climate data have _ so replace space with _ to match later
fsites<- gsub(" ", "_", fsites)

#### Climate data -----

path_to_climate_data <- "https://raw.githubusercontent.com/forestgeo/Climate/master/Climate_Data/CRU/CRU_v4_04/"
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
    
    # clean up data: date formats, climvar column, ordering the vector for later analysis.
    storage.vess[[counter]]$Date<- anytime::anydate(storage.vess[[counter]]$Date) # change to Date format
    storage.vess[[counter]]$climvar <- rep(names(storage.vess[[counter]])[3], times=nrow(storage.vess[[counter]])) # add the climvar column here (needs to be index)
    storage.vess[[counter]][,"month"] <- format(storage.vess[[counter]][,"Date"], "%m") # add month col for later processing! --
    storage.vess[[counter]]<-storage.vess[[counter]][order(as.numeric(storage.vess[[counter]]$month)),] # order the columns by month so we can use the RLE function 

    storage.vess[[counter]]<- storage.vess[[counter]] %>%
      rename(climvar.class =climvar,
             climvar.val = names(storage.vess[[counter]][3]))
    
    # ## We'll want to exclude frs=0
    storage.vess[[counter]]<-storage.vess[[counter]] %>% filter(climvar.class != "frs")
    storage.vess[[counter]]$month <-as.integer(storage.vess[[counter]]$month) # make months ints for later analysis

  }
}

### now for the length of storage vess: 12 different month and dfs combos --
months_list<- vector(mode="list", length=length(storage.vess)*12) # one for each month

  counter = 0
    for(m in 1:12){
      for(i in 1:length(storage.vess)){  # so 12 months per cld # 12 * 11 (sites - climvar - month combos)
        
        ## first 11 (climvars) are dfs of each location with climvar -- 12 month combos per df 
        ## 12 months and 166 dataframes with climvar data per sites so 12 * # of dfs

      counter = counter+1
      print(paste0("month ", m, " i ", i, " counter for dataframes from storage vess (made of 11 diff climvars and each site) ", counter))
      months_list[[counter]]<- storage.vess[[i]] %>%  dplyr::filter(climvar.class ==storage.vess[[i]]$climvar.class[1] & month ==m)
      
      #### REPS MONTH ANALYSIS --------------------
      if(nrow(months_list[[counter]]) !=0){ # if the dataframe is empty dont go in here
        
        repsmo<- rle(months_list[[counter]][,3])
        end = cumsum(repsmo$lengths)
        start = c(1, lag(end)[-1] + 1) # https://stackoverflow.com/questions/43875716/find-start-and-end-positions-indices-of-runs-consecutive-values
        start.end.indices <-data.frame(start,end) #lags by one - shifts to the left , -1 puts it back ot original place and +1 adds the number to index (c(1)) - lag maintains length
        
        start.df<-months_list[[counter]][start,] # add colanmes to start and end values
        end.df<- months_list[[counter]][end,]
        colnames(start.df) <- paste0('start_', colnames(start.df))
        colnames(end.df) <- paste0('end_', colnames(end.df))
        
        df.indices<-cbind(start.df,end.df) # bind both dataframes 
        rownames(df.indices)<-c(1:nrow(df.indices)) #change rownames to sequential order 
        selection<-cbind(df.indices, start.end.indices) # add start and end indices column
        selection$rep.yrs <-selection$end -selection$start # 0 is a 0 
        selection<- selection %>% filter(selection$rep.yrs>=2) # grab only repitions greater than 2 years
        selection$rep.yrs <- selection$rep.yrs+1 # add one to all instances to account for start years
        months_list[[counter]]<- selection
        
        # ## arrange for ease of viewing, select only relevent variables
        months_list[[counter]]<-months_list[[counter]] %>% arrange(desc(rep.yrs))
        months_list[[counter]]<- months_list[[counter]][c('start_sites.sitename', 'start_Date', 'start_climvar.val', 'start_climvar.class', 'start_month', 'end_Date', 'rep.yrs')] 
        
        # # ## grab years only for start / end dates
        months_list[[counter]]$start_Date<-as.numeric(format(months_list[[counter]]$start_Date,"%Y"))
        months_list[[counter]]$end_Date<-as.numeric(format(months_list[[counter]]$end_Date,"%Y"))
        
        # # ## Exclude frs=0
        months_list[[counter]]<-months_list[[counter]] %>% filter(start_climvar.class != "frs" & start_climvar.val !=0)
      }
  }
}

  ## make DF from list above
  sites_reps<-do.call("rbind", months_list)
  sites_reps<- sites_reps %>% rename(month = start_month) #rename startmonth to month

    
#----#----#----#----#----#----#----#----#----#----#----#----#----#----#----#----#----#----#----#----#----#----#----#----
sites_reps$nyears<- sites_reps$end_Date- sites_reps$start_Date+1
problemsites<- sites_reps[sites_reps$nyears != sites_reps$rep.yrs,]  #make sure there are none and reconcile 

## without the problem sites
sites_reps<- sites_reps[sites_reps$nyears == sites_reps$rep.yrs,] 

## add col with number of dates missing
sites_reps$n.missing <- sites_reps$nyears - sites_reps$rep.yrs

##change wd
setwd(paste0(getwd(), "/Climate_Data/CRU/scripts/CRU_gaps_analysis"))

##write.csv remember to always include row.names = FALSE.
#write.csv(sites_reps, "all_sites.reps.csv", row.names = FALSE)

## write csv of problem sites where rep years wont be accurate due to jumps in data 
#write.csv(problemsites, "problem_sites.csv", row.names=FALSE)

#site.index<- c(55,18,54,34,45,68,64,61,21,5)
#fsites<-ForestGEO_sites$Site.name[site.index]
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

## scotty Creek is missing some values so fill them in 
pad(storage.vess[[125]], interval = "month")
pre_BCI %>% complete(Date = seq.Date(min(Date), max(Date), by="month"))
