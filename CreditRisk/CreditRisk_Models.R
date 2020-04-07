

library(rpart)
#install.packages('rpart.plot', dependencies = TRUE)
library(rpart.plot)


#install.packages('pROC',dependencies=TRUE)
library(pROC)
library(stargazer)
#########################################################
# Load Files.*distinguish paths for laptop vs. workstation
#########################################################
#workstation
ws_path = 'C:\\Users\\Jason\\OneDrive - QJA\\My Files\\NW Coursework\\Predict 498 Capstone\\Project_Data\\'

#laptop
lap_path = 'D:\\OneDrive - QJA\\My Files\\NW Coursework\\Predict 498 Capstone\\Project_Data\\'

my_path = lap_path


#########################################################
#  set path where export images and files will be saved
#########################################################
ws_exp_path = 'C:\\Users\\Jason\\OneDrive - QJA\\My Files\\NW Coursework\\Predict 498 Capstone\\Project_Data\\exports\\'
lap_exp_path = 'D:\\OneDrive - QJA\\My Files\\NW Coursework\\Predict 498 Capstone\\Project_Data\\exports\\'

exp_path = lap_exp_path  #change this line depending on if using laptop or workstation

#########################################################
# Define Global Functions
#########################################################
#column number function
col_index = function(ci) {
  col_names = as.data.frame(colnames(ci))
  return(col_names)
}

#missing stats function
missing_stats = function(m) {
  miss = data.frame(rbind(length(m),
                          sum(is.na(m)==TRUE),
                          sum(is.na(m)==TRUE) / length(m)),
                    row.names = c("Length", 
                                  "Missing",
                                  "%Missing"))
  colnames(miss)=colnames(m)
  return(miss)
}

missing_stats_tbl = function (x){
  round(t(data.frame(apply(x, 2, 
                           missing_stats))),2)
}



#basic stats function
range = function(x) {
  max(x, na.rm = TRUE) - min(x, na.rm = TRUE)
}
summ_stats = function(x) {
  stats = data.frame(rbind(range(x),
                           min(x, na.rm=TRUE),
                           quantile(x, probs = c(0.10), 
                                    na.rm = TRUE),                           
                           #quantile(x, probs = c(0.25), na.rm = TRUE),
                           mean(x, na.rm = TRUE),
                           median(x, na.rm = TRUE),
                           #quantile(x, probs = c(0.75), na.rm = TRUE),
                           quantile(x, probs = c(0.90), 
                                    na.rm = TRUE),
                           max(x, na.rm=TRUE),
                           sd(x, na.rm = TRUE),
                           var(x, na.rm = TRUE)),
                     row.names = c("Range", "Min", 
                                   "Q10", 
                                   #"Q25", 
                                   "Mean", 
                                   "Med", 
                                   #"Q75", 
                                   "Q90", 
                                   "Max", 
                                   "SD", "Var"))
  colnames(stats)=colnames(x)
  return(stats)
}

summ_stats_tbl = function (x){
  round(t(data.frame(apply(x, 2, summ_stats))),2)
}

#########################################################
# Read the file;
#########################################################
cc_data_all = read.csv(
  file.path(my_path, 'cc_data_engineered.csv'), 
  header = TRUE)

head(cc_data_all)

col_index(cc_data_all)

#ORGANIZE THE VARIABLES FOR MODELING
cc_data_all2 = cc_data_all[,c(1, #index
                              26:30, #data split variables
                              25, #dependent var
                              3:24, 2, #original raw
                              31:32, #re-grouped education, marriage
                              33:34, 54, 52, #bill amt vars
                              35:36, 55, #pmt vars
                              37:43, #pmt ratio
                              58:59, #pmt to bill ratio: av and slope 
                              44:51, 53, #utilization
                              56:57, #deliquency vars
                              61, #age bin
                              60, #limit bal bin
                              62:63, 70, 72, #av and max bill amt bin
                              64:67, 73, #pmt ratio: av, slope bin
                              75:76, #pmt to bill: av, slope bin
                              68:69, 71, #util bin
                              74, #DLQ bin
                              77:83, #ed1 dum
                              84:88, #ed2 dum
                              89:92, #mar1 dum
                              93:95, #mar2 dum
                              96:99, #age dum
                              100:102, #LIM dum
                              103:111, #bill amt: av and slope dum
                              148:151, #max bill amt dum
                              139:142, #bal over 6mo dum
                              112:118, #pmt amt: av and slope dum
                              152:154, #max pmt amt dum
                              159:163, #av pmt to av bill ratio dum
                              164:168, #slope pmt to slope bill ratio dum
                              119:129, #pmt ratio: av & slope dum
                              130:138, #util: av & slope dum
                              143:147, #util over 6mo dum
                              155:158 #DLQ ratio dum
                              )] 

col_index(cc_data_all2)
head(cc_data_all2)



#########################################################
# #CREATE THREE DIFFERENT DATA SETS: 
#          ORIGINAL DATA, CONTINUOUS VARS, BINNED VARS
#########################################################

#########################################################
#ORIGINAL VARIABLES: except sex, edu, marr are dummy variables

orig = cc_data_all2[,c(1:7, 8, 11:30, 77:83, 89:92)]
col_index(orig)

#########################################################
#CONTINUOUS VARIABLES: except sex, edu, marr are dummy variables
cont_t = cc_data_all2[,c(1:7, 8, 84:88, 93:95, 11, 
                         30, 33:39, 45:48, 55:59)]
col_index(cont_t)

#  normalize the continuous vars
cont_a = cont_t[,1:16]
cont_b = cont_t[,17:ncol(cont_t)]

cont_mean = apply(cont_b, 2, mean)
cont_sd = apply(cont_b, 2, sd)
cont_stnd = t((t(cont_b)-cont_mean)/cont_sd)

head(cont_stnd)

#checks to make sure mean 0, sd 1
apply(cont_stnd, 2, mean)
apply(cont_stnd, 2, sd)

#get basic stats for normalized data set
basic_stats = summ_stats_tbl(cont_stnd)

#cobmine columsn from cont_a and cont_stnd
cont = cbind(cont_a, cont_stnd)

#########################################################
# BINNED VARS 
binn = cc_data_all2[c(1:7, 8, 84:88, 93:168)]
col_index(binn)


#original data vars
orig_trn = orig[orig$data.group==1,]
orig_val = orig[orig$data.group==2,]
orig_tst = orig[orig$data.group==3,]

