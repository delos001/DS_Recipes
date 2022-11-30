
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

t.test(d, 
       alternative = c("two.sided"), 
       mu = 0, 
       paired = FALSE,      # paried=FALSE means comparing two different groups
       var.equal = FALSE,
       conf.level = 0.95)

# result$weight~result$diet is the way to compre the weights for 
# two groups based on diet (diet is categorized as either 1 or 3 
# so this compares weights of diet 1 to weights of diet 2)

t.test(result$weight~result$Diet,
       alternative = c('two.sided'),
       mu = 0,
       paired = FALSE,
       var.equal = TRUE, 
       conf.level=0.95)


#----------------------------------------------------------
#----------------------------------------------------------
# SINGLE SAMPLE T TEST
#----------------------------------------------------------
#----------------------------------------------------------
#----------------------------------------------------------
# EXAMPLE
# groups vector S for 'baths' where number of bathrooms = 1
s1 <- S[baths == "1"]
s15 <- S[baths == "1.5"]
t.test(s15,s1,
       alternative = c("two.sided"),
       mu = 0,
       paired = FALSE)
