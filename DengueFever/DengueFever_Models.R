#MSDS 454 Midterm project Models

#load pakages
library(ggplot2)
library(Amelia)
library(mice)
library(randomForest)
library(VIM)
library(gridExtra)
library(grid)
library(tidyr)

library(tree)
library(gbm)
library(xgboost)
library(class)

#from laptop
data1 = read.csv(file.path("C:/Users/delos001/OneDrive - QJA/My Files/NW Coursework/Predict 454 Advanced Modelling/Midterm Data",
                               "data_final.csv"))

test_data = read.csv(file.path("C:/Users/delos001/OneDrive - QJA/My Files/NW Coursework/Predict 454 Advanced Modelling/Midterm Data",
                               "dengue_features_test.csv"))

#from desktop
data1 = read.csv(file.path("C:/Users/Jason/OneDrive - QJA/My Files/NW Coursework/Predict 454 Advanced Modelling/Midterm Data",
                           "data_final.csv"))

test_data = read.csv(file.path("C:/Users/Jason/OneDrive - QJA/My Files/NW Coursework/Predict 454 Advanced Modelling/Midterm Data", 
                               "dengue_features_test.csv"))

str(data1)
zero_infl = as.factor(ifelse(data1$total_cases==0,0,1))
city_dum = as.factor(ifelse(data1$city == "sj", 1, 0))


str(data1)

data1 = cbind(data1[,3:7], data1[,1:2], zero_infl, city_dum, data1[,8:ncol(data1)])
str(data1)

#convert values back to factors
colfact = 11:42
for(i in colfact){
 data1[,i] <- as.factor(data1[,i])
}

str(data1)
head(data1)
tail(data1)

write.csv(data1, "model_data.csv", row.names=FALSE)
##################################################################################
#
#
#         Create data sets (original and normalized)
#
#
#
##################################################################################

#create data sets with no normailization-----------------
data_o = data1[data1$data=="train", ]
str(data_o)
o_t_samp = sample(1:nrow(data_o), nrow(data_o)/2)

o_tr = data_o[o_t_samp,]
o_val = data_o[-o_t_samp,]
o_test = data1[data1$data=="test", ]
str(o_test)
#create normalized data set-------------------------------
data_n1 = data1[, 1:42]
data_n2 = data1[, 43:158]

data_mean = apply(data_n2, 2, mean)
data_sd = apply(data_n2, 2, sd)
data_stnd = t((t(data_n2)-data_mean)/data_sd)
head(data_stnd)

#check to make sure zero mean and sd=1
apply(data_stnd, 2, mean)
apply(data_stnd, 2, sd)

data2 = cbind(data_n1, data_stnd)
str(data2)

#create train and validation set-----------------------

data_n = data2[data2$data=="train",]
str(data_n)
n_t_samp = sample(1:nrow(data_n), nrow(data_n)/2)

n_tr = data_n[n_t_samp,]
n_val = data_n[-n_t_samp,]
n_test = data2[data2$data=="test", ]

##################################################################################
#
#
#         Start of Models
#
#
#
##################################################################################


#Boost Model-------------------------------------------

#boost model 2
boost.mod2 = gbm(total_cases~., 
                 data=o_tr[,7:158],
                 distribution = "gaussian",
                 n.trees=5000,
                 shrinkage=0.01,
                 bag.fraction = 0.5,
                 train.fraction = 0.5,
                 cv.folds = 10,
                 interaction.depth = 3,
                 n.cores=4)
summary(boost.mod2)

best_mod2_oob = gbm.perf(boost.mod2, method="OOB")
print(best_mod2_oob)

best_mod2_test = gbm.perf(boost.mod2, method="test")
print(best_mod2_test)

best_mod2_cv = gbm.perf(boost.mod2, method="cv")
print(best_mod2_cv)

summary(boost.mod2, n.trees=1)
summary(boost.mod2, n.trees=best_mod2_oob)
summary(boost.mod2, n.trees=best_mod2_test)
summary(boost.mod2, n.trees=best_mod2_cv)

print(pretty.gbm.tree(boost.mod2,1))
print(pretty.gbm.tree(boost.mod2, boost.mod2$n.trees))

