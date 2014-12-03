library(data.table)
library(lubridate)

# load data
# note: fread is not able to read the data as numeric values because of the "?"
data <- fread("data/household_power_consumption.txt", header = TRUE, sep = ";",
              na.strings = "?", colClasses = "numeric")

data[,DateTime:= dmy_hms(paste(Date,Time))] # combine date and time to a single variable
data$Date <- NULL
data$Time <- NULL

# Subset, we consider only data from the dates 2007-02-01 and 2007-02-02

start <- ymd("2007-02-01")
end   <- ymd("2007-02-02")
period <- interval(start,end)

data <- data[DateTime %within% period,]

# Concert to numeric

data <- data[, lapply(.SD, as.numeric), by=DateTime] # convert data to numeric
