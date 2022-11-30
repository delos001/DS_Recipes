
# Step functions cut the range of a variable into K distinct regions (bins) 
# and fit a different constant to each bin in order to produce an ordered 
# qualitative (categorical) variable (dummy variable). This has the effect 
# of fitting a piecewise constant function

# cut function cuts age into 4 groups.  
# NOTE: to specify your own groups, use the break function
table(cut(age, 4))
fit = lm(wage~cut(age,4), data=Wage)
coef(summary(fit))

# The age<33.5 category is left out, so the intercept coefficient 
# of $94,160 can be interpreted as the average salary for those 
# under 33.5 years of age, and the other coefficients can be 
# interpreted as the average additional salary for those in the other age groups. 
# We can produce predictions and plots just as we did in the case of the polynomial fit.
