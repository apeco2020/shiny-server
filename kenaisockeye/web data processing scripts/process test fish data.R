library(lubridate)
library(stringr)
## read in data
testFish <- read.csv(file.choose(), stringsAsFactors = FALSE)
## change column names
colnaems(testFish) <- c("Fishery", "Date", "nStations","StationID", "StationCount", "Daily", "Cumulative", "AverageLength", "Comments")
#rename fisheries
testFish$Fishery[testFish$Fishery == "North Kalgin Test Fishery"] <- "North Kalgin"
testFish$Fishery[testFish$Fishery == "Anchor Point Test Fishery"] <- "Anchor Point"
testFish$Fishery <- factor(testFish$Fishery)
## change date format with lubridate
theDay  <- ymd(str_split_fixed(testFish$Date, " " ,2 )[,1])
theTime <- hms(str_split_fixed(testFish$Date, " " ,2 )[,2])
testFish$Date <- theDay + theTime
#Combine fishery and station ID
testFish$allIDs <- paste(testFish$Fishery, testFish$StationID)
## save
save(testFish, file = "testFish.rda")

#Try out the plotting
ggplot(data = testFish, aes(x = Date, y = StationCount, color = allIDs, fill = allIDs)) +
  geom_bar(stat = "identity") +
  ggtitle("Total Test Fish Caught in Cook Inlet") +
  ylab("Total Fish")


