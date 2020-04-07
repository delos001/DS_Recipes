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
data TEMPFILE;
input X6 X8 Y;
datalines;
20  35.3  10.98
20  29.7  11.13
23  30.8  12.51
20  58.8  8.40
21  61.4  9.27
22  71.3  8.73
11  74.4  6.36
23  76.7  8.50
21  70.7  7.82
20  57.5  9.14
20  46.4  8.24
21  28.9  12.19
21  28.1  11.88
19  39.1  9.57
23  46.8  10.94
20  48.5  9.58
22  59.3  10.09
22  70.0  8.11
11  70.0  6.83
23  74.5  8.88
20  72.1  7.68
21  58.1  8.47
20  44.6  8.86
20  33.4  10.36
22  28.6  11.08
;
run; 

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
