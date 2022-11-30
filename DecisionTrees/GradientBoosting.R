
# https://rpubs.com/omicsdata/gbm



library(caret)
library(gbm)
library(e1071)

set.seed(3232)

# the the predictor variables you want in an object.  
# (NOTE: the cont_list_av is a list of column indexes 
# chosen previously to only get columns of interest)
gbm_trn = cont_trn[,cont_list_av]
# this is same as above except for validation set.  
# It excludes first column because first column is the dep var (DEFAULT)
gbm_val = cont_val[,cont_list_av][-1]

# run an initial model
gbm1 = gbm(DEFAULT~.,
           data=gbm_trn,
           shrinkage = 0.01, 
           distribution = 'bernoulli', 
           cv.folds = 5, 
           n.trees = 3000, 
           verbose=F)

# get best out of the cross validation set from intiial model above
best_gbm1 = gbm.perf(gbm1, 
                     method='cv')
summary(gbm1)

#plot marginal effect of DLQ ratio by integrating out the other variables
plot.gbm(gbm1, 15, best_gbm1)  # 15 is 15th variable (most predictive var)

#now run a cross validated model on the best iteration (best_gbm1)
# run another model where you can use best iteration (bestgbm1) from above
# set control to use cross validation, repeated 5 times with return sampling
fitControl = trainControl(method="cv", 
                          number=5, 
                          returnResamp = "all")
gbm1a = train(as.factor(DEFAULT)~.,  # run the second model
              data = gbm_trn,
              method = "gbm",
              distribution = "bernoulli", 
              trControl = fitControl,  # use the grid control specified above
              verbose = F, 
              tuneGrid=data.frame(   # use grid to specify parameters
                         # don't forget the periods for this data frame
                         .n.trees=best_gbm1, 
                         .shrinkage=0.01, 
                         .interaction.depth=1, 
                         .n.minobsinnode=1))

gbm1a

confusionMatrix(gbm1a)

#training performance for the cv model (gbm1a)
getTrainPerf(gbm1a)

#predict using validation set
gbm1_pred = predict(gbm1a, 
                    gbm_val, 
                    na.action = na.pass)

#get confusion matrix for validation
confusionMatrix(gbm1_pred, 
                as.factor(cont_val$DEFAULT))