#continuous data vars
cont_trn = cont[cont$data.group==1,]
cont_val = cont[cont$data.group==2,]
cont_tst = cont[cont$data.group==3,]

#binned data vars
binn_trn = binn[binn$data.group==1,]
binn_val = binn[binn$data.group==2,]
binn_tst = binn[binn$data.group==3,]

#check to make sure splits produce expected dimensions
#should be approx 50/25/25
dim(orig_trn); dim(cont_trn); dim(binn_trn)
dim(orig_val); dim(cont_val); dim(binn_val)
dim(orig_tst); dim(cont_tst); dim(binn_tst)



#########################################################
# EDA USING RPART FOR EXPLORATORY ANALYSIS
#########################################################

#https://blog.revolutionanalytics.com/2013/06/plotting-classification-and-regression-trees-with-plotrpart.html
#http://www.milbo.org/rpart-plot/prp.pdf

#model 1-------------------------------------------------
train_mod = orig_trn

tree_orig = rpart(DEFAULT~., train_mod, minsplit=20)
rpart.plot(tree_orig, type=3, 
           box.palette="RdBu", 
           shadow.col = 'gray', 
           nn=TRUE)
prp(tree_orig)
tree_orig

#model 2-------------------------------------------------
train_cont = cont_trn

tree_cont = rpart(DEFAULT~., train_cont, minsplit=20)
rpart.plot(tree_cont, type=3, 
           box.palette="RdBu", 
           shadow.col = 'gray', 
           nn=TRUE)
prp(tree_cont)
tree_cont

#model 3-------------------------------------------------
train_binn = binn_trn

tree_binn = rpart(DEFAULT~., train_binn, minsplit=20)
rpart.plot(tree_binn, type=3, 
           box.palette="RdBu", 
           shadow.col = 'gray', 
           nn=TRUE)
prp(tree_binn)
tree_binn

#########################################################
# MODELS:
#
# RANDOM FOREST
# GRADIENT BOOSTING
# LOGISTIC REGRESSION
# OTHER
#
#########################################################

#USE  names(model1) to get the options of a model object

#CREATE VARIABLE SUBSETS
#split the variables to exclude correlative effects
#list excludes 1 dummy variable for each factor

#get col numbers
col_index(cont_trn)

#use for regression models-------------------------------
cont_list_av = c(7, 8, 9:13, 14:16, 17:18, 19, 22, 23, 
                 26, 30, 34)
col_index(cont_trn[cont_list_av])

cont_list_max = c(7, 8, 9:13, 14:16, 17:18, 21, 22, 25, 
                  32, 33)
col_index(cont_trn[cont_list_max])

cont_list_sl = c(7, 8, 9:13, 14:16, 17:18, 20, 22, 24, 
                 27, 31, 34)
col_index(cont_trn[cont_list_sl])

cont_list_oth1 = c(7, 8, 9:13, 14:16, 17:18, 28, 30, 34)
col_index(cont_trn[cont_list_oth1])

cont_list_oth2 = c(7, 8, 9:13, 14:16, 17:18, 29, 31, 34)
col_index(cont_trn[cont_list_oth2])


#use for non-regression models---------------------------
col_index(binn)
binn_list_av = c(7, 8, 9:13, 14:16, 17:20, 
                 21:23, 
                 24:28, 
                 41:43, 
                 61:64, 
                 72:74, 
                 86:89)
col_index(binn_trn[binn_list_av])

binn_list_sl = c(7, 8, 9:13, 14:16, 17:20, 
                 21:23,
                 29:32, 
                 44:47, 
                 65:71, 
                 75:80,
                 86:89)
col_index(binn_trn[binn_list_sl])

binn_list_oth1a = c(7, 8, 9:12, 14:15, 17:19, 
                   21:22,
                   37:39,
                   48:49,
                   51:54,
                   72:73,
                   86:88)
col_index(binn_trn[binn_list_oth1a])

binn_list_oth1b = c(7, 8, 9:13, 14:16, 17:20, 
                    21:23,
                    37:40,
                    48:50,
                    51:55,
                    72:74,
                    86:89)
col_index(binn_trn[binn_list_oth1b])

binn_list_oth1c = c(7, 8, 9:12, 14:15, 17:19, 
                    21:22,
                    24:27,
                    29,31,
                    33:35,
                    37:39,
                    41:42,
                    44:46,
                    48:49,
                    51:54,
                    56:59,
                    61:63,
                    65:70,
                    72:73,
                    75:79,
                    81:84,
                    86:88)
col_index(binn_trn[binn_list_oth1c])

binn_list_oth2 = c(7, 8, 9:13, 14:16, 17:20, 
                   21:23,
                   56:60,
                   75:80,
                   86:89)
col_index(binn_trn[binn_list_oth2])


#########################################################
#
# RANDOM FOREST
#
#########################################################
library(randomForest)

col_index(orig_trn)

#removes intercept level for dummy vars
orig_list = c(7:28, 29:34, 36:38)
set.seed(3232)

#using original data--------------------------------------------
rf1 = randomForest(as.factor(DEFAULT)~., 
                   data=orig_trn[,orig_list],
                   mytry=6, ntree=500, importance=TRUE)

importance(rf1)
varImpPlot(rf1)
names(rf1)
summary(rf1)

#run on validation set
rf1pred = predict(rf1, 
                  newdata = orig_val[,orig_list][-1])

#confusion matrix for validation prediction
confusionMatrix(rf1pred, 
                as.factor(orig_val$DEFAULT))

num_rf1pred = as.numeric(rf1pred)-1
roc_rf1 <- roc(response=orig_val$DEFAULT, 
               predictor= num_rf1pred)
print(roc_rf1)
plot(roc_rf1, main = 'Random Forest: Original Data Vars')

# Compute AUC
auc_rf1 <- auc(roc_rf1);

#predict on test data
rf1.1pred = predict(rf1, 
                  newdata = orig_tst[,orig_list][-1])
num_rf1.1pred = as.numeric(rf1.1pred)-1
roc_rf1.1 <- roc(response=orig_tst$DEFAULT, 
               predictor= num_rf1.1pred)

print(roc_rf1.1)
plot(roc_rf1.1, main = 'Random Forest: Original Data Vars')

# Compute AUC
auc_rf1.1 <- auc(roc_rf1.1);

