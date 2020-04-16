#MSDS 454 Midterm project

#load pakages
library(ggplot2)
library(Amelia)
library(mice)
library(randomForest)
library(VIM)
library(gridExtra)
library(grid)
library(tidyr)
library(zoo)

#load files
#from laptop
feat_test = read.csv(file.path("C:/Users/delos001/OneDrive - QJA/My Files/NW Coursework/Predict 454 Advanced Modelling/Midterm Data",
                               "dengue_features_test.csv"), 
                     sep=",", 
                     na.strings = c("NA", ""))

feat_train = read.csv(file.path("C:/Users/delos001/OneDrive - QJA/My Files/NW Coursework/Predict 454 Advanced Modelling/Midterm Data",
                                "dengue_features_train.csv"), 
                      sep=",", 
                      na.strings = c("NA", ""))

labels_train = read.csv(file.path("C:/Users/delos001/OneDrive - QJA/My Files/NW Coursework/Predict 454 Advanced Modelling/Midterm Data",
                                  "dengue_labels_train.csv"), 
                        sep=",", 
                        na.strings = c("NA", ""))

#from desktop
feat_test = read.csv(file.path("C:/Users/Jason/OneDrive - QJA/My Files/NW Coursework/Predict 454 Advanced Modelling/Midterm Data",
                   "dengue_features_test.csv"), 
                     sep=",", 
                     na.strings = c("NA", ""))

feat_train = read.csv(file.path("C:/Users/Jason/OneDrive - QJA/My Files/NW Coursework/Predict 454 Advanced Modelling/Midterm Data",
                               "dengue_features_train.csv"), 
                      sep=",", 
                      na.strings = c("NA", ""))

labels_train = read.csv(file.path("C:/Users/Jason/OneDrive - QJA/My Files/NW Coursework/Predict 454 Advanced Modelling/Midterm Data",
                               "dengue_labels_train.csv"), 
                        sep=",", 
                        na.strings = c("NA", ""))

#add column to train file to distinguish train variables
total_cases=labels_train[,4]
feat_train=cbind(data="train", 
                 total_cases, 
                 feat_train)
str(feat_train)
head(feat_train)
tail(feat_train)

#add columns to test file to combine later
feat_test=cbind(data="test", 
                total_cases=0,
                feat_test)
# str(feat_test)
# head(feat_test)
# tail(feat_test)



#combine test and train data for EDA
feat_comb = rbind(feat_train, 
                  feat_test)
# str(feat_comb)
# head(feat_comb)
# tail(feat_comb)

#convert date to date format
feat_comb$week_start_date = as.Date(feat_comb$week_start_date, 
                                    format="%m/%d/%Y")

#convert climate data vars to continuous

#create new variable with month 
month = format(as.Date(feat_comb$week_start_date),"%m")

#convert new variable with year to show successive increases: 0-23
norm_year = feat_comb$year - 2018

#add new date variables to dataframe
feat_comb = cbind(feat_comb[,1:6], 
                  month, 
                  norm_year, 
                  eat_comb[,7:26])

#review combined test and train data set
#str(feat_comb)
#head(feat_comb)
#tail(feat_comb)

##################################################################################
#
#
#         Initial Basic Statistics
#
#
#
##################################################################################

######## review missing values ##########


missing_stats = function(m) {
  miss = data.frame(rbind(length(m),
                          sum(is.na(m)==TRUE),
                          sum(is.na(m)==TRUE) / length(m)),
  row.names = c("Length", "Missing","%Missing"))
  colnames(miss)=colnames(m)
  return(miss)
}

round(t(data.frame(apply(feat_comb[, 1:28], 
                         2, 
                         missing_stats))),
      2)

#uses Amelia package
missmap(feat_comb, main="Missing Map", 
        y.labels = NULL, 
        y.at=NULL, 
        rank.order = TRUE)

########## Summary Statistics ##########


range <- function(x) {max(x, na.rm = TRUE) - min(x, na.rm = TRUE)}
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

round(t(data.frame(apply(feat_comb[, 9:28], 2, summary_stats))),2)
#only select variables of interst in line below
round(summary_stats(feat_comb$reanalysis_air_temp_k),2)


