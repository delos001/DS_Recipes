


#----------------------------------------------------------
# dt
# produces t-dist density function for x=0.5 with 5 df
dt(0.5,df=5)


#----------------------------------------------------------
# pt
produces t-dist probability at x=2.5 with 5 df
pt(2.5,df=5)

produces t-dist probability that X lies between 3 and 1 for 5 df
pt(3,df=5)-pt(1,df=5)


#----------------------------------------------------------
# qt
# produces 95% t value for t-distribution
qt(0.95,df=5)

# get t value for 95% confidence (need to specify the degrees of freedom)
qt(1 - 0.05/𝟐, df)

# need to specify t value (-2.43) and df (9): 
#   will give you the 2 sided pvalue for t-statistic
2*(1 – pt(-2.43, 9)) 

