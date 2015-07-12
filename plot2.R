# Uses package "readr" for faster reading from files
# install.packages("readr")
library(readr)

# Download input file if not present
if (!file.exists("household_power_consumption.txt")) {
  temp <- tempfile()
  download.file(
    "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
    temp
  )
  unzip(temp, "household_power_consumption.txt")
  unlink(temp)
}

# Read all the data
colTypes <- list(
  Date = col_date("%d/%m/%Y"),
  Time = col_character(),
  Global_active_power = col_double(),
  Global_reactive_power = col_double(),
  Voltage = col_double(),
  Global_intensity = col_double(),
  Sub_metering_1 = col_double(),
  Sub_metering_2 = col_double(),
  Sub_metering_3 = col_double()
)

data <- read_delim(
  "household_power_consumption.txt",
  col_types = colTypes,
  delim = ";",
  na = "?"
)

# Use the subset of two dates and forget the rest
subset <- data[which(data$Date =='2007-02-01' | data$Date == "2007-02-02"),]
rm(data)

# Plot the whole timeline of 2880 observations as a line graph
dateTimes <- strptime(paste(subset$Date, subset$Time), format="%Y-%m-%d %H:%M:%S")
plot(
  dateTimes,
  subset$Global_active_power,
  type="l",
  col="black",
  ylab="Global active power (kilowatts)",
  xlab=""
)

# Copy the active device to png (this way is easier for debugging)
dev.copy(png,'plot2.png')
dev.off()