
#----------------------------------------------------------
# EXAMPLE 1

# windsorizes the data at 20% value (replaces the bottom and 
# top 20% of values with values at the lower and upper 20% mark)
# compare below to the original list to see what was replaced:
# -19.7 -19.7 -19.7 -15.4 -12.3 -8.0 -4.3 0.8 2.0 6.2 6.2 6.2
x <- c(-29.6,-20.9,-19.7,-15.4,-12.3,-8.0,-4.3,0.8,2.0,6.2,11.2,25.0)
require(asbio)
win(x,lambda=0.2)


# stnd dev of windsorized data
sd(win(x,lambda=0.2))




#----------------------------------------------------------
# EXAMPLE 2

mag<-sort(mag,decreasing=FALSE)
trimoff<-round(0.2*length(mag))
mag.win<-mag[(mag[(1+trimoff):(length(mag)-trimoff)]]


bottom <- rep(min(mag.win), times = trimoff)
top <- rep(max(mag.win), times = trimoff)


mag.win <- c(bottom, mag.win, top)
mag.win
