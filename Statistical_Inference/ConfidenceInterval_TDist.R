

#----------------------------------------------------------
# GENERAL EXAMPLE
# t-distribution
a <- 5
s <- 2
n <- 20
error <- qt(0.975,df=n-1)*s/sqrt(n)
left <- a-error
right <- a+error
left  # OUT: 4.063971
right  # OUT: 5.936029




#----------------------------------------------------------
# GENERAL EXAMPLE

# confidence interval for before and after (difference of the means)
t.test(post,pre,alternative=c('two.sided'),
       paired=TRUE, 
       conf.level=0.95)


# gets confidence interval for t statistic (smaller sample size) 
# change is the difference between the two means 
#   (pre and post variables)
# this is the standard deviation of the difference between the two 
#   variables pre and post
change<-mean(post)-mean(pre)
std<-sd(post-pre)

# df is degrees of freedom (number of samples, 
#   use n-1 for sample and use n for population)
# we add the error to the mean and subtract it which gives us CI
error<-qt(0.975, 
          df = length(pre)-1) * std/sqrt(length(pre))
ci<-c(change-error, change+error)
