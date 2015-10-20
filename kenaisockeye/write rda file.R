library(lubridate)
library(stringr)

load(file ="C:\\Users\\Hans T\\Desktop\\fish_counts.rda")
sonar_df <- obj 

month <- str_split_fixed(as.character(sonar_df$date), "-", 3)[,2]
day <- str_split_fixed(str_split_fixed(as.character(sonar_df$date), "-", 3)[,3], " ", 2)[,1]
sonar_df$date <- ymd(paste("2014", month, day, sep = "-"))



tide_df <- read.table( "C:\\Users\\Hans T\\Desktop\\dipnet_app\\kenai_tides.txt", sep="\t",
                       skip = 19, header = TRUE)

day_time <- hm(tide_df$Day)
dates <- ymd(gsub("/", "-",as.character(tide_df$Date)))
times <- dates + day_time
times <- with_tz(times, "America/Anchorage")

tide_df <- data.frame(times, height = tide_df$Time)
rm(obj)
rm(day_time)
rm(times)
rm(dates)

save(sonar_df, tide_df, file = "kenai_data.rda")

load("kenai_data.rda")


