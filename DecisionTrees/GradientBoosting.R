
# https://rpubs.com/omicsdata/gbm



library(caret)
library(gbm)
library(e1071)

set.seed(3232)

gbm_trn = cont_trn[,cont_list_av]
head(gbm_trn)
gbm_val = cont_val[,cont_list_av][-1]
head(gbm_val)

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
plot.gbm(gbm1, 15, best_gbm1)

#now run a cross validated model on the best iteration (best_gbm1)
fitControl = trainControl(method="cv", number=5, returnResamp = "all")
gbm1a = train(as.factor(DEFAULT)~.,
              data=gbm_trn,
              method="gbm",distribution="bernoulli", 
              trControl=fitControl, 
              verbose=F, 
              tuneGrid=data.frame(
                .n.trees=best_gbm1, 
                .shrinkage=0.01, 
                .interaction.depth=1, 
                .n.minobsinnode=1))

gbm1a

confusionMatrix(gbm1a)

#training performance for the cv model (gbm1a)
getTrainPerf(gbm1a)

#predict using validation set
gbm1_pred = predict(gbm1a, gbm_val, na.action = na.pass)

#get confusion matrix for validation
confusionMatrix(gbm1_pred, as.factor(cont_val$DEFAULT))



