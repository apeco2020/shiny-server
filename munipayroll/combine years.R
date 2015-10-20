library(xlsx)

payroll2012 <- read.xlsx("2012-Anc-Muni-PayrolltsortedHighesttoLowestPaid1.xlsx",
               sheetIndex = 2, 
               header = TRUE,
               colIndex = 1:8,
               rowIndex = 1:3201)

payroll2013 <- read.xlsx("MUNI-Payroll-Password-protected2.xlsx",
               header = TRUE,
               sheetIndex = 1)


year <- 2012
payroll2012 <- cbind(payroll2012, year)
payroll2012 <- payroll2012[,-c(4,8)]
year <- 2013
payroll2013 <- cbind(payroll2013, year)

colnames(payroll2013)[59] <- "Benefits"
colnames(payroll2013)[43] <- "Earnings"


subset2013 <- data.frame(payroll2013$Name, 
           payroll2013$Job.Title, 
           payroll2013$Bargaining.Unit,
           payroll2013$Earnings, 
           payroll2013$Overtime, 
           payroll2013$Benefits,
           payroll2013$year)
colnames(subset2013) <- colnames(payroll2012)


payroll <- rbind(payroll2012, subset2013)
payroll$year <- factor(payroll$year)

payroll$Job.Title <- gsub(" II", "", payroll$Job.Title)
payroll$Job.Title <- gsub(" III", "", payroll$Job.Title)
payroll$Job.Title <- gsub(" IV", "", payroll$Job.Title)
payroll$Job.Title <- gsub(" V", "", payroll$Job.Title)
payroll$Job.Title <- gsub(" VI", "", payroll$Job.Title)

substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}
 
payroll$Job.Title <- sub('II$', '', payroll$Job.Title)
payroll$Job.Title <- sub('I$', '', payroll$Job.Title)
payroll$Job.Title <- sub('I$', '', payroll$Job.Title)
payroll$Job.Title <- sub('V$', '', payroll$Job.Title)
payroll$Job.Title <- sub('- A$', '', payroll$Job.Title)
payroll$Job.Title <- sub('- B$', '', payroll$Job.Title)
payroll$Job.Title <- gsub("Civil EngineerI - AWWU", "Civil Engineer", payroll$Job.Title)
payroll$Job.Title <- gsub("Civil Engineer - AWWU", "Civil Engineer", payroll$Job.Title)
payroll$Job.Title <- gsub("UtilitymanII ", "Utilityman", payroll$Job.Title)
payroll$Job.Title <- gsub("Senior ", "", payroll$Job.Title)


levels(factor(payroll$Job.Title))

save(payroll, file = "payroll.rda")
