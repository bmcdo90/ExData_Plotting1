## check to see if packages that are needed are installed. if not, install them.
list.of.packages <- c("sqldf", "Rcpp")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

filename <- "epc.zip"

## Download and unzip the dataset if it does not exist already
if (!file.exists(filename)){
      fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
      download.file(fileURL, filename)
}  
if (!file.exists("household_power_consumption")) { 
      unzip(filename) 
}
##read the file for the two dates
input <- read.csv.sql("household_power_consumption.txt","select * from file where Date = '1/2/2007' or Date = '2/2/2007' ",sep=";")

##set date to new datetime column
dateTime <- paste(input$Date, input$Time, sep=' ')
dateTime <- strptime(dateTime, format="%d/%m/%Y %H:%M:%S")
input$DateTime <- as.POSIXct(dateTime)

ylabel = "Global Active Power (kilowatts)"
input$Global_active_power<-as.numeric(input$Global_active_power)

##write to png file
png(file = "plot2.png", width = 480, height = 480, units = "px")
plot(Global_active_power ~ DateTime, input, ylab=ylabel, type="l")
dev.off() 
