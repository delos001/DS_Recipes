

# simple example using boot library
# function stat_fun computes median for given sample specified by index (idx)

library(boot)
stat_fun = function(x, idx) median(x[idx])
boot = boot(df, R = 1000, statistic = stat_fun)
