/*
Similar to the backward selection using PROC REG for OLS regression, the backward selection removes 
variables with ChiSq p-value above 0.05 with default settings. The result within the example is a single 
variable model with X1 as the predictor variable. As done in the prior step, the SAS output tables 
identify model significance and odds ratios
*/


/*--------------------------------------------------------------------------------------------
Example1:
logit of y is modeled on the 6 variables specified
--------------------------------------------------------------------------------------------*/

proc logistic data=bankrupt descending;
model y=x1 x2 x3 x1_discrete x2_discrete x3_discrete / selection=backward;
run;

/*--------------------------------------------------------------------------------------------
Example2:
--------------------------------------------------------------------------------------------*/
proc logistic data=insmod1;
class car_use / param=reference;   /*if any variables are class variables, specify them here*/
model target_flag (ref="0")=
	car_use
	travtime
	imp_income
	/selection=stepwise;
score out=mod1score;
run;

/*--------------------------------------------------------------------------------------------
Example3:
--------------------------------------------------------------------------------------------*/
proc logistic data=helocmoda plot(only)=(roc(ID=prob));   /*this example uses roc plot where ID is probability*/
class impJOB impReason / param=reference;                 /*have to specify which variables are class variables*/
model Target_Flag (ref="0") = 	impMortdue
	flgMortdue
	impVALUE
	flgVALUE
	flgJOB/selection=stepwise roceps=0.1;             /*puts the values on the roc curve so you can see 1-specificity*/
score out=helocmod1score;
run;
