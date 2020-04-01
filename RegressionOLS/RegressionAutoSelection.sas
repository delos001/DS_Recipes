/*----------------------------------------------------------------------------------
MODEL SELECTION BY RSQUARED
regression of temp1 data
model is saleprice (dependent variable) vs. all other variables you want to assess
use the / at the end to add the selection statement
selection is the rsquare value which tells sas to get Rsq value for each of the variables
stop=1 gives you the best single variable combination
stop=2 would give you the best pair
stop=3 would give you the best three variable combination
etc
----------------------------------------------------------------------------------*/
proc reg data=temp1;
	model saleprice = grlivarea garagearea secondflrsf
	lotarea bsmtfinsf1 totalbsmtsf firstflrsf /
		selection = rsquare start=1 stop=1;
run;

