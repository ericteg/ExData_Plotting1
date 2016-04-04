##  1. Download the data 
library(data.table)
if (!file.exists('.exdata-data-household_power_consumption.zip')) {
        fileUrl = 'http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
        download.file(fileUrl,'.exdata-data-household_power_consumption.zip', mode = 'wb')
        unzip(".exdata-data-household_power_consumption.zip", exdir = './')
}
##  2. Load the table and then extract the data from the target dates (Feb 1 and 2, 2007) into a dataframe
##     The first plot only requires the date, time, and Global Power columns (1-3) so the rest are dropped
##     on load.

col_to_drop <- c(4:9)
all_rows <- fread("household_power_consumption.txt", header=TRUE, sep = ';', na.strings="?", drop=col_to_drop,data.table=F)
all_rows$Date <- as.Date(all_rows$Date, format="%d/%m/%Y") 
plot_data <- all_rows[(all_rows$Date=="2007-02-01") | (all_rows$Date=="2007-02-02"),]

##  3. Reset and Construct the plot

dev.off()
hist(plot_data$Global_active_power,main="Global Active Power",col="red",xlab="Global Active Power (kilowatts)")

##  4. Copy the plot to the PNG file

dev.copy(png, file="plot1.png", width = 480, height = 480)
dev.off()