#using average features----------------------------------------
rf2 = randomForest(as.factor(DEFAULT)~ 
                   SEX +
                   dED2_Adv_Gra +
                   dED2_Grad + dED2_University + dED2_HS + #dED2Other +
                   dMAR2_Married + dMAR2_Single + #dMAR2_Other +
                   AGE + 
                   LIMIT_BAL + 
                   Avg_Bill_Amt + 
                   Bal_Growth_6mo + 
                   Avg_Pmt_Amt + 
                   Avg_Pmt_Ratio + 
                   Avg_Util +
                   DLQ_ratio,
                  data=cont_trn,
                   mytry=6, ntree=500, importance=TRUE)

importance(rf2)
varImpPlot(rf2)

#get predicted values using validation set
col_index(cont_val)
rf2pred = predict(rf2, 
                    newdata = cont_val[,8:34])

#repeat using the variables >20 on mean decrease accuracy
rf2.1 = randomForest(as.factor(DEFAULT)~ 
                       SEX +
                       dED2_Adv_Gra + dED2_Grad + dED2_University + dED2_HS + #dED2Other +
                       dMAR2_Married + dMAR2_Single + #dMAR2_Other +
                       AGE + 
                       LIMIT_BAL + 
                       Avg_Bill_Amt + 
                       Bal_Growth_6mo + 
                       Avg_Pmt_Amt + 
                       Avg_Pmt_Ratio + 
                       Avg_Util +
                       DLQ_ratio,
                   data=cont_trn,
                   mytry=6, ntree=500, importance=TRUE)

rf2.1pred = predict(rf2.1, 
                    newdata = cont_val[,8:34])

#confusion matrix for validation prediction
confusionMatrix(rf2.1pred, 
                as.factor(orig_val$DEFAULT))


#predict on test set
rf2.2pred = predict(rf2.1, 
                    newdata = cont_tst[,8:34])

confusionMatrix(rf2.2pred, 
                as.factor(orig_tst$DEFAULT))

num_rf2.2pred = as.numeric(rf2.2pred)-1
roc_rf2.2 <- roc(response=orig_tst$DEFAULT, 
                 predictor= num_rf2.2pred)

print(roc_rf2.2)
plot(roc_rf2.2, main = 'Random Forest: Aggregate Average Variables')

# Compute AUC
auc_rf2.2 <- auc(roc_rf2.2);

varImpPlot(rf2.1)
importance(rf2.1)
names(rf2.1)
summary(rf2.1)

install.packages('randomForestExplainer')
library(randomForestExplainer)
explain_forest(rf2.1, interactions = TRUE, data=cont_tst[,8:34])

#using max features--------------------------------------------
rf3 = randomForest(as.factor(DEFAULT)~ 
                     SEX + 
                     dED2_Adv_Gra +  dED2_Grad +  dED2_University +  dED2_HS +  #dED2Other +  
                     dMAR2_Married +  dMAR2_Single +  #dMAR2_Other +  
                     AGE + 
                     LIMIT_BAL +  
                     Max_Bill_Amt +  
                     Bal_Growth_6mo +  
                     Max_Pmt_Amt +  
                     Util_Growth_6mo +  
                     Max_DLQ,
                     data = cont_trn,
                     mytry=6, ntree=500, importance=TRUE)

importance(rf3)
varImpPlot(rf3)

rf3pred = predict(rf3, 
                  newdata = cont_val[,8:34])

confusionMatrix(rf3pred, 
                as.factor(orig_val$DEFAULT))

#repeat using variable selected from varImpPlot
rf3.1 = randomForest(as.factor(DEFAULT)~ 
                     #SEX + 
                     #dED2_Adv_Gra +  dED2_Grad +  dED2_University +  dED2_HS +  #dED2Other +  
                     dMAR2_Married +  dMAR2_Single +  #dMAR2_Other +  
                     AGE + 
                     LIMIT_BAL +  
                     Max_Bill_Amt +  
                     Bal_Growth_6mo +  
                     Max_Pmt_Amt +  
                     Util_Growth_6mo +  
                     Max_DLQ,
                   data = cont_trn,
                   mytry=6, ntree=500, importance=TRUE)

rf3.1pred = predict(rf3.1, 
                    newdata = cont_val[,8:34])

confusionMatrix(rf3.1pred, 
                as.factor(orig_val$DEFAULT))


#predict on test data set
rf3.2pred = predict(rf3.1, 
                    newdata = cont_tst[,8:34])

confusionMatrix(rf3.2pred, 
                as.factor(orig_tst$DEFAULT))

num_rf3.2pred = as.numeric(rf3.2pred)-1
roc_rf3.2 <- roc(response=orig_tst$DEFAULT, 
                 predictor= num_rf3.2pred)

auc_rf3.2 <- auc(roc_rf3.2);

print(roc_rf3.2)
plot(roc_rf3.2, main = 'Random Forest: Aggregate Max Variables')

#using slope features------------------------------------------
rf4 = randomForest(as.factor(DEFAULT)~
                     SEX +  
                     dED2_Adv_Gra + dED2_Grad +  dED2_University +  dED2_HS +  dED2Other +  
                     dMAR2_Married +  dMAR2_Single +  dMAR2_Other +  
                     AGE +  
                     LIMIT_BAL + 
                     Slope_Bill_Amt + 
                     Bal_Growth_6mo + 
                     Slope_Pmt_Amt + 
                     Slope_Pmt_Ratio +  
                     Slope_Util + 
                     DLQ_ratio,
                   data = cont_trn,
                     mytry=6, ntree=500, importance=TRUE)

importance(rf4)
varImpPlot(rf4)

rf4pred = predict(rf4, 
                  newdata = cont_val[,8:34])

confusionMatrix(rf4pred, 
                as.factor(orig_val$DEFAULT))

#repeat using just vars from VarImpPlot
rf4.1 = randomForest(as.factor(DEFAULT)~
                     SEX +  
                     #dED2_Adv_Gra + dED2_Grad +  dED2_University +  dED2_HS +  dED2Other +  
                     dMAR2_Married +  dMAR2_Single +  dMAR2_Other +  
                     AGE +  
                     LIMIT_BAL + 
                     Slope_Bill_Amt + 
                     Bal_Growth_6mo + 
                     #Slope_Pmt_Amt + 
                     Slope_Pmt_Ratio +  
                     Slope_Util + 
                     DLQ_ratio,
                   data = cont_trn,
                   mytry=6, ntree=500, importance=TRUE)