#use validation data to get error
boost.mod2_pred = predict(boost.mod2, o_val, best_mod2_test)
boost.mod2_pred = ifelse(boost.mod2_pred<0, 0, boost.mod2_pred)
boost.mod2_compare = data.frame(boost.mod2_pred, o_val$total_cases)
head(boost.mod2_compare)
print(sum((o_val$total_cases - boost.mod2_pred)^2))

#run on test data
boost.pred2 = predict(boost.mod2, newdata=o_test[,-1])
head(boost.pred2)
boost.pred2 = ifelse(boost.pred2<0,0, boost.pred2)
boost.pred2 = round(boost.pred2, 0)

boost_sub_file = cbind(test_data[1:3], boost.pred2)
write.csv(boost_sub_file, file="boost_sub_file.csv", row.names = FALSE)


######################################################################
#
#   logistic regression: probability total cases = 0
#
#####################################################################

model.log1 = glm(zero_infl~ 
                   norm_year + 
                   city_dum +
                   ndvi_ne_av + 
                   ndvi_se_av +
                   reanalysis_dew_point_temp_k_av + 
                   reanalysis_sat_precip_amt_mm_av
                   ,
                 data=o_tr, family=binomial("logit"))

summary(model.log1)

sum(o_tr$total_cases==0)
pred.log1 = predict(model.log1, type="response", newdata=o_val)
pred.log1[1:10]
contrasts(zero_infl)
str(o_val)
#note: if its a one, then the infections for that week is >0

log1_out = rep("Zero", length(pred.log1))
log1_out[pred.log1>0.5]=">0"
table(log1_out, o_tr$zero_infl)
length(o_tr$zero_infl)

head(o_test)
str(o_test)
pred.log1_test = predict(model.log1, type="response", newdata=o_test)

length(pred.log1_test)
write.csv(pred.log1_test, "predlog1_test.csv", row.names = FALSE)

#NOTE: model predicts no zero week cases.  
#Therefore, the train model will be refit by excluding all zero cases

sum(o_tr$total_cases==0)
o_tr_2 = o_tr[o_tr$total_cases!=0,]

sum(o_val$total_cases==0)
o_val_2 = o_val[o_val$total_cases!=0,]

sum(n_tr$total_cases==0)
n_tr_2 = n_tr[n_tr$total_cases!=0,]

n_val_2 = n_val[n_val$total_cases!=0,]


#Lasso Model---------------------------------------------------------

library(glmnet)
str(n_tr_2)
lasso_mat = model.matrix(total_cases~., n_tr_2[,7:ncol(n_tr_2)])[,-7]
lasso_mat_val = model.matrix(total_cases~., n_val_2[,7:ncol(n_val_2)])[,-7]
lasso_mat_test = model.matrix(total_cases~., n_test[,7:ncol(n_test)])[,-7]
y=n_tr_2$total_cases

grid=10^seq(10, -2, length=100)

lasso.mod1 = glmnet(lasso_mat, y, alpha=1, lambda = grid)
plot(lasso.mod1)

lasso.cv = cv.glmnet(lasso_mat, y, alpha=1)
plot(lasso.cv)
bestlam=lasso.cv$lambda.min

lasso.pred1 = predict(lasso.mod1, s=bestlam, newx = lasso_mat_val)
lasso.pred1 = ifelse(lasso.pred1<0,0, lasso.pred1)
lasso.compare1 = data.frame(lasso.pred1 - n_val_2$total_cases)
write.csv(lasso.compare1, file="lasso_mod1.csv", row.names=FALSE)
print(sum((n_val_2$total_cases - lasso.pred1)^2))

head(n_test)
#run on test data
lasso.pred2 = predict(lasso.mod1, s=bestlam, newx = lasso_mat_test)
lasso.pred2 = ifelse(lasso.pred2<0,0, lasso.pred2)
lasso.pred2 = round(lasso.pred2, 0)
head(lasso.pred2)

lasso_sub_file = cbind(n_test[,1:3], lasso.pred2)
write.csv(lasso_sub_file, file="lasso_sub_file.csv", row.names = FALSE)

