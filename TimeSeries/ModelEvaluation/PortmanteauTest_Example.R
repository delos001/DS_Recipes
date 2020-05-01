
# In addition to looking at the ACF plot, we can do a more formal test for 
# autocorrelation by considering a whole set of rkrk values as a group, 
# rather than treat each one separately.

# Recall that rk is the autocorrelation for lag k.
# 	When we look at the ACF plot to see if each spike is within the required 
#   limits, we are implicitly carrying out multiple hypothesis tests, each one 
#   with a small probability of giving a false positive.
# 	When enough of these tests are done, it is likely that at least one will 
#   give a false positive and so we may conclude that the residuals have some 
#   remaining autocorrelation, when in fact they do not.
# In order to overcome this problem, we test whether the first hh autocorrelations 
#   are significantly different from what would be expected from a white noise 
#   process. A test for a group of autocorrelations is called a portmanteau test


# Exampple with Dow Jones Data
# For the Dow-Jones example, the naive model has no parameters, so K=0

# Box-Pierce test
Box.test(res, lag=10, fitdf=0)
# output:
# X-squared = 10.6425, df = 10, p-value = 0.385



# Box-Ljung test
Box.test(res,lag=10, fitdf=0, type="Lj")
# output:
# X-squared = 11.0729, df = 10, p-value = 0.3507

