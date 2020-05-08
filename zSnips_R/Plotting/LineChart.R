


#----------------------------------------------------------
# BASIC EXAMPLE
#----------------------------------------------------------
ggplot(propdf) + 
geom_line(aes(x=volVal,
              y=propI), 
          color='red',
          size=1)+
  geom_line(aes(x=volVal,
                y=propA), 
            color='blue',
            size=1)
  
  
  
#----------------------------------------------------------
# GRID ARRANGE EXAMPLE
#----------------------------------------------------------
grid.arrange(
ggplot(data=VolMean,
       aes(x = CLASS, 
           y = VOLUMEc, 
           group = SEX, 
           colour = SEX))+
  geom_line(size=1)+
  geom_point(size=2.5)+
  ggtitle('Mean Volume vs. Class \n Grouped by Sex'),

ggplot(data = RatMean,
       aes(x = CLASS, 
           y = RATIOc, 
           group = SEX, 
           colour = SEX))+
  geom_line(size = 1)+
  geom_point(size = 2.5)+
  ggtitle('Mean Volume vs. Class \n Grouped by Sex'),
  ncol=2,
  top='test')


#----------------------------------------------------------
# FREQ OVER TIME EXAMPLE
#----------------------------------------------------------

library(plyr)
library(ggplot2)

timestamps_month = count(data, 
                         vars = "year")
timestamps_month$status = c(rep("past",9), "current")

ggplot(data = timestamps_month) + 
geom_bar(aes(x = year, 
             y = freq, 
             fill = year), 
         stat = "identity", 
         position = "dodge")

ggplot(data = timestamps_month, 
       aes(x = year, 
           y = freq, 
           group = status, 
           color = status)) + 
ylim(0,300) +
geom_line() +
geom_point(aes(shape=status, 
               size=0.5)) + 
ggtitle("National Transportation Safety Board Aviation Accident Data: Fatal US Events 
        data from: https://www.ntsb.gov/_layouts/ntsb.aviation/index.aspx")
