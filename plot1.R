# This script is part of COurse project 1 of "Exploratory Data Analysis"
# It generates Plot 1 which is an histogram of Global_active_power variable

# Source data is assumed to be located in ./data/ folder in R working directory

library(data.table)
library(lubridate)

# part 1 : Load the data ####

data <- fread("data/household_power_consumption.txt", header = TRUE, sep = ";",
              na.strings = "?", colClasses = "character")

# combine date and time to a single variable
data[,DateTime:= dmy_hms(paste(Date,Time))]
data$Date <- NULL
data$Time <- NULL

# Subset : we consider only data from the dates 2007-02-01 and 2007-02-02
start  <- ymd("2007-02-01")
end    <- ymd("2007-02-02")
period <- interval(start,end)
data   <- data[DateTime %within% period,]

# Convert to numeric
data <- data[, lapply(.SD, as.numeric), by=DateTime] # convert data to numeric

# part 2 : generate the plot ####

png(file = "plot1.png", bg = "transparent", type = "cairo-png") # default size is 480*480
hist(data$Global_active_power, col = "red",
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)")
dev.off()



