
# Sample WITHOUT replacement
# Refer to Black Section 4.3.

# Problem:  One soft drink is preferred by the manufacturer.  
# Three people pick two soft drinks from 5 selections which 
#   include the preferred soft drink.  
# What is the probability none of the people pick the preferred 
#   soft drink at random? 


# combination: number of combinations for a single person 
#   (chosing 2 softdrinks)
combn(5,2)
# below are the possible combinations per person (without replacement)
#      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
# [1,]    1    1    1    1    2    2    2    3    3     4
# [2,]    2    3    4    5    3    4    5    4    5     5


# You want to calcluate the number of combinations where they don't 
#   pick the drink divided by total number of combinations
x <- c("a","b","c","d","e")  # choices are labeled a-e
dim(combn(x,2))[2]  # dimension of 10  (label the various categories)
# cubed for three people gives total possible outcomes for this study
total.number.combinations <- (dim(combn(x,2))[2])^3  


y <- c("b","c","d","e")  # remove the preferred drink
dim(combn(y,2))[2]  # dimension of 10 (allows you to label the various categories)
# calculate num of combinations for 1 person, raise to 3rd power for 3 people
reduced.number.combinations <- (dim(combn(y,2))[2])^3  
reduced.number.combinations/total.number.combinations  # answer
