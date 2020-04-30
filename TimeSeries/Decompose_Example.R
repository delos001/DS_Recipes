
# SEASONAL DATA:  decompose seasonal component  
# (once you decompose trend, try to decompose seasonal component too)

# A seasonal time series consists of a trend component, a seasonal 
# component and an irregular component. Decomposing the time series 
# means separating the time series into these three components: that 
# is, estimating these three components. 

library(TTR)


# The function “decompose()” returns a list object as its result, 
# where the estimates of the seasonal component, trend component and 
# irregular component are stored in named elements of that list objects, 
# called “seasonal”, “trend”, and “random” respectively
mydata_decomp = decompose(mydata_ts)
# Note: decompose also contains $figure, $type,


mydata_decomp$seasonal
mydata_decomp$trend
mydata_decomp$random

plot(mydata_decomp, "per")


# This will do the same thing as the decomp code above (plotting a three 
# panel decomposed plot).  The "per" syntax puts bars on right side of the 
# chart: should give relative variation amounts in which larger bars (on 
# right of plot) indicate smaller proportion of variance for that component.
# https://stats.stackexchange.com/questions/7876/interpreting-range-bars-in-rs-plot-stl
plot(stl(pne_ts, "per"))
