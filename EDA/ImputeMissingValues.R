


# This example is to impute continuous variables. 
#    (to encode categorical, code the categories)
Library(mice)

iris.mis <- subset(iris.mis, select = -c(Species))  # slice data to exclude cat var

md.pattern(feat_comb)  # Produces table showing missing variable values, produce heat-map like image

mice_plot <- aggr(feat_comb, col=c('navyblue','yellow'),
                  numbers=TRUE, sortVars=TRUE,
                  labels=names(feat_comb), cex.axis=.7,
                  gap=3, ylab=c("Missing data","Pattern"))


feat_comb_4 = feat_comb_3[5:23]
str(feat_comb_4)
imputed = mice(feat_comb_4, m=3, maxit=50, method="rf", seed=123)

summary(imputed)
imputed$loggedEvents
imputed$method

imputed$imp$ndvi_ne
complete_data = mice::complete(imputed,2)
