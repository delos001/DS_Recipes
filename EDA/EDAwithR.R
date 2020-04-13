
#-----------------------------------------------------
# BASIC EDA WITH AUTO DATASET
str(auto)
dim(auto)
auto[1:4,]
head(auto)
tail(auto)
names(auto)
dimnames(auto)

summary(auto)
summary(auto$mpg)

aggregate(Sepal.Length ~ Species, summary, data=iris)


# SUMMARY STATISTICS CUSTOM FUNCTION
range <- function(x) {max(x, na.rm = TRUE) - min(x, na.rm = TRUE)}  #need this line!!
summary_stats = function(x) {
  stats = data.frame(rbind(range(x),
                           min(x, na.rm=TRUE),
                           quantile(x, probs = c(0.10), na.rm = TRUE),                           
                           quantile(x, probs = c(0.25), na.rm = TRUE),
                           mean(x, na.rm = TRUE),
                           median(x, na.rm = TRUE),
                           quantile(x, probs = c(0.75), na.rm = TRUE),
                           quantile(x, probs = c(0.90), na.rm = TRUE),
                           max(x, na.rm=TRUE),
                           sd(x, na.rm = TRUE),
                           var(x, na.rm = TRUE)),
  row.names = c("Range", "Min", "Q10", "Q25", "Mean", "Med", "Q75", "Q90", 
                                   "Max", "SD", "Var"))
  colnames(stats)=colnames(x)
  return(stats)
}

#only select variables of interst in line below
round(t(data.frame(apply(feat_comb[, 5:24], 2, summary_stats))),2)
round(summary_stats(feat_comb$reanalysis_air_temp_k),2)

#-----------------------------------------------------
# BASIC EDA WITH fBASICS

library(fBasics)
round(basicStats(charity[,11:21])[c("Minimum", 
                                    "1. Quartile", 
                                    "Mean","Median", 
                                    "3. Quartile", 
                                    "Maximum"),],
      2)
