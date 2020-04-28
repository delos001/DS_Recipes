
# Tukey HSD function: Tukey's honestly significant difference test  (see Black 430)
# Tukey-Kramer formula for different sample sizes (Black p434)

# shows how different variables compare on a pairwise basis.  
# different from T test in that is controls for the type I bias 
# and givens just an overall 90% confidence (instead of a 
# decreaseing confidence by doing multiple T tests)
# only 5% of the time when null is true, will one of the comparisons result 
# in a type I error requires equal sample sizes



# Tukey HSD function  (see Black 430)

# OUT:
aov.region <- aov(Y~region, schools)
summary(aov.region)

TukeyHSD(aov.region)

#   Tukey multiple comparisons of means
#     95% family-wise confidence level
# Fit: aov(formula = Y ~ region, data = schools)
# $region
#          diff       lwr         upr     p adj
# B-A -15.91630 -50.35009  18.5174972 0.6270256
# C-A -46.29630 -78.83317 -13.7594198 0.0017298
# D-A  46.24319  12.38174  80.1046377 0.0028967
# C-B -30.38000 -60.20054  -0.5594601 0.0440826
# D-B  62.15949  30.89907  93.4199070 0.0000045
# D-C  92.53949  63.38171 121.6972657 0.0000000

# we see comparison of b to a is not significant.
