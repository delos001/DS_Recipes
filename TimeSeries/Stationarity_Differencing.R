

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

ns = nsdiffs(flu_ts)  # gets number of seasonal differences needed
if (ns > 0) {
  ns_store = diff(flu_ts, lag=frequency(flu_ts), differences=ns)
} else {
  ns_store = flu_ts
}

nd = ndiffs(flu_ts)
if(nd > 0) {
  nd_store = diff(ns_store, differences=nd)
}
