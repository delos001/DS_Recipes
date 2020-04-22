
#----------------------------------------------------------
# EXAMPLE 2
x <- c(-29.6,-20.9,-19.7,-15.4,-12.3,-8.0,-4.3,0.8,2.0,6.2,11.2,25.0)
require(asbio)
win(mag,lambda=0.2)



sd(win(mag,lambda=0.2)



#----------------------------------------------------------
# EXAMPLE 2
mag<-sort(mag,decreasing=FALSE)
trimoff<-round(0.2*length(mag))
mag.win<-mag[(mag[(1+trimoff):(length(mag)-trimoff)]]


bottom <- rep(min(mag.win), times = trimoff)
top <- rep(max(mag.win), times = trimoff)


mag.win <- c(bottom, mag.win, top)
mag.win
sd(mag.win)
