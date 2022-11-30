#
# Written by Dipanjan Paul
# PREDICT 411
# 2015 FALL
#

library(tree)
library(h2o)

parm <- "none"
setwd("~/Dropbox/MSPA/411/Assignment/Heloc")

train <- read.csv('heloc.csv', header=T)
train$REASON <- as.factor(as.integer(train$REASON))
train$JOB <- as.factor(as.integer(train$JOB))
train_tmp <- train[,-c(which(names(train) == "INDEX"), which(names(train) == "TARGET_FLAG"))]


test <- read.csv('heloc_test.csv', header=T)
test$REASON <- as.factor(as.integer(test$REASON))
test$JOB <- as.factor(as.integer(test$JOB))
test_tmp <- test[,-c(which(names(test) == "INDEX"), which(names(test) == "TARGET_FLAG"))]

# Imputing Missing Values,..
num_cols <- ncol(train_tmp)
impute_cols <- which(colSums(apply(train_tmp,2,is.na)) != 0)

for (i in (1:length(impute_cols))) {
  print(c('Imputing: ', names(train_tmp[impute_cols[i]])))
  trn_missing_idx <- which(is.na(train_tmp[,impute_cols[i]]) == T)
  tst_missing_idx <- which(is.na(test_tmp[,impute_cols[i]]) == T)
  
  tree_model <- tree(train_tmp[,impute_cols[i]] ~., data=train_tmp[,(1:num_cols)])
  train_tmp[trn_missing_idx,impute_cols[i]] <- 
  predict(tree_model, newdata = train_tmp[trn_missing_idx,])
  
  train_tmp[,c(paste(names(train_tmp[impute_cols[i]]),"_IMP_F",sep=""))] <- 0
  train_tmp[trn_missing_idx,c(paste(names(train_tmp[impute_cols[i]]),"_IMP_F",sep=""))] <- 1
  
  test_tmp[tst_missing_idx,impute_cols[i]] <- 
  predict(tree_model, newdata = test_tmp[tst_missing_idx,])
  
  test_tmp[,c(paste(names(test_tmp[impute_cols[i]]),"_IMP_F",sep=""))] <- 0
  test_tmp[tst_missing_idx,c(paste(names(test_tmp[impute_cols[i]]),"_IMP_F",sep=""))] <- 1
}

train_tmp$TARGET_FLAG <- train$TARGET_FLAG

# Variable Transformations,.. Train
train_tmp[(train_tmp$LOAN > 60000),c("LOAN")] <- 60000
train_tmp[(train_tmp$MORTDUE > 200000),c("MORTDUE")] <- 200000
train_tmp[(train_tmp$VALUE > 300000), c("VALUE")] <- 300000 
train_tmp[(train_tmp$CLAGE > 500), c("CLAGE")] <- 500
train_tmp[(train_tmp$CLNO > 60), c("CLNO")] <- 60
train_tmp[(train_tmp$DEBTINC > 60), c("DEBTINC")] <- 60

# Variable Transformations,.. Test
test_tmp[(test_tmp$LOAN > 60000),c("LOAN")] <- 60000
test_tmp[(test_tmp$MORTDUE > 200000),c("MORTDUE")] <- 200000
test_tmp[(test_tmp$VALUE > 300000), c("VALUE")] <- 300000 
test_tmp[(test_tmp$CLAGE > 500), c("CLAGE")] <- 500
test_tmp[(test_tmp$CLNO > 60), c("CLNO")] <- 60
test_tmp[(test_tmp$DEBTINC > 60), c("DEBTINC")] <- 60

# Normalize Variables

LOAN_m <- mean(c(train_tmp$LOAN, test_tmp$LOAN))
LOAN_sd <- sd(c(train_tmp$LOAN, test_tmp$LOAN))
train_tmp$LOAN <- (train_tmp$LOAN - LOAN_m)/LOAN_sd
test_tmp$LOAN <- (test_tmp$LOAN - LOAN_m)/LOAN_sd

MORTDUE_m <- mean(c(train_tmp$MORTDUE, test_tmp$MORTDUE))
MORTDUE_sd <- sd(c(train_tmp$MORTDUE, test_tmp$MORTDUE))
train_tmp$MORTDUE <- (train_tmp$MORTDUE - MORTDUE_m)/MORTDUE_sd
test_tmp$MORTDUE <- (test_tmp$MORTDUE - MORTDUE_m)/MORTDUE_sd

CLAGE_m <- mean(c(train_tmp$CLAGE, test_tmp$CLAGE))
CLAGE_sd <- sd(c(train_tmp$CLAGE, test_tmp$CLAGE))
train_tmp$CLAGE <- (train_tmp$CLAGE - CLAGE_m)/CLAGE_sd
test_tmp$CLAGE <- (test_tmp$CLAGE - CLAGE_m)/CLAGE_sd
 
VALUE_m <- mean(c(train_tmp$VALUE, test_tmp$VALUE))
VALUE_sd <- sd(c(train_tmp$VALUE, test_tmp$VALUE))
train_tmp$VALUE <- (train_tmp$VALUE - VALUE_m)/VALUE_sd
test_tmp$VALUE <- (test_tmp$VALUE - VALUE_m)/VALUE_sd
 
CLNO_m <- mean(c(train_tmp$CLNO, test_tmp$CLNO))
CLNO_sd <- sd(c(train_tmp$CLNO, test_tmp$CLNO))
train_tmp$CLNO <- (train_tmp$CLNO - CLNO_m)/CLNO_sd
test_tmp$CLNO <- (test_tmp$CLNO - CLNO_m)/CLNO_sd
 
