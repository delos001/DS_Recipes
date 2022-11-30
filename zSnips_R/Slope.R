

#----------------------------------------------------------
# OBTAIN SLOPE ACROSS SPECIFIED COLUMNS
#----------------------------------------------------------
slope = function(x){
  if(all(is.na(x)))    # if x is all missing, then lm will throw an error (avoid)
    return(NA)
  else
    #I(1:6) defines the y value to use in the linear regression, 
    # ie: y becomes 1, 2, 3, 4, 5, 6 and would apply to number of columns
    return(coef(lm(I(1:6)~x))[2])
}

# example where cc_data_fact is the df and 13:18 are the column references 
#    you want to get the slope of ('slope' is calling above function)
cc_data_fact$Slope_Bill_Amt = apply(cc_data_fact[,13:18], 1, slope)
head(cc_data_fact)
