## check to see if packages that are needed are installed. if not, install them.
list.of.packages <- c("sqldf")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

filename <- "epc.zip"

## Download and unzip the dataset:
if (!file.exists(filename)){
      fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
      download.file(fileURL, filename)
}  
if (!file.exists("household_power_consumption")) { 
      unzip(filename) 
}
##read data for two days
input <- read.csv.sql("household_power_consumption.txt","select * from file where Date = '1/2/2007' or Date = '2/2/2007' ",sep=";")

##set labels and titles, make sure input is numeric
xlabel = "Global Active Power (kilowatts)"
title="Global Active Power"
plotdata<-as.numeric(input$Global_active_power)

##prepare png and write to the file
png(file = "plot1.png", width = 480, height = 480, units = "px")
hist(plotdata, col="red",main=title, xlab=xlabel)
dev.off() 
