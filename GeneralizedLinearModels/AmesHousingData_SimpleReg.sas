

libname mydata'/scs/wtm926/' access=readonly;

proc datasets library=mydata;
run;

Data temp1;
	set mydata.ames_housing_data;

/* Q1 
Fit a simple linear regression model using X to predict Y. */	
proc corr data=temp1 plot(maxpoints=none)=matrix(histogram nvar=all);
	var saleprice MasVnrArea;
run;

proc corr data=temp1;
	var masvnrarea saleprice;
run;

proc reg data=temp1;
	model saleprice=masvnrarea;
run;
/* Q2
Now, find a better simple linear regression model to predict 
Y=sale price, using the selection=rsquare option in PROC REG with 
start=1 and stop=1*/
proc reg data=temp1;
	model saleprice = grlivarea garagearea firstflrsf secondflrsf
	lotarea bsmtfinsf1 bsmtfinsf2 totalbsmtsf lowqualFinsf
	bsmtunfsf lotfrontage wooddecksf 
	openporchsf enclosedporch threessnporch screenporch 
	poolarea miscval /
		selection = rsquare start=1 stop=1;
run;

/*Report the model in equation form and interpret each coefficient 
of the model in the context of this problem*/
proc reg data=temp1;
	model saleprice=grlivarea;
run;

/*Q4
Select one of the following categorical variables to use as an
explanatory variable (X) to predict Y, sales price: BedroomAbvGr*/

proc corr data=temp1 plot(maxpoints=none)=matrix(histogram nvar=all);
	var saleprice BedroomAbvGr;
run;

/*Fit a simple linear regression model using X to predict Y
BedroomAbvGr*/
proc reg data=temp1;
	model saleprice=BedroomAbvGr;
run;

/**/
proc sort data=temp1;
	by bedroomAbvGr;

proc means data=temp1;
	var saleprice;
run;
proc means data=temp1;
	by bedroomAbvGr;
var saleprice;

/*Q5
Now fit a multiple regression model that uses 2 continuous 
explanatory (X) variables to predict Sale Price (Y). */
proc reg data=temp1;
	model saleprice=masvnrarea grlivarea;
run;

/*Add a third continuous predictor (X) variable to your multiple 
regression model from part 5) This variable should be the one with 
the smallest correlation of X with Y*/
proc reg data=temp1;
	model saleprice=masvnrarea grlivarea BsmtFinSF2;
run;
