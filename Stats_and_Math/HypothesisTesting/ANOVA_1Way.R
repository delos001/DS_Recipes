

# Compares variances (not means).  USES F DISTRIBUTION 
# One variance is the pooled within group variance
# The other variance is variance constructed by looking at grouped means

# Its variablility in the grouped means greater than can be 
#   explained by the variation from each group


#----------------------------------------------------------
# EXAMPLE 1
yeild = c(3,6,4,7,8,9,2,9,3,4,5,9,8,3,3,1,2,5,6,8,3,9,4,4)
grp = c(rep('1',8), rep('2',8), rep('3',8)
results = aov(yield~group)


#----------------------------------------------------------
# EXAMPLE 2
aov.region <- aov(Y~region, schools)
summary(aov.region)


#----------------------------------------------------------
# EXAMPLE 3
# Y is expenditures so this is an analysis of variance as a 
# function of region, from the schools file asks for the summary 
# table for the aov.region
res <- aov(yield ~ operator, data = machine)
summary(res)

f.upper <- qf(0.95, 3, 20, lower.tail = TRUE)
cord.x <- c(f.upper, seq(f.upper, 15, 0.01), 6)
cord.y <- c(0, df(seq(f.upper, 15, 0.01), 3, 20), 0)
curve(df(x,3,20),xlim=c(0,6),main=" F Density", ylab = "density")
polygon(cord.x,cord.y,col="skyblue")
legend("right", legend = c("critical region >= 3.10"))


sigma <- sum(resid(res)^2)/(20)
sqrt(sigma)  # Pooled standard deviation
