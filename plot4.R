# This script is part of COurse project 1 of "Exploratory Data Analysis"
# It generates Plot 4 which is a combination of 4 different plots

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

# export plot to png
png(file = "plot4.png", bg = "transparent", type = "cairo-png") # default size is 480*480

par(mfcol = c(2, 2))

# first plot : Global_active_power vs time
with(data, plot(DateTime,Global_active_power, type = "n",
                xlab = NA, ylab = "Global Active Power"))
with(data, lines(DateTime,Global_active_power))

# Second plot : Energy sub metering vs time
with(data, plot(DateTime,Sub_metering_1, type = "n", xlab = NA, ylab = "Energy sub metering"))
with(data, lines(DateTime,Sub_metering_1, col = "black"))
with(data, lines(DateTime,Sub_metering_2, col = "red"))
with(data, lines(DateTime,Sub_metering_3, col = "blue"))
legend("topright", lty = 1, col = c("black","red","blue"), bty = "n",
       legend = grep("Sub_metering",names(data), value = TRUE))

# third plot : Voltage vs time
with(data, plot(DateTime,Voltage, type = "n",
                xlab = "datetime", ylab = "Voltage"))
with(data, lines(DateTime,Voltage))

# fourth plot : lobal_reactive_power vs time
with(data, plot(DateTime,Global_reactive_power, type = "n",
                xlab = "datetime", ylab = "Global Reactive Power"))
with(data, lines(DateTime,Global_reactive_power))

dev.off()