##################################################################################
#
#
#         Variable and Observation Deletion
#
#
#
##################################################################################

#delete precipitation_amt_mm: it is dupicative of reanalysis_sat_precip_amt_mm in
#both the test and training set

feat_comb_1 = feat_comb
feat_comb_1$precipitation_amt_mm=NULL

missmap(feat_comb_1, main="Missing Map", 
        y.labels = NULL, 
        y.at=NULL, 
        rank.order = TRUE)


##################################################################################
#
#
#        Create Dummy Variables for Missing Data and Impute Missing Values
#
#
#
##################################################################################



#from mice package: identifies missing data for each variable (also see missing data section above)
feat_comb_3 = feat_comb_1
str(feat_comb_1)
str(feat_comb_3)
md.pattern(feat_comb_3)

mice_plot <- aggr(feat_comb_3[,1:length(feat_comb_3)], 
                  col=c('light yellow','light green'), 
                  bars = FALSE,
                  numbers=TRUE, 
                  sortVars=TRUE, 
                  combined = FALSE, 
                  axes = TRUE,
                  varheight = FALSE, 
                  only.miss=TRUE, 
                  labels=names(feat_comb), 
                  cex.numbers = 0.8, 
                  cex.axis=0.4, cex.lab=1,
                  gap=FALSE, 
                  ylab=c("Missing data","Pattern"))


#create imputation flag variables and set to zero if not missing and 1 if missing (a one is flag for imputation later)
feat_comb_3$ndvi_ne_imp = as.factor(ifelse(is.na(feat_comb_3$ndvi_ne),1,0))
feat_comb_3$ndvi_nw_imp = as.factor(ifelse(is.na(feat_comb_3$ndvi_nw),1,0))
feat_comb_3$ndvi_se_imp = as.factor(ifelse(is.na(feat_comb_3$ndvi_se),1,0))
feat_comb_3$ndvi_sw_imp = as.factor(ifelse(is.na(feat_comb_3$ndvi_sw),1,0))

feat_comb_3$reanalysis_air_temp_k_imp = 
  as.factor(ifelse(is.na(feat_comb_3$reanalysis_air_temp_k),1,0))

feat_comb_3$reanalysis_avg_temp_k_imp = 
  as.factor(ifelse(is.na(feat_comb_3$reanalysis_avg_temp_k),1,0))

feat_comb_3$reanalysis_dew_point_temp_k_imp = 
  as.factor(ifelse(is.na(feat_comb_3$reanalysis_dew_point_temp_k),1,0))

feat_comb_3$reanalysis_max_air_temp_k_imp = 
  as.factor(ifelse(is.na(feat_comb_3$reanalysis_max_air_temp_k),1,0))

feat_comb_3$reanalysis_min_air_temp_k_imp = 
  as.factor(ifelse(is.na(feat_comb_3$reanalysis_min_air_temp_k),1,0))

feat_comb_3$reanalysis_precip_amt_kg_per_m2_imp = 
  as.factor(ifelse(is.na(feat_comb_3$reanalysis_precip_amt_kg_per_m2),1,0))

feat_comb_3$reanalysis_relative_humidity_percent_imp = 
  as.factor(ifelse(is.na(feat_comb_3$reanalysis_relative_humidity_percent),1,0))

feat_comb_3$reanalysis_sat_precip_amt_mm_imp = 
  as.factor(ifelse(is.na(feat_comb_3$reanalysis_sat_precip_amt_mm),1,0))

feat_comb_3$reanalysis_specific_humidity_g_per_kg_imp = 
  as.factor(ifelse(is.na(feat_comb_3$reanalysis_specific_humidity_g_per_kg),1,0))

feat_comb_3$reanalysis_tdtr_k_imp = 
  as.factor(ifelse(is.na(feat_comb_3$reanalysis_tdtr_k),1,0))

feat_comb_3$station_avg_temp_c_imp = 
  as.factor(ifelse(is.na(feat_comb_3$station_avg_temp_c),1,0))

