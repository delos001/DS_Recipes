
# IN THIS SCRIPT
# MICE
# ZOO


# Tutorial
# https://www.analyticsvidhya.com/blog/2016/03/tutorial-powerful-packages-imputing-missing-values/
#  https://datascienceplus.com/imputing-missing-data-with-r-mice-package/

#-------------------------------------------------------------------------------------
# MICE
# This example is to impute continuous variables. 
#    (to encode categorical, code the categories)
Library(mice)

iris.mis <- subset(iris.mis, select = -c(Species))  # slice data to exclude cat var

md.pattern(feat_comb)  # Produces table: missing variable values, produce heat-map like image


# 2 Plots of missing values by variable.  
#    Note: might want to figure out how to plot each plot separately if 
#       there are large number of variables.
mice_plot <- aggr(feat_comb, col=c('navyblue','yellow'),
                  numbers=TRUE, sortVars=TRUE,
                  labels=names(feat_comb), cex.axis=.7,
                  gap=3, ylab=c("Missing data","Pattern"))


feat_comb_4 = feat_comb_3[5:23]
str(feat_comb_4)
# Create new table which will contain the imputed variables
imputed = mice(feat_comb_4, m=3, maxit=50, method="rf", seed=123)

summary(imputed)
imputed$loggedEvents
imputed$method

# Combine the imputed values back.  
#   Note that mice::complete is used because "complete" is a function of 
#     other packages so this specifies to use the mice combine function.  
#   Note that the 2 indicates using the second imputed list 
#     (m=3 above means you had it run 3 different imputations)
imputed$imp$ndvi_ne   # Prints the different imputed values
complete_data = mice::complete(imputed,2)



#-------------------------------------------------------------------------------------
# ZOO
# example of imputation using simple interploation (******use for time series data)
library(zoo)

impute_mi = feat_comb_3[,9:ncol(feat_comb_3)]
impute_test = zoo(impute_mi)
impute_out = na.approx(impute_test)
head(impute_out)
tail(impute_out)

# create dummy column that is a 1 if the original value is NA and a zero if it is not NA
feat_comb$ndvi_ne_imp = as.factor(ifelse(is.na(feat_comb$ndvi_ne),1,0))
feat_comb$ndvi_nw_imp = as.factor(ifelse(is.na(feat_comb$ndvi_nw),1,0))
feat_comb$ndvi_se_imp = as.factor(ifelse(is.na(feat_comb$ndvi_se),1,0))
feat_comb$ndvi_sw_imp = as.factor(ifelse(is.na(feat_comb$ndvi_sw),1,0))

data.frame(colSums(feat_comb[,26:45] !=0))

