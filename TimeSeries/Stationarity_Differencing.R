

# Determine number of differences and seasonal differences that are needed


#----------------------------------------------------------
# BASIC EXAMPLE
#----------------------------------------------------------
ndiffs(flu_ts)  # number of differences to make data stationary
nsdiffs(flu_ts) # number of sesonal differencs needed to make data stationary


#----------------------------------------------------------
# CUSTOM FUNCTION
#----------------------------------------------------------
# this set of code will determine the number of differences and make the 
# number of differences for you to make the data non-stationary
# THIS DOES SEASONAL DIFFERENCING FIRST (if needed) THEN TESTS FOR NON-SEASONAL 
# DIFFERENCES AND IF THEY ARE NEEDED, IT PERFORMS THEM ON TOP OF THE RESULTS OF 
# THE SEASONAL DIFFERNCE OUTPUT FROM ABOVE

# if number of seasonal differences needed is > 0, then 
# 	makes that number of differences and stores the new results as ns_store
# 	else
# ns_store is just the original data
ns = nsdiffs(flu_ts)  # gets number of seasonal differences needed
if (ns > 0) {
  ns_store = diff(flu_ts, lag=frequency(flu_ts), differences=ns)
} else {
  ns_store = flu_ts
}

# this gets the number of differences needed to make the data stationary
# if number of difference is >0, then 
# gets the differences based on the results of the seasonal difference test above.
nd = ndiffs(flu_ts)
if(nd > 0) {
  nd_store = diff(ns_store, differences=nd)
}
