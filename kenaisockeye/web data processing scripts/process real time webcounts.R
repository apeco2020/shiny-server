library(XML)
library(lubridate)


u <- "C:\\Users\\Hans T\\Desktop\\webcounts.htm"
rt_dat <- readHTMLTable(u)[[length(readHTMLTable(u))]]
colnames(rt_dat) <- c("Date", "Count", "Cumulative", "Notes")
rt_dat$Count <- as.numeric(gsub(",", "", as.character(rt_dat$Count)))
rt_dat$Date <- mdy(paste(rt_dat$Date, "2014", sep = "-"))
#Catch for unit efforet (CFUE) MODEL
C <- -20.29183
A <-  3.2209791
rt_dat$cfue_estimates <- (A * log(rt_dat$Count, exp(1))) + C
rt_dat$cfue_estimates[rt_dat$cfue_estimates <= 0] <- 0
rt_dat <- rt_dat[!is.na(rt_dat$Count),]
rt_dat2 <- rt_dat
save(rt_dat2, file = "C:\\Users\\Hans T\\Documents\\GitHub\\dipnet_app\\data\\rt_dat.rda")
rm(list = ls())
load("C:\\Users\\Hans T\\Desktop\\dipnet_app_revamp\\rt_dat.rda")


