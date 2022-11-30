
#----------------------------------------------------------
#----------------------------------------------------------
# RANDOM SAMPLING
#----------------------------------------------------------
#----------------------------------------------------------

# random sample of 12 observations from the price column of the hp file
hp <- read.csv("home_prices.csv", sep=",")
price<-hp($PRICE)
set.seed(9999)
SRS<-sample(price,12)

#----------------------------------------------------------
# random sample of trees data for rows 1 through last row, 
#	5 observations without replace
set.seed(123)
index <- sample(1:nrow(trees), 5, replace = FALSE)
trees[index,] 

#----------------------------------------------------------
# sequence from row 1 to the last row by a sequence of 10 
#	(note the comma after the 1 instead of colon like in above example)
data(trees)
index<-seq(1,nrow(trees),by=10)
trees[index,]


#----------------------------------------------------------
# Splits the observations into 2 randomly selected groups: 
#   select sample of 196 out of 392
set.seed(1)
train = sample(392, 196)

#----------------------------------------------------------
# Randomly selects 20 row numbers from the mydata data set
set.seed(123)
df = sample(nrow(mydata),20)

#----------------------------------------------------------
# Randomly chose either -1 or 1.  
# Do that 20 times and replace after each selection: 
# result: -1  1 -1  1  1 -1 -1 -1  1 -1  1  1  1 -1 -1  
#	  1  1  1  1  1
ytest=sample(c(-1,1) , 20, replace = TRUE)

#----------------------------------------------------------
# randomly selects 20 row numbers from the mydata data set
sample(nrow(mydata),20)

#----------------------------------------------------------
# random selection of rows from the mydata data set  
x=mydata[sample(nrow(mydata),20),]


#----------------------------------------------------------
# SYSTEMACTIC SAMPLE
# sequence starting at 7, ending at 117, by interval of 10
hp <- read.csv("home_prices.csv", sep=",")

price<-hp($PRICE)
SS<-price[seq(from = 7, to =117, by=10)]


#----------------------------------------------------------
#----------------------------------------------------------
# Example:
# Take a simple random sample, sample of 5, sample of 20, and 
#     create a data frame
#----------------------------------------------------------
samp = data.frame(income = sample (loans_income, 1000), 
		  type = 'data_dist')

samp_05 = data.frame(			# take a sample of means of five values
	income = tapply(sample(loans_income, 1000*5),
		rep(1:1000, rep(5, 1000)), FUN = mean), 
	type = 'mean_of_5'
	
samp_20 = data.frame(			# take a sample of means of 20 values
	income = tapply(sample(loans_income, 1000*20),
		rep(1:1000, rep(20, 1000)), FUN = mean), 
	type = 'mean_of_20'

income = rbind(samp, samp_05, samp_20)  # bind dfs together

income$type = factor(income$type,
	levels = c('data_dist', 'mean_of_05', 'mean_of_20'),
	labels = c('Data', 'Mean of 5', 'Mean of 20')
	
ggplot(income, aes(x = income)) +
	geom_histogram(bins = 40) +
facet_grid(type~.)