#boost with only non zero observations
boost.mod3 = gbm(total_cases~., 
                 data=o_tr_2[,7:158],
                 distribution = "gaussian",
                 n.trees=5000,
                 shrinkage=0.01,
                 bag.fraction = 0.5,
                 train.fraction = 0.5,
                 cv.folds = 10,
                 interaction.depth = 3,
                 n.cores=4)
summary(boost.mod3)

best_mod3_oob = gbm.perf(boost.mod3, method="OOB", overlay=TRUE)
print(best_mod3_oob)

best_mod3_test = gbm.perf(boost.mod3, method="test", overlay=TRUE)
print(best_mod3_test)

best_mod3_cv = gbm.perf(boost.mod3, method="cv", overlay=TRUE)
print(best_mod3_cv)

summary(boost.mod3, n.trees=1)
summary(boost.mod3, n.trees=best_mod3_oob)
summary(boost.mod3, n.trees=best_mod3_test)
summary(boost.mod3, n.trees=best_mod3_cv)

print(pretty.gbm.tree(boost.mod3,1))
print(pretty.gbm.tree(boost.mod3, boost.mod2$n.trees))

#use validation data to get error
boost.mod3_pred = predict(boost.mod3, o_val_2, best_mod3_test)
boost.mod3_pred = ifelse(boost.mod3_pred<0, 0, boost.mod3_pred)
boost.mod3_compare = data.frame(boost.mod3_pred, o_val_2$total_cases)
head(boost.mod3_compare)
print(sum((o_val_2$total_cases - boost.mod3_pred)^2))

#run on test data
str(o_test)
boost.pred3 = predict(boost.mod3, newdata=o_test[,-7], best_mod3_test)
head(boost.pred3)
boost.pred3 = ifelse(boost.pred3<0,0, boost.pred3)
boost.pred3 = round(boost.pred3, 0)

boost_sub_file = cbind(o_test[1:3], boost.pred3)
write.csv(boost_sub_file, file="boost_sub_file.csv", row.names = FALSE)

#bagging model (includes non-zero observations------------------------------
model.bag1 = randomForest(total_cases~
                            norm_year + 
                            weekofyear + 
                            Oct + 
                            reanalysis_relative_humidity_percent_diff + 
                            reanalysis_precip_amt_kg_per_m2_sl + 
                            station_precip_mm_sl + 
                            station_avg_temp_c_K_av + 
                            station_min_temp_c_K_av + 
                            ndvi_se_av + 
                            ndvi_nw_imp + 
                            ndvi_north_diff + 
                            ndvi_nw_sl + 
                            ndvi_se + 
                            ndvi_ne_imp + 
                            reanalysis_tdtr_k_av + 
                            reanalysis_dew_point_temp_k,
                          data=o_tr, mtry=10, ntree=5000, importance=TRUE)

importance(model.bag1)

bag.pred1 = predict(model.bag1, newdata=o_val)
bag.pred1 = ifelse(bag.pred1<0,0, bag.pred1)
bag.compare = data.frame(bag.pred1, o_val$total_cases)
write.csv(bag.compare, file="bag.csv", row.names = FALSE)
print(sum((o_val$total_cases - bag.pred1)^2))

#run on test data
bag.pred2 = predict(model.bag1, newdata=o_test[,-1])
bag.pred2 = ifelse(bag.pred2<0,0, bag.pred2)
bag.pred2 = round(bag.pred2, 0)

bag_sub_file = cbind(o_test, bag.pred2)
write.csv(bag_sub_file, file="bag_sub_file.csv", row.names = FALSE)


#bagging model2 with non-zero observations only--------------------------------
bag_cor = data.frame(o_tr$norm_year , 
            o_tr$rain_seas , 
            o_tr$Oct , 
            o_tr$Nov , 
            o_tr$reanalysis_dew_point_temp_k_av , 
            o_tr$station_avg_temp_c_K_av , 
            o_tr$reanalysis_avg_temp_k_diff , 
            o_tr$station_min_max_temp_rng_c_K_diff , 
            o_tr$station_min_max_temp_rng_c_K_sl , 
            o_tr$station_max_temp_c_K , 
            o_tr$station_max_temp_c_K_sl , 
            o_tr$station_min_temp_c_K_av , 
            o_tr$comb_min_diff , 
            o_tr$reanalysis_precip_amt_kg_per_m2_diff , 
            o_tr$reanalysis_sat_precip_amt_mm_diff , 
            o_tr$station_precip_mm_diff , 
            o_tr$ndvi_se_av , 
            o_tr$ndvi_nw , 
            o_tr$ndvi_east_sl , 
            o_tr$ndvi_ne_diff , 
            o_tr$ndvi_nw_imp , 
            o_tr$ndvi_ne_imp)
