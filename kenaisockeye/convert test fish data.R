library(lubridate)
library(stringr)
## read in data
testFish <- read.csv(file.choose(), stringsAsFactors = FALSE)
## change column names
colnames(testFish) <- c("Fishery", "Date", "nStations","StationID", "StationCount", "Daily", "Cumulative", "AverageLength", "Comments")
#rename fisheries
testFish$Fishery[testFish$Fishery == "North Kalgin Test Fishery"] <- "North Kalgin"
testFish$Fishery[testFish$Fishery == "Anchor Point Test Fishery"] <- "Anchor Point"
testFish$Fishery <- factor(testFish$Fishery)
## change date format with lubridate
theDay  <- ymd(str_split_fixed(testFish$Date, " " ,2 )[,1])
theTime <- hms(str_split_fixed(testFish$Date, " " ,2 )[,2])
testFish$Date <- theDay + theTime
testFish$Date <- force_tz(testFish$Date, "America/Anchorage")

#Combine fishery and station ID
testFish$allIDs <- paste(testFish$Fishery, testFish$StationID)
## save
save(testFish, file = "testFish.rda")



#Try out the plotting
#prestuff
testFish$Comment[testFish$Comment != ""] <- "*"
dates <- unique(testFish$Date[testFish$Comment != ""] )
#plot
ggplot(data = testFish, aes(x = Date, y = StationCount, color = allIDs, fill = allIDs)) +
  geom_bar(stat = "identity") +
  ggtitle("Total Test Fish Caught in Cook Inlet") +
  ylab("Total Fish") +
  annotate("text",
           x=unique(testFish$Date[testFish$Comment != ""],
           y=1,
           label="*", size = 8)

#show grid of comments on test fish
 grid.table(d = unique(testFish[testFish$Comment != "", c(2, 9)]),
           show.rownames = FALSE)

mdy(theDay)
