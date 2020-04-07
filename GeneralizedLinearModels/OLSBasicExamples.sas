/* OPTIONAL COMMANDS*/

p               /*print th epredicted values*/
clm             /confidence limit mean: print the confidence band*/
cli             /*confidence limit individual observation: print the prediction band*/


/*
model is the command, 
time is the response variable
cases and distance are the predictor variables
p, clm, cli are the optional commands
*/

model  time=cases distance / p clm cli;

/*-----------------------------------------------------------------------------*/

/*example to select only the plots you want*/
ods graphics on;
proc reg data=temp1 plots(only)=(diagnostics fitplot residuals);
	model sales = income;
	title2 "Base Model";
run;
ods graphics off;


/*-----------------------------------------------------------------------------
REGRESSION COMMANDS: all three of these proc commands will do linear regression
-----------------------------------------------------------------------------*/
proc reg data=TEMPFILE;
model Y = X6 X8;
run;
quit;

proc glm data=TEMPFILE;
model Y = X6 X8;
run;
quit;

proc genmod data=TEMPFILE;
model Y = X6 X8 / link=identity dist=normal;
run;

proc glmselect data=TEMPFILE;
model Y = X6 X8;
run;
quit;


/*----------------------------------------------------------------------------------
EXAMPLE1
regression statement using the temp1 data
model of dependent variable vs. independent variable
----------------------------------------------------------------------------------*/

proc reg data=temp1;
	model saleprice = masvnrarea;
run;

/*----------------------------------------------------------------------------------
EXAMPLE2
regression for multiple variables vs. response variable (dependent variable) saleprice
----------------------------------------------------------------------------------*/
proc reg data=temp1;
	model saleprice=masvnrarea grlivarea BsmtFinSF2;
run;

/*----------------------------------------------------------------------------------
EXAMPLE3
scatter plot of temp1 data
create linear regression line in the scatter plot
----------------------------------------------------------------------------------*/
proc sgplot data=temp1;
	reg x=masvnrarea y=saleprice / lineattrs=(color=red thickness=3);
run;

/*----------------------------------------------------------------------------------
EXAMPLE4
the /P gets the predicted response
creates an output that has the predicted values included in the output
----------------------------------------------------------------------------------*/
roc reg data=manatee;
	model deaths=boats / P;
	
OUTPUT OUT = modelout  PREDICTED = PRED;


/*----------------------------------------------------------------------------------
EXAMPLE5
the /P gets the predicted response
creates an output that has the predicted values included in the output
----------------------------------------------------------------------------------*/
proc reg data=mbmod1a;
	model 
		Target_Wins         /*use multiple dependent variables
		sqTarget_Wins 
		logTarget_Wins
		log2Target_Wins
		hlfPTarget_Wins
		neghlfPTarget_Wins
		recipTarget_Wins
			 =  BATTING_H     /*with multiple independent variables
				BATTING_2B
				BATTING_3B
				BATTING_HR
				BATTING_BB
				/selection=stepwise;
run;