rf4.1pred = predict(rf4.1, 
                  newdata = cont_val[,8:34])

confusionMatrix(rf4.1pred, 
                as.factor(orig_val$DEFAULT))


#predict on test data set
rf4.2pred = predict(rf4.1, 
                    newdata = cont_tst[,8:34])

confusionMatrix(rf4.2pred, 
                as.factor(orig_tst$DEFAULT))

num_rf4.2pred = as.numeric(rf4.2pred)-1
roc_rf4.2 <- roc(response=orig_tst$DEFAULT, 
                 predictor= num_rf4.2pred)

auc_rf4.2 <- auc(roc_rf4.2);

print(roc_rf4.2)
plot(roc_rf4.2, main = 'Random Forest: Aggregate Slope Variables')


#using other1 features----------------------------------------
rf5 = randomForest(as.factor(DEFAULT)~
                     SEX + 
                     dED2_Adv_Gra +  dED2_Grad +  dED2_University +  dED2_HS +  dED2Other +  
                     dMAR2_Married +  dMAR2_Single +  dMAR2_Other +  
                     AGE +  
                     LIMIT_BAL +  
                     avPmt_avBill_Ratio +  
                     Avg_Util + 
                     DLQ_ratio,
                   data = cont_trn,
                     mytry=6, ntree=500, importance=TRUE)

importance(rf5)
varImpPlot(rf5)

rf5pred = predict(rf5, 
                  newdata = cont_val[,8:34])

confusionMatrix(rf5pred, 
                as.factor(orig_val$DEFAULT))

#repeat using vars from VarImpPlot
rf5.1 = randomForest(as.factor(DEFAULT)~
                       SEX + 
                       dED2_Adv_Gra +  dED2_Grad +  dED2_University +  dED2_HS +  dED2Other +
                       dMAR2_Married +  dMAR2_Single +  dMAR2_Other +  
                       AGE + 
                       LIMIT_BAL +  
                       avPmt_avBill_Ratio +  
                       Avg_Util + 
                       DLQ_ratio,
                   data = cont_trn,
                   mytry=6, ntree=500, importance=TRUE)

rf5.1pred = predict(rf5.1, 
                  newdata = cont_val[,8:34])

confusionMatrix(rf5.1pred, 
                as.factor(orig_val$DEFAULT))

#predict on test data set
rf5.2pred = predict(rf5.1, 
                    newdata = cont_tst[,8:34])

confusionMatrix(rf5.2pred, 
                as.factor(orig_tst$DEFAULT))

num_rf5.2pred = as.numeric(rf5.2pred)-1
roc_rf5.2 <- roc(response=orig_tst$DEFAULT, 
                 predictor= num_rf5.2pred)

auc_rf5.2 <- auc(roc_rf5.2);

print(roc_rf5.2)
plot(roc_rf5.2, main = 'Random Forest: Aggregate Other1 Variables')

#using other2 features------------------------------------------
rf6 = randomForest(as.factor(DEFAULT)~
                     SEX +  
                     dED2_Adv_Gra +  dED2_Grad +  dED2_University +  dED2_HS +  dED2Other +  
                     dMAR2_Married +  dMAR2_Single +  dMAR2_Other +  
                     AGE + 
                     LIMIT_BAL +  
                     slPmt_slBill_Ratio +  
                     Slope_Util +  
                     DLQ_ratio,
                   data = cont_trn,
                     mytry=6, ntree=500, importance=TRUE,
                     type = 'class')

importance(rf6)
varImpPlot(rf6)

rf6.1 = randomForest(as.factor(DEFAULT)~
                     SEX +  
                     #dED2_Adv_Gra +  dED2_Grad +  dED2_University +  dED2_HS +  dED2Other +  
                     dMAR2_Married +  dMAR2_Single +  dMAR2_Other +  
                     AGE + 
                     LIMIT_BAL +  
                     slPmt_slBill_Ratio +  
                     Slope_Util +  
                     DLQ_ratio,
                   data = cont_trn,
                   mytry=6, ntree=500, importance=TRUE,
                   type = 'class')

rf6.1pred = predict(rf6.1, newdata = cont_val[,8:34])

confusionMatrix(rf6.1pred, 
                as.factor(orig_val$DEFAULT))

#predict on test data set
rf6.2pred = predict(rf6.1, 
                    newdata = cont_tst[,8:34])

confusionMatrix(rf6.2pred, 
                as.factor(orig_tst$DEFAULT))

num_rf6.2pred = as.numeric(rf6.2pred)-1
roc_rf6.2 <- roc(response=orig_tst$DEFAULT, 
                 predictor= num_rf6.2pred)

auc_rf6.2 <- auc(roc_rf6.2);

print(roc_rf6.2)
plot(roc_rf6.2, main = 'Random Forest: Aggregate Other2 Variables')


file.name <- 'rf1_2.html';
stargazer(rf2.1, rf3.1, type=c('html'),out=paste(exp_path,file.name,sep=''),
          title=c('Table XX: Comparison of Model #1 and Model #2'),
          align=TRUE, digits=2, digits.extra=2, initial.zero=TRUE, 
          column.labels=c('Average_Vars','Max_Vars'), intercept.bottom=FALSE )

#########################################################
# 
# GRADIENT BOOSTING
#
#########################################################

#install.packages('xgboost', dependencies = TRUE)
library(xgboost)

set.seed(3232)
#Model 1 with average variables

#set training data as matrix using average variable set
cont_trn_xgb_data = as.matrix(cont_trn[,cont_list_av])
#remove DEFAULT variable
cont_trn_xgb_data = cont_trn_xgb_data[,-1]

#set depend variable as matrix
cont_trn_xgb_label = as.matrix(cont_trn$DEFAULT)

xgtrn = xgb.DMatrix(cont_trn_xgb_data, 
                    label = cont_trn$DEFAULT)

param <- list(max_depth = 12, eta = 0.01, 
              nthread = 2, 
              objective = "binary:logistic", 
              eval_metric = "auc")

#xgboost model1-------------------------------------
bst1 = xgb.train(param, xgtrn, nrounds = 1000)

#predict on validation set
cont_val_bst = cont_val[,cont_list_av]
cont_val_bst = cont_val_bst[,-1]
bst1pred = predict(bst1, as.matrix(cont_val_bst))


