


# logistic regression GAM

# logistic regression for true false whether wage is greater than 250 or not: 
# uses year, age with 5 degrees of freedom, education.

gam.lr=gam(I(wage>250)~year+s(age, df=5)+education, family=binomial, data=Wage)
par(mfrow=c(1,3))
plot(gam.lr, se=TRUE, col="green")
par(mfrow=c(1,1))

# table with true or false counts as to whether the wage is greater than 250 
# for each level of education
table(education, I(wage>250))


# fits a logistic regression GAM using all but the "1. 
# < HS Grad" category in the education variable  
#     (we do this since the table above shows that there are zero 
#     zeople making more than 250K a year that have less than high school education
gam.lr.s = gam(I(wage>250)~year + s(age, df=5) + education, family=binomial,
               data=Wage, subset=(education!="1. < HS Grad"))
plot(gam.lr.s, se=TRUE, col="green")

