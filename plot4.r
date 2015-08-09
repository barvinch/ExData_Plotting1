# data preparation 

# use dplyr package
library("dplyr", lib.loc="~/R/win-library/3.1")
# read data from file, keping in mind separator and missing data
ecd0 <- read.table("household_power_consumption.txt", 
                   header = TRUE, ## save header
                   sep = ";", ## data separated with semicolumn
                   na.strings = "?", ## ? means "no data", so we mark them as NA
                   strip.white=TRUE) ## remove extra spaces from text fields
# remove unused column Global_intensity
ecd_sel <- select(ecd0, -Global_intensity)
# filter only 2 days we need:  2007-02-01 and 2007-02-02.
ecd_fltr <- filter(ecd_sel, Date == "1/2/2007" | Date == "2/2/2007")
# put "Date" and "Time" character fields together before convering to date-time format
# sep ="-" used to make separator between date and time, it will be used in format string in next step
ecd_dt <- mutate(ecd_fltr, dtime = paste (Date, Time, sep ="-", collapse = NULL))
# convert dtime characted field to date-time
dt99 = strptime(ecd_dt$dtime, format="%d/%m/%Y-%H:%M:%S")
# Add "dtim" date-time field to final dataset
ecd_dt$dtim <- dt99

# data reading and preparation done
# ecd_dt is final dataset

# change parameters before making plot 
par(mfrow = c(2, 2), ## 4 histograms, 2*2 by rows 
    mar = c(4, 4, 2, 1), ## smaler margins
    cex = 0.75)  ## fonts 75% of default

# plot 4.1 is like plot 2 (Global Active Power by date-time) with small differences
with(ecd_dt, plot(dtim, Global_active_power, xlab = "", ylab ="Global Active Power", type="l" ))

# plot 4.2, Voltage by date-time
with(ecd_dt, plot(dtim, Voltage, xlab = "datetime", type="l" ))

#plot 4.3 is like plot 3 (Energy sub metering by date-time) with small differences
with(ecd_dt, 
{
  plot(dtim, Sub_metering_1, xlab = "", ylab ="Energy sub metering", type="l" )
  points(dtim, Sub_metering_2, col = "red", type="l" )
  points(dtim, Sub_metering_3, col = "blue", type="l" ) })

legend("topright", 
       bty="n", ## no legend box
       lty=c(1,1,1),
       lwd=c(1.5,1.5,1.5),
       col = c("black", "red", "blue"), 
       legend = c("Sub metering 1", "Sub metering 2", "Sub metering 3"))

# plot 4.4 Global reactive power by date-time
with(ecd_dt, plot(dtim, Global_reactive_power, xlab = "datetime", type="l" ))


## Copy my plot to a PNG file
dev.copy(png, file = "plot4.png")

## Don't forget to close the PNG device!
dev.off()