head(bag_cor)

small_cor = cor(bag_cor[,5:19])
write.csv(small_cor , "cor_matrixsmall.csv")

#bag2 with total-case = zero observations removed
model.bag3 = randomForest(total_cases~
                            norm_year + 
                            rain_seas + 
                            Oct + 
                            Nov + 
                            reanalysis_dew_point_temp_k_av + 
                            reanalysis_avg_temp_k_diff + 
                            station_min_max_temp_rng_c_K_diff + 
                            station_min_max_temp_rng_c_K_sl + 
                            station_max_temp_c_K + 
                            station_min_temp_c_K_av + 
                            comb_min_diff + 
                            reanalysis_precip_amt_kg_per_m2_diff + 
                            reanalysis_sat_precip_amt_mm_diff + 
                            station_precip_mm_diff + 
                            ndvi_se_av + 
                            ndvi_nw + 
                            ndvi_east_sl + 
                            ndvi_ne_diff + 
                            ndvi_nw_imp + 
                            ndvi_ne_imp, 
                            
                          data=o_tr_2[,7:ncol(o_tr_2)], mtry=10, ntree=5000, importance=TRUE)

importance(model.bag3)

bag.pred3 = predict(model.bag3, newdata=o_val_2)
bag.pred3 = ifelse(bag.pred3<0,0, bag.pred3)
bag.compare = data.frame(bag.pred3, o_val_2$total_cases)
write.csv(bag.compare, file="bag.csv", row.names = FALSE)
print(sum((o_val_2$total_cases - bag.pred3)^2))

#run on test data
bag.pred4 = predict(model.bag3, newdata=o_test[,-7])
bag.pred4 = ifelse(bag.pred4<0,0, bag.pred4)
bag.pred4 = round(bag.pred4, 0)

bag_sub_file = cbind(o_test[,1:3], bag.pred4)
write.csv(bag_sub_file, file="bag_sub_file.csv", row.names = FALSE)

#GAM Model-----------------##Poor performer: do not use

library(gam)
model.gam1 = gam(total_cases~
                   norm_year + 
                   weekofyear + 
                   Oct + 
                   reanalysis_relative_humidity_percent_diff + 
                   reanalysis_precip_amt_kg_per_m2_sl + 
                   station_precip_mm_sl + 
                   station_avg_temp_c_K_av + 
                   station_min_temp_c_K_av + 
                   ndvi_se_av + 
                   ndvi_nw_imp + 
                   ndvi_north_diff + 
                   ndvi_nw_sl + 
                   ndvi_se + 
                   ndvi_ne_imp + 
                   reanalysis_tdtr_k_av + 
                   reanalysis_dew_point_temp_k,
                   
                 data=n_tr)
plot(model.gam1, se=TRUE, col="green")
summary(model.gam1)
#SVM Model---------------------------------------------
library(e1071)

model.svm.tune = tune(svm, total_cases~
                        norm_year + 
                        weekofyear + 
                        Oct + 
                        reanalysis_relative_humidity_percent_diff + 
                        reanalysis_precip_amt_kg_per_m2_sl + 
                        station_precip_mm_sl + 
                        station_avg_temp_c_K_av + 
                        station_min_temp_c_K_av + 
                        ndvi_se_av + 
                        ndvi_nw_imp + 
                        ndvi_north_diff + 
                        ndvi_nw_sl + 
                        ndvi_se + 
                        ndvi_ne_imp + 
                        reanalysis_tdtr_k_av + 
                        reanalysis_dew_point_temp_k,
                      data=n_tr_2,
                      kernel="polynomial",
                      ranges=list(degree=c(1,2,3,4,5), 
                                cost=c(0.01, 0.1, 1, 10, 100)))

summary(model.svm.tune)

