##  1. Download the data 
library(data.table)
if (!file.exists('.exdata-data-household_power_consumption.zip')) {
        fileUrl = 'http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
        download.file(fileUrl,'.exdata-data-household_power_consumption.zip', mode = 'wb')
        unzip(".exdata-data-household_power_consumption.zip", exdir = './')
}
##  2. Load the table and then extract the data from the target dates (Feb 1 and 2, 2007) into a dataframe
##     The second plot only requires the date, time, and Global Power columns (1-3) so the rest are dropped
##     on load.

col_to_drop <- c(6)
all_rows <- fread("household_power_consumption.txt", header=TRUE, sep = ';', na.strings="?", drop=col_to_drop,data.table=F)
all_rows$Date <- as.Date(all_rows$Date, format="%d/%m/%Y") 
plot_data <- all_rows[(all_rows$Date=="2007-02-01") | (all_rows$Date=="2007-02-02"),]
plot_data <- transform(plot_data, daytime=as.POSIXct(paste(Date,Time)))

##  3. Reset and Construct the plot

if (dev.cur() != 1) 
{dev.off()}

par(mfrow=c(2,2),cex=.6)

##  First of 4 plots
plot(plot_data$daytime, plot_data$Global_active_power,type="l",xlab="",ylab="Global Active Power")

##  Second of 4 plots
plot(plot_data$daytime, plot_data$Voltage,type="l",xlab="datetime",ylab="Voltage")

##  Third of 4 plots
plot(plot_data$daytime, plot_data$Sub_metering_1,type="l",xlab="",ylab="Energy sub metering")
lines(plot_data$daytime,plot_data$Sub_metering_2,col="red")
lines(plot_data$daytime,plot_data$Sub_metering_3,col="blue")
legend("topright",
       col=c("black","red","blue"), c("Sub_metering_1   ","Sub_metering_2   ","Sub_metering_3   "),
       lty=c(1,1),bty="n", cex=.6)

##  Fourth of 4 plots
plot(plot_data$daytime, plot_data$Global_reactive_power,type="l",
     xlab="datetime",ylab="Global_reactive_power")


##  4. Copy the full plot to the PNG file

dev.copy(png, file="plot4.png", width = 480, height = 480)
dev.off()