feat_comb_3$station_diur_temp_rng_c_imp = 
  as.factor(ifelse(is.na(feat_comb_3$station_diur_temp_rng_c),1,0))

feat_comb_3$station_max_temp_c_imp = 
  as.factor(ifelse(is.na(feat_comb_3$station_max_temp_c),1,0))

feat_comb_3$station_min_temp_c_imp = 
  as.factor(ifelse(is.na(feat_comb_3$station_min_temp_c),1,0))

feat_comb_3$station_precip_mm_imp = 
  as.factor(ifelse(is.na(feat_comb_3$station_precip_mm),1,0))

#str(feat_comb_3)
#names(feat_comb_3)
#head(feat_comb_3)
#tail(feat_comb_3)



#check to make sure dummy variables for new imputation columns matches original missing values
#there should now be a 1 for every n/a from original file
dummy_impute = data.frame(colSums(feat_comb_3[,28:length(feat_comb_3)] ==1))
missing_stats = function(m) {
  miss = data.frame(rbind(sum(is.na(m)==TRUE)),
                    row.names = c("Missing"))
  colnames(miss)=colnames(m)
  return(miss)
}

#use feat_comb_1 which has the original missing data
orig_missing = round(t(
  data.frame(
    apply(feat_comb_1[, 9:length(feat_comb_1)], 
          2, missing_stats))), 2)

cbind(dummy_impute, orig_missing)


#Impute using interpolation
library(zoo)

impute = feat_comb_3[,9:27]
str(impute)
impute_test = zoo(impute)
impute_out = na.approx(impute_test)
impute_num = data.frame(impute_out)
#head(impute_num)
#str(impute_num)

impute_out = cbind(feat_comb_3[,1:8], 
                   impute_num, 
                   feat_comb_3[,28:ncol(feat_comb_3)])
#head(impute_out)
#str(impute_out)

########NOT USED IN ANALYSIS: SEE ABOVE FOR IMPUTATION METHOD
#impute: 2 imputed data sets, 50 iterations, using predictive mean matching method
# str(feat_comb_3)
# feat_comb_4 = feat_comb_3[9:27]
# str(feat_comb_4)
# imputed = mice(feat_comb_4, m=2, maxit=50, method="pmm", seed=123)
# summary(imputed)
# imputed$loggedEvents
# imputed$method
# 
# imputed_data = mice::complete(imputed,2)
# head(imputed_data)
# 
# 
# mice_missing = function(m) {
#   miss = data.frame(rbind(sum(is.na(m)==TRUE)),
#                     row.names = c("Missing"))
#   colnames(miss)=colnames(m)
#   return(miss)
# }
# check_imputed = round(t(data.frame(apply(imputed_data, 2, mice_missing))),2)
# 
# str(feat_comb_3)
# imputed_data = cbind(feat_comb_3[1:8],imputed_data, feat_comb_3[28:length(feat_comb_3)])
# str(imputed_data)
# head(imputed_data)


##################################################################################
#
#
#         EDA
#
#
#
##################################################################################


feat_eda = impute_out
str(feat_eda)

colNames1 = names(feat_eda[9:27])
colNames2 = names(feat_eda[9:27])

#plot correlation plots for dep vs. indep variables
par(mfrow = c(3,3))
par(mar=c(5,6,4,1)+.1)
for (i in colNames1){
  plot(feat_eda$total_cases, 
       feat_eda[,c(i)], 
       ylab=i, 
       col=feat_eda$city)
  legend("bottomright", 
         legend=levels(feat_eda$city), 
         col=1:length(feat_eda$city), 
         pch=1)
}

par(mfrow = c(1,1))
cor_mat = data.frame(round(cor(feat_eda[,9:27]),2))
cor_mat
write.csv(cor_mat, "cor_matrix.csv")

#plot correlation plots for each of the numerical variables

str(feat_eda)


par(mar=c(5,6,4,1)+.1)
par(mfrow = c(3,3))
for (k in colNames1){
  for (i in colNames2){
    plot(feat_eda[,c(k,i)], col=feat_eda$city)
    legend("bottomright", legend=levels(feat_eda$city), 
           col=1:length(feat_eda$city), 
           pch=1)
  }
}
par(mfrow = c(1,1))



