# This script is part of COurse project 1 of "Exploratory Data Analysis"
# It generates Plot 3 which displays the Energy sub metering as a function of time

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
png(file = "plot3.png", bg = "transparent", type = "cairo-png") # default size is 480*480
with(data, plot(DateTime,Sub_metering_1, type = "n", xlab = NA, ylab = "Energy sub metering"))
with(data, lines(DateTime,Sub_metering_1, col = "black"))
with(data, lines(DateTime,Sub_metering_2, col = "red"))
with(data, lines(DateTime,Sub_metering_3, col = "blue"))
legend("topright", lty = 1, col = c("black","red","blue"), legend = grep("Sub_metering",names(data), value = TRUE))
dev.off()


