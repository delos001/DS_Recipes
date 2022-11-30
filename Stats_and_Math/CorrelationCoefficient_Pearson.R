

# compares col 1 of schools, to col 2 of schools, using 
# p is the method. (will need to look up which to use)
# gives a correlation value (like an r squared value in regression) 
#     between -1 and 1

cor(schools[,1],schools[,2], method = c("p"))


