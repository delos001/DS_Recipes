# In this file:
#  factor
#  Rockchalk example
#  Loop through and change multiple columns to factor

#------------------------------------------------------------------------------
# creates a factor in which if 
#   number killed is above 118.5, yields 'above'.  
#   if below 118.5, yields 'below'

data(Seatbelts)
Seatbelts <- as.data.frame(Seatbelts)
Seatbelts$Month <- seq(from = 1, to = nrow(Seatbelts))
Seatbelts <- subset(Seatbelts, select = c(DriversKilled, Month))
killed <- factor(Seatbelts$DriversKilled > 118.5, 
            labels = c("below", "above"))
month <- factor(Seatbelts$Month > 96.5, 
            labels = c("below", "above"))


#------------------------------------------------------------------------------
# ROCKCHALK EXAMPLE
#------------------------------------------------------------------------------
rockchalk contains the 'combineLevels' function
takes the two different levels in the Sex column and combines them into a new level 
    (ie: combines Male and Female into a new level called category)
library(rockchalk)
df2$Adult<-combineLevels(df2$SEX,levs=c("M","F"),"ADULT")


#------------------------------------------------------------------------------
# LOOP
#------------------------------------------------------------------------------
df = c(25:44, 46:59)
for(i in df){
            data1[,i] <- as.factor(data1[,i])
}
