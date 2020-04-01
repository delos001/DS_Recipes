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

/*----------------------------------------------------------------------------------
FORWARD SELECTION
each of these are variables (in this case, these are continuous variables with dummy code: 
see dummy code section in stat tab add the VIF to include the variance inflation factor in 
the final model output table
----------------------------------------------------------------------------------*/
proc reg data=part2;
model saleprice = extcond_ex extcond_gd extcond_ta extcond_fa/
selection=forward vif;
run;

/*----------------------------------------------------------------------------------
BACKWARD SELECTION
add the VIF to include the variance inflation factor in the final model output table
----------------------------------------------------------------------------------*/
proc reg data=part2;
model saleprice = extcond_ex extcond_gd extcond_ta extcond_fa/
selection=backward vif;  
run;


/*----------------------------------------------------------------------------------
STEPWISE SELECTION
add the VIF to include the variance inflation factor in the final model output table
----------------------------------------------------------------------------------*/
proc reg data=part2;
model saleprice = extcond_ex extcond_gd extcond_ta extcond_fa/
selection=stepwise vif;
run;


/*----------------------------------------------------------------------------------
ADJUSTED RSQUARED SELECTION
adjusted r-square, aic and bic
----------------------------------------------------------------------------------*/
proc reg data=part2;
model saleprice = extcond_ex extcond_gd extcond_ta extcond_fa/
selection=adjrsq aic bic;
run;


/*----------------------------------------------------------------------------------
MALLOWS CP SELECTION
mallows cp, aic and bic
----------------------------------------------------------------------------------*/
proc reg data=part2;
model saleprice = extcond_ex extcond_gd extcond_ta extcond_fa/
selection=cp aic bic; 
run;


/*----------------------------------------------------------------------------------
AIC BIC SELECTION
AIC method (can also use BIC here too) creates a variable that has the results of the 
tests that can be acted upon later model sale price by the extcond… variables
using selction adjrsq and the aic bic values will be in the table also
----------------------------------------------------------------------------------*/
proc reg data=part2 outest=rsqest;
model saleprice = extcond_ex extcond_gd extcond_ta extcond_fa/
selection=adjrsq aic bic;

proc print data=rsqest;			/*prints the rsqest variable*/
proc sort data=rsqest; by _aic_;	/*sorts the rsqest variable by the aic (sorts asecnding by default)*/
proc print data=rsqest;			/*prints the rsqest variable*/
run;
