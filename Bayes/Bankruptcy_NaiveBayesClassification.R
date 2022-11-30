# Chad R Bhatti
# 11.10.2018
# NaiveBayes_Bankruptcy.R

# Related Paper
# The discovery of experts' decision rules from qualitative bankruptcy data using 
# genetic algorithms

# Note: This data is not from this paper!  The guy collected this data in the same
# manner as the data collected in this paper

# See Machine Learning for Predictive Analytics Chapter 6 Example 6.3.1

# R Bloggers Naive Bayes:  
# https://www.r-bloggers.com/understanding-naive-bayes-classifier-using-r/

# Data: https://archive.ics.uci.edu/ml/datasets/qualitative_bankruptcy


################################################################################
# Load Data
################################################################################

my.path <- 'C:\\Users\\Delos001\\';
my.file <- paste(my.path,'Qualitative_Bankruptcy_Data.csv',sep='');

my.data <- read.csv(my.file,header=FALSE);

str(my.data)
head(my.data)

# Add column names from data dictionary;
colnames(my.data) <- c('IndustrialRisk','ManagementRisk','FinancialFlexibility',
     'Credibility','Competitiveness','OperatingRisk','Class');


str(my.data)
head(my.data)



################################################################################
# Numerical Summary EDA
################################################################################

my.data$BinaryClass <- ifelse(my.data$Class=='NB',0,1);

# Check the coding of the indicator variable;
table(my.data$Class,my.data$BinaryClass)


# compute numerical summaries?;
aggregate(my.data$BinaryClass,by=list(IndustrialRisk=my.data$IndustrialRisk),FUN=mean)
aggregate(my.data$BinaryClass,by=list(ManagementRisk=my.data$ManagementRisk),FUN=mean)
aggregate(my.data$BinaryClass,by=list(FinancialFlexibility=my.data$FinancialFlexibility),FUN=mean)
aggregate(my.data$BinaryClass,by=list(Credibility=my.data$Credibility),FUN=mean)
aggregate(my.data$BinaryClass,by=list(Competitiveness=my.data$Competitiveness),FUN=mean)
aggregate(my.data$BinaryClass,by=list(OperatingRisk=my.data$OperatingRisk),FUN=mean)

# What was that?!;
table(my.data$Class,my.data$Competitiveness)

# What are the numbers computed by the mean() function?;

# These are the (conditional) bankruptcy probabilities:

# Prob(Bankruptcy | OperatingRisk=A) = 0.4210526
# Prob(Bankruptcy | OperatingRisk=N) = 0.5614035
# Prob(Bankruptcy | OperatingRisk=P) = 0.2405063

# Prob(Bankruptcy | IndustrialRisk=A) = 0.3456790
# Prob(Bankruptcy | IndustrialRisk=N) = 0.5955056
# Prob(Bankruptcy | IndustrialRisk=P) = 0.3250000



# Compute this probability matrix;
# Prob(IndustrialRisk=A | Bankruptcy=B) Prob(IndustrialRisk=A | Bankruptcy=NB)
# Prob(IndustrialRisk=N | Bankruptcy=B) Prob(IndustrialRisk=N | Bankruptcy=NB)
# Prob(IndustrialRisk=P | Bankruptcy=B) Prob(IndustrialRisk=P | Bankruptcy=NB)
t.IndustrialRisk <- table(my.data$IndustrialRisk,my.data$Class)
col.totals <- apply(t.IndustrialRisk,MAR=2,FUN=sum)
# Standardize table to probabilities;
prob.IndustrialRisk <- t.IndustrialRisk/matrix(col.totals,3,2,byrow=TRUE);
apply(prob.IndustrialRisk,MAR=2,FUN=sum)

> prob.IndustrialRisk
   
            B        NB
  A 0.2616822 0.3706294
  N 0.4953271 0.2517483
  P 0.2429907 0.3776224



# Compute overall class probabilities;
prob.B <- mean(my.data$BinaryClass);
prob.NB <- 1-mean(my.data$BinaryClass);

# Compute the joint probabilities.  What are joint probabilities?
# Prob(IndustrialRisk=A & Bankruptcy=B) = Prob(IndustrialRisk=A | Bankruptcy=B)*Prob(Bankruptcy=B)

b.IndustrialRisk <- prob.IndustrialRisk[,1]*prob.B;

> prob.IndustrialRisk[,1]*prob.B;
    A     N     P 
0.112 0.212 0.104 