#set rule if prob >0.5, then its 1, else 0
bst1pred_class = as.numeric(bst1pred>0.5)

#confusion matrix: valiation set
confusionMatrix(as.factor(bst1pred_class), 
                as.factor(orig_val$DEFAULT))

roc_bst1 <- roc(response=orig_val$DEFAULT, 
                 predictor= bst1pred_class)

auc_bst1 <- auc(roc_bst1);

print(roc_bst1)
plot(roc_bst1, main = 'XGBoost: Average Variables')

#predict on TEST set
cont_tst_bst = cont_tst[,cont_list_av]
cont_tst_bst = cont_tst_bst[,-1]

bst1.2pred = predict(bst1, as.matrix(cont_tst_bst))

#set rule if prob >0.5, then its 1, else 0
bst1.2pred_class = as.numeric(bst1.2pred>0.5)

#confusion matrix: valiation set
confusionMatrix(as.factor(bst1.2pred_class), 
                as.factor(orig_tst$DEFAULT))

roc_bst1.2 <- roc(response=orig_tst$DEFAULT, 
                predictor= bst1.2pred_class)

auc_bst1.2 <- auc(roc_bst1.2);

print(roc_bst1)
plot(roc_bst1.2, main = 'XGBoost: Aggregate Average Variables')

#Model 2 with oth1 variables---------------------------

#set training data as matrix using average variable set
cont_trn_xgb_data = as.matrix(cont_trn[,cont_list_oth1])
#remove DEFAULT variable
cont_trn_xgb_data = cont_trn_xgb_data[,-1]

#set depend variable as matrix
cont_trn_xgb_label = as.matrix(cont_trn$DEFAULT)

xgtrn2 = xgb.DMatrix(cont_trn_xgb_data, 
                     label = cont_trn$DEFAULT)

param <- list(max_depth = 12, eta = 0.01, 
              nthread = 2, 
              objective = "binary:logistic", 
              eval_metric = "auc")
bst2 = xgb.train(param, xgtrn2, nrounds = 1000)

cont_val_bst = cont_val[,cont_list_oth1]
cont_val_bst = cont_val_bst[,-1]

#predict on validation set
bst2pred = predict(bst2, as.matrix(cont_val_bst))

#set rule if prob >0.5, then its 1, else 0
bst2pred_class = as.numeric(bst2pred>0.5)

confusionMatrix(as.factor(bst2pred_class), 
                as.factor(orig_val$DEFAULT))

#predict on TEST set
cont_tst_bst = cont_tst[,cont_list_oth1]
cont_tst_bst = cont_tst_bst[,-1]

bst2.1pred = predict(bst2, as.matrix(cont_tst_bst))

#set rule if prob >0.5, then its 1, else 0
bst2.1pred_class = as.numeric(bst2.1pred>0.5)

#confusion matrix: valiation set
confusionMatrix(as.factor(bst2.1pred_class), 
                as.factor(orig_tst$DEFAULT))

roc_bst2.1 <- roc(response=orig_tst$DEFAULT, 
                  predictor= bst2.1pred_class)

auc_bst2.1 <- auc(roc_bst2.1);

print(roc_bst2.1)
plot(roc_bst2.1, main = 'XGBoost: Aggregate Other1 Variables')

# GLBM MODEL1--------------------------------------------
# https://rpubs.com/omicsdata/gbm

library(caret)
library(gbm)
library(e1071)

set.seed(3232)

#set oth1 variables for continuous traning data
gbm_trn = cont_trn[,cont_list_oth1]

#set oth1 variables for continuous validation data
gbm_val = cont_val[,cont_list_oth1][-1]

#set oth1 variables for continuous validation data
gbm_tst = cont_tst[,cont_list_oth1][-1]

#Gradient boosted machine model1-----------------------
gbm1 = gbm(DEFAULT~.,
           data=gbm_trn,
           shrinkage=0.01, 
           distribution = 'bernoulli', 
           cv.folds=5, 
           n.trees=3000, 
           verbose=F)

best_gbm1 = gbm.perf(gbm1, method='cv')
summary(gbm1)

#plot marginal effect of DLQ ratio by integrating out the other variables
plot.gbm(gbm1, 14, best_gbm1)

#now run a cross validated model on the best iteration (best_gbm1)
fitControl = trainControl(method="cv", 
                          number=10, 
                          returnResamp = "all")
gbm1a = train(as.factor(DEFAULT)~.,
              data=gbm_trn,
              method="gbm",distribution="bernoulli", 
              trControl=fitControl, 
              verbose=F, 
              tuneGrid=data.frame(
                .n.trees=best_gbm1, 
                .shrinkage=0.01, 
                .interaction.depth=2, 
                .n.minobsinnode=1))

gbm1a


confusionMatrix(gbm1a)

#training performance for the cv model (gbm1a)
getTrainPerf(gbm1a)

#predict using validation set
gbm1_pred = predict(gbm1a, gbm_val, 
                    na.action = na.pass)


#get confusion matrix for validation
confusionMatrix(gbm1_pred, 
                as.factor(cont_val$DEFAULT))

#predict using TEST set
gbm1.2_pred = predict(gbm1a, gbm_tst, 
                    na.action = na.pass)

gbm1.2_pred_num = as.numeric(gbm1.2_pred)-1
#get confusion matrix for test
confusionMatrix(as.factor(gbm1.2_pred_num), 
                as.factor(cont_tst$DEFAULT))

roc_gbm1.2 <- roc(response=cont_tst$DEFAULT, 
                  predictor= gbm1.2_pred_num)

auc_gbm1.2 <- auc(roc_gbm1.2);
varImp(gbm1a, numTree=50)

print(roc_gbm1.2)
plot(roc_gbm1.2, main = 'Gradient Boosted Machine: Aggregate Other1 Variables')



#########################################################
# 
# OTHER: Support Vector Machine
#
#########################################################

#install.packages('ROCR', dependencies = TRUE)
library(ROCR)
library(e1071)

#function to plot ROC curve 
rocplots = function (pred, truth, ...){
  predob = prediction(pred, truth)
  perf = performance(predob, 'tpr', 'fpr')
  plot(perf,...)
}


set.seed(3232)

#SVM Model 1 with average variables

#set data splits using oth1 average variable set
cont_trn_svm_data = cont_trn[,cont_list_oth1]
cont_val_svm_data = cont_val[,cont_list_oth1]
cont_tst_svm_data = cont_tst[,cont_list_oth1]