#*********************************************************
#BoxPlots
bpf = function(b) {
  B = list()
  for (k in colNames1){
    b = ggplot(feat_eda, aes_string(y=k)) + 
    geom_boxplot(outlier.color='red',
                 outlier.shape =1, 
                 outlier.size=3,
                 notch=TRUE)+ ylab(k)
    B = c(B, list(b))
  }
  return(list(plots=B, num=length(vars)))
}
BPlots = bpf(b)


#call each graph in 3x3 groups (can't figure out how to make do.call go to next page)
do.call(grid.arrange, c(BPlots$plots[1:7], ncol=3, nrow=3))
do.call(grid.arrange, c(BPlots$plots[8:14], ncol=3, nrow=3))
do.call(grid.arrange, c(BPlots$plots[15:19], ncol=3, nrow=3))

#BoxPlots by country  (note: there are significant differences in variables by location)
bpf2 = function(b2) {
  B = list()
  for (k in colNames1){
    b = ggplot(feat_eda, aes_string(x=feat_eda$city, y=k)) + 
    geom_boxplot(outlier.color='red',
                 outlier.shape =1, 
                 outlier.size=3,
                 notch=TRUE) + 
    ylab(k)
    B = c(B, list(b))
  }
  return(list(plots=B, num=length(vars)))
}
BPlots2 = bpf2(b2)


#call each graph in 3x3 groups (can't figure out how to make do.call go to next page)
do.call(grid.arrange, c(BPlots2$plots[1:7], ncol=3, nrow=3))
do.call(grid.arrange, c(BPlots2$plots[8:14], ncol=3, nrow=3))
do.call(grid.arrange, c(BPlots2$plots[15:19], ncol=3, nrow=3))


#*********************************************************
#Histogram

histf = function(h) {
  H = list()
  for (k in colNames1){
    h = ggplot(feat_eda, aes_string(x = k)) + 
    geom_histogram(alpha = .5,
                   fill = "blue", 
                   bins=20)
    H = c(H, list(h))
  }
  return(list(plots=H, num=length(vars)))
}
HPlots = histf(h)


#call each graph in 3x3 groups (can't figure out how to make do.call go to next page)
do.call(grid.arrange, c(HPlots$plots[1:7], ncol=3, nrow=3))
do.call(grid.arrange, c(HPlots$plots[8:14], ncol=3, nrow=3))
do.call(grid.arrange, c(HPlots$plots[15:19], ncol=3, nrow=3))

#Histogram by location

histf2 = function(h2) {
  H = list()
  for (k in colNames1){
    h = ggplot(feat_eda, aes_string(x = k, 
                                    color="city")) + 
    geom_histogram(alpha = .5, 
                   position="identity", 
                   ill = "white", 
                   bins=20)
    H = c(H, list(h))
  }
  return(list(plots=H, num=length(vars)))
}
HPlots2 = histf2(h2)


#call each graph in 3x3 groups (can't figure out how to make do.call go to next page)
do.call(grid.arrange, c(HPlots2$plots[1:7], ncol=3, nrow=3))
do.call(grid.arrange, c(HPlots2$plots[8:14], ncol=3, nrow=3))
do.call(grid.arrange, c(HPlots2$plots[15:19], ncol=3, nrow=3))

#*********************************************************
#density function

