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
             str_detect(dat$Race, "UNITED STATES SENATOR") |
             str_detect(dat$Race, "US REPRESENTATIVE") |
             str_detect(dat$Race, "GOVERNOR/LT GOVERNOR"  ) |
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


district_to_filter_for <- read.csv("change_district_names_from_voting_to_map.csv")

voting_results <- voting_results %>%
  filter(DISTRICT %in% district_to_filter_for$voting)

#Find difference in votes between yes and no

Yes_Votes <- voting_results %>%
  unique() %>%
  filter(Race %in% c("Ballot Measure 2 - 13PSUM", "Ballot Measure 3 - 13MINW", "Ballot Measure 4 - 12BBAY", "MOA Proposition #1")) %>%
  filter(! Value == "Registered Voters") %>%
  group_by(DISTRICT, Race) %>%
  mutate(Difference = (n - (sum(n)) + n)) %>%
  filter(Value == "YES") %>%
  select(DISTRICT, Race, Difference) %>%
  as.data.frame()
Yes_Votes <- spread(Yes_Votes, Race, Difference)
colnames(Yes_Votes) <- c(c("District", "Prop1", "Prop2", "Prop3", "Prop4"))

quantile(Yes_Votes[,2], 0.4)

Gov_Votes <- voting_results %>%
  unique() %>%
  filter(Race %in% c("GOVERNOR/LT GOVERNOR")) %>%
  filter(! Value == "Registered Voters") %>%
  group_by(DISTRICT) %>%
  mutate(Difference = (n - (sum(n)) + n)) %>%
  select(DISTRICT, Value, Difference) %>%
  as.data.frame()
Gov_Votes <- spread(Gov_Votes, Value, Difference)
colnames(Gov_Votes) <- c("District", "Clift", "Myers", "Parnell", "Walker", "Write-in")
Gov_Votes <- Gov_Votes[,-6]


House_Votes <- voting_results %>%
  unique() %>%
  filter(Race %in% c("US REPRESENTATIVE")) %>%
  filter(! Value == "Registered Voters") %>%
  group_by(DISTRICT) %>%
  mutate(Difference = (n - (sum(n)) + n)) %>%
  select(DISTRICT, Value, Difference) %>%
  as.data.frame()
House_Votes <- spread(House_Votes, Value, Difference) 
colnames(House_Votes) <- c("District", "Dunbar", "McDermott", "Write-in 50", "Young")
House_Votes <- House_Votes[,-4]

Senate_Votes <- voting_results %>%
  unique() %>%
  filter(Race %in% c("UNITED STATES SENATOR")) %>%
  filter(! Value == "Registered Voters") %>%
  group_by(DISTRICT) %>%
  mutate(Difference = (n - (sum(n)) + n)) %>%
  select(DISTRICT, Value, Difference) %>%
  as.data.frame()
Senate_Votes <- spread(Senate_Votes, Value, Difference) 
colnames(Senate_Votes) <- c("District", "Begich", "Fish", "Gianoutsos", "Sullivan", "Write-in")
Senate_Votes <- Senate_Votes[,-6]


#hist(House_Votes[,5])
n_Votes <- voting_results %>%
  unique() %>%
  filter(Race %in% c("GOVERNOR/LT GOVERNOR")) %>%
  filter(! Value == "Registered Voters") %>%
  group_by(DISTRICT) %>%
  mutate(Total_Votes = (sum(n))) %>%
  select(DISTRICT, Total_Votes) %>%
  unique() %>%
  select(-DISTRICT)

app_data <- cbind(House_Votes, n_Votes, Gov_Votes, Senate_Votes, Yes_Votes)
app_data <- app_data[!duplicated(lapply(app_data, summary))]


save(app_data, file = "app_data.rda")