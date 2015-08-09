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

# drawing plot 2: Global Active Power by date-time
with(ecd_dt, 
     plot(dtim,           # x axis - date time 
     Global_active_power, # y axis - Global Active Power
     xlab = "",           # without x axis label 
     ylab ="Global Active Power (kilowatts)", # more readable y axis label
                  type="l" )) # dots connected with line

## Copy my plot to a PNG file
dev.copy(png, file = "plot2.png")

## Don't forget to close the PNG device!
dev.off()
