## loading libraries
library(dplyr)
library(lubridate)
library(Hmisc)

## loading the data

#memory requirements
#memory required (in MB) = no. of columns * no. of rows * 8 bytes/numeric
ncol <- 2075259
nrow <- 9
memory.estimate <- ncol * nrow * 8 / (2 ^ 20)
print(memory.estimate)

#as my computer has enough memory, I can load the entire data set
#I downloaded and extracted the data manually
setwd(
      "C:/Users/claudia.brem/Desktop/R_Skripte/coursera/3_Exploratory_Data_Analysis/exdata_data_household_power_consumption/"
)
data <-
      read.table(file = "household_power_consumption.txt", sep = ";", header = TRUE)

#data$Date <- as.character(data$Date)
data <- mutate(data, Date = dmy(Date))
data <- filter(data, 
               Date == as.Date("2007-02-01") | Date == as.Date("2007-02-02")
)

# transform variables
data$Global_active_power <- as.numeric(as.character(data$Global_active_power))
data[, 3:9] <- sapply(data[ , 3:9], as.character)
data[, 3:9] <- sapply(data[ , 3:9], as.numeric)
data <- mutate(data, DateTime = paste(Date, Time, sep = " "))
data$DateTime <- ymd_hms(data$DateTime)

## making plots
png("plot4.png", width = 480, height = 480)

#my system language is German, but I guess it's not part of the project to change this ;)
#hence the slightly different units on the xlabel
par(mfrow = c(2,2))

#plot 1
plot(data$DateTime, data$Global_active_power, 
     type = "l",
     xlab = "",
     ylab = "Global Active Power")

#plot 2
plot(data$DateTime, data$Voltage,
     type = "l",
     xlab = "datetime",
     ylab = "Voltage",
     yaxt = "n")
axis(side = 2, seq(234, 246, 4))
#add minor tick marks
#minor.tick(nx=1, ny=2, tick.ratio=1)

#plot 3
color <- c("black", "red", "blue")
plot(data$DateTime, data$Sub_metering_1, 
     col = color[1],
     type = "l",
     xlab = "",
     ylab = "Energy sub metering", 
     yaxt = "n")
lines(data$DateTime, data$Sub_metering_2,
      col = color[2])
lines(data$DateTime, data$Sub_metering_3,
      col = color[3])
axis(side = 2, seq(0, 30, 10))
legend(x = "topright", 
       legend = names(data[, 7:9]), 
       col = color,
       lwd = 1,
       bty = "n")

#plot 4
plot(data$DateTime, data$Global_reactive_power,
     type = "l",
     xlab = "datetime",
     ylab = "Global_reactive_power",
     yaxt = "n")
axis(side = 2, seq(0.0, 0.5, 0.1))

dev.off()