denf = function(d) {
  D = list()
  for (k in colNames1){
    d = ggplot(feat_eda, aes_string(x = k)) + 
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

#density function by city

denf2 = function(d2) {
  D = list()
  for (k in colNames1){
    d = ggplot(feat_eda, aes_string(x = k, color="city")) + 
    geom_density(alpha = .5, 
                 osition = "identity", 
                 fill = "blue")
    D = c(D, list(d))
  }
  return(list(plots=D, num=length(vars)))
}
DPlots2 = denf2(d2)


#call each graph in 3x3 groups (can't figure out how to make do.call go to next page)
do.call(grid.arrange, c(DPlots2$plots[1:7], ncol=3, nrow=3))
do.call(grid.arrange, c(DPlots2$plots[8:14], ncol=3, nrow=3))
do.call(grid.arrange, c(DPlots2$plots[15:19], ncol=3, nrow=3))
#*********************************************************
#QQPlot

qqf = function(q) {
  Q = list()
  for (k in colNames1){
    q = ggplot(feat_eda, aes_string(sample = k)) + 
    stat_qq() + 
    stat_qq_line() + 
    ylab(k)
    Q = c(Q, list(q))
  }
  return(list(plots=Q, num=length(vars)))
}
QPlots = qqf(q)


#call each graph in 3x3 groups (can't figure out how to make do.call go to next page)
do.call(grid.arrange, c(QPlots$plots[1:7], ncol=3, nrow=3))
do.call(grid.arrange, c(QPlots$plots[8:14], ncol=3, nrow=3))
do.call(grid.arrange, c(QPlots$plots[15:19], ncol=3, nrow=3))

#QQPlot by city

qqf2 = function(q2) {
  Q = list()
  for (k in colNames1){
    q = ggplot(feat_eda, aes_string(sample = k, 
                                    color="city")) + 
    stat_qq() + 
    stat_qq_line() + 
    ylab(k)
    Q = c(Q, list(q))
  }
  return(list(plots=Q, num=length(vars)))
}
QPlots2 = qqf2(q2)


#call each graph in 3x3 groups (can't figure out how to make do.call go to next page)
do.call(grid.arrange, c(QPlots2$plots[1:7], ncol=3, nrow=3))
do.call(grid.arrange, c(QPlots2$plots[8:14], ncol=3, nrow=3))
do.call(grid.arrange, c(QPlots2$plots[15:19], ncol=3, nrow=3))

##################################################################################
#
#
#         Create New Variables
#
#
#
##################################################################################


new_variables = impute_out
str(new_variables)

#create dummy columns for month
#Jan is baseline: new_variables$Jan = as.factor(ifelse(new_variables$month == "01",1,0))
new_variables$Feb = as.factor(ifelse(new_variables$month == "02",1,0))
new_variables$Mar = as.factor(ifelse(new_variables$month == "03",1,0))
new_variables$Apr = as.factor(ifelse(new_variables$month == "04",1,0))
new_variables$May = as.factor(ifelse(new_variables$month == "05",1,0))
new_variables$Jun = as.factor(ifelse(new_variables$month == "06",1,0))
new_variables$Jul = as.factor(ifelse(new_variables$month == "07",1,0))
new_variables$Aug = as.factor(ifelse(new_variables$month == "08",1,0))
new_variables$Sep = as.factor(ifelse(new_variables$month == "09",1,0))
new_variables$Oct = as.factor(ifelse(new_variables$month == "10",1,0))
new_variables$Nov = as.factor(ifelse(new_variables$month == "11",1,0))
new_variables$Dec = as.factor(ifelse(new_variables$month == "12",1,0))

str(new_variables)

#create rainy season variable
#San Juan rain months May on: https://weather-and-climate.com/average-monthly-Rainfall-
  #Temperature-Sunshine,San-Juan,Puerto-Rico
#Iquitos rain months https://weather-and-climate.com/average-monthly-Rainfall-Temperature-Sunshine,Iquitos,Peru

sj_rain_months = c("05", "08", "09", "10", "11")
sj_heavy_rain_months = c("05", "10", "11")
iq_rain_months = c("01", "03", "04", "05", "11", "12" )
iq_heavy_rain_months = c("01", "04", "12")

#new varialbe to indicate the rainy season
new_variables$rain_seas = as.factor(ifelse(
                                (is.element(new_variables$month, sj_rain_months) &
                                (new_variables$city =="sj")) |
                                (is.element(new_variables$month, iq_rain_months) &
                                (new_variables$city =="iq")), 1, 0))

#new varialbe to indicate heavy rain months
new_variables$heavy_rain_mn = as.factor(ifelse(
                                  (is.element(new_variables$month, sj_heavy_rain_months) &
                                  (new_variables$city =="sj")) |
                                  (is.element(new_variables$month, iq_heavy_rain_months) &
                                  (new_variables$city =="iq")), 1, 0))

str(new_variables)
head(new_variables)
write.table(new_variables, "rain_months.csv", row.names=FALSE)

#variables to convert C to K
new_variables$station_avg_temp_c_K = new_variables$station_avg_temp_c+273.15
new_variables$station_max_temp_c_K = new_variables$station_max_temp_c+273.15
new_variables$station_min_temp_c_K = new_variables$station_min_temp_c+273.15
new_variables$station_min_max_temp_rng_c_K = new_variables$station_max_temp_c_K - 
                                              new_variables$station_min_temp_c_K

#drop celsius reported variables
new_variables$station_avg_temp_c = NULL
new_variables$station_max_temp_c = NULL
new_variables$station_min_temp_c = NULL

#new temperature variables
new_variables$comb_temp = (new_variables$reanalysis_air_temp_k+new_variables$reanalysis_avg_temp_k+
                               new_variables$station_avg_temp_c_K)/3
#new min and max and diurnal temp variables
new_variables$comb_min = 
    (new_variables$reanalysis_min_air_temp_k+new_variables$station_min_temp_c_K)/2
new_variables$comb_max = 
    (new_variables$reanalysis_max_air_temp_k+new_variables$station_max_temp_c_K)/2
new_variables$comb_diur = 
    (new_variables$reanalysis_tdtr_k+new_variables$station_diur_temp_rng_c)/2

# new variables for highly correlated ndvi variables
new_variables$ndvi_total = (new_variables$ndvi_ne+new_variables$ndvi_nw +
                              new_variables$ndvi_se+new_variables$ndvi_sw)/4
new_variables$ndvi_north = (new_variables$ndvi_ne+new_variables$ndvi_nw)/2
new_variables$ndvi_south = (new_variables$ndvi_se+new_variables$ndvi_sw)/2
new_variables$ndvi_east = (new_variables$ndvi_ne+new_variables$ndvi_se)/2
new_variables$ndvi_west = (new_variables$ndvi_nw+new_variables$ndvi_sw)/2

str(new_variables)

#create variables that show difference from previous observation---------

num_vars = c(9:24, 57:69)
#get diff for sj
sj_data = new_variables[new_variables$city=="sj", num_vars]

var_diff_sj_out = sj_data[-1,] - sj_data[-nrow(sj_data),]
head(var_diff_sj_out)
add_sj_diff = rep(0,length(sj_data))

var_diff_sj_out = rbind(add_sj_diff,var_diff_sj_out)
head(var_diff_sj_out)

#get diff for iq---------------
iq_data = new_variables[new_variables$city=="iq", num_vars]

var_diff_iq_out = iq_data[-1,] - iq_data[-nrow(iq_data),]
add_iq_diff = rep(0,length(iq_data))

var_diff_iq_out = rbind(add_iq_diff,var_diff_iq_out)
#head(var_diff_iq_out)

#combine sj and iq data frames
var_diff_both = rbind(var_diff_sj_out, var_diff_iq_out)
str(var_diff_both)
tail(var_diff_both)

#rename columns to specify they are the differnce 
colnames(var_diff_both) = paste(colnames(var_diff_both), 
                                "diff", 
                                sep="_")
head(var_diff_both)

#create variables that show average over 4 weeks------------------------
library(zoo)

var_av_sj_1 = data.frame(rollsumr(sj_data[], 
                                  k=4, 
                                  fill=NA)/4)
var_av_sj_2 = data.frame(rollsumr(sj_data[1:3,], 
                                  k=3, 
                                  fill=NA)/3)
var_av_sj_3 = data.frame(rollsumr(sj_data[1:2,], 
                                  k=2, 
                                  fill=NA)/2)
var_av_sj_4 = var_av_sj_1[4:nrow(var_av_sj_1),]

var_av_sj_out = rbind(sj_data[1,], 
                      var_av_sj_3[2,], 
                      var_av_sj_2[3,], 
                      var_av_sj_1[4:nrow(var_av_sj_1),])

#str(var_av_sj_out)
#head(var_av_sj_out)


#repeat with iq data set
var_av_iq_1 = data.frame(rollsumr(iq_data, 
                                  k=4, 
                                  fill=NA)/4)
var_av_iq_2 = data.frame(rollsumr(iq_data[1:3,], 
                                  k=3, 
                                  fill=NA)/3)
var_av_iq_3 = data.frame(rollsumr(iq_data[1:2,], 
                                  k=2, 
                                  fill=NA)/2)
var_av_iq_4 = var_av_iq_1[4:nrow(var_av_iq_1),]

var_av_iq_out = rbind(iq_data[1,], 
                      var_av_iq_3[2,], 
                      var_av_iq_2[3,], 
                      var_av_iq_1[4:nrow(var_av_iq_1),])

#str(var_av_iq_out)
#tail(var_av_iq_out)


#combine sj and iq data frames
var_av_both = rbind(var_av_sj_out, var_av_iq_out)
str(var_av_both)
tail(var_av_both)

#rename columns to specify they are the differnce 
colnames(var_av_both) = paste(colnames(var_av_both), 
                              "av", 
                              sep="_")
head(var_av_both)
tail(var_av_both)

#create variables that show slope over 4 weeks------------------------
#sj data
var_sl_sj_1 = apply(sj_data, 
                    2, 
                    function(x) diff(x, lag=3)/4)
var_sl_sj_2 = apply(sj_data[1:3,],
                    2, 
                    function(x) diff(x, lag=2)/3)
var_sl_sj_3 = apply(sj_data[1:2,], 
                    2, 
                    function(x) diff(x, lag=1)/2)

var_sl_sj_z = rep(0,length(sj_data))  #put zero as baseline for row 1
var_sl_sj_out = rbind(var_sl_sj_z, 
                      var_sl_sj_3, 
                      var_sl_sj_2, 
                      var_sl_sj_1)
#head(var_sl_sj_out)

#iq data
var_sl_iq_1 = apply(iq_data, 
                    2, 
                    function(x) diff(x, lag=3)/4)
var_sl_iq_2 = apply(iq_data[1:3,],
                    2, 
                    function(x) diff(x, lag=2)/3)
var_sl_iq_3 = apply(iq_data[1:2,], 
                    2, 
                    unction(x) diff(x, lag=1)/2)

var_sl_iq_z = rep(0,length(iq_data)) #put zero as baseline for row 1
var_sl_iq_out = rbind(var_sl_iq_z, 
                      var_sl_iq_3, 
                      var_sl_iq_2, var_sl_iq_1)
#head(var_sl_iq_out)
#tail(var_sl_iq_out)

#combine slope data for sj and iq
var_sl_both = rbind(var_sl_sj_out, var_sl_iq_out)
head(var_sl_both)
tail(var_sl_both)
write.csv(var_sl_both, file="test_iq.csv", row.names=FALSE)
str(var_sl_both)

#rename columsn to specify they are slope data
colnames(var_sl_both) = paste(colnames(var_sl_both), 
                              "sl", 
                              sep="_")
head(var_sl_both)

#bind new variables to main dataframe
sj_variables = new_variables[new_variables$city=="sj",]
iq_variables = new_variables[new_variables$city=="iq",]
sj_iq_variables = rbind(sj_variables, iq_variables)
new_variables2 = cbind(sj_iq_variables, 
                       var_diff_both, 
                       var_av_both, 
                       var_sl_both)
str(new_variables2)

write.csv(new_variables2, file="new_variables2.csv", row.names=FALSE)

#rearrange columns by var type to easily work with them

#remove columns not useful (including start date and year which were converted above)
data_final = cbind(new_variables2[,1:8], new_variables2[,25:56], new_variables2[,9:24],
                   new_variables2[,57:156])

str(data_final)
write.csv(data_final, file="data_final.csv", row.names=FALSE)
#standardize all number values for 


##################################################################################
#
#
#         2nd EDA with New Variables
#
#
#
##################################################################################

eda2 = data_final
new_num_vars = c(41:156)

range <- function(x) {max(x, na.rm = TRUE) - min(x, na.rm = TRUE)}
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

summ_stat_all = round(t(data.frame(apply(eda2[, new_num_vars], 2, summary_stats))),2)
write.csv(summ_stat_all, "summ_stat_all.csv")


#create variable containing column names for number variables
colNames6 = names(eda2[new_num_vars])

cor_mat_all = data.frame(round(cor(eda2[,new_num_vars]),2))
cor_mat_all
write.csv(cor_mat_all, "cor_matrix_all.csv")


#BoxPlots by country  (note: there are significant differences in variables by location)
bpf2 = function(b2) {
  B = list()
  for (k in colNames6){
    b = ggplot(eda2, aes_string(x=eda2$city, y=k)) + 
    geom_boxplot(outlier.color='red', 
                 outlier.shape =1, 
                 outlier.size=3, 
                 notch=TRUE)+ 
    ylab(k)
    B = c(B, list(b))
  }
  return(list(plots=B, num=length(vars)))
}
BPlots2 = bpf2(b2)


#call each graph in 3x3 groups (can't figure out how to make do.call go to next page)
do.call(grid.arrange, c(BPlots2$plots[1:9], ncol=3, nrow=3))
do.call(grid.arrange, c(BPlots2$plots[10:18], ncol=3, nrow=3))
do.call(grid.arrange, c(BPlots2$plots[19:27], ncol=3, nrow=3))
do.call(grid.arrange, c(BPlots2$plots[28:36], ncol=3, nrow=3))
do.call(grid.arrange, c(BPlots2$plots[37:45], ncol=3, nrow=3))
do.call(grid.arrange, c(BPlots2$plots[46:54], ncol=3, nrow=3))
do.call(grid.arrange, c(BPlots2$plots[55:63], ncol=3, nrow=3))
do.call(grid.arrange, c(BPlots2$plots[64:72], ncol=3, nrow=3))
do.call(grid.arrange, c(BPlots2$plots[73:81], ncol=3, nrow=3))
do.call(grid.arrange, c(BPlots2$plots[82:90], ncol=3, nrow=3))
do.call(grid.arrange, c(BPlots2$plots[91:99], ncol=3, nrow=3))
do.call(grid.arrange, c(BPlots2$plots[100:108], ncol=3, nrow=3))
do.call(grid.arrange, c(BPlots2$plots[109:116], ncol=3, nrow=3))

#QQ plots by country
qqf2 = function(q2) {
  Q = list()
  for (k in colNames6){
    q = ggplot(eda2, aes_string(sample = k, color="city")) + 
    stat_qq() + 
    stat_qq_line() + 
    ylab(k)
    Q = c(Q, list(q))
  }
  return(list(plots=Q, num=length(vars)))
}
QPlots2 = qqf2(q2)


#call each graph in 3x3 groups (can't figure out how to make do.call go to next page)
do.call(grid.arrange, c(QPlots2$plots[1:9], ncol=3, nrow=3))
do.call(grid.arrange, c(QPlots2$plots[10:18], ncol=3, nrow=3))
do.call(grid.arrange, c(QPlots2$plots[19:27], ncol=3, nrow=3))
do.call(grid.arrange, c(QPlots2$plots[28:36], ncol=3, nrow=3))
do.call(grid.arrange, c(QPlots2$plots[37:45], ncol=3, nrow=3))
do.call(grid.arrange, c(QPlots2$plots[46:54], ncol=3, nrow=3))
do.call(grid.arrange, c(QPlots2$plots[55:63], ncol=3, nrow=3))
do.call(grid.arrange, c(QPlots2$plots[64:72], ncol=3, nrow=3))
do.call(grid.arrange, c(QPlots2$plots[73:81], ncol=3, nrow=3))
do.call(grid.arrange, c(QPlots2$plots[82:90], ncol=3, nrow=3))
do.call(grid.arrange, c(QPlots2$plots[91:99], ncol=3, nrow=3))
do.call(grid.arrange, c(QPlots2$plots[100:108], ncol=3, nrow=3))
do.call(grid.arrange, c(QPlots2$plots[109:116], ncol=3, nrow=3))


