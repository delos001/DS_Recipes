# EXAMPLE FROM:
# https://towardsdatascience.com/fishers-exact-test-in-r-independence-test-for-a-small-sample-56965db48e87

# H0 : the variables are independent, there is no relationship 
#   between the two categorical variables. Knowing the value of 
#   one variable does not help to predict the value of the other variable
# H1 : the variables are dependent, there is a relationship between 
#   the two categorical variables. Knowing the value of one variable 
#   helps to predict the value of the other variable


# data:
##             Non-smoker Smoker
## Athlete            7    2
## Non-athlete        0    5


test <- fisher.test(dat)
test
## 
##  Fisher's Exact Test for Count Data
## 
## data:  dat
## p-value = 0.02098
## alternative hypothesis: true odds ratio is not equal to 1
## 95 percent confidence interval:
##  1.449481      Inf
## sample estimates:
## odds ratio 
##        Inf

test$p.value
# OUT: 0.02097902
