# I haven't matched "13-260 Centennial Park" yet. 

library(dplyr)
library(ggmap)
library(shiny)
library(leaflet)
#load ggmap maps
load("osm_map.rda")
#load election results
load("voting_results.rda")
#load polygons of precints
load("precinct_polygons.rda")

race <- "Ballot Measure 2 - 13PSUM"

yeses <- voting_results %>%
  filter(Race == race) %>%
  filter(Value == "YES") %>%
  select(n)

noes <- voting_results %>%
  filter(Race == race) %>%
  filter(Value == "NO") %>%
  select(n, DISTRICT)

registered <- voting_results %>%
  filter(Race == race) %>%
  filter(Value == "Registered Voters") %>%
  select(n, DISTRICT)  

summarized <- cbind(registered, var = yeses$n  / (noes$n + yeses$n))
summarized$DISTRICT <- factor(summarized$DISTRICT)
summarized <- arrange(summarized, var)
summarized$DISTRICT <- factor(summarized$DISTRICT,
                              levels = as.character(summarized$DISTRICT)) 

registered <- cbind(registered, turnout = (noes$n + yeses$n) / registered$n)
registered$DISTRICT <- factor(registered$DISTRICT)
registered <- arrange(registered, turnout)
registered$DISTRICT <- factor(registered$DISTRICT,
                              levels = as.character(registered$DISTRICT)) 

sum(noes$n) - sum(yeses$n)

summarized <- cbind(summarized, passed = summarized$var > .5)

mapping_obj <- inner_join(summarized, anc.df, by="DISTRICT")

#anc <- get_map("anchorage, AK", zoom = 8)
p <- ggmap(anc)
p +  geom_polygon(data = mapping_obj, aes(long,lat,group=DISTRICT, color = factor(as.character(passed))), color = "black", alpha = 0.5) +
  scale_fill_continuous(guide = guide_legend(title = "Yes on 2"))


ggplot(data = mapping_obj, aes(long,lat,group=DISTRICT, fill = passed)) +
  geom_polygon() + geom_path(color = "white")

ggplot(data = summarized, aes(x = var)) + geom_histogram(binwidth = 0.01)

ggplot(data = filter(mapping_obj, var > median(mapping_obj$var)), aes(DISTRICT, var)) + 
  geom_bar(stat = "identity", aes(label = DISTRICT)) +
  coord_flip() +
  labs(title = "var in Anchorage Precincts - Nov. 2014",
       y = "Percent of mapping_obj Voters That Casted Ballots",
       x = "Precinct")+
  ylim(c(0, 1))

ggplot(data = filter(mapping_obj, var <= median(mapping_obj$var)), aes(DISTRICT, var)) + 
  geom_bar(stat = "identity", aes(label = DISTRICT)) +
  coord_flip() + 
  labs(title = "var in Anchorage Precincts - Nov. 2014",
       y = "Percent of mapping_obj Voters That Casted Ballots",
       x = "Precinct") +
  ylim(c(0, 1))

median(summarized$var)
mean(summarized$var)

filter(summarized, var < .5)
