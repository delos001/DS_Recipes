

#----------------------------------------------------------
# BASIC EXAMPLE
s1<-2.1   # sd of var1
n1<-13    # n of var1
s2<-1.1   # sd of var2
n2<-16    # n of var2

F <- s1**2/s2**2  # F calculation (see image above)

# get quantile with 95% CI with n1-1, n2-1 degrees of freedom
qf(0.95,n1-1,n2-1,lower.tail=TRUE)
pf(F,n1-1,n2-1,lower.tail=FALSE) # probability of the F statistic


#----------------------------------------------------------
# BASIC EXAMPLE 2
# gets critical value for F statistic based on 95% confidence, 
# and 3 and 20 degrees of freedom (from the machine file)
# if the computed F test statistic is greater than the table F 
#   value, then its signficant.
f.upper <- qf(0.95, 3, 20, 
              lower.tail = TRUE)
cord.x <- c(f.upper, 
            seq(f.upper, 15, 0.01), 6)
cord.y <- c(0, df(seq(f.upper, 15, 0.01), 3, 20), 0)
curve(df(x,3,20),
      xlim=c(0,6),
      main=" F Density", 
      ylab = "density")
polygon(cord.x, cord.y, col="skyblue")
legend("right", 
       legend = c("critical region >= 3.10"))