class(cont_trn_svm_data)
head(cont_trn_svm_data)

svm1 = svm(as.factor(DEFAULT)~., data=cont_trn_svm_data,
           kernel = 'radial',
           gamma = 1, 
           cost = 1)

summary(svm1)

svm1_val_pred = predict(svm1, 
                        newdata = cont_val_svm_data[,-1])

fitted1_val_mat = confusionMatrix(svm1_val_pred, 
                                  as.factor(cont_val_svm_data$DEFAULT))

svm1_val_pred_num = as.numeric(svm1_val_pred)-1

roc_fitted1_val = roc(response = cont_val_svm_data$DEFAULT, 
                      predictor= svm1_val_pred_num)

auc_svm1_val = auc(roc_fitted1_val);

plot(roc_fitted2_tst, main = 'Model 1 Support Vector Machine: 
     Other1 Variables, Validation')

# Model 2 (best.model)--------------------------------------
tune_svm_rad = tune(svm, DEFAULT~., data = cont_trn_svm_data,
                 kernel = 'radial',
                 ranges = list(
                   cost = c(0.1, 1, 10),
                   gamma = c(0.5, 1, 2)))

summary(tune_svm_rad)
tune_svm_rad$performances
names(tune_svm_rad)
tune_svm_rad$best.parameters
tune_svm_rad$best.performance


#get specs for the best model from the tune above
tune_svm_rad$best.model


#use specs from best model to run svm
#NOTE: important to make dep var a factor!!
svm2 = svm(as.factor(DEFAULT)~., data=cont_trn_svm_data,
           kernel = 'radial',
           cost = 1,
           gamma = 2,
           epsilon = 0.1)

summary(svm2)
names(svm2)
svm2$fitted
svm2$coefs

#predict on the TRAIN set------------------------------------------------
svm2_pred = predict(svm2, 
                    newdata = cont_trn_svm_data[,-1])

head(svm2_pred)
attr(svm2_pred, "decision.values")[1:4,]
attr(svm2_pred, "probabilities")[1:4,]
names(svm2_pred)

table(predicted = svm2_pred, actual = cont_trn_svm_data$DEFAULT)

fitted2_trn_mat = confusionMatrix(svm2_pred, 
                                  as.factor(cont_trn_svm_data$DEFAULT))

svm2_pred_num = as.numeric(svm2_pred)-1

roc_fitted2_trn = roc(response = cont_trn_svm_data$DEFAULT, 
                 predictor= svm2_pred_num)

auc_svm2 = auc(roc_fitted2_trn);

plot(roc_fitted2_trn, main = 'Support Vector Machine: Other1 Variables')

#predict on the VALIDATION set-------------------------------------------
svm2_val_pred = predict(svm2, 
                    newdata = cont_val_svm_data[,-1])

fitted2_val_mat = confusionMatrix(svm2_val_pred, 
                                  as.factor(cont_val_svm_data$DEFAULT))

svm2_val_pred_num = as.numeric(svm2_val_pred)-1

roc_fitted2_val = roc(response = cont_val_svm_data$DEFAULT, 
                      predictor= svm2_val_pred_num)

auc_svm2_val = auc(roc_fitted2_val);

plot(roc_fitted2_val, main = 'Model2 Support Vector Machine: 
     Other1 Variables Valdiation')

#predict on the TEST set-------------------------------------------------
svm2_tst_pred = predict(svm2, 
                        newdata = cont_tst_svm_data[,-1])

fitted2_tst_mat = confusionMatrix(svm2_tst_pred, 
                                  as.factor(cont_tst_svm_data$DEFAULT))

svm2_tst_pred_num = as.numeric(svm2_tst_pred)-1

roc_fitted2_tst = roc(response = cont_tst_svm_data$DEFAULT, 
                      predictor= svm2_tst_pred_num)

auc_svm2_tst = auc(roc_fitted2_tst);

plot(roc_fitted2_tst, main = 'Model2 Support Vector Machine: 
     Other1 Variables, Test')

names(svm2)
svm2$coefs
svm2$terms

library(SparseM)
plot


#########################################################
# 
# LOGISTIC REGRESSION
#
#########################################################

#gen linear model 4---------------------------

glm_trn = cont_trn[,cont_list_oth1]
glm_val = cont_val[,cont_list_oth1][-1]
glm_tst = cont_tst[,cont_list_oth1][-1]

glm1 = glm(DEFAULT~., data=glm_trn, family = binomial)
summary(glm1)
coef(glm1)
summary(glm1)$coef

#predict on validation set
glm1_pred = predict(glm1, newdata = glm_val, type='response')

#confirm that 1 still means default with the resulting model
contrasts(as.factor(glm_trn$DEFAULT))

glm1_fact = as.numeric(glm1_pred>0.5)

glm1_mat = confusionMatrix(as.factor(glm1_fact), 
                           as.factor(cont_val$DEFAULT))

roc_glm1 = roc(response=cont_val$DEFAULT, 
               predictor= glm1_fact)

auc_glm1 = auc(roc_glm1);

print(roc_glm1)
plot(roc_glm1, main = 'Logistic Regression: Aggregate Other1 Variables')

######
#predict on TEST set
glm1.1_pred = predict(glm1, newdata = glm_tst, type='response')

glm1.1_fact = as.numeric(glm1.1_pred>0.5)

glm1.1_mat = confusionMatrix(as.factor(glm1.1_fact), 
                             as.factor(cont_tst$DEFAULT))

roc_glm1.1 = roc(response=cont_tst$DEFAULT, 
                 predictor= glm1.1_fact)

auc_glm1.1 = auc(roc_glm1.1);

print(roc_glm1.1)
plot(roc_glm1.1, main = 'Logistic Regression: Aggregate Other1 Variables')

#logistic regression model 3: forward selection

binn_trn_all = binn_trn[,binn_list_oth1c]
binn_val_all = binn_trn[,binn_list_oth1c]
binn_tst_all = binn_trn[,binn_list_oth1c]

glm3 = glm(DEFAULT~., 
           data=binn_trn_all, 
           family = binomial)

glm3.1 = step(glm3)

glm3.2 = glm(DEFAULT ~ 
               SEX + 
               
               dED2_Adv_Gra + dED2_Grad +  dED2_University +  dED2_HS + #dED2Other + 
               
               dMAR2_Married + dMAR2_Single +  #dMAR2_Other + 
               
               #dAGE_0_25 +  dAGE_25_35 +  dAGE_35_45 +  #dAGE_45_INF +  
               
               dLIM_BALnegINF_30000 +  dLIM_BAL_30000_140000 + #dLIM_BALnegINF_140000_INF +
               
               dAv_Bill_Amt_negINF_0 +  dAv_Bill_Amt_0_1159 +  
               dAv_Bill_Amt_1159_7878 +  dAv_Bill_Amt_7878_49419 +  
               #dAV_Bill_Amt_49419_INF +
               
               #dBal_Gr_6mo_negINF_neg21881 +  dBal_Gr_6mo_neg21881_neg10172 +  
               #dBal_Gr_6mo_neg10172_923 +  dBal_Gr_6mo_923_INF + 
               
               dAV_Pmt_Amt_negINF_2475 +  dAV_Pmt_Amt_2475_12935 +  
               #dAV_Pmt_Amt_12935_INF +  
               
               dMAX_Bill_Amt_negINF_0 + dMAX_Bill_Amt_0_3058 + dMAX_Bill_Amt_3058_52496 +
               #dMAX_Bill_Amt_52496_INF +
               
               davPmt_avBill_Ratio_negINF_0.03 +  davPmt_avBill_Ratio_0.03_0.15 +  
               davPmt_avBill_Ratio_0.15_0.99 +  davPmt_avBill_Ratio_0.99_1 +  
               #davPmt_avBill_Ratio_1_INF + 
               
               #dslope_Pmt_Rat_negINF_neg0.076 +  dslope_Pmt_Rat_neg0.076_neg0.0038 +  
               #dslope_Pmt_Rat_neg0.0038_neg3.3 +  dslope_Pmt_Rat_neg3.3_0 +  
               #dslope_Pmt_Rat_0_0.001 +  dslope_Pmt_Rat_0.001_0.026 +  
               #dslope_Pmt_Rat_0.026_INF + 
               
               #dAV_Util_negINF_0 +  dAV_Util_0_0.515 +  #dAV_Util_0.515_INF + 
               
               dUTIL_Gr_neg0.0404_neg7.3e.06 + dUTIL_Gr_6mo_neg7.3e.06_0 + dUTIL_Gr_6mo_0_0.591,
             #dUTIL_Gr_6mo_0.591_INF,
             
             data=binn_trn, family = binomial)

summary(glm3.2)

#predict on validation data
glm3.2_pred = predict(glm3.2, newdata = binn_val[-7], type='response')

glm3.2_fact = as.numeric(glm3.2_pred>0.5)

glm3.2_mat = confusionMatrix(as.factor(glm3.2_fact), 
                             as.factor(binn_val$DEFAULT))

roc_glm3.2 = roc(response=binn_val$DEFAULT, 
                 predictor= glm3.2_fact)

auc_glm3.2 = auc(roc_glm3.2);

plot(roc_glm3.2, main = 'Logistic Regression: Manual Variable Selection Binned Other1 Variables')

#predict on TEST data
glm3.3_pred = predict(glm3.2, newdata = binn_tst[-7], type='response')

glm3.3_fact = as.numeric(glm3.3_pred>0.5)

glm3.3_mat = confusionMatrix(as.factor(glm3.3_fact), 
                             as.factor(binn_tst$DEFAULT))

roc_glm3.3 = roc(response=binn_tst$DEFAULT, 
                 predictor= glm3.3_fact)

auc_glm3.3 = auc(roc_glm3.3);

plot(roc_glm3.3, main = 'Logistic Regression: Stepwise and Manual Variable Selection')

#gen linear model 5 (dummy vars)-------------------------------------------------------------

glm2 = glm(DEFAULT~ 
             SEX +  
             dED2_Adv_Gra + dED2_Grad +  dED2_University +  dED2_HS + #dED2Other +  
             
             dMAR2_Married +  dMAR2_Single +  #dMAR2_Other +  
             
             dAGE_0_25 +  dAGE_25_35 +  dAGE_35_45 +  #dAGE_45_INF + 
             
             dLIM_BALnegINF_30000 +  dLIM_BAL_30000_140000 + 
             
             dBal_Gr_6mo_negINF_neg21881 +  dBal_Gr_6mo_neg21881_neg10172 +  
             dBal_Gr_6mo_neg10172_923 +  #dBal_Gr_6mo_923_INF + 
             
             dMAX_Pmt_Amt_negINF_0 + dMAX_Pmt_Amt_0_0.3 + 
             #dMAX_Pmt_Amt_0.3_INF +  
             
             davPmt_avBill_Ratio_negINF_0.03 +  davPmt_avBill_Ratio_0.03_0.15 +  
             davPmt_avBill_Ratio_0.15_0.99 +  davPmt_avBill_Ratio_0.99_1 +  
             #davPmt_avBill_Ratio_1_INF +  
             
             dAV_Util_negINF_0 +  dAV_Util_0_0.515 + 
             #dAV_Util_0.515_INF + 
             
             dDLQ_Ratio_negINF_168 +  dDLQ_Ratio_168_5000 +  
             dDLQ_Ratio_5000_36621 #+  dDLQ_Ratio_36621_INF,
           ,
           
           data=binn_trn, family = binomial)

summary(glm2)
coef(glm2)
summary(glm2)$coef

#predict on validation set
col_index(binn_val)
glm2_pred = predict(glm2, newdata = binn_val[-7], type='response')

glm2_fact = as.numeric(glm2_pred>0.5)

glm2_mat = confusionMatrix(as.factor(glm2_fact), 
                           as.factor(binn_val$DEFAULT))

roc_glm2 = roc(response=binn_val$DEFAULT, 
               predictor= glm2_fact)

auc_glm2 = auc(roc_glm2);

#rerun glm2 but manually remove variables that were significant
glm2.1 = glm(DEFAULT~ 
               SEX +  
               dED2_Adv_Gra + dED2_Grad +  dED2_University +  dED2_HS + #dED2Other +  
               
               #dMAR2_Married +  dMAR2_Single +  #dMAR2_Other +  
               
               #dAGE_0_25 +  dAGE_25_35 +  dAGE_35_45 +  #dAGE_45_INF + 
               
               dLIM_BALnegINF_30000 +  dLIM_BAL_30000_140000 + 
               
               #dBal_Gr_6mo_negINF_neg21881 +  dBal_Gr_6mo_neg21881_neg10172 +  
               #dBal_Gr_6mo_neg10172_923 +  #dBal_Gr_6mo_923_INF + 
               
               dMAX_Pmt_Amt_negINF_0 + dMAX_Pmt_Amt_0_0.3 + 
               #dMAX_Pmt_Amt_0.3_INF +  
               
               davPmt_avBill_Ratio_negINF_0.03 +  davPmt_avBill_Ratio_0.03_0.15 +  
               davPmt_avBill_Ratio_0.15_0.99 +  davPmt_avBill_Ratio_0.99_1 +  
               #davPmt_avBill_Ratio_1_INF +  
               
               dAV_Util_negINF_0 +  dAV_Util_0_0.515 + 
               #dAV_Util_0.515_INF + 
               
               dDLQ_Ratio_negINF_168 +  dDLQ_Ratio_168_5000 +  
               dDLQ_Ratio_5000_36621 #+  dDLQ_Ratio_36621_INF,
             ,
             
             data=binn_trn, family = binomial)

summary(glm2.1)
coef(glm2.1)
summary(glm2.1)$coef

#predict on trn set
col_index(binn_val)
glm2_pred = predict(glm2.1, newdata = binn_trn[-7], type='response')

glm2_fact = as.numeric(glm2_pred>0.5)

glm2_mat = confusionMatrix(as.factor(glm2_fact), 
                           as.factor(binn_trn$DEFAULT))

roc_glm2 = roc(response=binn_trn$DEFAULT, 
               predictor= glm2_fact)
plot(roc_glm2, main = 'Train Data: Manaul Variable Selection Binned Other1 Variables')
auc_glm2 = auc(roc_glm2);

#CALCULATE KS STATISTIC  Training Set----------------------------------------------
set.seed(3232)

response = binn_trn$DEFAULT
mod_pred = glm2_pred
decile_seq = seq(from =1, to = 20, by = 1)
quant_seq = seq(from = 0.05, to = 0.95, by = 0.05)

ks_df = data.frame(mod_pred, response)
head(ks_df)

decile_pts <- quantile(ks_df$mod_pred,
                       probs=quant_seq)


ks_df$model_decile <- cut(ks_df$mod_pred,
                           breaks=c(0,decile_pts,1),
                           labels=rev(decile_seq))

head(ks_df)

# Check the min score in each model decile;
aggregate(ks_df$mod_pred,by=list(Decile=ks_df$model_decile),FUN=min);

obs_df = data.frame(table(ks_df$model_decile))
table(ks_df$model_decile,ks_df$response)

ks_table <- data.frame(list(Decile=rev(decile_seq),
                            Obs = obs_df[,2],
                            Y1=table(ks_df$model_decile,ks_df$response)[,2],
                            Y0=table(ks_df$model_decile,ks_df$response)[,1]
                            ))

ks_table[order(ks_table$Decile),]



#predict on validation set
col_index(binn_val)
glm2.1_pred = predict(glm2.1, newdata = binn_val[-7], type='response')

glm2.1_fact = as.numeric(glm2.1_pred>0.5)

glm2.1_mat = confusionMatrix(as.factor(glm2.1_fact), 
                             as.factor(binn_val$DEFAULT))

roc_glm2.1 = roc(response=binn_val$DEFAULT, 
                 predictor= glm2.1_fact)

auc_glm2.1 = auc(roc_glm2.1);

#CALCULATE KS STATISTIC  Validation Set----------------------------------------------
set.seed(3232)

response = binn_val$DEFAULT
mod_pred = glm2.1_pred
decile_seq = seq(from =1, to = 20, by = 1)
quant_seq = seq(from = 0.05, to = 0.95, by = 0.05)


ks_df = data.frame(mod_pred, response)
head(ks_df)

decile_pts <- quantile(ks_df$mod_pred,
                       probs=quant_seq)


ks_df$model_decile <- cut(ks_df$mod_pred,
                          breaks=c(0,decile_pts,1),
                          labels=rev(decile_seq))

head(ks_df)

# Check the min score in each model decile;
aggregate(ks_df$mod_pred,by=list(Decile=ks_df$model_decile),FUN=min);

obs_df = data.frame(table(ks_df$model_decile))
table(ks_df$model_decile,ks_df$response)

ks_table <- data.frame(list(Decile=rev(decile_seq),
                            Obs = obs_df[,2],
                            Y1=table(ks_df$model_decile,ks_df$response)[,2],
                            Y0=table(ks_df$model_decile,ks_df$response)[,1]
))

ks_table[order(ks_table$Decile),]


#predict on TEST set
col_index(binn_val)
glm2.2_pred = predict(glm2.1, newdata = binn_tst[-7], type='response')

glm2.2_fact = as.numeric(glm2.2_pred>0.5)

glm2.2_mat = confusionMatrix(as.factor(glm2.2_fact), 
                             as.factor(binn_tst$DEFAULT))

roc_glm2.2 = roc(response=binn_tst$DEFAULT, 
                 predictor= glm2.2_fact)

auc_glm2.2 = auc(roc_glm2.2);

plot(roc_glm2.2, main = 'Test Data: Manaul Variable Selection Binned Other1 Variables')


#CALCULATE KS STATISTIC  TEST Set----------------------------------------------
set.seed(3232)

response = binn_tst$DEFAULT
mod_pred = glm2.2_pred
decile_seq = seq(from =1, to = 20, by = 1)
quant_seq = seq(from = 0.05, to = 0.95, by = 0.05)

ks_df = data.frame(mod_pred, response)
head(ks_df)

decile_pts <- quantile(ks_df$mod_pred,
                       probs=quant_seq)


ks_df$model_decile <- cut(ks_df$mod_pred,
                          breaks=c(0,decile_pts,1),
                          labels=rev(decile_seq))

head(ks_df)

# Check the min score in each model decile;
aggregate(ks_df$mod_pred,by=list(Decile=ks_df$model_decile),FUN=min);

obs_df = data.frame(table(ks_df$model_decile))
table(ks_df$model_decile,ks_df$response)

ks_table <- data.frame(list(Decile=rev(decile_seq),
                            Obs = obs_df[,2],
                            Y1=table(ks_df$model_decile,ks_df$response)[,2],
                            Y0=table(ks_df$model_decile,ks_df$response)[,1]
))

ks_table[order(ks_table$Decile),]
