# data preparation 

# use dplyr package
library("dplyr", lib.loc="~/R/win-library/3.1")

# read data from file, keping in mind separator and missing data
ecd0 <- read.table("household_power_consumption.txt", 
                   header = TRUE, ## save header
                   sep = ";", ## data separated with semicolumn
                   na.strings = "?", ## ? means "no data", so we mark them as NA
                   strip.white=TRUE) ## remove extra spaces from text fields

# see dimension ...
dim(ecd0)
# [1] 2075259       9

# and stucture of data
str(ecd0)
# 'data.frame':  2075259 obs. of  9 variables:
#  $ Date                 : Factor w/ 1442 levels "1/1/2007","1/1/2008",..: 342 342 342 342 342 342 342 342 342 342 ...
# $ Time                 : Factor w/ 1440 levels "00:00:00","00:01:00",..: 1045 1046 1047 1048 1049 1050 1051 1052 1053 1054 ...
# $ Global_active_power  : num  4.22 5.36 5.37 5.39 3.67 ...
# $ Global_reactive_power: num  0.418 0.436 0.498 0.502 0.528 0.522 0.52 0.52 0.51 0.51 ...
# $ Voltage              : num  235 234 233 234 236 ...
# $ Global_intensity     : num  18.4 23 23 23 15.8 15 15.8 15.8 15.8 15.8 ...
# $ Sub_metering_1       : num  0 0 0 0 0 0 0 0 0 0 ...
# $ Sub_metering_2       : num  1 1 2 1 1 2 1 1 1 2 ...
# $ Sub_metering_3       : num  17 16 17 17 17 17 17 17 17 16 ...

# remove unused column Global_intensity
ecd_sel <- select(ecd0, -Global_intensity)

# filter only 2 days we need:  2007-02-01 and 2007-02-02.
ecd_fltr <- filter(ecd_sel, Date == "1/2/2007" | Date == "2/2/2007")
# we have 2880 objects (2*24hours*60 minutes)
# looks fine

# str(ecd_fltr)
# 'data.frame':  2880 obs. of  8 variables:
# $ Date                 : Factor w/ 1442 levels "1/1/2007","1/1/2008",..: 16 16 16 16 16 16 16 16 16 16 ...
# $ Time                 : Factor w/ 1440 levels "00:00:00","00:01:00",..: 1 2 3 4 5 6 7 8 9 10 ...
# $ Global_active_power  : num  0.326 0.326 0.324 0.324 0.322 0.32 0.32 0.32 0.32 0.236 ...
# $ Global_reactive_power: num  0.128 0.13 0.132 0.134 0.13 0.126 0.126 0.126 0.128 0 ...
# $ Voltage              : num  243 243 244 244 243 ...
# $ Sub_metering_1       : num  0 0 0 0 0 0 0 0 0 0 ...
# $ Sub_metering_2       : num  0 0 0 0 0 0 0 0 0 0 ...
# $ Sub_metering_3       : num  0 0 0 0 0 0 0 0 0 0 ...

# put "Date" and "Time" character fields together before convering to date-time format
# sep ="-" used to make separator between date and time, it will be used in format string in next step
ecd_dt <- mutate(ecd_fltr, dtime = paste (Date, Time, sep ="-", collapse = NULL))

# convert dtime characted field to date-time
dt99 = strptime(ecd_dt$dtime, format="%d/%m/%Y-%H:%M:%S")

# Add "dtim" date-time field to final dataset
ecd_dt$dtim <- dt99

# data reading and preparation done
# ecd_dt is final dataset

# make plot 1: Global Active Power histogram
hist(ecd_dt$Global_active_power, 
     col = "red", ## set color of columns to red
     main = "Global Active Power", ## set histogram title
     xlab = "Global Active Power (kilowatts)") ## make x axis label more readable

## Copy my plot to a PNG file
dev.copy(png, file = "plot1.png")

## Don't forget to close the PNG device!
dev.off()
