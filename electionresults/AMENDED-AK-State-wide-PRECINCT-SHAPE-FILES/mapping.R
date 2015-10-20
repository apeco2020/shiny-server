require("rgdal") # requires sp, will use proj.4 if installed
library("maptools")
require("ggplot2")
require("plyr")
library(rgeos)
library(stringr)
library(ggmap)

oldWD <- getwd()
setwd("AMENDED-AK-State-wide-PRECINCT-SHAPE-FILES")
anc = readOGR(dsn=".", layer="SW Amended Precinct shape files")
anc@data$id = rownames(anc@data)
anc.points = fortify(anc, region="id")
anc.df = join(anc.points, anc@data, by="id")
anc@data$id = rownames(anc@data)
anc.points = fortify(anc, region="id")
setwd(oldWD)

#They don't match up
#anc.df <-anc.df[anc.df$DISTRICT %in% voting_precincts,]

districts <- as.numeric(str_split_fixed(anc.df$DISTRICT, "-",2)[,1])

anc.df<- anc.df[districts >= 12 &
                districts <= 27 |
                anc.df$DISTRICT %in% c("11-225", "11-230", "12-235"),]

names_to_change <- read.csv("change_district_names_from_voting_to_map.csv")
       
for(i in seq(dim(names_to_change)[1])) {
  
  levels(anc.df$DISTRICT)[levels(anc.df$DISTRICT) == 
                          names_to_change$maping[i]] <- as.character(names_to_change$voting[i])
  
}

anc.df <- anc.df[!nchar(as.character(anc.df$DISTRICT)) == 6,]

anc.df <- select(anc.df, long, lat, group, DISTRICT, id)

save(anc.df, file = "precinct_polygons.rda")


anc  <- get_map(location = c(-149.85, 61.15), zoom = 6)
gird <- get_map(location = c(-149.3, 60.95), zoom = 10)
eagl <- get_map(location = c(-149.45, 61.32), zoom = 11)