nb.IndustrialRisk <- prob.IndustrialRisk[,2]*prob.NB;

> prob.IndustrialRisk[,2]*prob.NB;
    A     N     P 
0.212 0.144 0.216 


# The joint probabilities are the 2x2 table probabilities in this example;
# In general they are the probabilites in the sample hypercube.
# Here we have assigned every observation in the sample to a cell and computed the probability
# of each cell;

table(my.data$Class,my.data$IndustrialRisk)/250
    
#         A     N     P
#  B  0.112 0.212 0.104
#  NB 0.212 0.144 0.216

# Check that it is a probability distribution;
sum(table(my.data$Class,my.data$IndustrialRisk)/250)






################################################################################
# Naive Bayes #1
################################################################################

# Install package if needed;
# install.packages('naivebayes',dependencies=TRUE)
library(naivebayes)

nb.1 <- naive_bayes(x=my.data$IndustrialRisk,y=my.data$Class)

# Compare the table to the table above;
nb.1

# What else do we get?
summary(nb.1)
names(nb.1)

nb.1$levels
nb.1$laplace
nb.1$data


# Plot Naive Bayes probabilities;
# Note that this is a degenerate plotting option since there is only one predictor;
plot(nb.1)


# Predict the class;
predicted.class <- predict(nb.1);
pct.accuracy <- mean(predicted.class==my.data$Class);






################################################################################
# Naive Bayes #2
################################################################################

predictor.df <- my.data[,-c(7,8)]
nb.2 <- naive_bayes(x=predictor.df,y=my.data$Class)

# Look at output;
nb.2


# Plot Naive Bayes probabilities;
plot(nb.2, which=c('IndustrialRisk'))

# Open additional graphics window;
X11()
plot(nb.2, which=c('ManagementRisk'))


# Predict the class;
predicted.class <- predict(nb.2);
mean(predicted.class==my.data$Class)



################################################################################
# Scoring Naive Bayes #1
################################################################################
# Ideally the model would produce explicit model scores for each class and let 
# you see them.  However, it is not letting us see them.
# The model should produce a score for each class and then assign the observation
# to the class with the highest score.


# Aha! Looks like we need to read the documentation;
predicted.classProb <- predict(nb.1,type=c('prob'));



df.1 <- as.data.frame(list(IndustrialRisk=my.data$IndustrialRisk,Class=my.data$Class));


# Create the scoring data frame;
IndustrialRisk.df <- as.data.frame(list(IndustrialRisk=rownames(prob.IndustrialRisk),
			IndustrialRisk_B=prob.IndustrialRisk[,1],
			IndustrialRisk_NB=prob.IndustrialRisk[,2],
			Prob_B=prob.B,
			Prob_NB=prob.NB
			));

score.df <- merge(x=df.1,y=IndustrialRisk.df,by='IndustrialRisk');
head(score.df)

# What Dr. Bhatti considers to be the Naive Bayes scores;
score.df$score_B <- score.df$IndustrialRisk_B*score.df$Prob_B;
score.df$score_NB <- score.df$IndustrialRisk_NB*score.df$Prob_NB;
score.df$MyClass <- ifelse(score.df$score_B>score.df$score_NB,'B','NB');


# Note that the predict function did not like my newdata for some reason;
# Note sure what is going on or why, but the easiest work around is to simply
# refit the model to the score.df data frame.
nb.1 <- naive_bayes(x=score.df$IndustrialRisk,y=score.df$Class)
score.df$ModelClass <- predict(nb.1);
ModelProbs <- predict(nb.1, type=c('prob'));
score.df$ModelProb_B <- ModelProbs[,1];
score.df$ModelProb_NB <- ModelProbs[,2];

head(score.df)

# Do I match the R package?
mean(score.df$MyClass==score.df$ModelClass)

# How accurate am I?
mean(score.df$MyClass==score.df$Class)


# R is fully 'normalizing' scores strictly to Bayes Rule;
# This is not always done since the normalization will not affect the decision rule;
score.df$NormalScore_B <- score.df$score_B/(score.df$score_B + score.df$score_NB);
score.df$NormalScore_NB <- score.df$score_NB/(score.df$score_B + score.df$score_NB);

head(score.df)



# Note that this presentation is tailored to discrete probabilities, which means discrete
# or categorial predictor variables.  When the predictor variables are continuous, then
# naive bayes will use an assumed density function for the predictor, like the gaussian
# distribution.


















			













