# Chad R. Bhatti
# stargazer_examples.R


# See the vignette
# https://cran.r-project.org/web/packages/stargazer/vignettes/stargazer.pdf


# Install the package
install.packages('stargazer',dependencies=TRUE)


# Load packages
library(MASS)
library(stargazer)


# View Boston Housing Data 
str(Boston)
head(Boston)


# Define output path for html files;
# You will need to change this out.path;
out.path <- 'C:\\Users\\Chad R Bhatti\\Dropbox\\Northwestern_MSPA\\MSDS_410_R_2018F\\Stargazer_Examples\\';



########################################################################
# Example #1: Summary Statistics Table
########################################################################

file.name <- 'example_01.html';
stargazer(Boston, type=c('html'),out=paste(out.path,file.name,sep=''),
	title=c('Table XX: Summary Statistics for Boston Housing'),
	align=TRUE, digits=2, digits.extra=2, initial.zero=TRUE, median=TRUE)


# Read the help file on stargazer;




########################################################################
# Example #2: Regression Output Table
########################################################################

model.1 <- lm(medv ~ crim + rm + age, data=Boston)
summary(model.1)


file.name <- 'example_02.html';
stargazer(model.1, type=c('html'),out=paste(out.path,file.name,sep=''),
	title=c('Table XX: Model #1'),
	align=TRUE, digits=2, digits.extra=2, initial.zero=TRUE)




########################################################################
# Example #3: Compare Multiple Regression Models in a Single Table
########################################################################

model.2 <- lm(medv ~ crim + rm + tax, data=Boston)
summary(model.2)



file.name <- 'example_03.html';
stargazer(model.1, model.2, type=c('html'),out=paste(out.path,file.name,sep=''),
	title=c('Table XX: Comparison of Model #1 and Model #2'),
	align=TRUE, digits=2, digits.extra=2, initial.zero=TRUE, 
	column.labels=c('Model #1','Model #2'), intercept.bottom=FALSE )




########################################################################
# Example #4: Print a Table
########################################################################

file.name <- 'example_04.html';
# Note that stargazer will not take a table class;
# Convert table to a data frame and turn the summary off;
zn.table <- as.data.frame(table(Boston$zn))
colnames(zn.table) <- c('Zone #','Freq');

stargazer(zn.table, type=c('html'),out=paste(out.path,file.name,sep=''),
	title=c('Table XX: Frequency Table of Zone'),
	align=TRUE, digits=2, digits.extra=2, initial.zero=TRUE,
	summary=FALSE )


# Note that you can create any table, convert it to a data frame, and then
# print it using this approach.




########################################################################
# Example #5: Print a Correlation Matrix
########################################################################

file.name <- 'example_05.html';
cor.matrix <- cor(Boston);
stargazer(cor.matrix, type=c('html'),out=paste(out.path,file.name,sep=''),
	align=TRUE, digits=2, title='Table XX: Correlation Matrix')


# We could print out any matrix using this approach.





