model.svm1 = svm(total_cases~
                   norm_year + 
                   weekofyear + 
                   Oct + 
                   reanalysis_relative_humidity_percent_diff + 
                   reanalysis_precip_amt_kg_per_m2_sl + 
                   station_precip_mm_sl + 
                   station_avg_temp_c_K_av + 
                   station_min_temp_c_K_av + 
                   ndvi_se_av + 
                   ndvi_nw_imp + 
                   ndvi_north_diff + 
                   ndvi_nw_sl + 
                   ndvi_se + 
                   ndvi_ne_imp + 
                   reanalysis_tdtr_k_av + 
                   reanalysis_dew_point_temp_k,
                      data=n_tr,
                      kernel="polynomial",
                      ranges=list(degree=2, 
                                  cost=10))

summary(model.svm1)

svm1.predict = predict(model.svm1, newdata = n_val[,-1])
svm1.predict = ifelse(svm1.predict<0,0, svm1.predict)
svm1.compare = data.frame(svm1.predict, n_val$total_cases)
print(sum((n_val$total_cases - svm1.predict)^2))
length(svm1.predict)
str(n_val)

#spline model-------------------------------------------------------

library(splines)
model.spline1 = lm(total_cases~
                     norm_year + 
                     weekofyear + 
                     Oct + 
                     reanalysis_relative_humidity_percent_diff + 
                     reanalysis_precip_amt_kg_per_m2_sl + 
                     station_precip_mm_sl + 
                     station_avg_temp_c_K_av + 
                     station_min_temp_c_K_av + 
                     ndvi_se_av + 
                     ndvi_nw_imp + 
                     ndvi_north_diff + 
                     ndvi_nw_sl + 
                     ndvi_se + 
                     ndvi_ne_imp + 
                     reanalysis_tdtr_k_av + 
                     reanalysis_dew_point_temp_k,
                   data=n_tr)

summary(model.spline1)
spline.pred1 = predict(model.spline1, newdata=n_val)
spline.pred1 = ifelse(spline.pred1<0,0, spline.pred1)
spline.compare = data.frame(spline.pred1, n_val$total_cases)
write.csv(spline.compare, file="spline.csv", row.names = FALSE)
print(sum((n_val$total_cases - spline.pred1)^2))



#neural network model---------------------------------------

library(nnet)
library(caret)

mygrid = expand.grid(.decay = c(0.5, 0.1), .size=c(4,5,6))
train.nn1 = train(total_cases~
                    norm_year + 
                    weekofyear + 
                    Oct + 
                    reanalysis_relative_humidity_percent_diff + 
                    reanalysis_precip_amt_kg_per_m2_sl + 
                    station_precip_mm_sl + 
                    station_avg_temp_c_K_av + 
                    station_min_temp_c_K_av + 
                    ndvi_se_av + 
                    ndvi_nw_imp + 
                    ndvi_north_diff + 
                    ndvi_nw_sl + 
                    ndvi_se + 
                    ndvi_ne_imp + 
                    reanalysis_tdtr_k_av + 
                    reanalysis_dew_point_temp_k,
                 data=n_tr, method="nnet", maxit=1000, tuneGrid=mygrid, trace=FALSE )

print(train.nn1)

set.seed(123)
model.nn1 = nnet(total_cases~
                   norm_year + 
                   weekofyear + 
                   Oct + 
                   reanalysis_relative_humidity_percent_diff + 
                   reanalysis_precip_amt_kg_per_m2_sl + 
                   station_precip_mm_sl + 
                   station_avg_temp_c_K_av + 
                   station_min_temp_c_K_av + 
                   ndvi_se_av + 
                   ndvi_nw_imp + 
                   ndvi_north_diff + 
                   ndvi_nw_sl + 
                   ndvi_se + 
                   ndvi_ne_imp + 
                   reanalysis_tdtr_k_av + 
                   reanalysis_dew_point_temp_k,
                   data=n_tr, decay=0.1, size=6 )

summary(model.nn1)
nn.pred1 = predict(model.nn1, newdata = n_val)
nn.pred1 = ifelse(nn.pred1<0,0, nn.pred1)
nn.compare = data.frame(nn.pred1, n_val$total_cases)
write.csv(nn.compare, file="nn.csv", row.names = FALSE)
print(sum((n_val$total_cases - nn.pred1)^2))
