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

input$Global_active_power<-as.numeric(input$Global_active_power)

##write to png with 2 rows and 2 columns
par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))
with(input, {
      plot(Global_active_power~DateTime, type="l", 
           ylab="Global Active Power", xlab="")
      plot(Voltage~DateTime, type="l", 
           ylab="Voltage", xlab="", cex=0.8)
      plot(Sub_metering_1~DateTime, type="l", 
           ylab="Global Active Power", xlab="")
      lines(Sub_metering_2~DateTime,col='Red')
      lines(Sub_metering_3~DateTime,col='Blue')
      legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, bty="n",
             legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
      plot(Global_reactive_power~DateTime, type="l", 
           ylab="Global Rective Power",xlab="")
})
dev.copy(png, file="plot4.png", height=480, width=480)
dev.off()
