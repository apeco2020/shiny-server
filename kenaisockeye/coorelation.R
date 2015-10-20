library(ggplot2)

load("C:\\Users\\Hans T\\Downloads\\cfue_kenai_dipnet.rda") 

sonar2012 <- obj[obj$year == 2012 &
             as.Date(obj$date) >= as.Date("2012-07-11", format = "%Y-%m-%d") &
             as.Date(obj$date) <= as.Date("2012-08-01", format = "%Y-%m-%d"),]

sonar2011 <- obj[obj$year == 2011 &
                   as.Date(obj$date) >= as.Date("2011-07-11", format = "%Y-%m-%d") &
                   as.Date(obj$date) <= as.Date("2011-08-01", format = "%Y-%m-%d"),]

sonar2010 <- obj[obj$year == 2010 &
                   as.Date(obj$date) >= as.Date("2010-07-11", format = "%Y-%m-%d") &
                   as.Date(obj$date) <= as.Date("2010-08-01", format = "%Y-%m-%d"),]



ticket <- cfue_kenai_dipnet

dat <- data.frame(
                  rbind(sonar2010 , sonar2011, sonar2012),              
                  c(ticket[,2], ticket[,3], ticket[,4]))

names(dat)[4]  <- "cfue"
names(dat)[2]  <- "sonar_counts"
dat$year <- factor(dat$year)
kenai_dip_data <- dat
save(kenai_dip_data, file = "kenai_dip_data.rda")

##Proof of autocorrlation of a day
plot(dat$cfue[1:65], dat$sonar_counts[2:66])

ggplot(data = dat, aes(y = cfue, x = sonar_counts)) + geom_point(aes(size = 1)) +
  geom_smooth(method = "lm", formula=y~log(x, exp(1)-1), level = 0.99999999999999)

dat <- data.frame(
  rbind(sonar2010, sonar2011, sonar2012),              
  c(ticket[,2], ticket[,3], ticket[,4]))

names(dat)[4]  <- "cfue"
names(dat)[2]  <- "sonar_counts"
dat$year <- factor(dat$year)