DEBTINC_m <- mean(c(train_tmp$DEBTINC, test_tmp$DEBTINC))
DEBTINC_sd <- sd(c(train_tmp$DEBTINC, test_tmp$DEBTINC))
train_tmp$DEBTINC <- (train_tmp$DEBTINC - DEBTINC_m)/DEBTINC_sd
test_tmp$DEBTINC <- (test_tmp$DEBTINC - DEBTINC_m)/DEBTINC_sd

# Interaction Variable
train_tmp$Int_Var1 <- train_tmp$DELINQ * train_tmp$DEBTINC
test_tmp$Int_Var1 <- test_tmp$DELINQ * test_tmp$DEBTINC

train_tmp$Int_Var2 <- train_tmp$DELINQ * train_tmp$LOAN
test_tmp$Int_Var2 <- test_tmp$DELINQ * test_tmp$LOAN

# Split train set into trn and xcv
set.seed(12345)
ix <- rbinom(nrow(train_tmp), 1, .7)
trn <- train_tmp[ix==1,]
xcv <- train_tmp[ix==0,]

# Variable Selection
model <- glm(TARGET_FLAG ~ ., data=trn, family="binomial")
var_sel <- step(model, direction="both")

# EDA the train set to look for interaction,. 
tree_model <- tree(formula = TARGET_FLAG ~ LOAN + MORTDUE + VALUE + REASON + JOB + YOJ + DEROG + 
                     DELINQ + CLAGE + NINQ + DEBTINC + MORTDUE_IMP_F + VALUE_IMP_F + 
                     YOJ_IMP_F + DEROG_IMP_F + DELINQ_IMP_F + CLAGE_IMP_F + CLNO_IMP_F + 
                     DEBTINC_IMP_F + Int_Var1 + Int_Var2, data = trn)

plot(tree_model)
text(tree_model, pretty=0)

# After Variable Selection:
model <-  glm(formula = TARGET_FLAG ~ LOAN + MORTDUE + VALUE + REASON + JOB + YOJ + DEROG + 
                DELINQ + CLAGE + NINQ + DEBTINC + MORTDUE_IMP_F + VALUE_IMP_F + 
                YOJ_IMP_F + DEROG_IMP_F + DELINQ_IMP_F + CLAGE_IMP_F + CLNO_IMP_F + 
                DEBTINC_IMP_F + Int_Var1 + Int_Var2, family = "binomial", data = trn)

pred_flag <- predict.glm(model, newdata=xcv, type="response")
pred_flag[pred_flag >= .5] <- 1
pred_flag[pred_flag < .5] <- 0
table(pred_flag == xcv$TARGET_FLAG)

# Train on the whole set
model <-  glm(formula = TARGET_FLAG ~ LOAN + MORTDUE + VALUE + REASON + JOB + YOJ + DEROG + 
                DELINQ + CLAGE + NINQ + DEBTINC + MORTDUE_IMP_F + VALUE_IMP_F + 
                YOJ_IMP_F + DEROG_IMP_F + DELINQ_IMP_F + CLAGE_IMP_F + CLNO_IMP_F + 
                DEBTINC_IMP_F + Int_Var1 + Int_Var2, family = "binomial", data = train_tmp)

#Predict for the Test set
test$TARGET_FLAG <- predict.glm(model, newdata=test_tmp, type="response")

sub <- test[,(1:2)]
names(sub) <- c('INDEX','P_TARGET_FLAG')
write.table(sub,"heloc_sub_glm.csv",sep=',',col.names=T,row.names=F)

localH2O <- h2o.init(nthread=-1,max_mem_size="4G")
train.hex <- as.h2o(localH2O,train_tmp)
predictors <- which(names(train.hex) 
                    %in% c('LOAN', 'MORTDUE', 'VALUE', 'REASON', 'JOB', 'YOJ', 'DEROG', 'DELINQ', 
                          'CLAGE', 'NINQ', 'DEBTINC', 'MORTDUE_IMP_F', 
                          'VALUE_IMP_F',  'YOJ_IMP_F', 'DEROG_IMP_F', 'DELINQ_IMP_F', 'CLAGE_IMP_F', 
                          'CLNO_IMP_F', 'DEBTINC_IMP_F', 'Int_var_1', 'Int_Var_2'))

response <- which(names(train.hex) == "TARGET_FLAG")

submission <- as.data.frame(test$INDEX)
submission$P_TARGET_FLAG <- 0

test.hex <- as.h2o(localH2O,test_tmp)

for(j in 1:20){
  print(j)
  
  model <- h2o.deeplearning(x=predictors,
                            y=response,
                            data=train.hex,
                            classification=T,
                            activation="RectifierWithDropout",
                            hidden=c(1024,512,256),
                            hidden_dropout_ratio=c(0.5,0.5,0.5),
                            input_dropout_ratio=0.05,
                            epochs=20,
                            l1=1e-5,
                            l2=1e-5,
                            rho=0.99,
                            epsilon=1e-8,
                            train_samples_per_iteration=500,
                            max_w2=10,
                            seed=1)
  submission$P_TARGET_FLAG <- submission$P_TARGET_FLAG + as.data.frame(h2o.predict(model,test.hex))$X1
  print(j)
}

submission$P_TARGET_FLAG <- submission$P_TARGET_FLAG/j
names(submission) <- c('INDEX','P_TARGET_FLAG')
#submission$WnvPresent[l1] <- 0
#submission$WnvPresent[l2] <- 0

write.table(submission,"heloc_sub_h2o.csv",sep=',',col.names=T,row.names=F)

