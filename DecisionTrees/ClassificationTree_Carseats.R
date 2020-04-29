

# StatsLearning Lect10 R trees A 111213
# https://www.youtube.com/watch?v=0wZUXtvAtDc&feature=youtu.be



# example using tree library

library(tree)
library(ISLR)
attach(Carseats)  # attach so you don't have to type Carseats$varname

# the Sales variable is continuous so this creates a binary variable: 
# if sales >8, then its "high", else it's not high 
high=ifelse(Sales<=8, "No","Yes")
Carseats=data.frame(Carseats, high)


# create a tree for the "high" variable but exclude the Sales since the 
# high variable is derived from the Sales variable
tree.carseats=tree(high~. -Sales, Carseats)
summary(tree.carseats) # generate summary
# we see training error is 9%
# small deviance indicates a tree that provides a good fit
# residual mean deviance reported is simply the deviance divided 
#   by n−|T0|, which in this case is 400−27 = 373



plot(tree.carseats)   # creates the tree outline

# puts the text on the tree.  
# pretty=0 tells R to put the category name for any qualitative 
# predictors (rather than a letter for each cateogry).
# cex gives the font size, pos tells position (top, left, right, 
# center, etc), offset moves the label on the tree
text(tree.carseats, pretty=0, cex=0.6, pos=1, offset=0)

tree.carseats


# Esimate the test errror:
set.seed(2)
train = sample(1:nrow(Carseats), 200)  # randomly pick 200 out of nrows
Carseats.test=Carseats[-train,]  # exclude rows that aren't train samples 
# create a vector for the high variable for all the observations that are 
# not training samples (test sample): this contains the correct values to 
# compare predicted vs. actual
High.test=High[-train]


# create tree to predict the high variable using the train subset
tree.carseats=tree(High~.-Sales, Carseats, subset=train)
# get predicted variables using the tree.carseats tree using the test observations.  
# type="class" tells R to give the actual class prediction
tree.pred=predict(tree.carseats, Carseats.test, type="class")
table(tree.pred, High.test)  # creates confusion: shows 71.5 correct predictions



# Consider whether pruning might lead to improved results: Cost complexity Pruning
set.seed(3)

# cross validation to determine optimal level of tree complexity.  
# FUN=prune.misclass in order to indicate that we want a classification 
# error rate to guide the cross validation after pruning
cv.carseats=cv.tree(tree.carseats, FUN=prune.misclass)
names(cv.carseats)
cv.carseats
# OUTPUT Discussion:
# size is the number of terminal nodes of each treed considered
# dev is the cross validation error rate
# k is value of cost-complexity parameter (corresponds to alpha)



par(mfrow=c(1,2))
# plots error rate as function of size, type b gives connected dots
plot(cv.carseats$size, cv.carseats$dev, type="b")
# plots error rate as a function of k,
plot(cv.carseats$k, cv.carseats$dev, type="b")
par(mfrow=c(1,1))

# prunes the tree to a nine-node tree
prune.carseats=prune.misclass(tree.carseats, best=9)
plot(prune.carseats)

# pretty = use full word for classification variables (rather than the one letter symbol)
text(prune.carseats, pretty=0)  # adds the text. 


# predicts the results using the test data (carseats.test).  
# remember, type="class" tells R to give actual class prediction
# creates confusion that shows 77% correct prediction classification
# NOTE: you can change the "best" value to see if you get a better 
# classificaiton rate
tree.pred=predict(prune.carseats, Carseats.test, type="class")
table(tree.pred, High.test)
