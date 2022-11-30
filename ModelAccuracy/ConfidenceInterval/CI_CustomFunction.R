# t.interval is a user-defined function that produces a confidence interval.  The
# subset of data for which the confidence interval is computed is submitted as
# the argument x.  sigma and df refer to the pooled results.

t.interval <- function(x,sigma,df,alpha){
  # sigma is assumed to be a pooled variance as used by Business Statistics.
  t.lower <- qt(alpha, df, lower.tail = TRUE)
  t.upper <- qt(1-alpha, df, lower.tail = TRUE)
  n <- length(x)
  lower <- mean(x)+t.lower*sqrt(sigma/n)
  upper <- mean(x)+t.upper*sqrt(sigma/n)
  interval <- c(lower, upper)
  interval
}


# To produce a comparable table, the values for each operator will be extracted,
# and confidence intervals computed for each subset.  All the necessary statistics
# for the display are combined and the result placed in display. 
x1 <- (machine[machine$operator == "1", 2])
x2 <- (machine[machine$operator == "2", 2])
x3 <- (machine[machine$operator == "3", 2])
x4 <- (machine[machine$operator == "4", 2])

# t.interval function is used for each of these lines
Operator_1 <- c(length(x1), mean(x1), sd(x1), t.interval(x1, sigma, 20, 0.05))
Operator_2 <- c(length(x2), mean(x2), sd(x2), t.interval(x2, sigma, 20, 0.05))
Operator_3 <- c(length(x3), mean(x3), sd(x3), t.interval(x3, sigma, 20, 0.05))
Operator_4 <- c(length(x4), mean(x4), sd(x4), t.interval(x4, sigma, 20, 0.05))

display <- rbind(Operator_1, Operator_2, Operator_3, Operator_4)
colnames(display) <- c("N", "Mean", "StDev", "Lower", "Upper")

display
