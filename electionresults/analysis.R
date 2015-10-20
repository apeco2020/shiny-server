library(stringr)
library(dplyr)

dat <- read.table("results-precinct.txt", 
               sep=",", 
               col.names= c("DISTRICT", "Race" , "Value", "Party", "","n", ""), 
               fill=FALSE, 
               strip.white=TRUE,
               row.names = NULL)
dat <- dat[,c(1,2,3,4,6)]

substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}

match_senate <- data.frame(Senate = substrRight(as.character(dat[str_detect(dat$Race, "SENATE"),]$Race), 1),
                           DISTRICT = dat[str_detect(dat$Race, "SENATE"),]$DISTRICT)

match_house <- data.frame(House = as.numeric(substrRight(as.character(dat[str_detect(dat$Race, "HOUSE"),]$Race), 2)),
                           DISTRICT = dat[str_detect(dat$Race, "HOUSE"),]$DISTRICT)



dat <- dat[str_detect(dat$Race, "MOA Proposition #1") |
#             str_detect(dat$Race, "UNITED STATES SENATOR") |
#             str_detect(dat$Race, "US REPRESENTATIVE") |
#             str_detect(dat$Race, "GOVERNOR/LT GOVERNOR"  ) |
             str_detect(dat$Race, "Ballot Measure 2 - 13PSUM" ) |
             str_detect(dat$Race, "Ballot Measure 3 - 13MINW") |
             str_detect(dat$Race, "Ballot Measure 4 - 12BBAY" ) ,]

voting_precincts <- levels(factor(str_split_fixed(dat$DISTRICT, " ", 2)[,1]))
voting_precincts <- voting_precincts[voting_precincts != "District"]

names_to_change <- read.csv("change_district_names_from_voting_to_map.csv")

dat <- dat[dat$DISTRICT %in% names_to_change$voting,]

dat <- dat[dat$Value !=  "Number of Precincts for Race" &
           dat$Value !=   "Number of Precincts Reporting" &
           dat$Value !=   "Times Counted",]

dat <- dat[,-4]

dat <- inner_join(dat, match_senate, by = "DISTRICT")
dat <- inner_join(dat, match_house, by = "DISTRICT")


dat %>%
  group_by(Race, Precinct) %>% 
  filter()
  mutate()


voting_results <- dat

save(voting_results, file = "voting_results.rda")


filtered_dat_yes <- dat %>%
                filter(Race == "Ballot Measure 2 - 13PSUM") %>%
                filter(Value == "YES") %>%
                select(n)

filtered_dat_no <- dat %>%
  filter(Race == "Ballot Measure 2 - 13PSUM") %>%
  filter(Value == "NO") %>%
  select(n)

filtered_dat_registered <- dat %>%
  filter(Race == "Ballot Measure 2 - 13PSUM") %>%
  filter(Value == "Registered Voters") %>%
  select(n)  

filtered_dat <- cbind(filtered_dat_no, var = filtered_dat_yes$n  / (filtered_dat_no$n + filtered_dat_yes$n))

mapping_obj <- inner_join(filtered_dat ,anc.df, by="DISTRICT")
 
anc <- get_map("anchorage, AK", zoom = 8)
p <- ggmap(anc)
p +  geom_polygon(data = mapping_obj, aes(long,lat,group=DISTRICT, fill = var), alpha = 0.5)


ggplot(data = mapping_obj, aes(long,lat,group=DISTRICT, fill = var)) +