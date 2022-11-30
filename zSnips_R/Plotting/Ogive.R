
# An ogive is a cumulative frequency polygon.  
# Steep slopes identify where sharp increases in frequencies occur.  
# Construct an ogive of age distribution defined earlier.  
# (The following calculation could be done using a "for" loop.) 

tumor<-read.csv(file.path("C:/Users/Jason/Desktop/","tumor.csv"),
                sep=',')

# defines the class boundaries (age in this example)
# sets object 'result' to group the age by the classes specified above.  
#         Does the from left to right (or high to low)
# creates a table of the result object above
classes <- c(0,20,40,60,80,100)
result <- cut(tumor$age, 
              breaks = classes, 
              right = FALSE)
count <- table(result)


# This defines cum.count as a numeric vector
# sets cum.count[1] as count[1] which is the count of first class: 7
# sets cum.count[2] as sum of cum.count[1] plus count of second class frequency: 7+35
# reats through each class frequency
cum.count<- numeric(0)
cum.count[1]<-count[1]
cum.count[2]<-cum.count[1] + count[2]
cum.count[3]<-cum.count[2] + count[3]
cum.count[4]<-cum.count[3] + count[4]
cum.count[5]<-cum.count[4] + count[5]
cum.count   # cumulative frequency in table (7+35=42, 42+88=130, 130+68=198, 198+7=205

# plots cum.count values for each class midpoint in red
#         and chart title, xlabel, ylabel, and sets the xlim as 0-100

plot(center, 
     cum.count,
     type = 'b',
     col = 'red',
     main = 'Ogive of Age Distribution',
     xlab = 'Age Class Midpoints',
     ylab = 'Cumulative Freq',
     xlim = c(0,100))
# plots average cum.count (cum.count for each class divided by total n of 205), 
#         type b, color red, xlabel, chart title, xlimits and ylabel
plot(center, 
     cum.count/n, 
     type = "b", 
     col = "red", 
     xlab = "Age Class Midpoints", 
     main = "Ogive of Cumulative Relative Frequencies", 
     xlim = c(0, 100),
     ylab = "Cumulative Relative Frequency")
