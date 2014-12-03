# This script is part of COurse project 1 of "Exploratory Data Analysis"
# It generates Plot 2 which displays the Global_active_power as a function of weekday

# Source data is assumed to be located in ./data/ folder in R working directory

# Setup ####

library(data.table)
library(lubridate)
Sys.setlocale("LC_TIME", "English") # this is to get week days in english
                                    # (for windows - Rstudio)

# part 1 : Load the data ####

data <- fread("data/household_power_consumption.txt", header = TRUE, sep = ";",
              na.strings = "?", colClasses = "character")

# combine date and time to a single variable
data[,DateTime:= dmy_hms(paste(Date,Time))]
data$Date <- NULL
data$Time <- NULL

# Subset : we consider only data from the dates 2007-02-01 and 2007-02-02
start  <- ymd("2007-02-01")
end    <- ymd("2007-02-03")
period <- interval(start,end) # 2 days period
data   <- data[DateTime %within% period,]

# Convert to numeric
data <- data[, lapply(.SD, as.numeric), by=DateTime] # convert data to numeric

# part 2 : generate the plot ####

# first compute the average Global_active_power (GAP) per weekday
# data[,weekday := wday(data$DateTime, label = TRUE)]
# meanGAP <- data[, test=mean(Global_active_power), by = weekday]

# export plot to png
png(file = "plot2.png", bg = "transparent", type = "cairo-png") # default size is 480*480
with(data, plot(DateTime,Global_active_power, type = "n", xlab = NA, ylab = "Global Active Power (kilowatts)"))
with(data, lines(DateTime,Global_active_power))
dev.off()


