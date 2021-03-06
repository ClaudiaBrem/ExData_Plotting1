## loading libraries
library(dplyr)
library(lubridate)

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

## making plots
data$Global_active_power <- as.numeric(as.character(data$Global_active_power))
data <- mutate(data, DateTime = paste(Date, Time, sep = " "))
data$DateTime <- ymd_hms(data$DateTime)

png("plot2.png", width = 480, height = 480)

#my system language is German, but I guess it's not part of the project to change this ;)
#hence the slightly different units on the xlabel
plot(data$DateTime, data$Global_active_power, 
     type = "l",
     xlab = "",
     ylab = "Global Active Power (kilowatts)")
dev.off()
