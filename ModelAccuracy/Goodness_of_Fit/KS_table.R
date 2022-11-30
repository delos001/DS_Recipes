# Chad R Bhatti
# make_ks_table.R
# 02.05.2018



###############################################################################
# This example will show you how to make the components of a KS table;



###############################################################################
# Make some fake data;
###############################################################################

set.seed(123)
model.score <- runif(n=10000,min=0,max=1);
v <- runif(n=10000,min=0,max=1);
response <- ifelse(v<0.25,1,0);


table(response)

> table(response)
response
   0    1 
7436 2564 


# Create a data frame for model.score and response
my.df <- as.data.frame(cbind(model.score,response));
head(my.df)



###############################################################################
# Decile Model Scores;
###############################################################################

decile.pts <- quantile(my.df$model.score,
			probs=c(0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9));

# Note that since this data was generated from a unif(0,1) the decile pts
# should be very close to the probability pts.  This will not be the case with
# your actual model scores.



###############################################################################
# Assign Model Scores to Deciles;
###############################################################################

my.df$model.decile <- cut(my.df$model.score,breaks=c(0,decile.pts,1),
			labels=rev(c('01','02','03','04','05','06','07','08','09','10'))
			);

head(my.df)


# Note that we need to add the end points to our decile points to properly
# apply the cut() function;

# Note that we want the 'top decile' to be the highest model scores so we
# will reverse the labels.

# Check the min score in each model decile;
aggregate(my.df$model.score,by=list(Decile=my.df$model.decile),FUN=min);



table(my.df$model.decile)

> table(my.df$model.decile)

  01   02   03   04   05   06   07   08   09   10 
1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 



table(my.df$model.decile,my.df$response)

> table(my.df$model.decile,my.df$response)
    
       0   1
  10 754 246
  09 750 250
  08 738 262
  07 778 222
  06 736 264
  05 726 274
  04 755 245
  03 719 281
  02 751 249
  01 729 271




ks.table <- as.data.frame(list(Y0=table(my.df$model.decile,my.df$response)[,1],
		Y1=table(my.df$model.decile,my.df$response)[,2],
		Decile=rev(c('01','02','03','04','05','06','07','08','09','10'))
		));


# Sort the data frame by decile;
ks.table[order(ks.table$Decile),]


# Now plug these values into your KS spreadsheet and compute the KS statistic;




 






























