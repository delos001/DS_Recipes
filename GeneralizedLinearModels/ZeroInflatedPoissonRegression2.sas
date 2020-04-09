
/*
DEFINITION:
Continuous target with a high frequency of records at zero.
Data that is not zero, is distributed around some larger value.

EXAMPLE
	CAR CRASH
	• Most people do NOT crash their cars, so insurance claims are usually zero.
	• However, if you DO crash your car, your damage will be large (say $5000).
	LOAN DEFAULT
	• Most people do NOT default on loans, so losses are usually zero.
	• However, if you DO default on a loan, your default will be large (say $100,000)
	AIR TRAVEL
	• Most people do NOT fly on airplanes every year, so miles travelled are zero
However, if you DO fly on an airplane, you will usually travel at least 500 miles.

Could try linear regression.  It might work, but it violates statistical assumptions 
	and could lead to poor accuracy.
Could try Tweedie Distribution approach: 
	is mathematically intense and no guarantee it will be better than simple 
		linear regression approach
    
    
PROBABILITY / SEVERITY MODEL
Break complicated problem into two smaller problems. For example, CAR CRASH:
  What is the probability that a person will crash their car?
  If a person crashes their car, what will it cost?
Advantage
  Logistic and Linear regression are simple and well understood
  Can give good results
Disadvantages
  Build two models instead of one, and both need to be accurate
Requires coding skill to separate the data and then combine the results
*/

/*STEP 1--------------------------------------------------------------
Use ALL the data to develop a LOGISTIC regression model to predict probability 
  that a customer will crash their car
For demonstration purposes an overly simplified model was developed to predict 
  the PROBABILITY that a person will crash their car. The model has only one 
  predictive variable, MVR_PTS (the number of traffic tickets on their driving 
  record). 
*/
%let INFILE 	= &LIB.INSURANCE_PROB_SEV;
proc logistic data=&INFILE.;
model TARGET_FLAG(ref=“0”) = MVR_PTS;
run;


/*code will determine the probability that a person will be in a car crash
Using only this variable, the following logistic regression formula was calculated:
LOG_ODDS = -1.4345 + 0.2151*MVR_PTS */
%let INFILE 	= &LIB.INSURANCE_PROB_SEV;
%let OUTFILE 	= OUTFILE_FLAG;

%macro SCORE_FLAG( INFILE, OUTFILE );

data &OUTFILE.;
set &INFILE.;
	LOG_ODDS = -1.4345 + 0.2151*MVR_PTS;
	ODDS = exp( LOG_ODDS );
	P_TARGET_FLAG = ODDS / (1+ODDS);
drop LOG_ODDS ODDS;
run;

%mend;

%score_flag( &INFILE. , &OUTFILE. );    *remember: is calling a macro: takes the infile, creates the outfile

proc print data=&OUTFILE.(obs=10);
var INDEX TARGET_FLAG MVR_PTS P_TARGET_FLAG;
run;


/*STEP 2--------------------------------------------------------------
Subset the data to create a data set made up of ONLY people who had crashes
Build a LINEAR regression model to predict the amount of damages assuming 
  that the customer does crash their car

For demonstration purposes an overly simplified model was developed to predict 
  the SEVERITY of an accident, assuming that a person has an accident. The model 
  has only one predictive variable, BLUEBOOK (the estimated value of a person’s car).  
*/
%let INFILE 	= &LIB.INSURANCE_PROB_SEV;

/*Training Code:
There is one catch to this model, before doing the PROC REG, the data set must be 
pruned so that it only includes records where a person had a car crash */
data TEMPFILE;
set &INFILE.;
if TARGET_AMT > 0;
run;

proc reg data=TEMPFILE;
model TARGET_AMT = BLUEBOOK;
run;
quit;



/*Using only this variable, the following linear regression formula 
  was calculated:
    P_TARGET_AMT = 4131.65 + 0.11017*BLUEBOOK
The scoring program is run */
%let INFILE 	= &LIB.INSURANCE_PROB_SEV;
%let OUTFILE 	= OUTFILE_FLAG;

%macro SCORE_AMT( INFILE, OUTFILE );

data &OUTFILE.;
set &INFILE.;
P_TARGET_AMT = 4131.65 + 0.11017 * BLUEBOOK;
run;

%mend;

%score_amt( &INFILE. , &OUTFILE. );

proc print data=&OUTFILE.(obs=10);
var INDEX TARGET_AMT BLUEBOOK P_TARGET_AMT;
run;


/*STEP 3--------------------------------------------------------------
• Multiply PROBABILITY by SEVERITY to arrive at expected losses

The expected losses of a customer are simply the PREDICTED PROBABILITY 
  of a crash multiplied by PREDICTED LOSS if there is a crash.
P_TARGET = P_TARGET_FLAG * P_TARGET_AMT 
*/

%let INFILE 	= &LIB.INSURANCE_PROB_SEV;
%let OUTFILE 	= OUTFILE_FLAG;

%macro SCORE_FLAG( INFILE, OUTFILE );      *cacluating probability from step 1 results

data &OUTFILE.;
set &INFILE.;
LOG_ODDS = -1.4345 + 0.2151*MVR_PTS;
ODDS = exp( LOG_ODDS );
P_TARGET_FLAG = ODDS / (1+ODDS);
drop LOG_ODDS ODDS;
run;

%mend;
/********************************************/
%macro SCORE_AMT( INFILE, OUTFILE );        *calculating predicted target amount for those that do crash their car

data &OUTFILE.;
set &INFILE.;
P_TARGET_AMT = 4131.65 + 0.11017 * BLUEBOOK;
run;
/********************************************/
%mend;

%score_flag( &INFILE. , &OUTFILE. );        *runs two macros to combine the two data sets from step 1 and step 2
%score_amt( &OUTFILE. , &OUTFILE. );

data &OUTFILE.;
set &OUTFILE.;
P_TARGET = P_TARGET_FLAG * P_TARGET_AMT;    *multiplies probability (p-target_flag) times predicted amount
run;

proc print data=&OUTFILE.(obs=10);
run;
