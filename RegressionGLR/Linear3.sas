

libname mydata'/scs/wtm926/' access=readonly;
proc datasets library=mydata;
run;

Data temp1;
	set mydata.ames_housing_data;
	
/*Q1*/
/*First do a scatter plot of saleprice vs. grlivarea*/
proc reg data=temp1;
	model saleprice=grlivarea;
run;

/*create two new variables. The first variable is log(SalePrice) 
or the log of SalePrice. The second is log(X).*/

Data temp2;
	set temp1;
	logsaleprice=log(saleprice);
	loggrlivarea=log(grlivarea);
	/*keep SalePrice logSalePrice grlivarea loggrlivarea;*/

proc print data=temp2(obs=10);
run;

/*Q2
Now, you should fit four models, one for each pair-wise combination 
of these two new variables you constructed. */

/*2x2 scatter plot for transformed salprice and grlivare*/
proc sgscatter data=temp2;
	plot(saleprice logsaleprice) * (grlivarea loggrlivarea);
run;
/*a) X to predict SalePrice*/
proc reg data=temp2;
	model saleprice = grlivarea;
	title 'Model SalePrice vs. GrLivArea';
run;

/*b) log_X to predict SalePrice*/
proc reg data=temp2;
	model saleprice = loggrlivarea;
	title 'Model SalePrice vs. logGrLivArea';
run;

/*c) X to predict log_saleprice*/
proc reg data=temp2;
	model logsaleprice = grlivarea;
	title 'Model logSalePrice vs. GrLivArea';
run;

/*d) log_X to predict log_saleprice*/
proc reg data=temp2;
	model logsaleprice = loggrlivarea;
	title 'Model logSalePrice vs. logGrLivArea';
run;

/*Q3
Correlate the continuous variables in the dataset with 
log_saleprice. */
proc corr data=temp2 nosimple rank; 
	var LotFrontage LotArea MasVnrArea BsmtFinSF1 BsmtFinSF2
	BsmtUnfSF TotalBsmtSF FirstFlrSF SecondFlrSF LowQualFinSF GrLivArea
	GarageArea WoodDeckSF OpenPorchSF EnclosedPorch ThreeSsnPorch
	ScreenPorch PoolArea MiscVal;
	with logsaleprice;
run;

/*Make a scatterplot of X with SalePrice*/
proc sgscatter data=temp2;
	plot(saleprice logsaleprice) * (GarageArea);
run;

/*Create another transformation variable on Y (SalePrice) using
 some other function, (i.e. square root, square, exponential) t*/
Data temp3;
	set temp2;
	sqrtsaleprice=sqrt(saleprice);
	invsaleprice=1/(saleprice);
	sqrtgaragearea=sqrt(garagearea);
	loggaragearea=log(garagearea);
	sqrgaragearea=garagearea*garagearea;
run;
/*Q4
Fit one more regression model using the response variable X 
you obtained in part 3) and/or any transformation on that variable
that you find appropriate to predict your newly transformed Y.*/

/*saleprice vs. garagearea*/
proc reg data=temp3;
	model saleprice = garagearea;
	title 'Model SalePrice vs. GarageArea';
run;

/*sqrtsaleprice vs. garagearea*/
proc reg data=temp3;
	model sqrtsaleprice = garagearea;
	title 'Model sqrtSalePrice vs. GarageArea';
run;
/*sqrtsaleprice vs. sqrtgaragearea*/
proc reg data=temp3;
	model sqrtsaleprice = garagearea;
	title 'Model sqrtSalePrice vs. sqrtGarageArea';
run;

/*sqrtsaleprice vs. loggaragearea*/
proc reg data=temp3;
	model sqrtsaleprice = loggaragearea;
	title 'Model sqrtSalePrice vs. logGarageArea';
run;

/*PartB
Q5
Identify observations that are potential outliers for the SalePrice 
variable, Y. */

proc univariate normal plot data=temp3;
	var saleprice;
	histogram saleprice/normal (color=red w=2);
run;

Data temp4;
	set temp3;
		if saleprice = . then delete;
		if saleprice <=45500 then price_outlier=1;
			else if saleprice > 45500 & saleprice < 297500 
				then price_outlier=2;
			else if saleprice >= 297500 & saleprice < 465500
				then price_outlier=3;
			else if saleprice >=465500 then price_outlier=4;
proc print data=temp4 (obs=20);
run;

/*Report a table of counts for each of the outlier definitions 
using a PROC FREQ statement. */

proc freq data=temp4;
	table price_outlier;
run;

proc sort data=temp4;
	by price_outlier;
run;

proc means data=temp4;
	by price_outlier;
	var saleprice;
run;

/*Q6
create a data set without outliers by including a DELETE
statement in a subsequent new SAS data step. */

data temp5;
	set temp4;
		if price_outlier = 1 then delete;
		if price_outlier = 4 then delete;
run;
proc freq data=temp5;
	table price_outlier;
run;

proc univariate normal plot data=temp5;
	var saleprice;
	histogram saleprice/normal (color=red w=2);
run;

/*Q6
from assignment 2, Q2:
Now, find a better simple linear regression model to predict 
Y=sale price, using the selection=rsquare option in PROC REG with 
start=1 and stop=1*/
proc reg data=temp5;
	model saleprice = grlivarea garagearea firstflrsf secondflrsf
	lotarea bsmtfinsf1 bsmtfinsf2 totalbsmtsf lowqualFinsf
	bsmtunfsf lotfrontage wooddecksf 
	openporchsf enclosedporch threessnporch screenporch 
	poolarea miscval /
		selection = rsquare start=1 stop=1;
run;

/*from assignment 2, Q5
Report the model in equation form and interpret each coefficient 
of the model in the context of this problem*/
proc reg data=temp5;
	model saleprice=grlivarea;
run;

/*from assignment 2, Q5
Now fit a multiple regression model that uses 2 continuous 
explanatory (X) variables to predict Sale Price (Y). */
proc reg data=temp5;
	model saleprice=masvnrarea grlivarea;
run;

/*from assignment 2, Q6 
Add a third continuous predictor (X) 
variable to your multiple regression model from part 5) This 
variable should be the one with the smallest correlation of X 
with Y*/
proc reg data=temp5;
	model saleprice=masvnrarea grlivarea BsmtFinSF2;
run;

/*with outliers*/
proc reg data=temp1;
	model saleprice=grlivarea;
run;

/*with outliers */
proc reg data=temp1;
	model saleprice=masvnrarea grlivarea;
run;

/*with outliers*/
proc reg data=temp1;
	model saleprice=masvnrarea grlivarea BsmtFinSF2;
run;
