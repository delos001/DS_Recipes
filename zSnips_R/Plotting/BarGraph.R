

#----------------------------------------------------------
#----------------------------------------------------------
BASE R
#----------------------------------------------------------
#----------------------------------------------------------


# EXAMPLE 1
# use cut to 
tumor <- read.csv(file.path("tumor.csv"), sep=",")

classes <- c(0,20,40,60,80,100) # define age classes
# cut identifies value in age column, assigns approp class
result <- cut(tumor$age, breaks = classes, right = FALSE)

count = table(result)
barplot(count)

# EXAMPLE 2
# manually name bins (uses "count" data from example 1)
colors = c("red", "yellow", "green", "violet", "orange") 
barplot(count, col=colors, main = "Bar Plot of Age Distribution",
        names.arg = c("[0,20)","[20,40)","[40,60)","[60,80)","[80,100)"),
        xlab = "Age Class", 
        ylab = "Frequency")

# EXAMPLE 3
# manually name bins (uses "count" data from example 1)
colors = c("red", "yellow", "green", "violet", "orange") 
barplot(count, col=colors, main = "Bar Plot of Age Distribution",
        names.arg = c("Class 1","Class 2","Class 3","Class 4","Class 5"),
        xlab = "Age Class", 
        ylab = "Frequency", 
        horiz = TRUE)






#----------------------------------------------------------
#----------------------------------------------------------
GGPLOT
#----------------------------------------------------------
#----------------------------------------------------------

#----------------------------------------------------------
# Example with multiple grouping, axis and legend
SV_ET1 = edcSV %>% 
filter(FolderSeq == 18)
ggplot(SV_ET1, aes(x = Site, 
                   fill = SiteGroup, 
                   color = Visit_Date_req > W48max)) +
  geom_bar(size = 1) +
  geom_text(aes(label = ..count..),
          stat = 'count',
          position = position_stack(vjust = 0.5), 
            color = 'black') +
  scale_fill_discrete() + 
  scale_color_manual(values = c('white', 'red')) + 
  ggtitle(label = "ET All and ET Since Final Week48 date (Sep-18)") +
  labs(y = 'Count',
       x = 'Country') +
  theme_gray() +
  theme(axis.text.x = element_text(angle = 45, 
                                   hjust = 1))
```


#----------------------------------------------------------
# VERTICAL BAR Example with multiple grouping, axis and legend
```{r echo=FALSE}
ggplot(edcSV, aes(x = reorder(FolderName, 
                              -FolderSeq), 
                  fill = FolderName)) +
  geom_bar() +
  coord_flip() + 
  geom_text(aes(label = ..count..),
          stat = 'count',
          position = position_stack(vjust = 0.5)) +
  ggtitle(label = "Total Visits") +
  labs(y = 'Count',
       x = 'Visit') +
  theme_gray() +
  theme(axis.text.x = element_text(angle = 45, 
                                   hjust = 1), 
        legend.position = 'none')
```
