


#----------------------------------------------------------
#----------------------------------------------------------
# BASE R
#----------------------------------------------------------
#----------------------------------------------------------

#----------------------------------------------------------
# BASIC EXAMPLE
par(mfrow = c(1,2))
hist(iris$Sepal.Length)
plot(density(iris$Sepal.Length))



#----------------------------------------------------------
#----------------------------------------------------------
# GGPLOT
#----------------------------------------------------------
#----------------------------------------------------------
library(ggplot2)

plotDensityFunc <- function(x, na.rm = TRUE, ...) {
    nm <- names(x)
    for (i in seq_along(nm)) {
        plots <-ggplot(x,
                       aes_string(x = nm[i])) + 
        geom_density(alpha = .5,
                     fill = "purple")
        ggsave(plots,
               filename = paste("density",
                                nm[i],".png",
                                sep=""))
    }
}
plotDensityFunc(d) 


#----------------------------------------------------------
# FUNCTION TO APPLY DENSITY PLOT TO ALL SPECIFIED VARS
#----------------------------------------------------------
denf = function(d) {
    D = list()
    colNames3 = names(feat_eda[5:23])
    for (k in colNames3){
        d = ggplot(feat_eda, 
                   aes_string(x = k)) + 
        geom_density(alpha = .5,
                     fill = "blue")
        D = c(D, list(d))
    }
    return(list(plots=D, num=length(vars)))
}
DPlots = denf(d)

#call each graph in 3x3 groups (can't figure out how to make do.call go to next page)
do.call(grid.arrange, c(DPlots$plots[1:7], ncol=3, nrow=3))
do.call(grid.arrange, c(DPlots$plots[8:14], ncol=3, nrow=3))
do.call(grid.arrange, c(DPlots$plots[15:19], ncol=3, nrow=3))


#----------------------------------------------------------
# FUNCTION TO APPLY DENSITY PLOT TO ALL SPECIFIED VARS
# CATEGORICAL
#----------------------------------------------------------
#density function by city

denf = function(d) {
    D = list()
    colNames3 = names(feat_eda[5:23])
    for (k in colNames3){
        d = ggplot(feat_eda, 
                   aes_string(x = k, 
                              color="city")) + 
        geom_density(alpha = .5, 
                     position = "identity", 
                     fill = "blue")
        D = c(D, list(d))
    }
    return(list(plots=D, num=length(vars)))
}
DPlots = denf(d)


#call each graph in 3x3 groups (can't figure out how to make do.call go to next page)
do.call(grid.arrange, c(DPlots$plots[1:7], ncol=3, nrow=3))
do.call(grid.arrange, c(DPlots$plots[8:14], ncol=3, nrow=3))
do.call(grid.arrange, c(DPlots$plots[15:19], ncol=3, nrow=3))
