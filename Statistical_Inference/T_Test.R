
# ONE MEAN

# use paired when comparing two different measurements of 
# same group (ex: bp in am for person 1 vs. bp in pm for person 1)
# use two sided if the null hypothesis is that the two groups are 
#   not equal (ie: not greater or less than)

# testing for single mean  Black p319
# degrees of freedome = n-1
# do not know population standard deviation (use sample stdev)
# any sample size 
# population must be normally distributed in all cases

t.test(d, alternative = c("two.sided"), mu = 0, paired = FALSE, var.equal = FALSE,
       conf.level = 0.95)

t.test(result$weight~result$Diet,alternative=c('two.sided'),mu=0,paired=FALSE,
       var.equal = TRUE, conf.level=0.95)
