

### Gradient Boosting Machines ###
library(gbm)
library(caret)

x.train.boost = x.train
x.train.boost$TARGET_FLAG = ifelse(x.train.boost$TARGET_FLAG == "1",
                                   1,
                                   0)

#Find ideal parameter using CV using automatic grid search
fitControl <- trainControl(method="repeatedcv", 
                           number=5, 
                           repeats=5)

set.seed(1)
gbmFit <- train(TARGET_FLAG ~ ., 
                data = x.train.boost,
                method = "gbm", 
                trControl = fitControl, 
                verbose = FALSE, 
                tuneLength = 5)

gbmFit

#Fit Boost
set.seed(1)
boost.model <- gbm(TARGET_FLAG~.,
                   data = x.train.boost,
                   distribution = "bernoulli",
                   n.trees = x,
                   shrinkage = x,
                   interaction.depth = x, 
                   n.minobsinnode = x)

summary(boost.model)

#Evaluate on Validation Set
boost.pred <- predict(boost.model, 
                      x.validation, 
                      type = "response", 
                      n.trees = x)

#Confusion Matrix
boost.pred <- ifelse(boost.pred > 0.50, 1, 0)
xtab.boost1 = table(boost.pred, 
                    x.validation$TARGET_FLAG)
confusionMatrix(xtab.boost1, 
                positive = "1")
#AUC
library(ROCR)
library(cvAUC)
labels <- x.validation[,"TARGET_FLAG"]
AUC(predictions = boost.pred, 
    labels = labels)
